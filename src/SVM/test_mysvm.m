
 Events =['HE';'CR'];
[nrOfEvents,~]=size(Events);
% 
% X=[];
% for n=1:nrOfEvents
%     
%     FeatureFolder=['/home/ajdin/workspace/AAI_project/cognitive_load_classification/src/Classification_Evaluation/ExtractedFeatures_',Events(n,:)];
%     addpath(genpath(FeatureFolder));
%     files=dir( fullfile(FeatureFolder,'*.mat'));
%     files = {files.name}';
%     totalFiles = length(files);
%     Xtemp=[];
% 
% 
%     for j=1:totalFiles
%         load(files{j});
%         if j==1 
%             SF=size(Features); %size of the loops to come
%         end
% 
%         for i=1:SF(2) %extracting from the table which are loaded
%             temp(:,i)=Features{:,i};
%         end
%         Norm_temp=zeros(SF(1),SF(2));
%         for i=1:SF(2) %Normalinzing, each element in a column is divided
%             %by the sum of the column of which the elements belong
%             SumOfTemp=sum(temp(:,i));
%             for k=1:SF(1)
%                 Norm_temp(k,i)=temp(k,i)/SumOfTemp;
%             end
%         end
%         Xtemp=[Xtemp; Norm_temp(:,:)];
%         %Normalinzing using built in function normc (requries the neural
%         %network toolbox to be installed). This normalization makes the sum of
%         %the square of all element in a column equal to 1
%         %Norm_temp=normc(temp);
%         %Xtemp=[Xtemp; Norm_temp(:,:)];        
%     end
%     X=[X;Xtemp];
%     
% end
% SH = Shaibal_Features(Events,nrOfEvents);
% X=[X,SH(:,:)];  
% %around 0.84 for linear kernel with only SW event
% %X=X(:,[2,3,7,9,26,29,30,42,49]); 
% %0.74 for gaussian kernel with only SW event
% %X=X(:,[1 2 3 4 6 7 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 29 30 33 34 35 37 38 40 41 42 43 44 45 46 47 48 49 50 51 52 53 54 55]);
% %0.63 for linear kernel with ALL events
% %X=X(:,[4 6 11 15 22 35 52]);
% %0.65 for gaussian kernel with ALL events
% %X=X(:,[3 5 6 7 11 15 20 22 34 50]);
% %0.66 for gaussian kernel with HE, CR
% %X=X(:,[7 10 11 26 32 34 35 40 47 55]);
% 
% 
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %Deletes column 1 to 8
% %X(:, [1:8]) = []; %Removing features to try improve result
% %X(:, [
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% Y=repmat([1;0],length(X)/2,1); % TrueLabels
% 
% 
% 
% 
% 
% 
% 
% Idx_CR=find(Events=='CR'); 
% %if CR is among the events the labels need to be switched around for that
% %event
% 
% if  Idx_CR> 0
%     start=1+(Idx_CR(1,1)-1)*(length(X)/nrOfEvents);
%     stop=start+(length(X)/nrOfEvents)-1;
%     Y(start:stop)=repmat([0;1], (length(X)/(nrOfEvents*2)),1);%true labels
%  
% end
% 
% [inmodel,history]=sequentialfs(@my_fun,X,Y,'cv',4,'direction','forward','nfeatures',20);
% OnesInModel=find(inmodel==1);
% ZerosInModel=find(inmodel==0);
% 
% X=X(:,inmodel(:,:));
% 
%  x = X;
%  y = Y;
%  y(y == 0) = -1;
%  [w, b] = my_fitcsvm(x, y);
x = [5     1;
     6    -1;
     7     3;
     1     7;
     2     8;
     3     8];
 y = [1 1 1 -1 -1 -1]';
 
 positive_test = [6 -5; 5 1];
 negative_test = [2 10; 3 8];
 obs_test = [positive_test;negative_test];
 
 % using quad prog
 [n, p] = size(x);
 H = eye(p);
 H(p+1, p+1) = 0;
 f = zeros(p+1, 1);
 A = -[diag(y)*x y];
 bb = -ones(n, 1);
 
 solution_q = quadprog(H, f, A, bb);
 labels_test = [1 1 -1 -1]; 
 
 results_imp = 1:4;
 results_q;
 for i = 1:size(X,1)
%     results_imp(i) = sign(dot(w, obs_test(i,:)) + b) == labels_test(i);
    results_q(i) = sign(dot(solution_q([1:end-1]), x(i,:)) + solution_q(end)) == y(i);
 end
 results_imp
 length(results_q(results_q == 1)) / length(results_q)
