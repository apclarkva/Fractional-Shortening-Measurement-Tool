function [ output_args ] = adjSA( src,event,fig2,fig3,fig4,figSA,fig3D )


handles2 = get(fig2,'UserData');
handles3 = get(fig3,'UserData');
handles4 = get(fig4,'UserData');
handlesSA = get(figSA,'UserData');
handles3D = get(fig3D,'UserData');

colorfy(handlesSA.line1,handles2.color);
colorfy(handlesSA.line2,handles3.color);
colorfy(handlesSA.line3,handles4.color);

set(handles2.line1,'visible','off');
set(handles2.line2,'visible','off');
set(handles2.line3,'visible','on');

set(handles3.line1,'visible','off');
set(handles3.line2,'visible','off');
set(handles3.line3,'visible','on');

set(handles4.line1,'visible','off');
set(handles4.line2,'visible','off');
set(handles4.line3,'visible','on');

handles3D.invisible = 5;

setPositionConstraintFcn(handlesSA.line1,@(candidate,prevpos,line1,line2,figure2,figure3,figure4,figureSA,figure3D,whichLine)posConstraint(candidate,getPosition(handlesSA.line1), handlesSA.line3,handlesSA.line2,fig2,fig3,fig4,figSA,fig3D,1));
setPositionConstraintFcn(handlesSA.line2,@(candidate,prevpos,line1,line2,figure2,figure3,figure4,figureSA,figure3D,whichLine)posConstraint(candidate,getPosition(handlesSA.line2), handlesSA.line1,handlesSA.line3,fig2,fig3,fig4,figSA,fig3D,2));
setPositionConstraintFcn(handlesSA.line3,@(candidate,prevpos,line1,line2,figure2,figure3,figure4,figureSA,figure3D,whichLine)posConstraint(candidate,getPosition(handlesSA.line3), handlesSA.line1,handlesSA.line2,fig2,fig3,fig4,figSA,fig3D,3));

set(fig3D,'UserData',handles3D);
plot3D(1,1,fig2,fig3,fig4,figSA,fig3D);

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


