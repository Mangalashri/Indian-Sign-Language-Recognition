%%
%Create a Visual Vocabulary and Train an Image Category Classifier
bag = bagOfFeatures(trainingSet,'GridStep',[4 4]);

img = readimage(imds, 1);
featureVector = encode(bag, double(img));

% Plot the histogram of visual word occurrences
figure;
bar(featureVector);
title('Visual word occurrences');
xlabel('Visual word index');
ylabel('Frequency of occurrence');

global categoryClassifier;
categoryClassifier = trainImageCategoryClassifier(trainingSet, bag);
%%
%Evaluate Classifier Performance
confMatrix = evaluate(categoryClassifier, trainingSet);