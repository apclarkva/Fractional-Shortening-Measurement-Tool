function [imagetoshow] = findPixels(corners,img,which,numIn)
% sliceplane = handle.LA1.Plane;

disp('Find Pixels');

si = size(img);


if strcmp(which,'LA')
% This will find the imagetoshow for LA1 slice
    %     This will find two vectors that outline the two sides of the plane
    vector1x2 = corners(2,:) - corners(1,:);
    vector1x3 = corners(3,:) - corners(1,:);
    
    % This will find the distance between the two points
    dist1x2 = sqrt(vector1x2(1).^2 + vector1x2(2).^2 + vector1x2(3).^2);
    dist1x3 = sqrt(vector1x3(1).^2 + vector1x3(2).^2 + vector1x3(3).^2);
    
    % This will use the distance and vector to find the unitvector from one
    % point to another
    unitvector1x2 = vector1x2./dist1x2;
    unitvector1x3 = vector1x3./dist1x3;
    % Must check to see if x, y or z are outside of pixel box This will
    % initialize the currpt to be the floor of LA1, which is the first pixel to
    % be saved
    currpt = floor(corners(1,:));
    % This will initialize the first point that is not rounded.  This is
    % necessary, because if you add the unit vector to the rounded currpt, then
    % it will always be rounded down to the corner before it.
    currpoint = corners(1,:);
    % initialzes a blank imagetoshow
    imagetoshow = [];
    % nested for loop which indexes from 1 to 256 in each for loop and will
    % retrieve 256x256 values to be saved in a 256x256 matrix.
    for index = 1:si(2)
        for i = 1:si(1)
            %         This if-else statement checks to see if the current point is
            %         inside the 256x256x256 image box.  If it is, then save the pixel
            %         at the current index to be 0
            if currpt(1) < si(1) && currpt(1) > 0 && currpt(2)<si(2) && currpt(2)>0 && currpt(3)<si(3) && currpt(3)>0
                
                imagetoshow(i, index) = img(currpt(1), currpt(2), currpt(3),numIn);
            else
                imagetoshow(i, index) = 0;
            end
            %         This creates the indeces that will be saved on the next loop
            %         through.
            currpoint = currpoint + unitvector1x2.*1;
            currpt = floor(currpoint);
        end
        %         This creates the indeces that will be saved on the next loop
        %         through.
        currpoint = corners(1,:) + index.*unitvector1x3;
        currpt = floor(currpoint);
    end
else
    zHeight = floor(corners(1,3));    
    imagetoshow = img(:,:,zHeight,numIn);
end

end