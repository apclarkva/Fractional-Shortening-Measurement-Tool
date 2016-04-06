function [ output_args ] = lineLonL( fig,fig2,fig3,fig4,fig3D,x )
%changes other stuff when long on long is changed

handlesMain = get(fig,'UserData');
handles3D = get(fig3D,'UserData');
handlesSA = get(fig4,'UserData');
tagMain = get(fig,'Tag');

if x ==1
    imL = handlesMain.line1;
    handlesOther = get(fig2,'UserData');
    
    %now, which line to get from this handle
    if strcmp(tagMain, 'figure2')
        imLother = handlesOther.line1; %line for figure2 will always be line1
        cornersMain = handles3D.corners2;
        cornersOther = handles3D.corners3;
        pointsonSA1 = getPosition(handlesSA.line1);%for last bit of code
        pointsonSA2 = getPosition(handlesSA.line2);
        lineonS = handlesSA.line2;
        theta = handlesSA.theta3;
    end
    if strcmp(tagMain,'figure3')
        imLother = handlesOther.line1; %since x = 1, this means 2ch line is being moved
        %so fig2 will be figure2 - where
        %line1 is ch3
        cornersMain = handles3D.corners3;
        cornersOther = handles3D.corners2;
        pointsonSA1 = getPosition(handlesSA.line2);%for last bit of code
        pointsonSA2 = getPosition(handlesSA.line1);
        lineonS = handlesSA.line1;
        theta = handlesSA.theta2;
    end
    if strcmp(tagMain,'figure4')
        imLother = handlesOther.line2;
        cornersMain = handles3D.corners4;
        cornersOther = handles3D.corners2;
        pointsonSA1 = getPosition(handlesSA.line3);%for last bit of code
        pointsonSA2 = getPosition(handlesSA.line1);
        lineonS = handlesSA.line1;
        theta = handlesSA.theta2;
    end
else
    imL = handlesMain.line2;
    handlesOther = get(fig3,'UserData');
    
    %now, which line to get from this handle
    if strcmp(tagMain, 'figure2')
        imLother = handlesOther.line1;
        cornersMain = handles3D.corners2;
        cornersOther = handles3D.corners4;
        pointsonSA1 = getPosition(handlesSA.line1);%for last bit of code
        pointsonSA2 = getPosition(handlesSA.line3);
        lineonS = handlesSA.line3;
        theta = handlesSA.theta4;
    end
    if strcmp(tagMain,'figure3')
        imLother = handlesOther.line2;%since x = 2, 4ch is being moved so fig2 will be
        %figure4 - where line2 is ch3
        cornersMain = handles3D.corners3;
        cornersOther = handles3D.corners4;
        pointsonSA1 = getPosition(handlesSA.line2);%for last bit of code
        pointsonSA2 = getPosition(handlesSA.line3);
        lineonS = handlesSA.line3;
        theta = handlesSA.theta4;
    end
    if strcmp(tagMain,'figure4')
        imLother = handlesOther.line2;
        cornersMain = handles3D.corners4;
        cornersOther = handles3D.corners3;
        pointsonSA1 = getPosition(handlesSA.line3);%for last bit of code
        pointsonSA2 = getPosition(handlesSA.line2);
        lineonS = handlesSA.line2;
        theta = handlesSA.theta3;
    end
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

x1 = c2-c1;
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

% Now, make the SA lines shift with the shifts in the LA
% Adjust the 4onS line

% must find intersection of moving line and SA slice to determine how far apex is from
% intersection point
pointsSA = getPosition(handlesMain.line3);
intersectionPtonMain = findIntersection(pointsSA,pointsMain);
if strcmp(tagMain,'figure2')
    % distance from left SA slice point to intersection point
    if pointsSA(1,1)>intersectionPtonMain(1)
        distanceLStoIPt = norm(intersectionPtonMain - pointsSA(1,:));
    else
        distanceLStoIPt = -norm(intersectionPtonMain - pointsSA(1,:));
    end
else
    if pointsSA(1,1)>intersectionPtonMain(1)
        distanceLStoIPt = -norm(intersectionPtonMain - pointsSA(1,:));
    else
        distanceLStoIPt = norm(intersectionPtonMain - pointsSA(1,:));
    end    
end
intersectionPtonSA = findIntersection(pointsonSA1,pointsonSA2);

% Distance/vector from intersection point to 4ch
% want pointsOther on the short axis view
vectInttoOut1 = pointsonSA2(1,:) - intersectionPtonSA;
vectInttoOut2 = pointsonSA2(2,:) - intersectionPtonSA;

% outside points of moved line with SA view
vectPtSA1 = pointsonSA1(2,:) - pointsonSA1(1,:);
unitVptSA1 = vectPtSA1./norm(vectPtSA1);

if strcmp(tagMain,'figure2')
    newIntersectionPtonSA = pointsonSA1(2,:) + unitVptSA1.*distanceLStoIPt;
else
    newIntersectionPtonSA = pointsonSA1(1,:) + unitVptSA1.*distanceLStoIPt;
end
setPosition(lineonS, [newIntersectionPtonSA+vectInttoOut1;...
    newIntersectionPtonSA+vectInttoOut2]);

if x ==1
    %now, which line to get from this handle
    if strcmp(tagMain, 'figure2')
        handles3D.corners3 = cornersOther; 
    end
    if strcmp(tagMain,'figure3')
        handles3D.corners2 = cornersOther;       
    end
    if strcmp(tagMain,'figure4')
        handles3D.corners2 = cornersOther;    
    end
else
    
    %now, which line to get from this handle
    if strcmp(tagMain, 'figure2')
        handles3D.corners4 = cornersOther;  
        
    end
    if strcmp(tagMain,'figure3')
        handles3D.corners4 = cornersOther;        
    end
    if strcmp(tagMain,'figure4')
        handles3D.corners3 = cornersOther;       
    end
end

set(fig3D,'UserData',handles3D);

end


function int = findIntersection(position1,position2)
% takes in two points from two lines and finds their intersection
vect1onS = position1(1,:) - position1(2,:);
m1 = vect1onS(2)./vect1onS(1);
vect2onS = position2(1,:) - position2(2,:);
m2 = vect2onS(2)./vect2onS(1);

x1 = position1(1,1);
y1 = position1(1,2);
x2 = position2(1,1);
y2 = position2(1,2);

x0 = (-m2.*x2+m1.*x1+y2-y1)./(m1-m2);
y0 = m1.*(x0-x1)+y1;

int = [x0 y0];
end

