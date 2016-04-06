function output = posConstraint(candidate,prevpos,line1,line2,fig2,fig3,fig4,figSA,fig3D,x)

% to find whether rotation or translation
handles = get(figSA,'UserData');
handles3D = get(fig3D,'UserData');
which = handles.which;
handles.whichLine = x;

mPosition = get(gcf,'CurrentPoint');
mPosition = [mPosition(1), 300 - mPosition(2)];
if which == 2
    %---------------this is for rotation------------------------
    
    intersection = findIntersection(prevpos,getPosition(line1));
    distTop1 = norm(intersection - prevpos(1,:));
    distTop2 = norm(intersection - prevpos(2,:));
    vectToM = mPosition-intersection;
    normVectToM = vectToM./norm(vectToM);
    
    dist1 = norm(mPosition - prevpos(1,:));
    dist2 = norm(mPosition - prevpos(2,:));
    
    if dist1<dist2
       pos1 = intersection + normVectToM.*distTop1;
       pos2 = intersection - normVectToM.*distTop2;
    else
       pos1 = intersection - normVectToM.*distTop1;
       pos2 = intersection + normVectToM.*distTop2;        
    end
    
    output = [pos1; pos2];
    %---------------this is for translation----------------------
elseif which == 1
    distMoved = candidate - prevpos;
    points1 = getPosition(line1);
    setPosition(line1,points1+distMoved);
    points2 = getPosition(line2);
    setPosition(line2,points2+distMoved);
    
    distMoved3D = [distMoved(1,2),distMoved(1,1) 0];
    
    distMoved3 = [];
    for i = 1:4
       distMoved3 = [distMoved3;distMoved3D]; 
    end
    handles3D.corners2 = handles3D.corners2 + distMoved3;
    handles3D.corners3 = handles3D.corners3 + distMoved3;
    handles3D.corners4 = handles3D.corners4 + distMoved3;
    
    
    
    set(fig3D,'UserData',handles3D);
    
    output = candidate;
else
    changeTheta(1,1,fig2,fig3,fig4,figSA,fig3D);
    output = prevpos;
end
set(figSA,'UserData',handles);
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

