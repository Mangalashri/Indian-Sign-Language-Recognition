
%Load Image Sets
setDir  = fullfile('C:\Users\Mangalashri\Desktop\Final Dataset');
imds = imageDatastore(setDir,'FileExtensions','.png','IncludeSubfolders',true,'LabelSource',...
    'foldernames');
tbl = countEachLabel(imds);
%%
%Prepare Training and Test Image Sets
minSetCount = min(tbl{:,2}); % determine the smallest amount of images in a category

% Use splitEachLabel method to trim the set.
imds = splitEachLabel(imds, minSetCount, 'randomize');

% Notice that each set now has exactly the same number of images.
countEachLabel(imds);
global trainingSet;
global testSet;
[trainingSet,testSet] = splitEachLabel(imds,0.80,'randomize');

%{
global trainingSet;
global testSet;
load('trainingSet.mat');
load('testSet.mat');
%}
%%
name = testSet.Files(100);
Img = importdata(name{1});
%%
%Load trained classifiers
load('lbpclassifier.mat');
load('hogclassifier.mat');
load('surfClassifier4x4.mat');

global LBPClassifier;
LBPClassifier = lbpclassifier;
global HOGClassifier;
HOGClassifier = hogclassifier;
global SVMClassifier;
SVMClassifier = categoryClassifier;
%%
%Dataset words
datasetwords;
%%
load('conflictingWords.mat');
load('sentences.mat');

global conflictingWords;
conflictingWords = m;

