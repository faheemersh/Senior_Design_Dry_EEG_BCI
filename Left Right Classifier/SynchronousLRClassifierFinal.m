addpath(genpath('C:\\Users\\fahee\\Downloads\\Capstone downloads\\labstreaminglayer-master\\labstreaminglayer-master\\LSL\\liblsl-Matlab'))
addpath(genpath('C://Users//fahee//Google Drive//University of Houston//Fall 2017//BIOE 4335 (Capstone)//Project files//Saved Data from OpenBCI GUI'))

% instantiate the library
disp('Loading the library...');
lib = lsl_loadlib();

% resolve a stream...
disp('Resolving an EEG stream...');
result = {};
while isempty(result)
    result = lsl_resolve_byprop(lib,'type','EEG'); 
end

% create a new inlet
disp('Opening an inlet...');
inlet = lsl_inlet(result{1});

disp('Now receiving data...');

% Initialize stuffs
EEGwMarkers=[];
time=[];
fs = 250;
[b1,a1] = butter(5,[8 12]/(fs/2));
[b2,a2] = butter(5,[13 30]/(fs/2));
[b3,a3] = butter(5,[8 12]/125);
[b4,a4] = butter(5,[13 30]/125);
labelstring = {'left','right','not moving'}; %if the output of predictedlabel{1} is 0, then left is chosen,if it is 1, then right is chosen
%%
fig=openfig('CursorMovement.fig','invisible');
fig.Units='pixels';
ScDim=[1,1,1920,1080];%get(0,'ScreenSize'); %hard coded to my screen size
Outer=fig.OuterPosition;Inner=fig.InnerPosition;
%close(fig)
%%
x1=960;
y1=540;
xs=[];ys=[];Datas=[];
%
% all units are in seconds
% training session
traintime = 161; %CHANGE THIS
steptime = 4; %CHANGE THIS: for creating C and D matrices (actual data we take, 3 seconds of the 4 second trials)
trialtime = 4; %CHANGE THIS
numtrials = 40; %CHANGE THIS
startprediction = 168;%CHANGE THIS

% online prediction
fullruntime = traintime+traintime+traintime;
predictiontrials = numtrials+numtrials+numtrials;
% markers for training session
markerMtx = ones(1,fs*traintime);
markerMtx = markerMtx.*7; %7 is used as a random number, does not need to be changed
randMarx = randperm(numtrials);
randMarx = mod(randMarx,2); % gives us 0, 1, and 2 as a remainder, don't change!!
everyxs = 1:trialtime:traintime-1;
for ii = 1:numtrials
    markerMtx(everyxs(ii)*fs) = randMarx(ii);
end

% markers for the online prediction
testmarkerMtx = ones(1,fs*(fullruntime)).*7; % tripling from the training time, 7 was randomly chosen
testrandMarx = randperm(predictiontrials); % tripling from the regular number of trials
testrandMarx = mod(testrandMarx,2); % gives us 0, 1, and 2 as a remainder, don't change!!
testeveryxs = 0:trialtime:fullruntime-trialtime;
for ii = numtrials:predictiontrials
    testmarkerMtx(testeveryxs(ii)*fs) = testrandMarx(ii-(numtrials-1));
end

msg=msgbox('Training session has started');
WinOnTop(msg);
disp('Training session has started');
Ml=[]; Mr=[]; N=[];
Mll=[]; Mrr=[]; NN=[];
C=[];D=[];
predicttask = [];
predictcount = [];
count=0;    this_count = []; predictedALL = []; predictedlabel = {}; datastore = [];
storethis_count = []; truelabels=[]; allXp =[]; allXEEp =[]; allXptimes = []; allXEEptimes = [];
while true
    
    % get data from the inlet
    count = count+1;
    [vec,ts] = inlet.pull_sample();
    EEGwMarkers(count,:) = vec;
    time(count,:) = ts;
    %% online training
    

    if count<(fs*traintime)+1
        if markerMtx(count) ~= 7
            if markerMtx(count) == 0
                delete(msg)
                msg=msgbox(sprintf('Time: %.0f. Open and close your left hand one time.\n',count/fs));
                WinOnTop(msg);
                                fprintf('Time: %.0f. Open and close your left hand one time.\n',count/fs);
            elseif markerMtx(count) == 1
                delete(msg)
                msg=msgbox(sprintf('Time: %.0f. Open and close your right hand one time.\n',count/fs));
                WinOnTop(msg);
                               fprintf('Time: %.0f. Open and close your right hand one time.\n',count/fs);
            end
        end
    end

    
    if count==fs*traintime % checking that the 80 trials worth of data has passed
        %using any integer multiplier greater than 5 works
        %         fprintf('\n%5.0f\n',vec(end)) for using with markers!
        this_count = count;
               disp('Training session is finished.');
        delete(msg)
        msg=msgbox('Training session is finished.');
        WinOnTop(msg);


    end % if this if statement results in false, then the following if statement is skipped

        if not(isempty(this_count)) && count==fs*traintime %start analysis if this_count is not empty
            %             data = abs(randn((60*1000)+250,8));
            data = EEGwMarkers(:,1:end-1); %gets the indexed EEG data for the 5 seconds prior
            %%% do the prediction routine
            % Train and map through CSP
            for p = fs:fs*trialtime:length(markerMtx)-fs*trialtime
                if markerMtx(p)==0
%                     Ml = data(p+1:p+trialtime*fs,5:7);
                    Ml = data(p+1:p+trialtime*fs,3:7);
                    Mll = [Mll;Ml];
                elseif markerMtx(p)==1
%                     Mr = data(p+1:p+trialtime*fs,5:7);
                    Mr = data(p+1:p+trialtime*fs,3:7);
                    Mrr = [Mrr;Mr];
                end
            end
            
            M = [Mll;Mrr];
            step = fs*steptime;
            p=1; q=1;
            while p < size(M,1)+1 && q < size(M,1)/step+1
                epoch_moving = M(p:p+step-1,:);
%                 epoch_moving_mu = filtfilt(b1,a1,epoch_moving);
%                 epoch_moving_beta = filtfilt(b2,a2,epoch_moving);

%                 fft_moving = abs(fft(epoch_moving));
%                 D(:,:,q)=fft_moving;
                
%                     [p_moving_mu,f1]= pwelch(epoch_moving_mu,fs/2,[],fs,fs);
%                     [p_moving_beta,f2]= pwelch(epoch_moving_beta,fs/2,[],fs,fs);
%                     D(:,:,q)=[p_moving_mu(9:31,:);p_moving_beta(9:31,:)];
                    [p_moving,f1]= pwelch(epoch_moving,fs/2,[],fs,fs);
                    D(:,:,q)=p_moving(9:31,:);
%                 D(:,:,q)=epoch_moving;
                p=p+step;
                q=q+1;
            end
            D = permute(D,[3 2 1]);
            %the dimensions of C and D are a little switched compared to
            %the offline code! Just a note. So permuting below is also
            %different than that in the offline code.
            %Start of twobinary_CSP.m code
  
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
                        
            %reorganizing for PSD just like below
            for r=1:size(D,1)
                for g=1:sizetrainEE(1)
                    XEE(r,1+(g-1)*size(D,3):g*size(D,3))=trainEE(g,1+(r-1)*size(D,3):r*size(D,3));
                end
            end
            
            %reorganizing (for fft) into rows (trials) by columns (features=samples*channels)
%             for r=1:size(D,1)
%                 for g=1:sizetrainEE(1)
%                     XEE(r,1+(g-1)*fs*trialtime:g*fs*trialtime)=trainEE(g,1+(r-1)*fs*trialtime:r*fs*trialtime);
%                 end
%             end
%           
%             %reducing the features
%             XEE = reshape(XEE,size(XEE,1),size(XEE,2)/250,250);
%             XEE = mean(XEE,3);
%             
           
%              % PCA
%              [coeff,score,latent,~,explained]=pca(XEE);
%              XEE = score(:,1:20);
% creating labels/targets
            YEE(1:sizeEEXl(3),:)=0; %left trials
            YEE(sizeEEXl(3)+1:sizeEEXl(3)+sizeEEXr(3),:)=1; %right trials
            
            %randomizing rows of XEE
            tmpEE = randperm(size(XEE, 1));
            XEE = XEE(tmpEE, :);
            YEE = YEE(tmpEE, :);
            XEE(:,size(XEE,2)+1) = YEE;
            sizeXEE = size(XEE);
            
            %% cross val for second classifier
            clear SVMModellr
            kfoldcrossvallr = 8;
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
            delete(msg)
            msg=msgbox(sprintf('Cross validation for 2nd classifier: \nThis is the average train accuracy: %.2f percent \nThis is the average test accuracy: %.2f percent \n',avetrainacclr*100,avetestacclr*100));
            WinOnTop(msg);
            fprintf('Cross validation for 2nd classifier: \nThis is the average train accuracy: %.2f percent \nThis is the average test accuracy: %.2f percent \n',avetrainacclr*100,avetestacclr*100);

            %% creating the second model
            SVMModellr = fitcsvm(XEE(:,1:size(XEE,2)-1),XEE(:,size(XEE,2)),'KernelFunction','linear',...
                'Standardize',true,'ClassNames',{'0','1'});
            
            CVSVMModellr = crossval(SVMModellr,'KFold',8);
            classLosslr = kfoldLoss(CVSVMModellr);
            
            %predicting on training set and accuracy of left/right classifier
            tmp1EE = predict(SVMModellr,XEE(:,1:size(XEE,2)-1));
            tmp1EE = str2num(cell2mat(tmp1EE));
            acc1EE = tmp1EE - YEE;
            acc1EE = numel(find(acc1EE == 0))/numel(YEE);
            
            %accuracy of lr classifier
            delete(msg)
            msg=msgbox(sprintf('Accuracy for the second classifier in the training session was %4.2f. \n',acc1EE*100));
            WinOnTop(msg);
            fprintf('Accuracy for the second classifier in the training session was %4.2f. \n',acc1EE*100);

            this_count=[];
        end
    %% Online prediction
    
    starttrial=[];
    if  count>fs*(traintime+trialtime) && mod(count,fs*trialtime) == 0
        predicttask = [predicttask;count/fs];
        if testmarkerMtx(count) == 0
            delete(msg)
            msg=msgbox(sprintf('Time: %.0f. Open and close your left hand one time.\n',count/fs));
            WinOnTop(msg);
            fprintf('Time: %.0f. Open and close your left hand one time.\n',count/fs);
            truelabels = [truelabels;testmarkerMtx(count)];
        elseif testmarkerMtx(count) == 1
            delete(msg)
            msg=msgbox(sprintf('Time: %.0f. Open and close your right hand one time.\n',count/fs));
            WinOnTop(msg);
            fprintf('Time: %.0f. Open and close your right hand one time.\n',count/fs);
            truelabels = [truelabels;testmarkerMtx(count)];
        end
%         delete(msg)
%         msg=msgbox(sprintf('Either sit still, or move your right or left hand now. Time: %.f',count/fs));
%         WinOnTop(msg);
%        fprintf('Either sit still, or move your right or left hand now. Time: %.f\n',count/fs)
    end
    
    if count/fs~=startprediction && mod(count,fs*trialtime) == 0 && count>fs*(traintime+trialtime) % checking that the 4 seconds (fs*4 samples) worth of data has passed
        %using any integer multiplier greater than 3 works  
%         fprintf('\n%5.0f\n',vec(end)) for using with markers!
        this_count = count;
        storethis_count = [storethis_count;this_count];
    end % if this if statement results in false, then the following if statement is skipped
    
    
    
    if not(isempty(this_count)) && count>fs*(traintime+trialtime) %fs*3 works
        % above line checks for whether this_count is empty and that the
        % difference between count and this_count is 6 seconds
        for dothis = 1:1
            %timer start
            % datapredict = abs(randn(750,8));
%             datapredict = abs(fft(EEGwMarkers(this_count-fs*trialtime+1:end,1:end-1))); %gets the indexed EEG data for the 5 seconds prior
                datapredict = EEGwMarkers(this_count-fs*trialtime+1:end,1:end-1);
                datapredict = datapredict(:,3:7);
                [p_movingp,f1p]= pwelch(datapredict,fs/2,[],fs,fs);
                datapredict=p_movingp(9:31,:);
                datastore = [datastore;EEGwMarkers(this_count-fs*trialtime+1:end,1:end-1)];
              %%% output prediction, occurs EVERY 10 seconds
                trainEEp = spatFilt(datapredict',ProjectionCSPlr,5);              
%                 trainEEp = permute(trainEEp,[3 2 1]);
%                 trainEEp = reshape(trainEEp,[1,size(trainEEp,1)*size(trainEEp,2)]); %1 for one trial only
                sizetrainEE1p = size(trainEEp);
%                 trainEEp = reshape(trainEEp,sizetrainEE1p(1),sizetrainEE1p(2)/fs,fs);
%                 XEEp = mean(trainEEp,3);
                for r=1:1 %1 trial
                    for g=1:sizetrainEE1p(1)
                        XEEp(r,1+(g-1)*sizetrainEE1p(2):g*sizetrainEE1p(2))=trainEEp(g,1+(r-1)*sizetrainEE1p(2):r*sizetrainEE1p(2));
                    end
                end
                allXEEp = [allXEEp;XEEp];
                allXEEptimes = [allXEEptimes;count/fs];
                % apply the built SVM
                predictedlabel = predict(SVMModellr,XEEp);
                predictedALL(end+1,:)= [vec(end),str2num(predictedlabel{1})];
                delete(msg)
                msg=msgbox(sprintf('\nPrediction: %s - Time: %.0f\n',labelstring{str2num(predictedlabel{1})+1},count/fs));
                WinOnTop(msg);

                predictcount = [predictcount;count/fs];
                fprintf('\nPrediction: %s - Time: %.0f\n',labelstring{str2num(predictedlabel{1})+1},count/fs)
                if testmarkerMtx(count) == 0
                    delete(msg)
                    msg=msgbox(sprintf('Time: %.0f. Open and close your left hand one time.\n',count/fs));
                    WinOnTop(msg);
                    fprintf('Time: %.0f. Open and close your left hand one time.\n',count/fs);
                elseif testmarkerMtx(count) == 1
                    delete(msg)
                    msg=msgbox(sprintf('Time: %.0f. Open and close your right hand one time.\n',count/fs));
                    WinOnTop(msg);
                    fprintf('Time: %.0f. Open and close your right hand one time.\n',count/fs);
                end

            
            this_count = []; %sets this count back to blank so that we can check again when 6 seconds have passed
        end
%         fprintf('\b\b\b\b\b')
        
        if ~isempty(predictedlabel)
            Data=str2num(predictedlabel{1}); %input the data from the classifier it gives doubles NOT categoricals
            if Data==0%left
%                 x=720;
%                 y=330;
                x=300;
                y=540;
            elseif Data==1 %right
                x=1610;
                y=540;
            end
       %%     
            %how to programatically control the cursor movement.
            import java.awt.Robot
            import java.awt.event.InputEvent
            robot=Robot();
            %do not pause between the import of java.awt.event.InputEvent and the mouse
            %press or else the program won't read input event
%             robot.mouseMove(400,400)
        %%    
            set(0,'PointerLocation',[x,y])
            xmove=abs(x-x1)/20;
            ymove=abs(y-y1)/20;
            a=x1; b=y1;
            for i=1:19
                if x1>x & y1>y
                    a=a-xmove;
                    b=b-ymove;
                elseif x1<x & y1<y
                    a=a+xmove;
                    b=b+ymove;
                end
                %robot.mouseMove(a,b);
                set(0,'PointerLocation',[a,b])
                pause(.1)
            end
            set(0,'PointerLocation',[x,y]);
            robot.mousePress(InputEvent.BUTTON1_MASK);
            pause(.5)
            robot.mouseRelease(InputEvent.BUTTON1_MASK);
            x1=x;
            y1=y;
            xs=[xs,x];ys=[ys,y];
            Datas=[Datas;Data];
            %
            predictedlabel={};
        end
    end
    
 

end
