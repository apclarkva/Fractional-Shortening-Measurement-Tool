function [] = distanceFromPoints( fig, x )
%DISTANCEFROMPOINTS Summary of this function goes here
%   Detailed explanation goes here
if isempty(x)
    handles = get(fig,'UserData');
%     Bring in positions of three lines associated with current figure
    pos1 = getPosition(handles.line1);
    pos2 = getPosition(handles.line2);
    pos3 = getPosition(handles.line3);
    
    mPosition = get(gcf, 'CurrentPoint');
    mPosition = [mPosition(1), 300-mPosition(2)];

%     This sets which - a way of determining whether translation or
%     rotation
    if ((norm(pos1(1,:)-mPosition)) < 5) || ((norm(pos2(1,:)-mPosition))<5 || ((norm(pos3(1,:)-mPosition))<5))
        handles.which = 2;
    elseif ((norm(pos1(2,:)-mPosition)) < 5) || ((norm(pos2(2,:)-mPosition))<5)|| ((norm(pos3(2,:)-mPosition))<5)
        handles.which = 2;
    else
        handles.which = 1;
    end
    set(fig,'UserData',handles);
else
    if strcmp(x.Key, 'l') || strcmp(x.Key,'u')
        lockUnlock(x.Key);
    end
end

end

