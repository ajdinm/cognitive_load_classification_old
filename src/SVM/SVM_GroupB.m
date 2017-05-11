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

Y_Ones=find(Y==1);
Y_Zeros=find(Y==0);
ClassOnes=X(Y_Ones(:),:);
ClassZeros=X(Y_Zeros(:),:);


Class1=ClassOnes(1:20,1:2);
Class2=ClassZeros(1:20,1:2);
x1=Class1;
x2=Class2;
% Combine data into one set
xt=[x1;x2];
% Create class labels
y=[ones(length(x1),1); -1.*ones(length(x2),1)];
N=length(xt);
% Scatter plot of original data class data points
figure
scatter(x1(:,1),x1(:,2));
hold on
scatter(x2(:,1),x2(:,2));
legend('Class1','Class2')
xlabel('x1')
ylabel('x2')
title('Class Data Scatter Plot')
% Data component of Langrangian dual
H=(xt*xt').*(y*y');
% Vector to flip signs
f=-ones(N,1);
%Constraint 1) a(i)>=0
A= -eye(N);
a=zeros(N,1);
% Constraint 2) sum[a(i)y(i)]=0
B=[y';zeros(N-1,N)];
b=zeros(N,1);

%Solve Quadratic Programming optimization for alpha
alph=quadprog(H+eye(N)*.001,f,A,a,B,b);
%Solve for W
w=(alph.*y)'*xt;
sv=[];
for i=1:length(xt)
if abs(alph(i))>=.0000001
    sv=[sv i];
end
end
xtsv=xt(sv,:);
wo=1/y(1)-w*xt(1,:)';   
if abs(w(1))<=.000001
y=-wo/w(2).*ones(round(max(xt(:,1))-min(xt(:,1))),1);
x=min(xt(:,2)):(max(xt(:,2))-min(xt(:,2)))/(length(y)-1):max(xt(:,2));
elseif abs(w(2))<=.000001
x=-wo/w(1).*ones(round(max(xt(:,2))-min(xt(:,2))),1);
y=min(xt(:,1)):(max(xt(:,1))-min(xt(:,1)))/(length(x)-1):max(xt(:,1));
else
x=round(min(xt(:,1))):round(max(xt(:,1)))
y=(w(1)/w(2)).*-x-wo/(w(2));
end
sv=[];
for i=1:length(xt)
if abs(alph(i))>=.0000001
    sv=[sv i];
end
end
xtsv=xt(sv,:);
scatter(xtsv(:,1),xtsv(:,2),'fillled','markeredgecolor','black','markerfacecolor','yellow');
% y=-(w(1).*x)-wo
length(x)
length(y)
hold on
plot(x,y)




