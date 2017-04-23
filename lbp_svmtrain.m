%%
rows = 100;
cols = 100;
%%
%Load Image Sets
setDir  = fullfile('C:\Users\Admin\Documents\8th sem\FYP\FinalDataset');
imds = imageDatastore(setDir,'FileExtensions','.png','IncludeSubfolders',true,'LabelSource',...
    'foldernames');
tbl = countEachLabel(imds);
%%
%Prepare Training and Test  Image Sets
minSetCount = min(tbl{:,2}); % determine the smallest amount of images in a category

% Use splitEachLabel method to trim the set.
imds = splitEachLabel(imds, minSetCount, 'randomize');

% Notice that each set now has exactly the same number of images.
countEachLabel(imds);
[trainingSet,testSet] = splitEachLabel(imds,0.80,'randomize'); 
name = trainingSet.Files(1);
Img = importdata(name{1});
Img = imresize(Img, [rows cols]) ;
%%
lbpFeatures = extractLBPFeatures(Img,'CellSize',[4 4],'Normalization','None');
lbpFeatureSize = length(lbpFeatures);
cellSize = [4 4];
numImages = numel(trainingSet.Files);
trainingFeatures = zeros(numImages, lbpFeatureSize, 'single');

%%
for i = 1:numImages
    disp(i);
    name = trainingSet.Files(i);
    A = importdata(name{1});
    Img = imresize(A, [rows cols]) ;
    trainingFeatures(i, :) = extractLBPFeatures(Img,'CellSize',[4 4],'Normalization','None');
end
%%
trainingLabels = trainingSet.Labels;
global lbpclassifier;
lbpclassifier = fitcecoc(trainingFeatures, trainingLabels);
%%
%confMatrix = evaluate(lbpclassifier, trainingSet);

%predictedLabels = predict(lbpclassifier, trainingFeatures);

%confMat = confusionmat(trainingLabels, predictedLabels);

%disp(confMatrix)

%mean(diag(confMatrix))