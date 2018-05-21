addpath(genpath('C:\\Users\\fahee\\Downloads\\Capstone downloads\\labstreaminglayer-master\\labstreaminglayer-master\\LSL\\liblsl-Matlab'))
addpath(genpath('C://Users//fahee//Google Drive//University of Houston//Fall 2017//BIOE 4335 (Capstone)//Project files//Saved Data from OpenBCI GUI'))


%% reorienting data for CSP.m and spatFilt.m, for cross validation (functions from Thinh), based on code provided in CSPTest.m
%NOTE: RUN THIS AND THE 3rd Section ONLY FOR TRAINING, 2nd section
% and 3rd for ONLY TESTING, DO NOT JUST RUN!!!!


Xn = permute(C,[2 3 1]); % baseline
Xm = permute(D,[2 3 1]);

% to get number of trials
sizeXn = size(Xn); % size should be same for both Xl and Xr
sizeXm = size(Xm);
% reshaping to get the trials next to each other (stack horizontally)
Xnreshape = reshape(Xn,sizeXn(1),sizeXn(2)*sizeXn(3));
Xmreshape = reshape(Xm,sizeXm(1),sizeXm(2)*sizeXm(3));

% getting the weight matrix from CSP.m
[ProjectionCSPnm] = CSP(Xnreshape,Xmreshape);
% h = warndlg('Save the created ProjectionCSP variable as ProjectionCSPnm.mat for testing data');
% save('ProjectionCSPnm.mat','ProjectionCSPnm')

% getting the dot product of our data (concatenated) and weight matrix from
% spatFilt.m, 
classtrain = horzcat(Xnreshape,Xmreshape);
train = spatFilt(classtrain,ProjectionCSPnm,5); % taking only the 5 best channels for CSP


%% combining everything back into one train matrix (this will be the X that
% goes into SVM)
sizeXn = size(Xn);
sizeXm = size(Xm);
sizetrain = size(train);

for r=1:size(C,1)+size(D,1)
    for g=1:sizetrain(1)
        X(r,1+(g-1)*(size(C,3)):g*(size(C,3)))=train(g,1+(r-1)*(size(C,3)):r*(size(C,3)));
    end
end

Y(1:sizeXn(3),:)=2; %null trials (baseline)
Y(sizeXn(3)+1:sizeXn(3)+sizeXm(3),:)=0; %moving trials



%% two binary class SVM, offline (no crossval)

%keeping track of where the rows where originally
order = (1:size(X,1))';

% randomizing all the rows of X
tmp = randperm(size(X, 1));
X = X(tmp, :);
Y = Y(tmp, :);
order = order(tmp, :);
sizeX = size(X);

X(:,size(X,2)+1) = Y;
sizeX = size(X);
%% %% segmenting data for cross validation (Faheem's cross validation)

kfoldcrossval = 10;
dividetrialsbycrossval = (sizeX(1))/kfoldcrossval;
classifierinput = {zeros(1,kfoldcrossval)};
for i = 0:dividetrialsbycrossval:sizeX(1)-dividetrialsbycrossval
    if i == 0
        classifierinput{i+1} = X(i+1:i+dividetrialsbycrossval,:,:);
    else
        classifierinput{(i+dividetrialsbycrossval)/dividetrialsbycrossval} = X(i+1:i+dividetrialsbycrossval,:,:);
    end
end

%cross validation with SVM, 8 fold, below we predefine variables for faster
%processing time
training = zeros(dividetrialsbycrossval,sizeX(2),kfoldcrossval-1);
testingset = zeros(dividetrialsbycrossval,sizeX(2),kfoldcrossval);
trainingset = zeros(kfoldcrossval*dividetrialsbycrossval-dividetrialsbycrossval,sizeX(2),kfoldcrossval);
mstore = zeros(1,kfoldcrossval);

clear trainAcc testAcc
for k = 1:kfoldcrossval
    c = randperm(length(classifierinput),kfoldcrossval-1);
    z = sort(c);
    
    for f = 1:length(c)-1
        if z(f+1)-z(f) ~= 1 %taking care of all middle numbers
            m = z(f)+1;
        elseif z(length(c)) ~= kfoldcrossval %taking care of the end
            m = kfoldcrossval;
        elseif z(1) ~= 1 %taking care of the beginning
            m = 1;
        end
    end
    mstore(k) = m;
    anyDuplicates = ~all(diff(sort(mstore(mstore ~= 0)))); %found this online to check for dupes
  
       %make sure same data (m) is not picked every time, the above loop
       %was copied again and goes on until m is a different number than
       %before
       while anyDuplicates == 1
           if anyDuplicates == 1
               c = randperm(length(classifierinput),kfoldcrossval-1);
               z = sort(c);
               for f = 1:length(c)-1
                   if z(f+1)-z(f) ~= 1 %taking care of all middle numbers
                       m = z(f)+1;
                   elseif z(length(c)) ~= kfoldcrossval %taking care of the end
                       m = kfoldcrossval;
                   elseif z(1) ~= 1 %taking care of the beginning
                       m = 1;
                   end
               end
           else
           end
           mstore(k) = m;
           anyDuplicates = ~all(diff(sort(mstore(mstore ~= 0))));
       end
    
    %defining the test set
    testingset(:,:,k) = classifierinput{m};
    %defining the train set, but first, have to do one segment of trails at
    %a time
    for b = 1:length(c)
        training(:,:,b) = classifierinput{z(b)};
    end
    %permuting and reshaping the training data so that 7 of the 8 segments
    %(35 trials for 8 fold crossval of 40 trials) now are the rows and the
    %last column contains the labels, results in a 2D matrix
    trainingdata = permute(training,[1 3 2]);
    trainingdatasize = size(trainingdata);
    trainingdata = reshape(trainingdata,trainingdatasize(1)*trainingdatasize(2),trainingdatasize(3));
    trainingset(:,:,k) = trainingdata;
    
    %creating the SVM Model using kfoldcrossval-1 sections of the data
    %in other words, if we have 40 trials with labels
    %included, 35 are being used to train the model, 5 to test
    
    SVMModelnm{:,k} = fitcsvm(trainingset(:,1:trainingdatasize(3)-1,k),trainingset(:,trainingdatasize(3),k),'KernelFunction','linear',...
    'Standardize',true,'ClassNames',{'2','0'});
 
    %predicting on the training set
    tmp1 = predict(SVMModelnm{:,k},trainingset(:,1:trainingdatasize(3)-1,k));
    tmp1 = str2num(cell2mat(tmp1));
    acc = tmp1 - trainingset(:,trainingdatasize(3),k);
    acc = numel(find(acc == 0))/numel(trainingset(:,trainingdatasize(3),k));
    trainAcc(k) = acc;

    %predicting on the test set (m)
    tmp2 = predict(SVMModelnm{:,k},testingset(:,1:trainingdatasize(3)-1,k));   
    tmp2 = str2num(cell2mat(tmp2));
    acc2 = tmp2 - testingset(:,trainingdatasize(3),k);
    acc2 = numel(find(acc2 == 0))/numel(testingset(:,trainingdatasize(3),k));
    testAcc(k) = acc2;
    
end

% training and testing accuracy goes below!!!
avetrainAcc = mean(trainAcc);
avetestAcc = mean(testAcc);
StoredNMmodels = SVMModelnm;
clear SVMModelnm
%% creating the SVM Model AND CROSS VALIDATION
%NEED TO CONSIDER OUTLIERS!!!

SVMModelnm = fitcsvm(X(:,1:size(X,2)-1),X(:,size(X,2)),'KernelFunction','linear',...
    'Standardize',true,'ClassNames',{'2','0'}); %this number is from optimizing

CVSVMModelnm = crossval(SVMModelnm,'KFold',8);
classLoss = kfoldLoss(CVSVMModelnm);

% h = warndlg('Save the created SavedSVMModel variable as SavedSVMModel.mat for testing data');
% save('SavedSVMModel.mat','SVMModel')

%% predicting on the training set
tmp1 = predict(SVMModelnm,X(:,1:size(X,2)-1));
tmp1 = str2num(cell2mat(tmp1));
acctrainpred = tmp1 - Y;
acctrainpred = numel(find(acctrainpred == 0))/numel(Y);
%% TRAIN SET ONLY: SECOND CSP AND SECOND CLASSIFIER
Fs=250;
Dl = D(1:size(D,1)/2,:,:);
Dr = D(size(D,1)/2+1:size(D,1),:,:);

Xl = permute(Dl,[2 3 1]);
Xr = permute(Dr,[2 3 1]);

% to get number of trials
sizeXl = size(Xl); % size should be same for both Xl and Xr
sizeXr = size(Xr);
% reshaping to get the trials next to each other (stack horizontally)
Xlreshape = reshape(Xl,sizeXl(1),sizeXl(2)*sizeXl(3));
Xrreshape = reshape(Xr,sizeXr(1),sizeXr(2)*sizeXr(3));

[ProjectionCSPlr] = CSP(Xlreshape,Xrreshape);

classtrainEE = horzcat(Xlreshape,Xrreshape);
trainEE = spatFilt(classtrainEE,ProjectionCSPlr,5);

sizeEEXl = size(Xl);
sizeEEXr = size(Xr);
sizetrainEE = size(trainEE);

%reorganizing for PSD
for r=1:size(D,1)
    for g=1:sizetrainEE(1)
        XEE(r,1+(g-1)*size(D,3):g*size(D,3))=trainEE(g,1+(r-1)*size(D,3):r*size(D,3));
    end
end

% creating labels/targets
YEE(1:sizeEEXl(3),:)=0; %left trials
YEE(sizeEEXl(3)+1:sizeEEXl(3)+sizeEEXr(3),:)=1; %right trials
sizeXEE = size(XEE);

% randomizing all the rows of X
tmpEE = randperm(size(XEE, 1));
XEE = XEE(tmpEE, :);
YEE = YEE(tmpEE, :);
XEE(:,size(XEE,2)+1) = YEE;
sizeXEE = size(XEE);


%% segmenting data for cross validation (Faheem's cross validation)

kfoldcrossvallr = 10;
dividetrialsbycrossvallr = (sizeXEE(1))/kfoldcrossvallr;
classifierinputlr = {zeros(1,kfoldcrossvallr)};
for i = 0:dividetrialsbycrossvallr:sizeXEE(1)-dividetrialsbycrossvallr
    if i == 0
        classifierinputlr{i+1} = XEE(i+1:i+dividetrialsbycrossvallr,:,:);
    else
        classifierinputlr{(i+dividetrialsbycrossvallr)/dividetrialsbycrossvallr} = XEE(i+1:i+dividetrialsbycrossvallr,:,:);
    end
end

%cross validation with SVM, 8 fold, below we predefine variables for faster
%processing time
traininglr = zeros(dividetrialsbycrossvallr,sizeXEE(2),kfoldcrossvallr-1);
testingsetlr = zeros(dividetrialsbycrossvallr,sizeXEE(2),kfoldcrossvallr);
trainingsetlr = zeros(kfoldcrossvallr*dividetrialsbycrossvallr-dividetrialsbycrossvallr,sizeXEE(2),kfoldcrossvallr);
mstorelr = zeros(1,kfoldcrossvallr);

clear trainacclr testacclr
for k = 1:kfoldcrossvallr
    clr = randperm(length(classifierinputlr),kfoldcrossvallr-1);
    zlr = sort(clr);
    
    for f = 1:length(clr)-1
        if zlr(f+1)-zlr(f) ~= 1 %taking care of all middle numbers
            mlr = zlr(f)+1;
        elseif zlr(length(clr)) ~= kfoldcrossvallr %taking care of the end
            mlr = kfoldcrossvallr;
        elseif zlr(1) ~= 1 %taking care of the beginning
            mlr = 1;
        end
    end
    mstorelr(k) = mlr;
    anyDuplicateslr = ~all(diff(sort(mstorelr(mstorelr ~= 0)))); %found this online to check for dupes
  
       %make sure same data (m) is not picked every time, the above loop
       %was copied again and goes on until m is a different number than
       %before
       while anyDuplicateslr == 1
           if anyDuplicateslr == 1
               clr = randperm(length(classifierinputlr),kfoldcrossvallr-1);
               zlr = sort(clr);
               for f = 1:length(clr)-1
                   if zlr(f+1)-zlr(f) ~= 1 %taking care of all middle numbers
                       mlr = zlr(f)+1;
                   elseif zlr(length(clr)) ~= kfoldcrossvallr %taking care of the end
                       mlr = kfoldcrossvallr;
                   elseif zlr(1) ~= 1 %taking care of the beginning
                       mlr = 1;
                   end
               end
           else
           end
           mstorelr(k) = mlr;
           anyDuplicateslr = ~all(diff(sort(mstorelr(mstorelr ~= 0))));
       end
    
    %defining the test set
    testingsetlr(:,:,k) = classifierinputlr{mlr};
    %defining the train set, but first, have to do one segment of trails at
    %a time
    for b = 1:length(clr)
        traininglr(:,:,b) = classifierinputlr{zlr(b)};
    end
    %permuting and reshaping the training data so that 7 of the 8 segments
    %(35 trials for 8 fold crossval of 40 trials) now are the rows and the
    %last column contains the labels, results in a 2D matrix
    trainingdatalr = permute(traininglr,[1 3 2]);
    trainingdatasizelr = size(trainingdatalr);
    trainingdatalr = reshape(trainingdatalr,trainingdatasizelr(1)*trainingdatasizelr(2),trainingdatasizelr(3));
    trainingsetlr(:,:,k) = trainingdatalr;
    
    %creating the SVM Model using kfoldcrossval-1 sections of the data
    %in other words, if we have 40 trials with labels
    %included, 35 are being used to train the model, 5 to test
    
    SVMModellr{:,k} = fitcsvm(trainingsetlr(:,1:trainingdatasizelr(3)-1,k),trainingsetlr(:,trainingdatasizelr(3),k),'KernelFunction','linear',...
    'Standardize',true,'ClassNames',{'0','1'});
 
    %predicting on the training set
    tmp1lr = predict(SVMModellr{:,k},trainingsetlr(:,1:trainingdatasizelr(3)-1,k));
    tmp1lr = str2num(cell2mat(tmp1lr));
    acclr = tmp1lr - trainingsetlr(:,trainingdatasizelr(3),k);
    acclr = numel(find(acclr == 0))/numel(trainingsetlr(:,trainingdatasizelr(3),k));
    trainacclr(k) = acclr;

    %predicting on the test set (m)
    tmp2lr = predict(SVMModellr{:,k},testingsetlr(:,1:trainingdatasizelr(3)-1,k));   
    tmp2lr = str2num(cell2mat(tmp2lr));
    acclr2 = tmp2lr - testingsetlr(:,trainingdatasizelr(3),k);
    acclr2 = numel(find(acclr2 == 0))/numel(testingsetlr(:,trainingdatasizelr(3),k));
    testacclr(k) = acclr2;
    
end

% training and testing acclruracy goes below!!!
avetrainacclr = mean(trainacclr);
avetestacclr = mean(testacclr);
StoredLRmodels = SVMModellr;
clear SVMModellr
%% end of faheem's cross val code


%creating the model
SVMModellr = fitcsvm(XEE(:,1:size(XEE,2)-1),XEE(:,size(XEE,2)),'KernelFunction','linear',...
    'Standardize',true,'ClassNames',{'0','1'});

CVSVMModellr = crossval(SVMModellr,'KFold',8);
classLosslr = kfoldLoss(CVSVMModellr);

%predicting on training set and accuracy of left/right classifier
tmp1EE = predict(SVMModellr,XEE(:,1:size(XEE,2)-1));
tmp1EE = str2num(cell2mat(tmp1EE));
acc1EE = tmp1EE - YEE;
acc1EE = numel(find(acc1EE == 0))/numel(YEE);

%% SVM Plot N and M
%rename the X variable to X_sv  and save variable for testing session!!!
%note: these are plotted using true labels
X_sv = X;
try
figure;
f1=1; f2=2; %change these numbers to compare different features
for u = 1:size(Y,1) %replace Y with tmp1 for predicted labels, or replace tmp1 with Y for true labels
    if Y(u)==0 %replace Y with tmp1 for predicted labels, or replace tmp1 with Y for true labels
        Ystring{u}='Moving';
    else
        Ystring{u}='Not moving';
    end
end
h(1:2) = gscatter(X_sv(:,f1),X_sv(:,f2),Ystring'); 
xlabel(num2str(f1)),ylabel(num2str(f2))
title('Not moving vs. moving SVM classifier')
hold on
h(3) = plot(X_sv(SVMModelnm.IsSupportVector,f1),X_sv(SVMModelnm.IsSupportVector,f2),'ko','MarkerSize',10);
legend(h,{'Not moving','Moving','Support Vectors'});
axis equal
hold off
catch
end
%% SVM Plot left and Right
%rename the XEE variable to XEE_sv and save variable for testing session!!!
%note: these are plotted using true labels
XEE_sv=XEE;
try
figure;
f1=1; f2=2; %change these numbers to compare different features
for u = 1:size(YEE,1) %replace YEE with tmp1EE if using predicted labels, or replace tmp1EE with YEE for true labels
    if YEE(u)==0 %replace YEE with tmp1EE if using predicted labels, or replace tmp1EE with YEE for true labels
        YEEstring{u}='Left';
    else
        YEEstring{u}='Right';
    end
end
h(1:2) = gscatter(XEE_sv(:,f1),XEE_sv(:,f2),YEEstring');
xlabel(num2str(f1)),ylabel(num2str(f2))
title('Left vs. right SVM classifier')
hold on
h(3) = plot(XEE_sv(SVMModellr.IsSupportVector,f1),XEE_sv(SVMModellr.IsSupportVector,f2),'ko','MarkerSize',10);
legend(h,{'Left','Right','Support Vectors'});
axis equal
hold off
catch
end

%% 3d scatter plotting and features
% 3d scatter plot 1st classifier
f1 = 1; f2 = 2; f3 = 3; 
figure 
hold on
scatter3(X(Y==2,f1),X(Y==2,f2),X(Y==2,f3),10,'fill','r')
scatter3(X(Y==0,f1),X(Y==0,f2),X(Y==0,f3),10,'fill','b')
xlabel(num2str(f1)),ylabel(num2str(f2)),zlabel(num2str(f3))

% 3d scatter plot 2nd classifier
f1 = 1; f2 = 2; f3 = 3; 
figure 
hold on
scatter3(XEE(YEE==0,f1),XEE(YEE==0,f2),XEE(YEE==0,f3),10,'fill','r')
scatter3(XEE(YEE==1,f1),XEE(YEE==1,f2),XEE(YEE==1,f3),10,'fill','b')
xlabel(num2str(f1)),ylabel(num2str(f2)),zlabel(num2str(f3))