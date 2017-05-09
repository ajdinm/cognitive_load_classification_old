function [  ClassifyResult ] = EvaluateClassification(Classified, validation_labels, figNr)
    
     [len,k]=size(Classified);
     
   % validation_labels=zeros(1,len);
    %validation_labels(len/2:len)=ones;
    for i =1 : 4
        [X_score(:,i),Y_score(:,i),~,AUC_score(:,i)] = perfcurve(validation_labels{i,1},Classified{i,1},1);
    end
    %plotting ROC for the two cognitnive loaded and the not loaded events
    X_mean_score=mean(X_score.');
    Y_mean_score=mean(Y_score.');
    AUC_score=mean(AUC_score);
    switch(figNr)
        case 1
            titleName='Support Vector Machine with gaussian kernel';
        case 2
            titleName='Support Vector Machine with polynomial kernel';
        case 3
            titleName='Linear Support Vector Machine';
        case 4
            titleName='Random Forest';
        otherwise
            titleName='Naive Bayes';
    end
    figure(figNr)
    plot(X_mean_score, Y_mean_score);
    xlabel('False Positive Rate');
    ylabel('True Positive Rate');
    AUC=['Area under curve: ', num2str(AUC_score)];
    title({titleName, ; AUC});
   
    TP=zeros(k);
    FP=zeros(k);
    TN=zeros(k);
    FN=zeros(k);
    
    for j=1:k
        N=length(validation_labels{j,1});
        for i=1:N
            
            if Classified{j,1}(i,1) == 1
                if Classified{j,1}(i,1) == validation_labels{j,1}(i,1)
                    %validation_labels(i)
                    TP(j) = TP(j) +1;  %true positive
                else
                    FP(j) = FP(j) +1;  %false positive
                end
            else
                if Classified{j,1}(i,1) == validation_labels{j,1}(i,1)
                    TN(j) = TN(j)+1; %true negative
                else
                    FN(j) = FN(j)+1; %false negative
                end
            end
        end
            Precision(j) = TP(j) / ( TP(j)+FP(j));
            
            TPR(j)=TP(j)/(TP(j)+FN(j)); %True positive rate aka Sensitivity
            FPR(j)=FP(j)/(TN(j)+FP(j)); %False positive rate
    end
    
    Precision=mean(Precision);
    TPR=mean(TPR);
    FPR=mean(FPR);
    ClassifyResult=table(AUC_score,Precision, TPR, FPR);
end
