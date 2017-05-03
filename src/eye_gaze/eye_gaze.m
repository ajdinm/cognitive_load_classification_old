%load('/home/ajdin/workspace/AAI_project/dataset/TP02_20150518_1500_Drive.mat')
%load('/home/ajdin/workspace/AAI_project/dataset/TP02_20150518_1500_Drive_TimeSegment.mat')

t = SS_VDM_seGazeDirX.TimeAxis.Data;
x = SS_VDM_seGazeDirX.Data;
y = SS_VDM_seGazeDirY.Data;
z = SS_VDM_seGazeDirZ.Data;

% remove blinks
y = remove_blinks(y, t);
z = remove_blinks(z, t);

fs = 50;
[yhe1, yhe2, yhe3, yhe4] = separate_event_signals(y, t, [HE], 10, fs);
[zhe1, zhe2, zhe3, zhe4] = separate_event_signals(z, t, [HE], 10, fs);

