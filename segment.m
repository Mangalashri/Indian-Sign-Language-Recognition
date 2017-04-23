function Img = segment(A)
    %%
    figure(2),imshow(A,[0 2047]);
    pause(1);
   % whos
    %%
    %Denoising the depth image
    modifyA = zeros(size(A)+2);
    B = zeros(size(A));
    for x=1:size(A,1)
        for y=1:size(A,2)
            modifyA(x+1,y+1)=A(x,y);
        end
    end
    for i= 1:size(modifyA,1)-2
        for j=1:size(modifyA,2)-2
            window=zeros(9,1);
            inc=1;
            for x=1:3
                for y=1:3
                    window(inc)=modifyA(i+x-1,j+y-1);
                    inc=inc+1;
                end
            end
            med=sort(window);
            B(i,j)=med(5);
        end
    end
    img=B;
    
    figure(2),imshow(img,[0 2047]);
    pause(1);
    
    %%
    %Find histogram of the image
    C = reshape(img,[],1);
    C = double(C);
    D = hist(C,0:2047);
 
    %%
    %Hand Segmentation
    minPeakDist = 70;
    while minPeakDist >= 0
        %Find seed points to initialise the 3 clusters
        [pks,locs] = findpeaks(D,'NPeaks',3,'MinPeakHeight', 70,'MinPeakDistance',minPeakDist,'Annotate','peaks');
        while (size(pks)<3)
            minPeakDist = minPeakDist - 5;
            [pks,locs] = findpeaks(D,'NPeaks',3,'MinPeakHeight', 70,'MinPeakDistance',minPeakDist,'Annotate','peaks');
        end
       % xlabel('Depth');
        %ylabel('Frequency');
        %title('Histogram of the Depth Image');
        %findpeaks(D,'NPeaks',3,'MinPeakHeight', 70,'MinPeakDistance',minPeakDist,'Annotate','peaks');
        %pause(1);
        seed(1,1) = locs(1);
        seed(2,1) = locs(2);
        seed(3,1) = locs(3);
        %%
        %Segmentation of hands using kmeans
        [idx,centroids] = kmeans(double(img(:)),[],'Distance','cityblock','Start',seed);
        imseg = zeros(size(img,1),size(img,2));
        for i=1:max(idx)
            imseg(idx==i)=i;
        end
        imagesc(imseg)
        pause(1);
        %%
        %Separate hand region - Find the custer closest to kinect
        [i1,j1]=find(imseg==1,1);
        [i2,j2]=find(imseg==2,1);
        [i3,j3]=find(imseg==3,1);
        req = min([img(i1,j1) img(i2,j2) img(i3,j3)]);
        if req==img(i1,j1)
            req = 1;
        elseif req==img(i2,j2)
            req = 2;
        else
            req = 3;
        end
        hand = imseg;
        hand = hand==req;
        figure(2),imshow(hand);
        pause(1);
        %%
        %Bounding box around the hand regions
        L = bwlabel(hand);
        imageStats = regionprops(L,'Area','BoundingBox'); 
        area_values = [imageStats.Area];
        %Include regions with area greater than or equal to 500
        [idx] = find((500 <= area_values)); 
        %Remove regions with area less than 500
        [less] = find((500 > area_values)); 
        lesslen = size(less);
        z=1;
        while z<=lesslen(2)
            bbox = imageStats(less(z)).BoundingBox;
            x1 = ceil(bbox(1));
            x2 = round(x1 + bbox(3));
            y1 = ceil(bbox(2));
            y2 = round(y1 + bbox(4));
            hand(y1:y2, x1:x2) = 0;
            z=z+1;
        end
        len = size(idx);
        %If no of regions greater than 2(Might include belly or face or other
        %person's hand)
        if len(2)>2
            %Find the leftmost region which would be the left hand(min x)
            z=1;
            Max = 0;
            MaxInd = 1;
            while z<=len(2)
                if imageStats(idx(z)).BoundingBox(1) > Max && (imageStats(idx(z)).BoundingBox(1)+imageStats(idx(z)).BoundingBox(3))<630
                    Max = imageStats(idx(z)).BoundingBox(1);
                    MaxInd=idx(z);
                end
                z=z+1;
            end
            %Find the rightmost region which would be the right hand(max x)
            Min = 640;
            MinInd = 1;
            z=1;
            while z<=len(2)
                if imageStats(idx(z)).BoundingBox(1) < Min
                    Min = imageStats(idx(z)).BoundingBox(1);
                    MinInd=idx(z);
                end
                z=z+1;
            end
            top1=MinInd;
            top2=MaxInd;
            %Remove regions other than left or right hands
            z=1;
            while z<=len(2)
                if imageStats(idx(z)).BoundingBox(2)~=imageStats(top1).BoundingBox(2) && imageStats(idx(z)).BoundingBox(2)~=imageStats(top2).BoundingBox(2)
                    bbox = imageStats(idx(z)).BoundingBox;
                    x1 = ceil(bbox(1));
                    x2 = round(x1 + bbox(3));
                    y1 = ceil(bbox(2));
                    y2 = round(y1 + bbox(4));
                    hand(y1:y2, x1:x2) = 0;
                end
                z=z+1;
            end
            idx(1)=top1;
            idx(2)=top2;
            sizeidx = size(idx);
            while sizeidx(2)>2
                idx(3)=[];
                sizeidx = size(idx);
            end
            len=size(idx);
        end
        %After removing unnecessary regions, if there are two hands
        if len(2)==2
            %Sometimes hand may be connected to belly(Area will be very large i.e., greater than 20000). Try reducing minPeakDist
            if area_values(idx(1))>20000 || area_values(idx(2))>20000
                minPeakDist = minPeakDist - 5;
                continue;
            end
            bb1 = imageStats(idx(1)).BoundingBox;
            bb2 = imageStats(idx(2)).BoundingBox;
            %If there is only one hand, the other region might be belly(lies at
            %the bottom)
            bottom1 = bb1(2)+bb1(4);
            bottom2 = bb2(2)+bb2(4);
            if(bottom1 > 460)
                bbox = imageStats(idx(1)).BoundingBox;
                x1 = ceil(bbox(1));
                x2 = round(x1 + bbox(3));
                y1 = ceil(bbox(2));
                y2 = round(y1 + bbox(4));
                hand(y1:y2, x1:x2) = 0;
                %After removing belly,we have one hand
                Img = imcrop(hand,imageStats(idx(2)).BoundingBox);
                figure(2),imshow(Img);
                break;
            elseif(bottom2 > 460)
                bbox = imageStats(idx(2)).BoundingBox;
                x1 = ceil(bbox(1));
                x2 = round(x1 + bbox(3));
                y1 = ceil(bbox(2));
                y2 = round(y1 + bbox(4));
                hand(y1:y2, x1:x2) = 0;
                %After removing belly,we have one hand
                Img = imcrop(hand,imageStats(idx(1)).BoundingBox);
                figure(2),imshow(Img);
                break;
            else
                %Crop the two hands
                minx = min(bb1(1),bb2(1));
                miny = min(bb1(2),bb2(2));
                maxx = max(bb1(1),bb2(1));
                maxy = max(bb1(2),bb2(2));
                widthdiff = maxx-minx;
                heightdiff = maxy-miny;
                if bb1(1)==minx
                   objwidth = bb2(3);
                else
                   objwidth = bb1(3);
                end
                if bb1(2)==miny
                   height1 = bb1(4) - heightdiff;
                   height2 = bb2(4);
                else
                   height2 = bb2(4) - heightdiff;
                   height1 = bb1(4);
                end 
                objheight = max(height1,height2);
                Img = imcrop(hand,[minx, miny, widthdiff+objwidth, heightdiff+objheight]);
                figure(2),imshow(Img);
                break;
            end
        %One hand
        else
            %Sometimes hand may be connected to belly(Area will be very large i.e., greater than 19000). Try reducing minPeakDist
            if area_values(idx(1))>19000 
                minPeakDist = minPeakDist - 5;
                continue;
            else
                Img = imcrop(hand,imageStats(idx).BoundingBox);
                figure(2),imshow(Img);
                break;
            end
        end
    end
end