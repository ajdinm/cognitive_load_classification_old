X = []; % input vectors
X = [1 2]';
Y = repmat([0, 1]', [size(X, 1) / 2, 1]); % labels ?

training_inds = crossvalind('HoldOut', length(Y), 0.75);
validation_inds = find(training_inds == 0);
training_inds = find(training_inds == 1);

training_set = X(training_inds);
training_labels = X(training_inds);

validation_set = X(validation_inds);
validation_labels = Y(validation_inds);

k = 5;

classifier = fitcsvm(training_set, training_labels);
cross_val_classifier = crossval(classifier, 'Kfold', k);

cross_val_classifier_full = fitcsvm(X, Y);
cross_val_classifier_full = crossval(cross_val_classifier_full, 'Kfold', k);

random_forest = TreeBagger(10, training_set, training_labels);
random_forest_1 = TreeBagger(2, training_set, training_labels);

hits = [0 0 0 0 0]; % for each classifier
for i = 1:length(validation_labels)
    prediction = predict(classifier, validation_set(i,:));
    if prediction == Y(i)
        hits(1) = hits(1) + 1;
    end
    prediction = predict(cross_val_classifier, validation_set(i,:));
    if prediction == Y(i)
        hits(2) = hits(2) + 1;
    end
    prediction = predict(cross_val_classifier_full, validation_set(i,:));
    if prediction == Y(i)
        hits(3) = hits(3) + 1;
    end
    prediction = predict(random_forest, validation_set(i,:));
    if prediction == Y(i)
        hits(4) = hits(4) + 1;
    end
    prediction = predict(random_forest1, validation_set(i,:));
    if prediction == Y(i)
        hits(5) = hits(5) + 1;
    end
end

fprintf('Accuracy %i\n', hits ./length(validation_inds));