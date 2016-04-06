function [ output_args ] = lineSonL( fig, fig2, fig3, fig4, fig3D, x )
% Control moving the short axis on the long axis views

handlesL0 = get(fig,'UserData');
handles3D = get(fig3D,'UserData');
handlesS = get(fig4,'UserData');

cornersS = handles3D.cornersSA;

if x == 1 %figure2
    lineSonL0 = handlesL0.line3;
    lineL0onS = handlesS.line1;
    cornersL0 = handles3D.corners2;
    
    if handles3D.invisible == 4
        handlesL1 = get(fig2,'UserData');
        lineL1onL0 = handlesL0.line1;
        lineL1onS = handlesS.line2;
        lineSonL1 = hanldesL1.line3;
        handlesL2 = get(fig3,'UserData');
        lineSonL2 = handlesL2.line3;
    else
        handlesL1 = get(fig3,'UserData');
        lineL1onL0 = handlesL0.line2;
        lineL1onS = handlesS.line3;
        lineSonL1 = handlesL1.line3;
        handlesL2 = get(fig2,'UserData');
        lineSonL2 = handlesL2.line3;
    end
elseif x == 2 %figure3
    lineSonL0 = handlesL0.line3;
    lineL0onS = handlesS.line2;
    cornersL0 = handles3D.corners3;
    
    if handles3D.invisible == 4
        handlesL1 = get(fig2,'UserData');
        lineL1onL0 = handlesL0.line1;
        lineL1onS = handlesS.line1;
        lineSonL1 = hanldesL1.line3;
        handlesL2 = get(fig3,'UserData');
        lineSonL2 = handlesL2.line3;        
    else
        handlesL1 = get(fig3,'UserData');
        lineL1onL0 = handlesL0.line2; %active long on moving long
        lineL1onS = handlesS.line3; %active long on short
        lineSonL1 = handlesL1.line3; %always same
        handlesL2 = get(fig2,'UserData');
        lineSonL2 = handlesL2.line3;        
    end
else %figure4
    lineSonL0 = handlesL0.line3;
    lineL0onS = handlesS.line3;
    cornersL0 = handles3D.corners4;
    
    if handles3D.invisible == 3
        handlesL1 = get(fig2,'UserData');
        lineL1onL0 = handlesL0.line1;
        lineL1onS = handlesS.line1;
        lineSonL1 = handlesL1.line3;
        handlesL2 = get(fig3,'UserData');
        lineSonL2 = handlesL2.line3;        
    else
        handlesL1 = get(fig3,'UserData');
        lineL1onL0 = handlesL0.line2; %active long on moving long
        lineL1onS = handlesS.line2; %active long on short
        lineSonL1 = handlesL1.line3; %always same
        handlesL2 = get(fig2,'UserData');
        lineSonL2 = handlesL2.line3;        
    end
end



pointsSonL0 = getPosition(lineSonL0);
pointsL1onL0 = getPosition(lineL1onL0);
pointsL1onS = getPosition(lineL1onS);
pointsL0onS = getPosition(lineL0onS);
pointsSonL1 = getPosition(lineSonL1);
pointsSonL2 = getPosition(lineSonL2);

% intersection point on the moving long axis
intersectionPtonL0 = findIntersection(pointsL1onL0,pointsSonL0);
% change the position of the short axis views on the long axis view
setPosition(lineSonL1,[pointsSonL1(1,1) pointsSonL0(1,2); pointsSonL1(2,1), pointsSonL0(1,2)]);
setPosition(lineSonL2,[pointsSonL2(1,1) pointsSonL0(1,2); pointsSonL2(2,1), pointsSonL0(1,2)]);

if intersectionPtonL0(2)>pointsL1onL0(1,2)
   distFromApex = -norm(pointsL1onL0(1,:)-intersectionPtonL0);
else
   distFromApex = norm(pointsL1onL0(1,:)-intersectionPtonL0);
end


% Must find the chamber 4 apex in 3D
vectToApex = pointsL1onL0(1,:);
vectToBase = pointsL1onL0(2,:);

% Now, find the x and y equivalents in 3D
c1 = cornersL0(1,:);
c2 = cornersL0(2,:);
c3 = cornersL0(3,:);

x = c2-c1;
x = x./norm(x);
y = c3-c1;
y = y./norm(y);

% intersectionPt3D = c1 + intersectionPton4(1).*x+intersectionPton4(2).*y;
% These 3D apex and base points are the 3D points of the line 4on2
apex3D = c1+vectToApex(1).*x+vectToApex(2).*y;
base3D = c1+vectToBase(1).*x+vectToBase(2).*y;
apexBaseIn3D = [apex3D;base3D];
vectApexBaseIn3D = apexBaseIn3D(2,:)-apexBaseIn3D(1,:);
uVectAB3D = vectApexBaseIn3D./norm(vectApexBaseIn3D);

newCenter = apex3D+uVectAB3D.*(-distFromApex);
newCenterx4 = [newCenter(1:2);newCenter(1:2);newCenter(1:2)...
               ;newCenter(1:2)];
zHeight = newCenter(1,3);

intersectionPtonSA = findIntersection(pointsL0onS,pointsL1onS);

x0 = intersectionPtonSA(1);
y0 = intersectionPtonSA(2);

vectorsToSAPoints = [-y0,400-x0;...
                     -y0,-x0;...
                     300-y0,400-x0;...
                     300-y0,-x0;];
% keyboard
D2SA = newCenterx4+vectorsToSAPoints;
handles3D.cornersSA = [D2SA(2,:),zHeight;...
             D2SA(1,:),zHeight;...
             D2SA(4,:),zHeight;...
             D2SA(3,:),zHeight];
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




