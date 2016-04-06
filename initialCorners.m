function [ output_args ] = initialCorners( fig2, fig3, fig4, figSA, fig3D )

handles3D = get(fig3D, 'UserData');
handles2 = get(fig2,'UserData');
handles3 = get(fig3,'UserData');
handles4 = get(fig4,'UserData');
handlesSA = get(figSA,'UserData');

% The size of the images to be used are 300x400
% 1) place the z plane at 150.
% the corners below go: [bottom left, bottom right, upper left, upper right]
zHeight = 150;% The height of the short axis
handles3D.cornersSA = [0 0 zHeight;...
    0 400 zHeight;...
    300 0 zHeight;...
    300 400 zHeight];


set(figSA, 'WindowButtonDownFcn', @distanceFromPoints);
set(fig2, 'WindowButtonUpFcn', @(x,y,figure2,figure3,figure4,figureSA,f3D)plot3D(x,y,fig2,fig3,fig4,figSA,fig3D));
set(fig3, 'WindowButtonUpFcn', @(x,y,figure2,figure3,figure4,figureSA,f3D)plot3D(x,y,fig2,fig3,fig4,figSA,fig3D));
set(fig4, 'WindowButtonUpFcn', @(x,y,figure2,figure3,figure4,figureSA,f3D)plot3D(x,y,fig2,fig3,fig4,figSA,fig3D));
set(figSA, 'WindowButtonUpFcn', @(x,y,figure2,figure3,figure4,figureSA,f3D)plot3D(x,y,fig2,fig3,fig4,figSA,fig3D));


%-----------------------------------------------------------------------
% That is all I need to do for the short axis corners
% Now, for the four chamber corners: match the center points of 4ch and SA
points2on4 = getPosition(handles4.line1);
points4onS = getPosition(handlesSA.line3);

% Match the midpoint of the short axis with the intersection of SA and 2Ch
% of the 4Ch view
midPt4onS = mean(points4onS);
% The lineSon4 is mean of 2on4
midPt2on4 = mean(points2on4);

% Now,match the 4 chamber and SA views
vector4onS = points4onS(2,:)-points4onS(1,:); % vector between the two points on the 2 chamber view:
unitVector4onS = vector4onS./norm(vector4onS);
% multiply the unitvector by the x distance of midPt2on4
ch4XY00 = -unitVector4onS.*midPt2on4(1); %This gives x distance along SA view of [0,0 and 0,300]
ch4XY4000 = unitVector4onS.*(400-midPt2on4(1));
% The y value of the midPt2on4 is the z value of intersection of SA with
% 4Ch
midPt4onS = [midPt4onS(2), midPt4onS(1), 150];
midPt4onSx4 = [midPt4onS;midPt4onS;midPt4onS;midPt4onS];

% Need BA axis in 3D...
midPt2on4x2 = [midPt2on4; midPt2on4];
vectMidtoBA = midPt2on4x2-points2on4;
apexBaseIn3D = [midPt4onS;midPt4onS]+...
    [vectMidtoBA(1,1).*unitVector4onS vectMidtoBA(1,2);...
    vectMidtoBA(2,1).*unitVector4onS vectMidtoBA(2,2)];

% Must add the x and y components to the actual center points

handles3D.corners4 = midPt4onSx4 + [ch4XY00(2) ch4XY00(1)  midPt2on4(2);...
    ch4XY4000(2) ch4XY4000(1)  midPt2on4(2);...
    ch4XY00(2) ch4XY00(1) -(300-midPt2on4(2));...
    ch4XY4000(2) ch4XY4000(1) -(300-midPt2on4(2))];
%-----------------------------------------------------------------------
% Must find the 2Ch and 3ch corners by aligning the BA axis of 4 and 2 and then
% rotating the 2Ch and 3ch such that the 2 and 3 are along the line on the SA view.
% Do this for

vectLonS = points4onS(1,:) - points4onS(2,:);
theta4 = (atand(vectLonS(2)./vectLonS(1)));
handlesSA.theta4 = theta4;
for j = 1:2
    if j ==1
        pointsLonL = getPosition(handles2.line2);
        pointsLonS = getPosition(handlesSA.line1);
    elseif j == 2
        pointsLonL = getPosition(handles3.line2);
        pointsLonS = getPosition(handlesSA.line2);
    else
        pointsLonL = getPosition(handles4.line1);
        
        points2onS = getPosition(handlesSA.line1);
        points4on2 = getPosition(handles2.line2);
        
        midPt2onS = mean(points2onS);
        midPt4on2 = mean(points4on2);
        
        midPt2onS = mean(points2onS);
        % The lineSon4 is mean of 2on4
        midPt4on2 = mean(points4on2);
        
        % Now,match the 4 chamber and SA views
        vector2onS = points4onS(2,:)-points4onS(1,:); % vector between the two points on the 2 chamber view:
        unitVector2onS = vector2onS./norm(vector2onS);
        % multiply the unitvector by the x distance of midPt2on4
        ch2XY00 = -unitVector2onS.*midPt4on2(1); %This gives x distance along SA view of [0,0 and 0,300]
        ch2XY4000 = unitVector2onS.*(400-midPt4on2(1));
        % The y value of the midPt2on4 is the z value of intersection of SA with
        % 4Ch
        midPt2onS = [midPt2onS(2), midPt2onS(1), 150];
        midPt2onSx4 = [midPt2onS;midPt2onS;midPt2onS;midPt2onS];
        
        % Need BA axis in 3D...
        midPt4on2x2 = [midPt4on2; midPt4on2];
        vectMidtoBA = midPt4on2x2-points4on2;
        apexBaseIn3D = [midPt2onS;midPt2onS]+...
            [vectMidtoBA(1,1).*unitVector2onS vectMidtoBA(1,2);...
            vectMidtoBA(2,1).*unitVector2onS vectMidtoBA(2,2)];
    end
    vect4on2 = pointsLonL(2,:)-pointsLonL(1,:);%from apex to base
    unitV4on2 = vect4on2./norm(vect4on2);
    m1 = unitV4on2(2)./unitV4on2(1);
    m2 = -1/m1;
    corners = [0 0;400 0; 0 300; 400 300];
    % Find point in 2D of intersection pt
    perpIntPt = [];
    for i = 1:4
        x1 = pointsLonL(1,1);
        y1 = pointsLonL(1,2);
        x2 = corners(i, 1);
        y2 = corners(i, 2);
        x0 = (-m2.*x2+m1.*x1+y2-y1)./(m1-m2);
        y0 = m1.*(x0-x1)+y1;
        perpIntPt = [perpIntPt; x0 y0];
    end
    % Find the distance from the apical point to the intersection pt
    distArrayAtoI = [];
    for i = 1:4
        vect = perpIntPt(i,:) - pointsLonL(1,:);
        if vect(2) < 0
            dist = -norm(perpIntPt(i,:) - pointsLonL(1,:));
        else
            dist = norm(perpIntPt(i,:) - pointsLonL(1,:));
        end
        distArrayAtoI = [distArrayAtoI; dist];
    end
    % Find the vector from the intersection point to the corners
    vectArray = [];
    distarrayItoC = [];
    for i = 1:4
        vect = perpIntPt(i,:) - corners(i,:);
        if vect(1) < 0
            distarrayItoC = [distarrayItoC; norm(vect)];
        else
            distarrayItoC = [distarrayItoC; -norm(vect)];
        end
        vect = vect./norm(vect);
        vectArray = [vectArray; vect];
    end
    % 3D base-apex axis is apexBaseIn3D
    baVect = apexBaseIn3D(2,:) - apexBaseIn3D(1,:);
    unitVector = baVect./norm(baVect);
    % Now, find the vector perpendicular to the BA axis that will be used for
    % placing the 2Ch
    % Find two vectors perpendicular to base-apex and to one another
    vA = [-baVect(3), 0, baVect(1)];
    vA = vA./norm(vA);
    vB = cross(vA, baVect);
    vB = vB./norm(vB);
    
    apex = apexBaseIn3D(1,:);
    base = apexBaseIn3D(2,:);
    % Figure out initial theta for 2 and 4 chamber by finding the angle
    % relative to the vertical
    
    
    if j ==1
        handlesSA.theta2 = abs(theta4 - 60)-90;
        theta2 = handlesSA.theta2;
        corners2 = [];
        for h = 1:4
            answer = (apex + distArrayAtoI(h)*unitVector) + distarrayItoC(h)*cosd(theta2).*vA + distarrayItoC(h)*sind(theta2).*vB;
            corners2 = [corners2; answer];
        end
        handles3D.corners2 = corners2;
        %         line4onSTrans(4);
    elseif j == 2
        handlesSA.theta3 = theta2 + 60;
        theta3 = handlesSA.theta3;
        corners3 = [];
        for h = 1:4
            answer = (apex + distArrayAtoI(h)*unitVector) + distarrayItoC(h)*cosd(theta3).*vA + distarrayItoC(h)*sind(theta3).*vB;
            corners3 = [corners3; answer];
        end
        handles3D.corners3 = corners3;     
    end
end
handlesSA.theta4 = 90-handlesSA.theta4;
set(fig3D,'UserData',handles3D);
set(figSA,'UserData',handlesSA);
set(fig2,'UserData',handles2);
set(fig3,'UserData',handles3);
set(fig4,'UserData',handles4);
plot3D(1,1,fig2,fig3,fig4,figSA,fig3D);

set(fig3D,'UserData',handles3D);
set(figSA,'UserData',handlesSA);
end


