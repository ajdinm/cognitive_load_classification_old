function [HFC,nrOfZeroCross,RevRate ] = STEERING_WHEEL(event,dir)
%Function to extract features from the steering wheel signal
%Three features are extracted and return from the function:
%Number of zero crossings
%Reversal rate
%HIGH FREQUENCY COMPONENT OF STEERING WHEEL ANGLE VARIATION 

    load (dir,'SS_VDM_stwAngle')
    %load ('TP02_20150518_1500_Drive_TimeSegment')   %For debugging
    fs=50;
    low=0.6;
    high=0.3;
    t=SS_VDM_stwAngle.TimeAxis.Data;
    Data=rad2deg(SS_VDM_stwAngle.Data);

    FiltData=LowPassFilter(low,fs,Data,2); %Filtering the signal
    FiltDataHigh=HighPassFilter(high,fs,FiltData,2); %Only used to calculate HFC
    [FiltData,idx]=get_event_signals(FiltData, t, event);

    %Extracting High frequency component of steering wheel angle 
    for i=1:length(event)
        Pall=rms(FiltData(idx(i,1):idx(i,2)));
        Pband=rms(FiltDataHigh(idx(i,1):idx(i,2)));
        HFC(i) = Pband/Pall;
    end

    %Extracting nr of zero crossings, numFeatuers corresponds to the number of
    %featuers per scenario
    for i=1:length(event)
        nrOfZeroCross(i,:)=ZeroCross(idx(i,1), idx(i,2), Data);
    end

    %Extracting reversal rate 
    for i=1:1:length(event)
        RevRate(i)=Rev_Rate(FiltData, idx(i,:), t);
    end 
end

%Papers and references
%http://www.ao.i2.psychologie.uni-wuerzburg.de/fileadmin/06020230/user_upload/11-_KrajewskiSommerSTEERING_WHEEL_BEHAVIOR_BASED_ESTIMATION_OF_FATIGUE.pdf
%http://www.its.leeds.ac.uk/projects/haste/Haste%20D2%20v1-3%20small.pdf
%https://www-nrd.nhtsa.dot.gov/pdf/esv/esv20/07-0262-o.pdf 
%https://www-nrd.nhtsa.dot.gov/pdf/esv/esv20/07-0262-O.pdf



% For plotting purpose and debugging purpose, uncomment if necessary
% figure
% subplot(2,2,1);
% plot(t(idx(1,1):idx(1,2)), FiltData(idx(1,1):idx(1,2)));
% xlabel('Time (s)');
% ylabel('Steering Angle (Degrees)');
% axis tight
% subplot(2,2,2);
% plot(t(idx(2,1):idx(2,2)), FiltData(idx(2,1):idx(2,2)));
% xlabel('Time (s)');
% ylabel('Steering Angle (Degrees)');
% axis tight
% subplot(2,2,3);
% plot(t(idx(3,1):idx(3,2)), FiltData(idx(3,1):idx(3,2)));
% xlabel('Time (s)');
% ylabel('Steering Angle (Degrees)');
% axis tight
% subplot(2,2,4);
% plot(t(idx(4,1):idx(4,2)), FiltData(idx(4,1):idx(4,2)));
% xlabel('Time (s)');
% ylabel('Steering Angle (Degrees)');
% axis tight