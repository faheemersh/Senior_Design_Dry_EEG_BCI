%% ONLINE Prediction Data Processing 
fs=250; Fs=250;
datastore = datastore(:,3:7);

if length(truelabels)>size(predictedALL,1)
    truelabels = truelabels(1:size(predictedALL,1));
end

datastore_label=truelabels;
% creating true labels (manually)
% datastore_label=[0 0 0 0 0 1 1 1 1 1 2 2 2 2 2 0 0 0 0 0 0 1 1 1 1 1 1 2 2 2 2 2 2];


% datastore_label=[2 1 0 2 1 0 2 1 0 2 1 0 2 1 0 2 1 0 2 1 0 2 0 0 0 0 0 0 0 0 0 0 0 0 0];
% reshape online prediction data into samples*channels*epochs
incr=0;
datastore_reshape=[];


for d=1:(size(datastore,1)/(fs*trialtime))
    datastore_reshape(:,:,d)=datastore(1+fs*trialtime*incr:fs*trialtime*d,:);
    incr=incr+1;
end

% find epochs corresponding to classes (2 0 1) and store them
datastore_n=[];
datastore_l=[];
datastore_r=[];


clear C;clear D;
g=0; h=0; i=0;
for e=1:length(datastore_label)
    [p_trial,f1]= pwelch(datastore_reshape(:,:,e),fs/2,[],fs,fs);
    if datastore_label(e)==2
        datastore_n = p_trial(9:31,:);
%         datastore_n=abs(fft(datastore_reshape(:,:,e)));
        g=g+1;
    elseif datastore_label(e)==0
        datastore_l = p_trial(9:31,:);
%         datastore_l=abs(fft(datastore_reshape(:,:,e)));
        h=h+1;
    elseif datastore_label(e)==1
        datastore_r = p_trial(9:31,:);
%         datastore_r=abs(fft(datastore_reshape(:,:,e)));
        i=i+1;
    end
    if g==0
    else
    C(g,:,:)=datastore_n;
    end
    
    if h==0
    else
    Ddl(h,:,:)=datastore_l;
    end
    
    if i==0
    else
    Ddr(i,:,:)=datastore_r;
    end
end


C = permute(C,[1 3 2]);
D = [Ddl;Ddr];
D = permute(D,[1 3 2]);


accuracy=(predictedALL(:,2)-datastore_label);
accuracy = numel(find(~accuracy))/length(datastore_label); %this is the accuracy of the online classifier
% pwelch on E
% E=permute(E,[3 2 1]);
% EE=[];
% for g=1:size(E,3)
%     E(:,:,g) = ((filtfilt(b1,a1,E(:,:,g)))); %filtering
%     [p_E,f_E]= pwelch(E(:,:,g),Fs/2,[],Fs/2,Fs); %pwelch
%     EE(:,:,g) = p_E; 
% end
% EE=EE(5:16,:,:); %taking 8-30Hz in f_E
%% for test data (no cross validation)
Xn = permute(C,[2 3 1]); % baseline
Xm = permute(D,[2 3 1]);

% to get number of trials
sizeXn = size(Xn); % size should be same for both Xl and Xr
sizeXm = size(Xm);
% reshaping to get the trials next to each other (stack horizontally)
Xnreshape = reshape(Xn,sizeXn(1),sizeXn(2)*sizeXn(3));
Xmreshape = reshape(Xm,sizeXm(1),sizeXm(2)*sizeXm(3));

classtrain = horzcat(Xnreshape,Xmreshape);
train = spatFilt(classtrain,ProjectionCSPnm,5); % taking only the 5 best channels for CSP

sizeXn = size(Xn);
sizeXm = size(Xm);
sizetrain = size(train);
X_sv = X;
clear X
for r=1:size(C,1)+size(D,1)
    for g=1:sizetrain(1)
        X(r,1+(g-1)*(size(C,3)):g*(size(C,3)))=train(g,1+(r-1)*(size(C,3)):r*(size(C,3)));
    end
end

% customize the below lines based on the amount of trials recorded if it is
% uneven!!!!
Y_sv = Y;
clear Y
Y(1:size(C,1),:)=2; %null trials (baseline)
Y(size(C,1)+1:size(C,1)+size(Ddl,1)+size(Ddr,1),:)=0; %moving trials

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

tmp2 = predict(SVMModelnm,X(:,1:size(X,2)-1));
tmp2 = str2num(cell2mat(tmp2));
acc2testpred = tmp2 - Y;
acc2testpred = numel(find(acc2testpred == 0))/numel(Y);

%% second classifier

Dl = permute(Ddl,[1 3 2]);
Dr = permute(Ddr,[1 3 2]);


Xl = permute(Dl,[2 3 1]);
Xr = permute(Dr,[2 3 1]);

% to get number of trials
sizeXl = size(Xl); % size should be same for both Xl and Xr
sizeXr = size(Xr);
% reshaping to get the trials next to each other (stack horizontally)
Xlreshape = reshape(Xl,sizeXl(1),sizeXl(2)*sizeXl(3));
Xrreshape = reshape(Xr,sizeXr(1),sizeXr(2)*sizeXr(3));

classtrainEE = horzcat(Xlreshape,Xrreshape);
trainEE = spatFilt(classtrainEE,ProjectionCSPlr,5);


sizeEEXl = size(Xl);
sizeEEXr = size(Xr);
sizetrainEE = size(trainEE);
XEE_sv = XEE;
clear XEE
for r=1:size(D,1)
    for g=1:sizetrainEE(1)
        XEE(r,1+(g-1)*size(D,3):g*size(D,3))=trainEE(g,1+(r-1)*size(D,3):r*size(D,3));
    end
end

% creating labels/targets
YEE_sv = YEE;
clear YEE
YEE(1:size(Ddl,1),:)=0; %left trials
YEE(size(Ddl,1)+1:size(Ddl,1)+size(Ddr,1),:)=1; %right trials

% randomizing all the rows of XEE
tmpEE = randperm(size(XEE, 1));
XEE = XEE(tmpEE, :);
YEE = YEE(tmpEE, :);

%accuracy of left/right classifier
tmp2EE = predict(SVMModellr,XEE);
tmp2EE = str2num(cell2mat(tmp2EE));
acc2EE = tmp2EE - YEE;
acc2EE = numel(find(acc2EE == 0))/numel(YEE);

%% SVM Plot N and M Training session
%rename the X variable to X_sv  and save variable for testing session!!!
%note: these are plotted using true labels
clear Ystring
try
figure;
f1=1; f2=2; %change these numbers to compare different features
for u = 1:size(tmp1,1) %replace Y with tmp1 for predicted labels, or replace tmp1 with Y for true labels
    if tmp1(u)==0 %replace Y with tmp1 for predicted labels, or replace tmp1 with Y for true labels
        Ystring{u}='Moving';
    else
        Ystring{u}='Not moving';
    end
end
h(1:2) = gscatter(X_sv(:,f1),X_sv(:,f2),Ystring'); 
xlabel(sprintf('Feature %d',f1)),ylabel(sprintf('Feature %d',f2))
title('Not moving vs. moving linear SVM classifier, Online Training Session')
hold on
h(3) = plot(X_sv(SVMModelnm.IsSupportVector,f1),X_sv(SVMModelnm.IsSupportVector,f2),'ko','MarkerSize',10);
legend(h,{'Not moving','Moving','Support Vectors'});
axis equal
hold off
catch
end
%% SVM Plot left and Right Training session
%rename the XEE variable to XEE_sv and save variable for testing session!!!
%note: these are plotted using true labels
clear YEEstring
try
figure;
f1=1; f2=2; %change these numbers to compare different features
for u = 1:size(tmp1EE,1) %replace YEE with tmp1EE if using predicted labels, or replace tmp1EE with YEE for true labels
    if tmp1EE(u)==0 %replace YEE with tmp1EE if using predicted labels, or replace tmp1EE with YEE for true labels
        YEEstring{u}='Left';
    else
        YEEstring{u}='Right';
    end
end
h(1:2) = gscatter(XEE_sv(:,f1),XEE_sv(:,f2),YEEstring');
xlabel(sprintf('Feature %d',f1)),ylabel(sprintf('Feature %d',f2))
title('Left vs. right linear SVM classifier, Online Training Session')
hold on
h(3) = plot(XEE_sv(SVMModellr.IsSupportVector,f1),XEE_sv(SVMModellr.IsSupportVector,f2),'ko','MarkerSize',10);
legend(h,{'Left','Right','Support Vectors'});
axis equal
hold off
catch
end


%% SVM Plot N and M Online Prediction
%store X_sv from training session!!!
clear Ystring
try
    figure;
f1=1; f2=2; %change these numbers to compare different features
for u = 1:size(tmp2,1) %replace Y with tmp2 for predicted labels, or replace tmp2 with Y for true labels
    if tmp2(u)==0 %replace Y with tmp2 for predicted labels, or replace tmp2 with Y for true labels
        Ystring{u}='Moving';
    else
        Ystring{u}='Not moving';
    end
end
h(1:2) = gscatter(X(:,f1),X(:,f2),Ystring');
xlabel(sprintf('Feature %d',f1)),ylabel(sprintf('Feature %d',f2))
title('Not moving vs. moving linear SVM classifier, Online Prediction')
hold on
colorstring='br';
h(3)=gscatter(X_sv(SVMModelnm.IsSupportVector,f1),X_sv(SVMModelnm.IsSupportVector,f2),  SVMModelnm.Y(SVMModelnm.IsSupportVector,f1),'rb','oo');
legend(h,{'Not moving','Moving','Support Vectors'});
axis equal
hold off
catch
end
%% SVM Plot left and Right Online Prediction
%store XEE_sv from training session!!!
clear YEEstring
try
figure;
f1=1; f2=2; %change these numbers to compare different features
for u = 1:size(tmp2EE,1) %replace YEE with tmp2EE if using predicted labels, or replace tmp2EE with YEE for true labels
    if tmp2EE(u)==0 %replace YEE with tmp2EE if using predicted labels, or replace tmp2EE with YEE for true labels
        YEEstring{u}='Left';
    else
        YEEstring{u}='Right';
    end
end
h(1:2) = gscatter(XEE(:,f1),XEE(:,f2),YEEstring');
xlabel(sprintf('Feature %d',f1)),ylabel(sprintf('Feature %d',f2))
title('Left vs. right linear SVM classifier, Online Prediction')
hold on
h(3) = gscatter(XEE_sv(SVMModellr.IsSupportVector,f1),XEE_sv(SVMModellr.IsSupportVector,f2), SVMModellr.Y(SVMModellr.IsSupportVector,f1),'rb','oo');
legend(h,{'Left','Right','Support Vectors'});
axis equal
hold off
catch
end