function [ criterion ] = my_fun(training_set,training_labels,validation_set,validation_labels)
model = fitcsvm(training_set, training_labels,'KernelFunction', 'rbf'...
    ,'Standardize', false, 'KernelScale','auto','BoxConstraint',1);
%Gaussian kernel = rbf
%Linear kernel = linear

Predictions = predict (model, validation_set);
[~,~,~,AUC] = perfcurve(validation_labels,Predictions,1);
criterion=1-AUC;
%criterion = sum(predict (model, validation_set)~=validation_labels);


end
    %model = svmtrain(trainY, trainX,['-s 0 -t 0 -c ' bestc]);
      %criterion = sum(svmpredict(testY, testX, model) ~= testY);