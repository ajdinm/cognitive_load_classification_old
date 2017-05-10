%Before running create three new folders in the directory of your choice
%and name the folders: FeatureExtraction_HE, FeatureExtraction_SW,
%FeatureExtraction_CR
%This is used to save the different features from the different events
%and the whole directory name goes in to SaveDir
%For example: C:\Desktop\Feature\ExtractedFeatures_SW\
%Also, scroll down to line 29 and change the event you want to run

close all
clear
clc
%Time segments directory
Time_Segments_Folder = 'C:\Users\nille\Desktop\AI Project VT 2017\script from shaibal\Time Segments';
%SaveLocation
SaveDir='C:\Users\nille\Desktop\AI Project VT 2017\Code\cognitive_load_classification\src\Classification_Evaluation\ExtractedFeatures_CR\';

addpath(genpath(Time_Segments_Folder));
files=dir( fullfile(Time_Segments_Folder,'*.mat'));
files = {files.name}';
totalFiles = length(files);

for i=1:totalFiles
    
    load(files{i}); %One file at the time
    name=files{i};
    nametemp=strsplit(name, 'e');
    name=strcat(nametemp{1},'e');
    folder=strcat('D:\Driving\',name); %The 8GB of data directory
    event=CR; %From what event do you want to extract the features?

    for i=1:numel(event)
        event{i}.timeSegment(1) = event{i}.timeSegment(1)+10;%chop of the 10 first seconds
        event{i}.timeSegment(2)= event{i}.timeSegment(1)+50; %Extract features for next 50 seconds
    end
    RespRate = RESPIRATION(event,folder)';

    [HFC,nrOfZeroCross,RevRate] = STEERING_WHEEL(event,folder);
    HFC=HFC';
    RevRate=RevRate';
    [MeanBlinkTime,BlinksPerMin,STDAMP]=EOG(event,folder);
    MeanBlinkTime=MeanBlinkTime';
    BlinksPerMin=BlinksPerMin';
    STDAMP=STDAMP';

    LD=Lane_Departure(event,folder)';
    LPA=Lateral_position_Acceleration(event,folder)';
    LPFB=Lateral_position_Fixed_Body(event,folder)';
    LPIR=Lateral_position_in_R(event,folder)';
    TH1=TH(event,folder)';

    ToC=Time_to_Collision(event,folder)';
    PD=extract_pd_features(event,folder);
    GSR=extract_gsr_features (event,folder);

    MRS=GSR(:,1);%means of the raw signal
    SDRS=GSR(:,2);%standard dev of the raw signal
    MAFDRS=GSR(:,3);%the means of the absolute values of the first differences of the raw signals
    MAFDNS=GSR(:,4);%the means of the absolute values of the first differences of the normalized signals
    MASDRS=GSR(:,5);%the means of the absolute values of the second differences of the raw signals
    MASDNS=GSR(:,6);%the means of the absolute values of the second differences of the normalized signals
    AGSR=GSR(:,7);%accumulated gsr
    AVGSR=GSR(:,8);%averaged gsr
    PM=GSR(:,9);%peak_magnitude
    PD=GSR(:,10);%peak_duration
    NROP=GSR(:,11);%number_of_peaks
    TOP=GSR(:,12);%time_to_peak
    ASP=GSR(:,13);%average spectral power
    BP=GSR(:,14);%bandpower
 
 %Transform necessary features to be expressed as rate/min
    for i=1:length(event)
        RevRate(i)=RevRate(i)*60/(event{i}.timeSegment(2)-event{i}.timeSegment(1));
        BlinksPerMin(i)=BlinksPerMin(i)*60/(event{i}.timeSegment(2)-event{i}.timeSegment(1));
        nrOfZeroCross(i)=nrOfZeroCross(i)*60/(event{i}.timeSegment(2)-event{i}.timeSegment(1));
        RespRate(i)=RespRate(i)*60/(event{i}.timeSegment(2)-event{i}.timeSegment(1));
    end

    EventNumber={'One';'Two';'Three';'Four'};
    Features=table(RespRate, BlinksPerMin, RevRate, HFC, MeanBlinkTime,...
    nrOfZeroCross,LPA,LPFB,LPIR,TH1,ToC,PD,STDAMP,MRS,SDRS,MAFDRS,MAFDNS,...
    MASDRS,MASDNS,AGSR,AVGSR,PM,PD,NROP,TOP,ASP,BP,'RowNames',EventNumber);
    %Save works like this:
    %Directory, name+_SW_FEATURES and now saves a table of this test subject with that event.
    save([SaveDir name '_CR_FEATURES.mat'], 'Features');
end

