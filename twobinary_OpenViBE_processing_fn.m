function [C,D] = twobinary_OpenViBE_processing_fn(samples,sampleTime,stims)
%% Two Binary Classifiers OpenViBE processing
addpath(genpath('C:\\Users\\fahee\\Downloads\\Capstone downloads\\labstreaminglayer-master\\labstreaminglayer-master\\LSL\\liblsl-Matlab'))
addpath(genpath('C://Users//fahee//Google Drive//University of Houston//Fall 2017//BIOE 4335 (Capstone)//Project files//Saved Data from OpenBCI GUI'))
stims_label = stims(:,2); %get all the markers

%% finding end of current trial to next trial cue
baseline5s = [];
stims = fix(stims);

for k=1:length(stims_label)-4 
    if k==1 && stims_label(k+3)==32776 && stims_label(k+5)==768
        baseline5s(k:4:k+4) = stims(k+3:2:k+5,1); %gets first 5 seconds before trials start
    elseif stims_label(k)==800 && (stims_label(k+4)==769 || stims_label(k+4)==770)
        baseline5s(k:4:k+4) = stims(k:4:k+4,1); %stores the times for end of a previous trial to cue of next trial
    elseif k==length(stims_label)-4 && stims_label(k+1)==800
        baseline5s(k:4:k+4) = stims(k+1:2:k+3,1); %gets five seconds after the last trial is finished
    else
    end
end

baseline5s=(baseline5s(baseline5s ~= 0));
%make sure that each pair of markers has a difference of 5, if not report
%where the pair starts and correct the second marker so that there's
%always 5 s after the end of trial 
diff_baseline = zeros(1,77);
for h = 1:2:length(baseline5s)-1
    if baseline5s(h+1)-baseline5s(h) ~= 5
       if  baseline5s(h+1)-baseline5s(h) == 6
           baseline5s(h+1) = baseline5s(h+1)-1;
       elseif baseline5s(h+1)-baseline5s(h) == 7
           baseline5s(h+1) = baseline5s(h+1)-2;
       else
       end
%         diff_baseline(h) = baseline5s(h+1)-baseline5s(h); %check
%         difference between timepoints is 5 seconds
    end
end
        

%take only first 80 of these markers (like forty trials worth of data)
baseline5s = baseline5s(:,1:80);

%% finding marker to end of trial data
markerleft = [];
markerright = [];
stims=fix(stims);

%taking only the 5 seconds including cue, not including the first 3
for k=1:length(stims_label)-4 %stores the times for cue and end of trial
    if stims_label(k)==786 && stims_label(k+2)==769 && stims_label(k+4)== 800
        markerleft(k+2:2:k+4) = stims(k+2:2:k+4,1) ;
    elseif stims_label(k)==786 && stims_label(k+2)==770 && stims_label(k+4)== 800
        markerright(k+2:2:k+4) = stims(k+2:2:k+4,1) ;
  
    else
       
    end
end

markerleft=(markerleft(markerleft ~= 0));
markerright=(markerright(markerright ~= 0));

%% Finding index of sampletime
Fs=250; epoch_win=5; fs=250;
markerleft_id = [];
markerright_id =[];
% Downsampling and Upsampling for integer precision
sampleTime_down=downsample(sampleTime,250); %downsample to 1 Hz
sampleTime_down=round(sampleTime_down); % gets rid of decimal places
sampleTime_up=upsample(sampleTime_down,250); 
sampleTime_up=sampleTime_up(1:length(sampleTime)); %making sure we get length of the array that we had prior to downsample
for n=1:length(markerleft) % finds the indices of the corresponding rows of data for each marker to end of trial
    for m=1:length(sampleTime_up)-Fs*epoch_win
        if sampleTime_up(m,:) == markerleft(n)
            markerleft_id(n)= m;
        elseif sampleTime_up(m,:) == markerright(n)
            markerright_id(n)= m;
        end
    end
end

moving_id = [markerleft_id markerright_id];

baseline5s_id = [];
for n=1:length(baseline5s) % finds the indices of the corresponding rows of data for each end of one trial to next trail's marker
    for m=1:length(sampleTime_up)-Fs*epoch_win
        if sampleTime_up(m,:) == baseline5s(n)
            baseline5s_id(n)= m;
        else
        end
    end
end

%% finding the corresponding rows of data relative to markers of interest
C=[];
D=[];
fft_moving=[];
fft_baseline=[];
epoch_moving=[];
epoch_baseline=[];
p=1;q=1;
%below loop uses the found indices from the above loop to get the rows of
%data corresponding to the found markers and the data corresponding to 5
%seconds after the marker was shown, then it takes the fft on that data. It
%also finds the data for the baseline trials (these are makeshift trials based on the
%time between the end of one trial to the right/left cue for the next
%trial). 

while p < length(baseline5s_id)+1 && q<(length(baseline5s_id)/2)+1
   epoch_moving = samples(moving_id(p):moving_id(p+1),:);
    epoch_baseline = samples(baseline5s_id(p):baseline5s_id(p+1),:);

%     fft_moving = abs(fft(epoch_moving));
%     fft_baseline = abs(fft(epoch_baseline));
    [p_moving,f1]= pwelch(epoch_moving,fs/2,[],fs,fs);
    D(:,:,q)=p_moving(9:31,:);
    [p_baseline,f2]= pwelch(epoch_baseline,fs/2,[],fs,fs);
    C(:,:,q)=p_baseline(9:31,:);
%      C(:,:,q)=fft_baseline;  
%      D(:,:,q)=fft_moving;
    p=p+2;
    q=q+1;
end

%permute the variables to get the correct dimensions
C=permute(C,[3 2 1]);
D=permute(D,[3 2 1]);

%taking only five channels
C=C(:,3:7,:);
D=D(:,3:7,:);

end

