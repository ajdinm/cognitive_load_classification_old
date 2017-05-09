function [BlinkTime,NrOfBlinks,STDAMP ] = EOG(event,dir)
    %testing github
    
    %Preprocessing and feature extraction from the EOG signal
    %The average blinktime and nr of blinks during the event time
    %are extracted from the signal
    %Signal filtred through a lowpass, highpass as well as a median filter


    load (dir,'SS_VDM_VEOG','SS_VDM_HEOG')
    %load ('TP02_20150518_1500_Drive_TimeSegment')
    %event=HE;
    fs=256; %sample rate
    Low=30; %cut off freq
    High=0.5;
    
    VData=double(SS_VDM_VEOG.Data);
    t=SS_VDM_HEOG.TimeAxis.Data;

    VFiltData=LowPassFilter(Low,fs,VData,2);
    VFiltData=HighPassFilter(High,fs,VFiltData,5);
    VFiltData=medfilt1(VFiltData,5);
    [VFiltData,idx]=get_event_signals(VFiltData, t, event);
    
    
    for j=1:length(event)
        
                Temp=findpeaks(VFiltData(idx(j,1):idx(j,2)),t(idx(j,1):idx(j,2)),'MinPeakHeight', 50);
                MinHeight=max(Temp)/4;
        [pks,locs]=findpeaks(VFiltData(idx(j,1):idx(j,2)),t(idx(j,1):idx(j,2)),'MinPeakHeight', MinHeight,'MinPeakDistance',1.5);
        STDAMP(j)=std(pks);
        interval=fs*1; %one blink can be up to 2 seconds long
        BTime=[];
        for i=1:length(pks)
            in=find(locs(i) == t(idx(j,1):idx(j,2)))+idx(j,1);
            if in-idx(j,1)>interval
                [~,locmin1]=min(VFiltData(in-interval:in)); %Blink in the 2 second interval
                [~,locmin2]=min(VFiltData(in:in+interval)); 
                HalfRiseTime=(t(in)-t(in-locmin1))/2; 
                HalfFallTime=(t(in+locmin2) -t(in))/2;
                BTime(i,1)=HalfRiseTime+HalfFallTime; %calculates blink time
            end
        end
        BlinkTime(j)=mean(BTime(BTime~=0));
        NrOfBlinks(j) = length ( BTime);
    end
end



%http://www.diva-portal.org/smash/get/diva2:673983/FULLTEXT01.pdf
%Really usefull info, 3 blinks /min at cognitive load
%When a relax person does about 15blinks/min

%Mycket bra ang EOG!! Måste använda wavelet decomp.. Fixa på måndag!
%http://ieeexplore.ieee.org.ep.bib.mdh.se/stamp/stamp.jsp?arnumber=5444879

%Activities that require thought or attention, leads to a decrease in blink frequency (Andreassi,
%2000). When confronted with a visually demanding task, blink rate decrease significantly
%(Fogarty & Stern, 1989).

%http://ieeexplore.ieee.org.ep.bib.mdh.se/stamp/stamp.jsp?arnumber=5632116

%Filter freq 0.5-30Hz
%http://irep.iium.edu.my/28360/1/5104376821910001000.pdf
%https://link.springer.com/article/10.1007%2Fs10633-006-9030-0

%Eye blink typical 200-400ms, 400uV





% figure
% subplot(2,2,1);
% plot(t(idx(1,1):idx(1,2)), HFiltData(idx(1,1):idx(1,2)));
% xlabel('Time (s)');
% ylabel('Horizontal EOG');
% axis tight
% 
% subplot(2,2,2);
% plot(t(idx(1,1):idx(1,2)), VFiltData(idx(1,1):idx(1,2)));
% xlabel('Time (s)');
% ylabel('Vertical EOG (uV)');
% axis tight
% 
% subplot(2,2,3);
% plot(t(idx(1,1):idx(1,2)), HData(idx(1,1):idx(1,2)));
% xlabel('Unfiltered Time (s)');
% ylabel('Horizontal EOG (uV)');
% axis tight
% 



%     subplot(2,1,1);
% plot(t(idx(1,1):idx(1,2)), VData(idx(1,1):idx(1,2)));
% xlabel('Unfiltered Time (s)');
% ylabel('Vertical EOG (uV)');
% axis tight
% 
% subplot(2,1,2);
% plot(t(idx(1,1):idx(1,2)), VFiltData(idx(1,1):idx(1,2)));
% xlabel('Time (s)');
% ylabel('Vertical EOG (uV)');
% axis tight
%     


%plot_freq(fs,VFiltData);
%%%%%%%%%%%%%%%%%
