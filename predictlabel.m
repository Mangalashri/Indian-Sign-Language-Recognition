function result = predictlabel(Img)
    global words;
    %Predict SURF
    global categoryClassifier;
    rows = 150;
    cols = 150;
    [labelIdx, scores] = predict(categoryClassifier, double(Img));

    label = categoryClassifier.Labels(labelIdx);
    surfresult = str2num(label{1});
    disp('SURF');
    disp(words(surfresult));

    %Predict HOG
    global HOGClassifier;
    cellSize = [8 8];
    
    Img = imresize(Img, [rows cols]) ;
    inputImageHOGFeature = extractHOGFeatures(Img, 'CellSize', cellSize);
    [labelIdx, scores] = predict(HOGClassifier, inputImageHOGFeature);

    hogresult = double(string(labelIdx));
    disp('HOG');
    disp(words(hogresult));
      
    %Predict LBP
    global LBPClassifier;
   
    inputImageLBPFeature = extractLBPFeatures(Img, 'CellSize', cellSize,'Normalization','None');
    [labelIdx, scores] = predict(LBPClassifier, inputImageLBPFeature);

    lbpresult = double(string(labelIdx));
    disp('LBP');
    disp(words(lbpresult));
    
    result = ensemble(surfresult,hogresult,lbpresult);
    