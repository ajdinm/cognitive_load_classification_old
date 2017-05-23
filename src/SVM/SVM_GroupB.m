%On line 13 you will have to change the directory path to the path where
%you have the three folders of extracted features.

close all
clear
clc
k = 5;  %Number of k-folds for feature selection algorithm
CritInclude=0.80;% Threshold will be set to 80% of maximum criterion
PortionToHoldOut=0.3; %For hold out validation must be between 0 and 1
%How many scenarios should be included in the classification?
%Choose between HE, SW and CR or two or all three. Separate them using ;
Scenario =['SW'];
FeatureDir='C:\Users\nille\Desktop\AI Project VT 2017\Code\cognitive_load_classification\src\Classification_Evaluation\';
choice = false; %set to true to run the script with the implemented SVM as well
FeatChoice=0; %1=only physological signals, 2= only vehicle siganls, else all signals
[nrOfScenarios,~]=size(Scenario);
X=[];
Featex='\ExtractedFeatures_';
for n=1:nrOfScenarios
    FeatureFolder=[FeatureDir Featex Scenario(n,:)];
    addpath(genpath(FeatureFolder));
    files=dir( fullfile(FeatureFolder,'*.mat'));
    files = {files.name}';
    totalFiles = length(files);
    
    for j=1:totalFiles
        load(files{j});
        if j==1 
            SF=size(Features); %size of the loops to come
        end
        for i=1:SF(2) %extracting from the table which are loaded
            temp(:,i)=Features{:,i}; %avoiding to convert all numbers to integers
        end      
        X=[X;temp];
    end
end
%Normalization of all features except HRV
Folder='C:\Users\nille\Desktop\AI Project VT 2017\Code\cognitive_load_classification\src\Classification_Evaluation';
addpath(genpath(Folder));
for i=1:size(X,2)
    X(:,i)=Normalization_Features(X(:,i));
end

HRV = Shaibal_Features(Scenario,nrOfScenarios); %Adding HRV features which already
%are normalized
X=[X,HRV(:,:)];  


if FeatChoice==1
    %Physological signals 1,2,5,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27 + HRV
    X=X(:,[1,2,5,12:55]);
elseif FeatChoice == 2
    %Vehicle signals 3,4,6,7,8,9,10,11
    X=X(:,[3,4,6:11]);
end

Y=repmat([1;0],length(X)/2,1);
Idx_CR=find(Scenario=='CR'); 
%if CR is among the scenarios the labels need to be switched around for that
%scenario
if  Idx_CR> 0
    start=1+(Idx_CR(1,1)-1)*(length(X)/nrOfScenarios);
    stop=start+(length(X)/nrOfScenarios)-1;
    Y(start:stop)=repmat([0;1], (length(X)/(nrOfScenarios*2)),1);
end

%%%%%%%%%%%%%%%%55
for m=1:1
%Hold out validation
[Train,Test]=HoldOutValid(Y, PortionToHoldOut);

%Sequential Feature Selection
if FeatChoice~=2
    [inmodel,history]=sequentialfs(@OptFeatures,X(Train,:),Y(Train),'cv',k,'direction','forward','nfeatures',15);
    threshold=max(history.Crit)-max(history.Crit)*(1-CritInclude);
    [~,indx]=find(inmodel==1);
    SelectedFeatures=indx(history.Crit > threshold);
    X1=X(:,SelectedFeatures(:,:));
    NoFeatures(m)=length(SelectedFeatures);
else
    X1=X; %No feature selection with only vehicle signals
end

%Training and validation set for the optimised SVM
training_set1=X1(Train,:);
training_labels1=Y(Train);
validation_set1=X1(Test,:);
validation_labels1=Y(Test);

SVM_Gaussian=fitcsvm(training_set1 ,training_labels1,'KernelFunction','rbf',...
           'BoxConstraint',100,'KernelScale','auto','Standardize',true...
           ,'Solver', 'L1QP');
[Opt_Prediction, Opt_Score] = predict (SVM_Gaussian, validation_set1);

%Implemented SVM
if choice == true
    sigma=0.25;
    Xnew = gaussian_kernel(X, sigma);
    training_set2=Xnew(Train,:);
    training_labels2=Y(Train);
    validation_set2=Xnew(Test,:);
    validation_labels2=Y(Test);
    [w,b]=quad_fitcsvm(training_set2, training_labels2);

    for i = 1:size(validation_labels2, 1)
        Prediction(i,1)= quad_predict(w, b, validation_set2(i,:));
    end
    ImplResult(m,:)=EvaluateClassification(Prediction, Prediction, validation_labels2, 6);
end
%Evaluate the results from the classification
OptimisedResult(m,:)=EvaluateClassification ( Opt_Prediction, Opt_Score(:,2), validation_labels1, 1);
disp('done');
end
