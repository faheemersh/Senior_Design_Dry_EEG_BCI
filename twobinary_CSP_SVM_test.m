addpath(genpath('C:\\Users\\fahee\\Downloads\\Capstone downloads\\labstreaminglayer-master\\labstreaminglayer-master\\LSL\\liblsl-Matlab'))
addpath(genpath('C://Users//fahee//Google Drive//University of Houston//Fall 2017//BIOE 4335 (Capstone)//Project files//Saved Data from OpenBCI GUI'))

%% for test data (no cross validation), RUN THIS SECTION BY ITSELF!
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

%% predicting on the testing set
tmp2 = predict(SVMModelnm,X(:,1:size(X,2)-1));
tmp2 = str2num(cell2mat(tmp2));
acc2testpred = tmp2 - Y;
acc2testpred = numel(find(acc2testpred == 0))/numel(Y);
%% TEST SET ONLY: second CSP and SVM
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

% randomizing all the rows of X
tmpEE = randperm(size(XEE, 1));
XEE = XEE(tmpEE, :);
YEE = YEE(tmpEE, :);

%accuracy of left/right classifier
tmp2EE = predict(SVMModellr,XEE);
tmp2EE = str2num(cell2mat(tmp2EE));
acc2EE = tmp2EE - YEE;
acc2EE = numel(find(acc2EE == 0))/numel(YEE);

%% SVM Plot N and M
%store X_sv from training session!!!
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
xlabel(num2str(f1)),ylabel(num2str(f2))
title('Not moving vs. moving SVM classifier')
hold on
colorstring='br';
h(3)=gscatter(X_sv(SVMModelnm.IsSupportVector,f1),X_sv(SVMModelnm.IsSupportVector,f2),  SVMModelnm.Y(SVMModelnm.IsSupportVector,f1),'rb','oo');
legend(h,{'Not moving','Moving','Support Vectors'});
axis equal
hold off
catch
end
%% SVM Plot left and Right
%store XEE_sv from training session!!!
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
xlabel(num2str(f1)),ylabel(num2str(f2))
title('Left vs. right SVM classifier')
hold on
h(3) = gscatter(XEE_sv(SVMModellr.IsSupportVector,f1),XEE_sv(SVMModellr.IsSupportVector,f2), SVMModellr.Y(SVMModellr.IsSupportVector,f1),'rb','oo');
legend(h,{'Left','Right','Support Vectors'});
axis equal
hold off
catch
end