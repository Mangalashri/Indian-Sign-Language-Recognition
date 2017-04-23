%%
rows = 150;
cols = 150;
%%
name = trainingSet.Files{1};
Img = importdata(name);
Img = imresize(Img, [rows cols]) ;
%%
[hog_4x4, vis4x4] = extractHOGFeatures(Img,'CellSize',[4 4]);
hogFeatureSize = length(hog_4x4);
cellSize = [4 4];
numImages = numel(testSet.Files);
testFeatures = zeros(numImages, hogFeatureSize, 'single');
%%
% Extract HOG features from the test set.
for i = 1:numImages
    disp(i);
    name = testSet.Files(i);
    A = importdata(name{1});
    Img = imresize(A, [rows cols]) ;
    testFeatures(i, :) = extractHOGFeatures(Img, 'CellSize', cellSize);
end
testLabels = testSet.Labels;

global hogclassifier;
predictedLabels=predict(hogclassifier,testFeatures);
confMat=confusionmat(testLabels,predictedLabels);
mean(diag(confMat))
%{
predictedLabels = predict(hogclassifier, testFeatures);

confMat = confusionmat(testLabels, predictedLabels);
%}

