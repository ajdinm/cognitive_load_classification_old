
function [ filtered_signal ] = moving_avg_filter(signal, step)
%moving_avg_filter Preformes moving avg_filter on signal
%   Detailed explanation goes here

coeff = ones(1, step) / step;
filtered_signal = filter(coeff, 1, signal);

end


% 
% clear
% clc
% close all
% load ('C:\Users\nille\Desktop\AI Project VT 2017\Data\TP02_20150518_1500_Drive.mat','SS_VDM_VEOG','SS_VDM_HEOG')
% 
%     load ('TP02_20150518_1500_Drive_TimeSegment')
%     event=HE;
%       fs=256;
%     Low=30;
%     High=0.5;
%     
%     HData=double(SS_VDM_HEOG.Data);
%     VData=double(SS_VDM_VEOG.Data);
%     t=SS_VDM_HEOG.TimeAxis.Data;
%     %[Lo_D,Hi_D,Lo_R,Hi_R] = wfilters('db9');
%     VFiltData=LowPassFilter(Low,fs,VData,2);
%     VFiltData=HighPassFilter(High,fs,VFiltData,5);
%     VFiltData = medfilt1(VFiltData,5);
%     
%     
%     
% [a,b]=wavedec(VFiltData,9,'db9');
% 
% [cd1,cd2,cd3,cd4,cd5,cd6,cd7,cd8,cd9] = detcoef(a,b,[1 2 3 4 5 6 7 8 9]);
% X=waverec(a,b,'db1');
% 
% length(cd1)+length(cd2)+length(cd3)+length(cd4)+length(cd5)+length(cd6)+length(cd7)+length(cd8)+length(cd9);
% 
% 
% plot_freq(fs,VFiltData);
% VFiltData1=VFiltData-X;
% 
% [VData,idx]=get_event_signals(VData,t,event);
% figure
% plot(t(idx(1,1):idx(1,2)), VData(idx(1,1):idx(1,2)))
% xlabel('Time (s)');
% ylabel('VData');
% 
%  VFiltData1 = medfilt1(VFiltData1,50);
% 
% figure
% plot(t(idx(1,1):idx(1,2)), VFiltData1(idx(1,1):idx(1,2)))
% figure
% plot(t(idx(1,1):idx(1,2)), VFiltData(idx(1,1):idx(1,2)))
