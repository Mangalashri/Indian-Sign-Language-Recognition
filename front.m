figure(1),
title = uicontrol('Style','text','String','Indian Sign Language to Text/Voice',...
    'Position',[5 350 550 25]);

figure(1),
button1 = uicontrol('Style','PushButton','String','Start Sign',...
'Position',[230 300 80 25]);
set(button1,'Callback',@fun1)

figure(1),
button2 = uicontrol('Style','PushButton','String','End Sign',...
'Position',[230 200 80 25]);
set(button2,'Callback',@fun2)

figure(1),
button3 = uicontrol('Style','PushButton','String','Next Sign',...
'Position',[230 250 80 25]);
set(button3,'Callback',@fun3)


figure(1),
button4 = uicontrol('Style','PushButton','String','Save Sign',...
'Position',[230 150 80 25]);
set(button4,'Callback',@fun4)

global resultList;
resultList=[];

%Start Sign button function 
function fun1(src,~)
   
    formatOut = 'HH:MM:SS:FFF';
    [~,~,~,hours,minutes,seconds] = datevec(datestr(now,formatOut), formatOut);
    time1 = 1000*(3600*hours + 60*minutes + seconds);

    %Capture image
    info = imaqhwinfo('kinect')
    %info.DeviceInfo(1)
    info.DeviceInfo(2)

    %rgbVid = videoinput('kinect',1);
    depthVid = videoinput('kinect',2);

    %rgbImage= getsnapshot(rgbVid);
    depthImage= getsnapshot(depthVid);
    start(depthVid);
    
    global resultList;
    resultList=[];
    
    global words;
    
    depthImage(depthImage==0)=2047;
    depthImage(depthImage>2047)=2047;
    global Img;
    Img = segment(depthImage);
    global result;
    result = predictlabel(Img);
    resultList = [resultList, result];
    figure(1),
    uicontrol('Style','text','String',words(result),...
    'Position',[5 100 550 25]);
    formatOut = 'HH:MM:SS:FFF';
    
    [~,~,~,hours,minutes,seconds] = datevec(datestr(now,formatOut), formatOut);
    time2 = 1000*(3600*hours + 60*minutes + seconds);
    disp(time2-time1);
    
end

%Next Sign button function 
function fun3(src,~)
    %Capture image
    info = imaqhwinfo('kinect')
    info.DeviceInfo(1)
    info.DeviceInfo(2)

    rgbVid = videoinput('kinect',1);
    depthVid = videoinput('kinect',2);

    rgbImage= getsnapshot(rgbVid);
    depthImage= getsnapshot(depthVid);
    start(depthVid);
    
    global resultList;
    global words;
    global Img;
    global result;
    
    depthImage(depthImage==0)=2047;
    depthImage(depthImage>2047)=2047;
    Img = segment(depthImage);
    result = predictlabel(Img);
    resultList = [resultList, result];
    figure(1),
    uicontrol('Style','text','String',words(result),...
    'Position',[5 100 550 25]);
end

%End Sign button function 
function fun2(src,~)
    global resultList;
    global conflictingWords;
    global words;
    figure(1),
    global wordList;
    wordList = [];
    resultSize = size(resultList);
    for i=1:resultSize(2)
        
        temp = words(conflictingWords(resultList(i),1));
        for j=2:4
            if(conflictingWords(resultList(i),j)~= 0)
                temp = strcat(temp,'/');
                
                temp = strcat(temp,words(conflictingWords(resultList(i),j)));
            end
        end
        wordList = [wordList, temp];
    end
    sentence = invertedindex(wordList);
    uicontrol('Style','text','String',sentence,...
'Position',[5 100 550 25]);
    resultList = [];
end

%Save Sign button function 
function fun4(src,~)
    global Img;
    global result;
    loc = 'C:\Users\Mangalashri\Desktop\Final Dataset\';
loc = strcat(loc, num2str(result));
loc = strcat(loc, '\');
formatOut = 'mm-dd-yy-HH-MM-SS';
loc = strcat(loc, datestr(now,formatOut));
loc = strcat(loc, '.png');
imwrite(Img,loc);
end
