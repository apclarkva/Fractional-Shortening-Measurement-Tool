function [ output_args ] = lineLonS( fig,fig2,fig3,fig4,fig3D,x)
%LINELONS handles what to do with moving long axis views on the short axis

% x tells me which line I am moving
% fig is the short axis figure
% fig2 = figure2, fig3 = figure3, fig4 = figure4

handlesSA = get(fig,'UserData');
handles3D = get(fig3D,'UserData');
if x == 1
    lineSA1 = handlesSA.line1;
    %     moving line on SA
    pointsSA1 = getPosition(lineSA1);
    cornersMain = handles3D.corners2;
        
    if handles3D.invisible == 4
        %     other lines on SA view
        pointsSA2 = getPosition(handlesSA.line2);
        %     the moving line on other long axis views
        handlesL1 = get(fig3,'UserData');
        pointsL0onL1 = getPosition(handlesL1.line1);
        lineL0onL1 = handlesL1.line1;
        %   short axis lines on the other long axis views
        pointsSonL1 = getPosition(handlesL1.line3);
        %   other long axis slices on main long axis slice
        handlesL0 = get(fig2,'UserData');
        pointsL1onL0 = getPosition(handlesL0.line1);
        cornersOther = handles3D.corners3;
        figL1 = fig3;
    else
        pointsSA2 = getPosition(handlesSA.line3);
        handlesL1 = get(fig4,'UserData');
        pointsL0onL1 = getPosition(handlesL1.line1);
        lineL0onL1 = handlesL1.line1;
        pointsSonL1 = getPosition(handlesL1.line3);
        handlesL0 = get(fig2,'UserData');
        pointsL1onL0 = getPosition(handlesL0.line2);
        cornersOther = handles3D.corners4;
        figL1 = fig4;
    end
elseif x == 2
    lineSA1 = handlesSA.line2;
    %     moving line on SA
    pointsSA1 = getPosition(lineSA1);
    cornersMain = handles3D.corners3;
    figL0 = fig3;
    if handles3D.invisible == 4
        %     other lines on SA view
        pointsSA2 = getPosition(handlesSA.line1);
        %     the moving line on other long axis views
        handlesL1 = get(fig2,'UserData');
        pointsL0onL1 = getPosition(handlesL1.line1);
        lineL0onL1 = handlesL1.line1;
        %   short axis lines on the other long axis views
        pointsSonL1 = getPosition(handlesL1.line3);
        %   other long axis slices on main long axis slice
        handlesL0 = get(fig3,'UserData');
        pointsL1onL0 = getPosition(handlesL0.line1);
        cornersOther = handles3D.corners2;
        figL1 = fig2;
    else
        pointsSA2 = getPosition(handlesSA.line3);
        handlesL1 = get(fig4,'UserData');
        pointsL0onL1 = getPosition(handlesL1.line2);
        lineL0onL1 = handlesL1.line2;
        pointsSonL1 = getPosition(handlesL1.line3);
        handlesL0 = get(fig3,'UserData');
        pointsL1onL0 = getPosition(handlesL0.line2);
        cornersOther = handles3D.corners4;
        figL1 = fig4;
    end
else
    lineSA1 = handlesSA.line3;
    %     moving line on SA
    pointsSA1 = getPosition(lineSA1);
    cornersMain = handles3D.corners4;
    figL0 = fig4;
    if handles3D.invisible == 3
        %     other lines on SA view
        pointsSA2 = getPosition(handlesSA.line1);
        %     the moving line on other long axis views
        handlesL1 = get(fig2,'UserData');
        pointsL0onL1 = getPosition(handlesL1.line2);
        lineL0onL1 = handlesL1.line2;
        %   short axis lines on the other long axis views
        pointsSonL1 = getPosition(handlesL1.line3);
        %   other long axis slices on main long axis slice
        handlesL0 = get(fig4,'UserData');
        pointsL1onL0 = getPosition(handlesL0.line1);
        cornersOther = handles3D.corners2;
        figL1 = fig2;
    else
        pointsSA2 = getPosition(handlesSA.line2);
        handlesL1 = get(fig3,'UserData');
        pointsL0onL1 = getPosition(handlesL1.line2);
        lineL0onL1 = handlesL1.line2;
        pointsSonL1 = getPosition(handlesL1.line3);
        handlesL0 = get(fig4,'UserData');
        pointsL1onL0 = getPosition(handlesL0.line2);
        cornersOther = handles3D.corners4;
        figL1 = fig3;
    end
end

% Must call this function for the other two LonS lines
% This means calling this function twich more
% The x values must be used from xOther
% Problem arises, because the spot of x will change
% For example, if the original move is with
if (handlesSA.shift == 1)
    %need x to tell you which one is moving
    %shiftMove will move all three of the lines together
    %going to need to use handles.distMoved from SA figure
    shiftMove(fig,fig3D,x);
    
else
    
    intersectionPtonS = findIntersection(pointsSA1,pointsSA2);
    %distance from one point to intersection point
    if pointsSA2(1,1) > intersectionPtonS(1)
        distanceLStoIPt = -norm(intersectionPtonS - pointsSA2(1,:));
    else
        distanceLStoIPt = norm(intersectionPtonS - pointsSA2(2,:));
    end
    
    intersectionPtonL1 = findIntersection(pointsL0onL1,pointsSonL1);
    
    % Distance/vector from intersection point to L1
    vectInttoApex = pointsL0onL1(1,:) - intersectionPtonL1;
    vectInttoBase = pointsL0onL1(2,:) - intersectionPtonL1;
    
    vectSonL1 = pointsSonL1(1,:)-pointsSonL1(2,:);
    unitVSonL1 = vectSonL1./norm(vectSonL1);
    newIntersectionPtonL1 = pointsSonL1(1,:) + unitVSonL1.*distanceLStoIPt;
    
    newBase = newIntersectionPtonL1 + vectInttoBase;
    newApex = newIntersectionPtonL1 + vectInttoApex;
    
    setPosition(lineL0onL1, [newApex; newBase]);
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Find intersection points of the line perpendicular to the 2 chamber line
    % that goes through the corners of the 4 chamber view
    vectorMainonL1 = pointsL0onL1(2,:) - pointsL0onL1(1,:);
    unitVMainonL1 = vectorMainonL1./norm(vectorMainonL1);
    m1 = unitVMainonL1(2)./unitVMainonL1(1);
    m2 = -1/m1;   
    perpIntPt = [];
    corners = [0 0;400 0; 0 300; 400 300];
    for i = 1:4
        x1 = pointsSA1(1,1);
        y1 = pointsSA1(1,2);
        x2 = corners(i,1);
        y2 = corners(i,2);
        x0 = (-m2.*x2+m1.*x1+y2-y1)./(m1-m2);
        y0 = m1.*(x0-x1)+y1;        
        perpIntPt = [perpIntPt; x0 y0];
    end
    
    % Find the distance from the apical point to the intersection pt
    distArrayAtoI = [];
    for i = 1:4
        vect = perpIntPt(i,:) - pointsL1onL0(1,:);
        if vect(2) < 0
            dist = -norm(perpIntPt(i,:) - pointsL1onL0(1,:));
        else
            dist = norm(perpIntPt(i,:) - pointsL1onL0(1,:));
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
    
    %-----------------------------------------
    % find 2D vector from 0,0 corner to base and apex
    vectToApex = pointsL0onL1(1,:);
    vectToBase = pointsL0onL1(2,:);
    % Now, find the x and y equivalents in 3D
    c1 = cornersOther(1,:);
    c2 = cornersOther(2,:);
    c3 = cornersOther(3,:);
    
    x = c2-c1;
    x = x./norm(x);
    y = c3-c1;
    y = y./norm(y);
    
    % intersectionPt3D = c1 + intersectionPton4(1).*x+intersectionPton4(2).*y;
    % These 3D apex and base points are the 3D points of the line 4on2
    apex3D = c1+vectToBase(1).*x+vectToBase(2).*y;
    base3D = c1+vectToApex(1).*x+vectToApex(2).*y;
    apexBaseIn3D = [apex3D;base3D];
    % keyboard
    %------------------------------------------------
    
    
    % 3D base-apex axis is apexBaseIn3D
    baVect = apexBaseIn3D(2,:) - apexBaseIn3D(1,:);
    unitVector = baVect./norm(baVect);
    apex = apexBaseIn3D(1,:);%intersectionPt3D - unitVector.*distance;
    % keyboard
    % Now, find the vector perpendicular to the BA axis that will be used for
    % placing the 2Ch
    % Find two vectors perpendicular to base-apex and to one another
    vA = [-baVect(3), 0, baVect(1)];
    vA = vA./norm(vA);
    vB = cross(vA, baVect);
    vB = vB./norm(vB);
    
    vectMain = pointsSA1(1,:) - pointsSA1(2,:);
    thetaMain = (90-atand(vectMain(2)./vectMain(1)));
    cornersMain = [];
    % keyboard
    for i = 1:4
        answer = (apex - distArrayAtoI(i)*unitVector) - distarrayItoC(i)*cosd(-thetaMain).*vA - distarrayItoC(i)*sind(-thetaMain).*vB;
        cornersMain = [cornersMain; answer];
    end
end

if x == 1
    handles3D.corners2 = cornersMain;
elseif x==2
    handles3D.corners3 = cornersMain;
else
    handles3D.corners4 = cornersMain;
end
%     Something about fig3D being empty => plot3D

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

function shiftMove(fig,fig3D,x)

handles = get(fig,'UserData');
handles3D = get(fig3D,'UserData');


if x == 1
    line1 = getPosition(handles.line2);
    line2 = getPosition(handles.line3);
    
elseif x == 2
    line1 = getPosition(handles.line1);
    line2 = getPosition(handles.line3);
else
    line1 = getPosition(handles.line1);
    line2 = getPosition(handles.line2);
end

line1 = [line1(1,:)-distMoved;line1(2,:)-distMoved];
line2 = [line2(1,:)-distMoved;line2(2,:)-distMoved];

if x ==1
    setPosition(handles.line2, line1);
    setPosition(handles.line3, line2);
elseif x == 2
    setPosition(handles.line1,line1);
    setPosition(handles.line3,line2);
else
    setPosition(handles.line1,line1);
    setPosition(handles.line2,line2);
end

corners2 = handles3D.corners2;
corners3 = handles3D.corners3;
corners4 = handles3D.corners4;

distMoved = [distMoved(2),distMoved(1)];

subtractingMat = [distMoved, 0; distMoved, 0; distMoved, 0; distMoved, 0];

handles3D.corners2 = corners2 - subtractingMat;
handles3D.corners3 = corners3 - subtractingMat;
handles3D.corners4 = corners4 - subtractingMat;

set(fig3D, 'UserData', handles3D);
end





