function [ output_args ] = adj2and3( src,event,fig2,fig3,fig4,figSA,fig3D )

handles3D = get(fig3D,'UserData');
handlesSA = get(figSA,'UserData');

% setPositionConstraintFcn(handlesSA.line1,@(candidate,previous)sameSpot(candidate,getPosition(handlesSA.line1)));
% setPositionConstraintFcn(handlesSA.line2,@(candidate,previous)sameSpot(candidate,getPosition(handlesSA.line1)));
% setPositionConstraintFcn(handlesSA.line3,@(candidate,previous)sameSpot(candidate,getPosition(handlesSA.line1)));

% % whiten SA lines
% whiten(handlesSA.line1);
% whiten(handlesSA.line2);
% whiten(handlesSA.line3);

set(fig3,'visible','on');
set(figSA,'visible','on');
set(fig4,'visible','off');

handles2 = get(fig2,'UserData');
handles3 = get(fig3,'UserData');

set(handles2.line1,'visible','on');
set(handles2.line2,'visible','off');
set(handles2.line3,'visible','off');
colorfy(handles2.line1,handles3.color);

set(handles3.line1,'visible','on');
set(handles3.line2,'visible','off');
set(handles3.line3,'visible','off');
colorfy(handles3.line1,handles2.color);

handles3D.invisible = 4;
set(fig3D,'UserData',handles3D);
plot3D(1,1,fig2,fig3,fig4,figSA,fig3D);
end

function output = sameSpot(candidate, previous)
keyboard
output = previous;
end

function whiten(line)
parts = get(line,'Children');
for i = 1:4
    set(parts(i),'Color',[1 1 1]);
end
end

function colorfy(line,col)
parts = get(line,'Children');
for i = 1:4
   set(parts(i),'Color',col); 
end
end


