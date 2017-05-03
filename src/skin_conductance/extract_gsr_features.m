%load('/home/ajdin/workspace/AAI_project/dataset/TP02_20150518_1500_Drive.mat');
%load('/home/ajdin/workspace/AAI_project/dataset/TP02_20150518_1500_Drive_TimeSegment.mat')

y = SS_VDM_SC.Data;
t = SS_VDM_SC.TimeAxis.Data;

he_features = get_all_gsr_features(y, t, [HE]);
cr_features = get_all_gsr_features(y, t, [CR]);
sw_features = get_all_gsr_features(y, t, [SW]);

cognitively_loaded = [he_features(1, :); he_features(3,:); ...
                      cr_features(1,:); cr_features(3,:)];
not_cognitively_loaded = [he_features(2, :); he_features(4,:); ...
                      cr_features(2,:); cr_features(4,:)];
                  
