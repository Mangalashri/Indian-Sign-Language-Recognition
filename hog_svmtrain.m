tbl = countEachLabel(imds);
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
numImages = numel(trainingSet.Files);
trainingFeatures = zeros(numImages, hogFeatureSize, 'single');

%%
for i = 1:numImages
    disp(i);
    name = trainingSet.Files(i);
    A = importdata(name{1});
    Img = imresize(A, [rows cols]) ;
    trainingFeatures(i, :) = extractHOGFeatures(Img, 'CellSize', cellSize);
end
%%
trainingLabels = trainingSet.Labels; 
global hogclassifier;
hogclassifier = fitcecoc(trainingFeatures, trainingLabels);
predictedLabels=predict(hogclassifier,trainingFeatures);
confMat=confusionmat(trainingLabels,predictedLabels);
mean(diag(confMat))