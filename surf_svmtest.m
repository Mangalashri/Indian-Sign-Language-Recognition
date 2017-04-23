confMatrix = evaluate(categoryClassifier, testSet);

% Compute average accuracy
mean(diag(confMatrix));
