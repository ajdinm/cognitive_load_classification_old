close all
clear
clc


k = 10;  %Number of k-folds for feature selection algorithm
CritDiff=0.001;
PortionToHoldOut=0.2; %For hold out validation must be between 0 and 1
%How many events should be included in the classification?
%Choose between HE, SW and CR or two of them or all three.
Events =['SW';'HE';'CR'];
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
%Normalization of all features except HRV
for i=1:size(X,2)
    X(:,i)=Normalization_Features(X(:,i));
end

HRV = Shaibal_Features(Events,nrOfEvents); %Adding HRV features which already
%are normalized
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
%  [inmodel,history]=sequentialfs(@my_fun,X(Train,:),Y(Train),'cv',k,'direction','forward','nfeatures',15);
% 
% threshold=max(history.Crit)-CritDiff;
% SelectedFeatures=find(history.Crit > threshold);
% X=X(:,SelectedFeatures(:,:));

training_set=X(Train,:);
training_labels=Y(Train);
validation_set=X(Test,:);
validation_labels=Y(Test);

 sigma = 1;
training_set = gaussian_kernel(training_set, sigma);
[w, b]=quad_fitcsvm(training_set, training_labels);
hits=0;
for i = 1:size(validation_labels, 1)
    temp2(i,1)= quad_predict(w, b, validation_set(i,:));
     if temp2(i,1)==   validation_labels(i)
        hits = hits + 1;
    end
end
hits/length(validation_labels)
disp('done');
