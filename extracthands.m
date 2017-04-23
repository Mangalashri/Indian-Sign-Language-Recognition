%Store the segmented images
total = numel(dataSet.Files);
for i=1:total
    disp(i);
    name = dataSet.Files(i);
    A = importdata(name{1});
    A(A==0)=2047;
    A(A>2047)=2047;
    Img = segment(A);
    imwrite(Img,strrep(name{1}, 'txt', 'png'));
end
