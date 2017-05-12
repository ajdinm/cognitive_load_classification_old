function [  ClassifyResult ] = EvaluateClassification(Classified, validation_labels, figNr)
     
    [X_score,Y_score,~,AUC_score] = perfcurve(validation_labels,Classified,1);
    
    %plotting ROC for the two cognitnive loaded and the not loaded events
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
    plot(X_score, Y_score);
    xlabel('False Positive Rate');
    ylabel('True Positive Rate');
    AUC=['Area under curve: ', num2str(AUC_score)];
    title({titleName, ; AUC});
   
    TP=0;
    FP=0;
    TN=0;
    FN=0;
        for i=1:length(validation_labels)
            if Classified(i) == 1
                if Classified(i) == validation_labels(i)
                    TP = TP +1;  %true positive
                else
                    FP = FP +1;  %false positive
                end
            else
                if Classified(i) == validation_labels(i)
                    TN = TN+1; %true negative
                else
                    FN = FN+1; %false negative
                end
            end
        end
            Precision = TP / ( TP+FP);
            TPR=TP/(TP+FN); %True positive rate aka Sensitivity
            FPR=FP/(TN+FP); %False positive rate
    
    ClassifyResult=table(AUC_score,Precision, TPR, FPR, TP, FP, TN, FN);
end
