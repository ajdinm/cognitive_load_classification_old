close all
clear
clc
%Using the features extracted with FeatureExtraction scirpt to compare
%5 different classifiers, k-fold cross validation is used where k can be
%changed to any real number you want. The classifiers are evaluated
%according to their ROC curve which will be plotted to you along with the
%AUC result.
%Need to install Bioinformatics Toolbox 4.7 for it to work - maybe not..??

%Find the folder in which you store the three folders that contains the
%features from FeatureExtraction.m script. 
%Type the directory and \ExtractedFeatures_, DO NOT include HE, CR or SW.
%So for example C:\Desktop\Features\ExtractedFeatures_


k = 10;  %How many folds for the k-fold
threshold=0.011; %Threshold for the feature selection
PortionToHoldOut=0.2; %For hold out validation must be between 0 and 1
%How many events should be included in the classification?
%Choose between HE, SW and CR or two of them or all three.
Events =['HE';'CR';'SW'];
[nrOfEvents,~]=size(Events);

X=[];
for n=1:nrOfEvents
    FeatureFolder=['C:\Users\nille\Desktop\AI Project VT 2017\Code\cognitive_load_classification\src\Classification_Evaluation\ExtractedFeatures_',Events(n,:)];
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
%Normalization takes place here
HRV = Shaibal_Features(Events,nrOfEvents); %Adding HRV features
X=[X,HRV(:,:)];  

Y=repmat([1;0],length(X)/2,1);
Idx_CR=find(Events=='CR'); 
%if CR is among the events the labels need to be switched around for that
%event
if  Idx_CR> 0
    start=1+(Idx_CR(1,1)-1)*(length(X)/nrOfEvents);
    stop=start+(length(X)/nrOfEvents)-1;
    Y(start:stop)=repmat([0;1], (length(X)/(nrOfEvents*2)),1);
end

%Hold out validation
[Train,Test]=HoldOutValid(Y, PortionToHoldOut);

%Sequential Feature Selection
[inmodel,history]=sequentialfs(@my_fun,X(Train,:),Y(Train),'cv',k,'direction','forward','nfeatures',20);
SelectedFeatures=find(history.Crit > threshold);

X=X(:,SelectedFeatures(:,:));
training_set=X(Train,:);
training_labels=Y(Train);
validation_set=X(Test,:);
validation_labels=Y(Test);

    %Training of 5 different classifiers
    rng(1);
    SVM_Gaussian=fitcsvm(training_set ,training_labels,'KernelFunction','rbf',...
           'BoxConstraint',1,'KernelScale','auto','Standardize',false);
    rng(1);
    SVM_Polynomial = fitcsvm(training_set, training_labels, ... 
           'KernelFunction', 'polynomial', 'Standardize', false, 'KernelScale','auto');
    rng(1);
    SVM_Linear  = fitcsvm(training_set, training_labels,'BoxConstraint',1, ... 
           'KernelFunction', 'linear', 'Standardize', false, 'KernelScale','auto');

    Random_Forest = TreeBagger(20, training_set, training_labels, ...
           'OOBPrediction','on');
    Naive_Bayes = fitcnb(training_set, training_labels);

    %Validation of each classifier
        Gauss_Prediction = predict (SVM_Gaussian, validation_set);
        Poly_Prediction = predict (SVM_Polynomial, validation_set);
        Linear_Prediction = predict (SVM_Linear, validation_set);
        Random_Forest_Prediction = str2double(predict (Random_Forest, validation_set));
        Naive_Bayes_Prediction = predict (Naive_Bayes, validation_set);


Result(1).Gaussian=EvaluateClassification ( Gauss_Prediction, validation_labels, 1);
Result(2).Polynomial= EvaluateClassification ( Poly_Prediction, validation_labels,2);
Result(3).Linear= EvaluateClassification ( Linear_Prediction, validation_labels,3);
Result(4).RandomForest= EvaluateClassification ( Random_Forest_Prediction, validation_labels,4);
Result(5).NaiveBayes= EvaluateClassification ( Naive_Bayes_Prediction, validation_labels,5);


