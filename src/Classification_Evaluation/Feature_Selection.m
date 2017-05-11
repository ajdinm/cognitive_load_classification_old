close all
clear
clc

Events =['SW';'CR';'HE'];
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
SH = Shaibal_Features(Events,nrOfEvents);
X=[X,SH(:,:)];  


Y=repmat([1;0],length(X)/2,1); %Labels

Idx_CR=find(Events=='CR'); 
%if CR is among the events the labels need to be switched around for that
%event

if  Idx_CR> 0
    start=1+(Idx_CR(1,1)-1)*(length(X)/nrOfEvents);
    stop=start+(length(X)/nrOfEvents)-1;
    Y(start:stop)=repmat([0;1], (length(X)/(nrOfEvents*2)),1);
end

[inmodel,history]=sequentialfs(@my_fun,X,Y,'cv',4,'direction','forward','nfeatures',10);
OnesInModel=find(inmodel==1);
ZerosInModel=find(inmodel==0);