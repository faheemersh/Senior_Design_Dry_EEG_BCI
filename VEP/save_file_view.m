addpath('C:\\Users\\fahee\\Google Drive\\University of Houston\\Fall 2017\\BIOE 4335 (Capstone)\\Project files\\Saved Data from OpenBCI GUI\\p300')

% T = readtable('OpenBCI-RAW-faheem_p300_021518_tr2_mod.txt');
T = readtable('faheem-wet-vep-4-13-tr2.txt');

% filename = 'OpenBCI-RAW-faheem_p300_021518_tr2_mod.txt';
% filename = 'myfile01.txt';
% delimiterIn = ' ';
% headerlinesIn = 1;
% A = importdata(filename,delimiterIn,headerlinesIn);

EEG_data = (table2array(T(:,2:9)))';
Markers = (table2array(T(:,10:14)))';

% D17 = Markers(2,:); %Actually D12, changed to D17 for sake of time
D17 = Markers(4,:); %this line is actually D17
new_D17 = [];
% inverting the D17 data from zero to one and one to zero
for k=1:length(D17)
    if D17(k)==1
        new_D17(k) = 0;
    else
        new_D17(k) = 1;
    end
end
       
% plotting all the channels original data
% figure(2)
for i=1:8
    time = (1:length(EEG_data));
%     subplot(8,1,i)
%     plot(time,EEG_data(i,:))
end

% making sure that the D17 data has inversed ones and zeros
% figure(3)
% plot(time,new_D17,'.')


%plotting each channel multiplied with the new D17 marker variable
% figure(4)
for i=1:8
    time = (1:length(EEG_data));
%     subplot(8,1,i)
%     plot(time,new_D17.*EEG_data(i,:))
end

% plotting one channel with markers
% figure(5)
% plot(time,EEG_data(8,:),time,new_D17.*EEG_data(8,:),'o')

EEG_data_mod = EEG_data';
% save('faheem-wet-vep-4-13-tr2.mat',EEG_data_mod) 
%% finding zero to one and one to zero in the D17 vector (markers)

markerpos = [];
for k=1:length(D17)-1
    if D17(k)==0 && D17(k+1)==1
        markerpos(k+1) = k+1;
    elseif D17(k)==1 && D17(k+1)==0
        markerpos(k+1) = k+1;
    else
        markerpos(k+1) = 0;
    end
end
        

% getting rid of zeros
markerpos_exact = (markerpos(markerpos ~= 0))';

%NOTE: YOU NEED TO STILL MAKE SURE SOMEHOW THAT THE CH_0 INDICES ARE
%ACTUALLY 30 INDICES AWAY FROM ONE ANOTHER, CURRENT CODE DOESN'T DO THAT,
%IT JUST ASSUMES EVERYTHING IS CORRECTLY SPACED

for j=1:length(markerpos_exact)-1
    if mod(j,2) == 0 && markerpos_exact(j+1)-markerpos_exact(j) < 3500 %this number set to ensure that we're getting the points that are 30 indices away from each other
        type(j,1) = "CH_2";
    elseif mod(j,2) ~= 0
        type(j,1) = "CH_1";
    else 
        type(j,1) = "CH_0";
    end
end
type(length(markerpos_exact),1)= "CH_0";

duration = nan(length(markerpos_exact),1);

fulldata = [markerpos_exact type duration];

T = table;
T.latency = markerpos_exact;
T.type = type;
T.duration = duration;

writetable(T,'event_markers_faheem-wet-vep-4-13-tr2.xlsx');
% Now save that .xlsx file as a (macintosh) .txt file in Excel and then put
% in EEGLAB
