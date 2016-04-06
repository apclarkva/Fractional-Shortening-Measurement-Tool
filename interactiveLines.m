function [ output_args ] = interactiveLines(figure2,figure3,figure4,figureSA,instruct,figure3D)
% This function will draw the imlines on the three figure plots, using the
% specified reference points selected by the user.

handles3D = get(figure3D,'UserData');
handlesI = get(instruct,'UserData');
handlesI.invisible = handles3D.invisible;
set(instruct,'UserData',handlesI);

%handles has:
        %which
        %num
        %mask
        %selectORmove
        %recursionPrevent
        %alex
        %distMoved
        %shift
        %img
        %color
        %colorStr
        %text1
        %text2
        %ui1 (SA only)
        %border
        %ishow
        %base -LA
        %apex -LA
        %leafD -LA
        %leafS -LA
        %medial -SA
        %lateral -SA  

% handles for each figure
handles2 = get(figure2,'UserData');
handles3 = get(figure3,'UserData');
handles4 = get(figure4,'UserData');
handlesSA = get(figureSA,'UserData');

% The colors of each of the 3 lines on figure2
handles2.lineCLR = [handles3.color; handles4.color; handlesSA.color];
set(figure2,'UserData',handles2);

handles3.lineCLR = [handles2.color;handles4.color;handlesSA.color];
set(figure3,'UserData',handles3);

handles4.lineCLR = [handles2.color;handles3.color;handlesSA.color];
set(figure4,'UserData',handles4);

handlesSA.lineCLR = [handles2.color;handles3.color;handles4.color];
set(figureSA,'UserData',handlesSA);

% the interactive lines for each figure
% figure2 interactive lines
[line1,line2,line3] = makeLines(figure2,handles2.base,handles2.apex,'Long');
handles2.line1 = line1;
handles2.line2 = line2;
handles2.line3 = line3;
set(figure2,'UserData',handles2);

% figure3 interactive lines
[line4,line5,line6] = makeLines(figure3,handles3.base,handles3.apex,'Long');
handles3.line1 = line4;
handles3.line2 = line5;
handles3.line3 = line6;
set(figure3,'UserData',handles3);

% figure4 interactive lines
[line7,line8,line9] = makeLines(figure4,handles4.base,handles4.apex,'Long');
handles4.line1 = line7;
handles4.line2 = line8;
handles4.line3 = line9;
set(figure4,'UserData',handles4);

% figureSA interactive lines
[line10,line11,line12] = makeLines(figureSA,handlesSA.medial,handlesSA.lateral,'Short');
handlesSA.line1 = line10;
handlesSA.line2 = line11;
handlesSA.line3 = line12;
set(figureSA,'UserData',handlesSA);


% Now, put the callback on these imlines
set(figure2, 'WindowButtonDownFcn', @distanceFromPoints);
set(figure3, 'WindowButtonDownFcn', @distanceFromPoints);
set(figure4, 'WindowButtonDownFcn', @distanceFromPoints);

% % Now, this is the position constraint function
setPositionConstraintFcn(line1,@(position,fig,inst,x)editLine(position,figure2, instruct, 1));
setPositionConstraintFcn(line2,@(position,fig,inst,x)editLine(position,figure2, instruct, 2));
setPositionConstraintFcn(line3,@(position,fig,inst,x)editLine(position,figure2, instruct, 3));
setPositionConstraintFcn(line4,@(position,fig,inst,x)editLine(position,figure3, instruct, 1));
setPositionConstraintFcn(line5,@(position,fig,inst,x)editLine(position,figure3, instruct, 2));
setPositionConstraintFcn(line6,@(position,fig,inst,x)editLine(position,figure3, instruct, 3));
setPositionConstraintFcn(line7,@(position,fig,inst,x)editLine(position,figure4, instruct, 1));
setPositionConstraintFcn(line8,@(position,fig,inst,x)editLine(position,figure4, instruct, 2));
setPositionConstraintFcn(line9,@(position,fig,inst,x)editLine(position,figure4, instruct, 3));
setPositionConstraintFcn(line10,@(position,fig,inst,x)editLine(position,figureSA, instruct, 1));
setPositionConstraintFcn(line11,@(position,fig,inst,x)editLine(position,figureSA, instruct, 2));
setPositionConstraintFcn(line12,@(position,fig,inst,x)editLine(position,figureSA, instruct, 3));


% Make a callback function here to be called when each line is moved
global gj;
gj = 1;

% 6xLonL
addNewPositionCallback(line1,@(fig,fig2,fig3,fig4,fig3D, x)lineLonL(figure2,figure3,figure4,figureSA,figure3D,1));
addNewPositionCallback(line2,@(fig,fig2,fig3,fig4,fig3D,x)lineLonL(figure2,figure3,figure4,figureSA,figure3D,2));

addNewPositionCallback(line4,@(fig,fig2,fig3,fig4,fig3D,x)lineLonL(figure3,figure2,figure4,figureSA,figure3D,1));
addNewPositionCallback(line5,@(fig,fig2,fig3,fig4,fig3D,x)lineLonL(figure3,figure2,figure4,figureSA,figure3D,2));

addNewPositionCallback(line7,@(fig,fig2,fig3,fig4,fig3D,x)lineLonL(figure4,figure2,figure3,figureSA,figure3D,1));
addNewPositionCallback(line8,@(fig,fig2,fig3,fig4,fig3D,x)lineLonL(figure4,figure2,figure3,figureSA,figure3D,2));

% 3xLonS
% addNewPositionCallback(line10,@(fig,fig2,fig3,fig4,fig3D,x)lineLonS(figureSA,figure2,figure3,figure4,figure3D,1));
% addNewPositionCallback(line11,@(fig,fig2,fig3,fig4,fig3D,x)lineLonS(figureSA,figure2,figure3,figure4,figure3D,2));
% addNewPositionCallback(line12,@(fig,fig2,fig3,fig4,fig3D,x)lineLonS(figureSA,figure2,figure3,figure4,figure3D,3));

% 3xSonL
addNewPositionCallback(line3,@(fig,fig2,fig3,fig4,fig3D,x)lineSonL(figure2,figure3,figure4,figureSA,figure3D,3));
addNewPositionCallback(line6,@(fig,fig2,fig3,fig4,fig3D,x)lineSonL(figure3,figure2,figure4,figureSA,figure3D,3));
addNewPositionCallback(line9,@(fig,fig2,fig3,fig4,fig3D,x)lineSonL(figure4,figure2,figure3,figureSA,figure3D,3));
end


function [line1,line2,line3] = makeLines(fig,pt1,pt2,which)
    
handles = get(fig,'UserData');
figure(fig);
% for long axis views only need base and apex to make long and short plots
switch which
    case 'Long'
        base = pt1;
        apex = pt2;
        figure(fig);
%       First long axis line
        line1 = imline(gca,[base;apex]);
        a = get(line1,'Children');
        for i = 1:4
           set(a(i), 'Color', handles.lineCLR(1,:));
        end
%       Second long axis - set invisible
        line2 = imline(gca,[base;apex]);
        set(line2,'Visible','off');
        a = get(line2,'Children');
        for i = 1:4
           set(a(i),'Color',handles.lineCLR(2,:)); 
        end
%       Short axis
        center = (base+apex)./2;
        pt1 = [center(1)-80,center(2)];
        pt2 = [center(1)+80,center(2)];
        line3 = imline(gca,[pt1;pt2]);
        a = get(line3,'Children');
        for i = 1:4
           set(a(i),'Color',handles.lineCLR(3,:)); 
        end
    otherwise
    medial = pt1;
    lateral = pt2;
    center = mean([lateral;medial]);
    centMedVect = medial-center;
    angle = atand(centMedVect(2)./centMedVect(1));
    angle = angle + 10;%add ten degrees, because this is better approximate
    chSARV = [center(1)-10.*cosd(angle), center(2)-10.*sind(angle)];
    
    saVect = center - chSARV;
    unitV = saVect./norm(saVect);
    
%     find points for 4 on S
    pt1 = center - 80.*unitV;
    pt2 = center + 80.*unitV;
    line3 = imline(gca,[pt1;pt2]);
    a = get(line3,'Children');
    for i = 1:4
       set(a(i),'Color',handles.lineCLR(3,:)); 
    end
    
%     find points for 2 on S
    d = atand(unitV(2)./unitV(1));
    d1 = d-60;
    y = tand(d1);
    unitV = [1, y]./norm([1, y]);
    pt1 = center - 80.*unitV;
    pt2 = center + 80.*unitV;
    line1 = imline(gca,[pt1; pt2]);
    a = get(line1,'Children');
    for i = 1:4
       set(a(i),'Color',handles.lineCLR(1,:)); 
    end
    
%    find points for 3 on S
    d2 = d+60;
    y = tand(d2);
    unitV = [1, y]./norm([1, y]);
    pt1 = center - 80.*unitV;
    pt2 = center + 80.*unitV;
    line2 = imline(gca,[pt1; pt2]);
    a = get(line2,'Children');
    for i = 1:4
       set(a(i),'Color',handles.lineCLR(2,:)); 
    end
end
end



