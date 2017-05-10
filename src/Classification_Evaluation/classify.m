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

close all
clear
clc
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
    Xtemp=[];


    for j=1:totalFiles
        load(files{j});
        if j==1 
            SF=size(Features); %size of the loops to come
        end

        for i=1:SF(2) %extracting from the table which are loaded
            temp(:,i)=Features{:,i};
        end
        Norm_temp=zeros(SF(1),SF(2));
        for i=1:SF(2) %Normalinzing, each element in a column is divided
            %by the sum of the column of which the elements belong
            SumOfTemp=sum(temp(:,i));
            for k=1:SF(1)
                Norm_temp(k,i)=temp(k,i)/SumOfTemp;
            end
        end
        Xtemp=[Xtemp; Norm_temp(:,:)];
        %Normalinzing using built in function normc (requries the neural
        %network toolbox to be installed). This normalization makes the sum of
        %the square of all element in a column equal to 1
        %Norm_temp=normc(temp);
        %Xtemp=[Xtemp; Norm_temp(:,:)];        
    end
    X=[X;Xtemp];
    
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%X(:, [1:8] + 12) = []; %Removing features to try improve result
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

Y=repmat([1;0],length(X)/2,1); %Labels
Idx_CR=find(Events=='CR'); 
%if CR is among the events the labels need to be switched around for that
%event
if  Idx_CR> 0
    start=1+(Idx_CR(1,1)-1)*(length(X)/nrOfEvents);
    stop=start+(length(X)/nrOfEvents)-1;
    Y(start:stop)=repmat([0;1], (length(X)/(nrOfEvents*2)),1);
end


k = 4;  %How many folds for the k-fold

Indices=KFoldValid(k,length(Y));
Result = struct('Gaussian',{},'Polynomial',{},'Linear',{},'NaiveBayes',{},'RandomForest',{});
validation_labels = cell(k,1);
Gauss_Prediction=cell(k,1);
Poly_Prediction=cell(k,1);
Linear_Prediction=cell(k,1);
Random_Forest_Prediction=cell(k,1);
Naive_Bayes_Prediction=cell(k,1);

 


for j=1:k
    validation_inds=Indices{j,1};
    validation_set=X(validation_inds,:);
   
    validation_labels{j,1}=Y(validation_inds);
    %validation_labels=Y(validation_inds);
    
    training_inds = Indices;
    training_inds(j,:) =[];
    training_idx=[];
    for i=1:k-1
        training_idx=[training_idx , training_inds{i,1}(:,:)];
    end
    ix = randperm(length(training_idx));
    Shuffled_Train_idx = training_idx(ix);
    training_set =X(Shuffled_Train_idx,:);
    training_labels=Y(Shuffled_Train_idx);
    
    %Training of 5 different classifiers
    rng(1);
    SVM_Gaussian=fitcsvm(training_set ,training_labels,'KernelFunction','rbf',...
           'BoxConstraint',Inf,'ClassNames',[0,1],'KernelScale','auto');
    rng(1);
    SVM_Polynomial = fitcsvm(training_set, training_labels, ... 
           'KernelFunction', 'polynomial', 'Standardize', true, 'KernelScale','auto');
    rng(1);
    SVM_Linear  = fitcsvm(training_set, training_labels, ... 
           'KernelFunction', 'linear', 'Standardize', true, 'KernelScale','auto');

    Random_Forest = TreeBagger(20, training_set, training_labels, ...
           'OOBPrediction','on');
    Naive_Bayes = fitcnb(training_set, training_labels);

    %Validation of each classifier
    for i = 1:length(validation_inds)
        Gauss_Prediction{j,1}(i,1) = predict (SVM_Gaussian, validation_set(i,:));
        Poly_Prediction{j,1}(i,1) = predict (SVM_Polynomial, validation_set(i,:));
        Linear_Prediction{j,1}(i,1) = predict (SVM_Linear, validation_set(i,:));
        Random_Forest_Prediction{j,1}(i,1) = str2double(predict (Random_Forest, validation_set(i,:)));
        Naive_Bayes_Prediction{j,1}(i,1) = predict (Naive_Bayes, validation_set(i,:));
    end
    
end

Result(1).Gaussian=EvaluateClassification ( Gauss_Prediction, validation_labels, 1);
Result(2).Polynomial= EvaluateClassification ( Poly_Prediction, validation_labels,2);
Result(3).Linear= EvaluateClassification ( Linear_Prediction, validation_labels,3);
Result(4).RandomForest= EvaluateClassification ( Random_Forest_Prediction, validation_labels,4);
Result(5).NaiveBayes= EvaluateClassification ( Naive_Bayes_Prediction, validation_labels,5);


