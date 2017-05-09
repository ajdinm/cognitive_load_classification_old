function [ result ] = Lateral_position_in_R(event,dir)


%  HASTE Book page 279 - mean value is used to calculate accuracy.
% Time to Line Crossing was first proposed by Godthelp and Konings (1981) to describe
% steering behaviour.  Godthelp’s proposed calculation of TLC included a complex mathematical
% definition, based on vehicle speed, steering wheel angle, heading angle and lateral position. In
% this calculation, it is assumed that the road is straight.

% Part of the fourier transformation, using cycle and mean performs a decomposition in the harmonic
% components   -  book : Time-Frequency Signal Analysis and Processing: A Comprehensive Reference - by - Boualem Boashash

% Mean value on cycling peaks data shows frequency of occurance
%   Mean on SideWind scenario shows in 1 and 3 - 408,5 resp 407.5 while in 2 and 4 - 317.78 resp 297.125
% 	
% close all
% clear all
% clc

load (dir,'SS_VDM_latPos') %---------------- data directory to be changed
%load ('TP02_20150518_1500_Drive_TimeSegment')
fs=50;
low=1;
high=0.1;
t=SS_VDM_latPos.TimeAxis.Data;
Data=SS_VDM_latPos.Data;

                    %              event= SW;  % CHANGE SCENARIO - CR,SW,BC

[Data,idx]=get_event_signals(Data, t, event);

WinSize=100;

t1=t(idx(1,1):idx(1,2));
t2=t(idx(2,1):idx(2,2));
t3=t(idx(3,1):idx(3,2));
t4=t(idx(4,1):idx(4,2));

Data1 = Data(idx(1,1):idx(1,2));
Data2 = Data(idx(2,1):idx(2,2));
Data3 = Data(idx(3,1):idx(3,2));
Data4 = Data(idx(4,1):idx(4,2));

[pks1,locs1] = findpeaks(Data1);
[pks2,locs2] = findpeaks(Data2);
[pks3,locs3] = findpeaks(Data3);
[pks4,locs4] = findpeaks(Data4);

cycles1 = diff(locs1);
cycles2 = diff(locs2);
cycles3 = diff(locs3);
cycles4 = diff(locs4);

% Mean values
meanCycle1 = mean(cycles1);
meanCycle2 = mean(cycles2);
meanCycle3 = mean(cycles3);
meanCycle4 = mean(cycles4);


result = [meanCycle1,meanCycle2,meanCycle3,meanCycle4];
end
% Plot 
% 
% figure
% subplot(2,2,1);
% plot(t1,Data1,t1(locs1),pks1,'or')
% xlabel('Time (s)');
% ylabel('Data1');
% axis tight
% subplot(2,2,2);
% plot(t2,Data2,t2(locs2),pks2,'or')
% xlabel('Time (s)');
% ylabel('Data2');
% axis tight
% subplot(2,2,3);
% plot(t3,Data3,t3(locs3),pks3,'or')
% xlabel('Time (s)');
% ylabel('Data3');
% axis tight
% subplot(2,2,4);
% plot(t4,Data4,t4(locs4),pks4,'or')
% xlabel('Time (s)');
% ylabel('Data4');
% axis tight
