% X = []; % input vectors
% X = Features;
% Y = Y;

training_inds = crossvalind('HoldOut', length(Y), 0.8);
validation_inds = find(training_inds == 0);
training_inds = find(training_inds == 1);
n = 25 * 4;
training_inds = 1:n;
validation_inds = n:132;

training_set = X(training_inds,:);
training_labels = Y(training_inds, :);

validation_set = X(validation_inds,:);
validation_labels = Y(validation_inds,:);

k = 5;

classifier = fitcsvm(training_set, training_labels, 'KernelFunction', 'polynomial');
cross_val_classifier  = fitcsvm(training_set, training_labels, 'KernelFunction', 'linear');

cross_val_classifier_full = fitcsvm(X, Y);

random_forest = TreeBagger(25, training_set, training_labels, 'OOBPrediction','on');
nb = fitcnb(training_set, training_labels);
% crossval(random_forest, 'Kfold', k);

hits = [0 0 0 0 0]; % for each classifier
for i = 1:length(validation_labels)
    prediction = predict(classifier, validation_set(i,:));
    if prediction == validation_labels(i)
        hits(1) = hits(1) + 1;
    end
    prediction = predict(cross_val_classifier, validation_set(i,:));
    if prediction == validation_labels(i)
        hits(2) = hits(2) + 1;
    end
    prediction = predict(cross_val_classifier_full, validation_set(i,:));
    if prediction == validation_labels(i)
        hits(3) = hits(3) + 1;
    end
    prediction = predict(random_forest, validation_set(i,:));
    if str2double(prediction) == validation_labels(i)
        hits(4) = hits(4) + 1;
    end
    prediction = predict(nb, validation_set(i,:));
    if prediction == validation_labels(i)
        hits(5) = hits(5) + 1;
    end
end

fprintf('Accuracy %i\n', (hits .* 100) ./length(validation_labels));