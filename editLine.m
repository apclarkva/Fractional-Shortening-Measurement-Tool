function [output] = editLine(position, fig, instruct, x)
%fig is the figure with the edited line coming into it
%x tells me whether it is line 1,2,3
% Need to start checking which of the 4 views is turned off
% Save as instruct.invisible

inst = get(instruct,'UserData');%just for variable inst.invisible

handles = get(fig,'UserData');
whichLine = x;%save numbers to this x to tell you which line in the figure you want
theTag = get(fig,'Tag');%way of telling which figure
figure(fig);


switch theTag %This tells me the type of line
    %1) Long axis on Long axis
    %2) Short axis on Long axis
    %3) Long axis on Short axis
    case {'figure2','figure3','figure4'}
        if x ==1 ||x==2
            typeOfLine = 'LonL';
        else
        typeOfLine = 'SonL';            
        end
    case 'figureSA'
        typeOfLine = 'LonS';
end

switch theTag %numerical whichFig makes it easier to do logicals
    case 'figure2'
        whichFig = 2;
    case 'figure3'
        whichFig = 3;
    case 'figure4'
        whichFig = 4;
    case 'figureSA'
        whichFig = 5;
end

if whichLine == 1
    imL = handles.line1;
    if inst.invisible==3;
        imLother = handles.line3;
    else
        imLother = handles.line2;
    end
elseif whichLine == 2
    imL = handles.line2;
    if inst.invisible==2;
        imLother = handles.line3;
    else
        imLother = handles.line1;
    end
else
    imL = handles.line3;
    if inst.invisible == 2;
        imLother = handles.line2;
    else
        imLother = handles.line3;
    end
end

if whichFig == 5 %if the current figure is short axis
    %     Intersection of LA lines on SA
    pos = getPosition(imL);
    posOther = getPosition(imLother);
    intersection = findIntersection(posOther,pos);
    
    %     Distances from intersection to each of two points
    %     This will stay constant when rotating
    distToP1 = norm(pos(1,:) - intersection);
    distToP2 = norm(pos(2,:) - intersection);
else
    %     If we are not on the SA, then just do this
    pos = getPosition(imL);
    centerPoint = (pos(1,:) + pos(2,:))./2;
end

distanceBet = norm(pos(1,:) - pos(2,:))/2; %length of imLine
mPosition = get(gcf,'CurrentPoint');
mPosition = [mPosition(1), 300 - mPosition(2)];%where your mouse is positioned on the figure

% if one of the following is false, then execute code
% if short axis figure, and locked, then don't execute
%the reason is that when locked, rotate does not happen
%locked condition is after the else later

if ~((whichFig == 5) && inst.shift == 1)
    if handles.which == 2 %this means rotation, not translation
        dist1 = norm(mPosition-pos(1,:));%dist from mouse to first currimline point
        dist2 = norm(mPosition-pos(2,:));%dist from mouse to second currimline point
        if strcmp('LonS',typeOfLine) %short axis view - long on SA
            if dist1>dist2
                vect = mPosition - intersection;
                unitV = vect./norm(vect);
                p2 = intersection+distToP2.*unitV;
                p1 = intersection+distToP1.*(-unitV);
            else
                vect = mPosition-intersection;
                unitV = vect./norm(vect);
                p2 = intersection+distToP2.*unitV;
                p1 = intersection+distToP1.*(-unitV);
            end
            
        elseif strcmp('LonL',typeOfLine)
            %rotation of long axis on long axis
            if dist1>dist2
                vect = centerPoint-mPosition; %get new vector
            else
                vect = mPosition-centerPoint;
            end
            
            if (-30> atand(vect(1)./vect(2)))||(atand(vect(1)./vect(2))> 30) %don't allow to overrotate
                p1 = pos(1,:);
                p2 = pos(2,:);                
            else %if not overrotating, then this is where rot occurs
                unitV = vect./norm(vect);
                p1 = centerPoint + unitV.*distanceBet;
                p2 = centerPoint - unitV.*distanceBet;
            end
            
        else %short axis on long axis views
            %end point only does translation - cannot rotate these slices
            if dist1>dist2
                vect = pos(1,:) - pos(2,:);
                p2 = [pos(2,1) mPosition(2)];
                p1 = p2+vect;
            else
                vect = pos(2,:) - pos(1,:);
                p1 = [pos(1,1) mPosition(2)];
                p2 = p1+vect;
            end
        end
        output = [p1;p2];
    else %if you're translating
        if strcmp('LonS',typeOfLine)
            vect = position(2,:) - position(1,:);
            unitV = vect./norm(vect);
            %want the intersection of line with slope of imline
            %but with points of mouse and other active line
            x1 = mPosition(1);
            y1 = mPosition(2);%mouse x and y
            posIM = getPosition(imL); %main imline position
            m1 = posIM(1,:) - posIM(2,:);%
            m1 = m1(2)./m1(1);%slope from imLine
            imL2 = getPosition(imLother);
            x2 = imL2(1,1);
            y2 = imL2(1,2);%other imline position
            m2 = imL2(1,:) - imL2(2,:);
            m2 = m2(2)./m2(1);%slope  of other interactive line
            x0 = (-m2.*x2+m1.*x1+y2-y1)./(m1-m2);
            y0 = m1.*(x0-x1)+y1;
            intersection = [x0,y0];
            
            % new points
            p1 = intersection - distToP1.*unitV;
            p2 = intersection - distToP2.*unitV;
            output = [p1;p2];
        elseif strcmp('SonL',typeOfLine) %same x always, allow to change y
            output = [pos(1,1) mPosition(2); pos(2,1) mPosition(2)];
        else %allow
            handles.distMoved;
            output = position;
        end
    end

else
    %find positions of all the short axis lines
    line1 = getPosition(handles.line1);
    line2 = getPosition(handles.line2);
    line3 = getPosition(handles.line3);
    
    handles.distMoved = handles.prevPos - mPosition;
    
    distMoved = handles.distMoved;
    
    line1 = [line1(1,:)-distMoved;line1(2,:)-distMoved];
    line2 = [line2(1,:)-distMoved;line2(2,:)-distMoved];
    line3 = [line3(1,:)-distMoved;line3(2,:)-distMoved];
    
    if whichLine == 1
        setPosition(handles.line2,line2);
        setPosition(handles.line3,line3);
    elseif whichLine ==2
        setPosition(handles.line1,line1);
        setPosition(handles.line3,line3);
    else
        setPosition(handles.line1,line1);
        setPosition(handles.line2,line2);
    end
    handles.prevPos = mPosition;
%     disp('here2');
end

set(fig,'UserData',handles);
set(instruct,'UserData',inst);

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









