function [ output_args ] = adj2and4( src,event,fig2,fig3,fig4,figSA,fig3D )

handles3D = get(fig3D,'UserData');
handlesSA = get(figSA,'UserData');

setPositionConstraintFcn(handlesSA.line1,@(candidate,previous)sameSpot(candidate,getPosition(handlesSA.line1)));
setPositionConstraintFcn(handlesSA.line2,@(candidate,previous)sameSpot(candidate,getPosition(handlesSA.line2)));
setPositionConstraintFcn(handlesSA.line3,@(candidate,previous)sameSpot(candidate,getPosition(handlesSA.line3)));
% whiten SA lines
% whiten(handlesSA.line1);
% whiten(handlesSA.line2);
% whiten(handlesSA.line3);


set(fig3,'visible','off');
set(figSA,'visible','on');
set(fig4,'visible','on');

handles2 = get(fig2,'UserData');
handles4 = get(fig4,'UserData');

set(handles2.line1,'visible','off');
set(handles2.line2,'visible','on');
set(handles2.line3,'visible','off');
colorfy(handles2.line2,handles4.color);

set(handles4.line1,'visible','on');
set(handles4.line2,'visible','off');
set(handles4.line3,'visible','off');
colorfy(handles4.line1,handles2.color);

handles3D.invisible = 3;
set(fig3D,'UserData',handles3D);
set(figSA,'UserData',handlesSA);



plot3D(1,1,fig2,fig3,fig4,figSA,fig3D);
end

function output = sameSpot(candidate, previous)
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
