function [  ] = changeTheta( a,b,fig2,fig3,fig4,figSA,fig3D )
%HEY Summary of this function goes here
%   Detailed explanation goes here

handles3D = get(fig3D,'UserData');
handlesSA = get(figSA,'UserData');

x = handlesSA.whichLine;

if x == 1
    handlesMain = get(fig4,'UserData');
    imL = handlesMain.line1;
    handlesOther = get(fig2,'UserData');
    imLother = handlesOther.line2;
    cornersMain = handles3D.corners4;
    
    points2onS = getPosition(handlesSA.line1);
    vectTheta = points2onS(1,:) - points2onS(2,:);
    theta = (atand(vectTheta(2)./vectTheta(1)));
    theta = -(90+theta);
    handlesSA.theta2 = theta;
    
elseif x == 2
    handlesMain = get(fig2,'UserData');
    imL = handlesMain.line1;
    handlesOther = get(fig3,'UserData');
    imLother = handlesOther.line1;
    cornersMain = handles3D.corners2;
    
    points3onS = getPosition(handlesSA.line2);
    vectTheta = points3onS(1,:) - points3onS(2,:);
    theta = (atand(vectTheta(2)./vectTheta(1)));
    theta = 90-theta;
    handlesSA.theta3 = theta;  
else
    handlesMain = get(fig2,'UserData');
    imL = handlesMain.line1;
    handlesOther = get(fig4,'UserData');
    imLother = handlesOther.line2;
    cornersMain = handles3D.corners2;

    points4onS = getPosition(handlesSA.line3);
    vectTheta = points4onS(1,:) - points4onS(2,:);
    theta = (atand(vectTheta(2)./vectTheta(1)));
    theta = 90-theta;
    handlesSA.theta4 = theta;
end


pointsOther = getPosition(imLother);
vectorOther = pointsOther(2,:) - pointsOther(1,:);
unitVOther = vectorOther./norm(vectorOther);
m1 = unitVOther(2)./unitVOther(1);
m2 = -1/m1;

corners = [0 0;400 0; 0 300; 400 300];

% Find intersection points of the line perpendicular to the 2 chamber line
% that goes through the corners of the 4 chamber view
perpIntPt = [];
for i = 1:4
    x1 = pointsOther(1,1);
    y1 = pointsOther(1,2);
    x2 = corners(i,1);
    y2 = corners(i,2);
    x0 = (-m2.*x2+m1.*x1+y2-y1)./(m1-m2);
    y0 = m1.*(x0-x1)+y1;
    perpIntPt = [perpIntPt; x0 y0];
end

% Find the distance from the apical point to the intersection pt
distArrayAtoI = []; %apex to intersection
for i = 1:4
    vect = perpIntPt(i,:) - pointsOther(1,:);
    if vect(2)<0
        dist = -norm(perpIntPt(i,:) - pointsOther(1,:));
    else
        dist = norm(perpIntPt(i,:) - pointsOther(1,:));
    end
    distArrayAtoI = [distArrayAtoI;dist];
end
% Find the vector from the intersection point to the corners
vectArray = [];
distarrayItoC = []; %intersection to corner
for i = 1:4
    vect = perpIntPt(i,:) - corners(i,:);
    if vect(1)<0
        distarrayItoC = [distarrayItoC; norm(vect)];
    else
        distarrayItoC = [distarrayItoC; -norm(vect)];
    end
    vect = vect./norm(vect);
    vectArray = [vectArray;vect];
end

%START TO DEAL WITH MAIN
% Main variables are variables for imline that has been moved
%-----------------------------------------------------
pointsMain = getPosition(imL);
vectToApex = pointsMain(1,:);
vectToBase = pointsMain(2,:);

% Now, find the x and y equivalents in 3D
c1 = cornersMain(1,:);
c2 = cornersMain(2,:);
c3 = cornersMain(3,:);

if x == 4
    x1 = c1-c2;
else
    x1 = c2-c1;
end

x1 = x1./norm(x1);
y1 = c3-c1;
y1 = y1./norm(y1);

% intersectionPt3D = c1 + intersectionPton4(1).*x+intersectionPton4(2).*y;
% These 3D apex and base points are the 3D points of the line 4on2
apex3D = c1+vectToApex(1).*x1+vectToApex(2).*y1;
base3D = c1+vectToBase(1).*x1+vectToBase(2).*y1;
apexBaseIn3D = [apex3D;base3D];

%-----------------------------------------------------
% 3D base-apex axis is apexBaseIn3D
baVect = apexBaseIn3D(2,:) - apexBaseIn3D(1,:);
unitVector = baVect./norm(baVect);
apex = apexBaseIn3D(1,:);%intersectionPt3D - unitVector.*distance;

% Now, find the vector perpendicular to the BA axis that will be used for
% placing the 2Ch
% Find two vectors perpendicular to base-apex and to one another
vA = [-baVect(3), 0, baVect(1)];
vA = vA./norm(vA);
vB = cross(vA, baVect);
vB = vB./norm(vB);

cornersOther = [];
for i = 1:4
    answer = (apex + distArrayAtoI(i)*unitVector) + distarrayItoC(i)*cosd(theta).*vA + distarrayItoC(i)*sind(theta).*vB;
    cornersOther = [cornersOther; answer];
end
% apex
% distArrayAtoI
% unitVector
% distarrayItoC
% theta
% vA
% vB

if x == 1
    handles3D.corners2 = cornersOther;
elseif x == 2
    handles3D.corners3 = cornersOther;
else
    handles3D.corners4 = cornersOther;
end

set(fig3D,'UserData',handles3D);
set(figSA,'UserData',handlesSA);
plot3D(1,1,fig2,fig3,fig4,figSA,fig3D);
end