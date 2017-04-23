info = imaqhwinfo('kinect')
info.DeviceInfo(1)
info.DeviceInfo(2)

disp(count);

rgbVid = videoinput('kinect',1);
depthVid = videoinput('kinect',2);

rgbImage= getsnapshot(rgbVid);
depthImage= getsnapshot(depthVid);
start(depthVid);
inputImage = strcat('G:\FYP\Matlab Code\new\1\',num2str(count));
inputImage = strcat(inputImage, '.png');
imwrite(rgbImage,inputImage);

inputImage = strcat('G:\FYP\Matlab Code\new\1\',num2str(count));
inputImage = strcat(inputImage, '.txt');
save(inputImage,'depthImage');
count = count + 1;
depthImage(depthImage==0)=2047;
depthImage(depthImage>2047)=2047;

%%
imshow(depthImage,[0 2047]);
segment(depthImage);







