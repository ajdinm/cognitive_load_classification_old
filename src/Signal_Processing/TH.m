function [ result ] = TH( event,dir )

% close all
% clear all
% clc

% TTC - Time to colision, distance to lead vehicule divided by the differnece in speed between the 2.
%Speed of the vehicule - velX
%Speed of event vehicule - eventVehVelX
%Distance to event vehicule - eventVehDist

load (dir,'SS_VDM_velX')         %Speed of the vehicule - velX
load (dir,'SS_VDM_eventVehVelX')         %Speed of event vehicule - eventVehVelX
load (dir,'SS_VDM_eventVehDist')         %Distance to event vehicule - eventVehDist
%load ('TP02_20150518_1500_Drive_TimeSegment')
fs=50;
low=1;
high=0.1;
t=SS_VDM_velX.TimeAxis.Data;
Data1=SS_VDM_velX.Data;
Data2=SS_VDM_eventVehVelX.Data;
Data3=SS_VDM_eventVehDist.Data;

%                                                                 event= HE;  % CHANGE SCENARIO - CR,SW,HE

[Data1,idx]=get_event_signals(Data1, t, event);
% [Data2,idx]=get_event_signals(Data2, t, event);
[Data3,idx]=get_event_signals(Data3, t, event);

WinSize=100;


t1=t(idx(1,1):idx(1,2));              t2=t(idx(2,1):idx(2,2));              t3=t(idx(3,1):idx(3,2));              t4=t(idx(4,1):idx(4,2));

Data11 = Data1(idx(1,1):idx(1,2));    Data12 = Data1(idx(2,1):idx(2,2));    Data13 = Data1(idx(3,1):idx(3,2));    Data14 = Data1(idx(4,1):idx(4,2));

% Data21 = Data2(idx(1,1):idx(1,2));    Data22 = Data2(idx(2,1):idx(2,2));    Data23 = Data2(idx(3,1):idx(3,2));    Data24 = Data2(idx(4,1):idx(4,2));

Data31 = Data3(idx(1,1):idx(1,2));    Data32 = Data3(idx(2,1):idx(2,2));    Data33 = Data3(idx(3,1):idx(3,2));    Data34 = Data3(idx(4,1):idx(4,2));

% TTC - distance to lead /(lead vehicule speed - own vehicule speed)

% TTC1 = Data31/(Data21-Data11);
% TTC2 = Data32/(Data22-Data12);
% TTC3 = Data33/(Data23-Data13);
% TTC4 = Data34/(Data24-Data14);

% TH - dist to lead / own vehicule speed

TH1 = Data31/(Data11);
TH2 = Data32/(Data12);
TH3 = Data33/(Data13);
TH4 = Data34/(Data14);

% Features
% Average Time to Collision

% mean1 = mean(TTC1);
% mean2 = mean(TTC2);
% mean3 = mean(TTC3);
% mean4 = mean(TTC4);

% Average Time Headway

mean5 = mean(TH1);
mean6 = mean(TH2);
mean7 = mean(TH3);
mean8 = mean(TH4);
 
% value1 = min(mean1)
% value2 = min(mean2)
% value3 = min(mean3)
% value4 = min(mean4)
value5 = max(mean5);
value6 = max(mean6);
value7 = max(mean7);
value8 = max(mean8);

result = [value5,value6,value7,value8];
end
% choice = 2 ; % 1- Time to Colission, 2 - Time Headway, 3 - Overlap
% 
% if choice==1
%     figure
%     subplot(2,2,1);
%     plot(TTC1)
%     xlabel('Time (s)');
%     ylabel('TTC1');
%     axis tight
%     subplot(2,2,2);
%     plot(TTC2)
%     xlabel('Time (s)');
%     ylabel('TTC2');
%     axis tight
%     subplot(2,2,3);
%     plot(TTC3)
%     xlabel('Time (s)');
%     ylabel('TTC3');
%     axis tight
%     subplot(2,2,4);
%     plot(TTC4)
%     xlabel('Time (s)');
%     ylabel('TTC4');
%     axis tight
% 
% elseif choice == 2
%     subplot(2,2,1);
%     plot(TH1)
%     xlabel('Time (s)');
%     ylabel('TH1');
%     axis tight
%     subplot(2,2,2);
%     plot(TH2)
%     xlabel('Time (s)');
%     ylabel('TH2');
%     axis tight
%     subplot(2,2,3);
%     plot(TH3)
%     xlabel('Time (s)');
%     ylabel('TH3');
%     axis tight
%     subplot(2,2,4);
%     plot(TH4)
%     xlabel('Time (s)');
%     ylabel('TH4');
%     axis tight
%     
% elseif choice  == 3
%     subplot(2,1,1);
%     plot(TTC1)
%     hold on
%     plot(TTC2)
%     plot(TTC3)
%     plot(TTC4)
%     hold off
%     xlabel('Time (s)');
%     ylabel('ALL TTC');
%     axis tight
%     subplot(2,1,2);
%     plot(TH1)
%     hold on
%     plot(TH2)
%     plot(TH3)
%     plot(TH4)
%     hold off
%     xlabel('Time (s)');
%     ylabel('ALL TH');
%     axis tight
% end;
% 

