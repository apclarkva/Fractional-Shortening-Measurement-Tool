function [ output_args ] = plot3D(x,y,fig2,fig3,fig4,figSA,fig3D)
handles3D = get(fig3D, 'UserData');
handlesSA = get(figSA,'UserData');
cla(handles3D.ax3D);
figure(fig3D);
rotate3d on;
for j = 1:4
    switch j
        case 1
            corners = handles3D.corners2;
            handles = get(fig2,'UserData');
            a = handlesSA.line1;
        case 2
            corners = handles3D.corners3;
            handles = get(fig3,'UserData');
            a = handlesSA.line2;
        case 3
            corners = handles3D.corners4;
            handles = get(fig4,'UserData');
            a = handlesSA.line3;
        case 4
            corners = handles3D.cornersSA;
            handles = get(figSA,'UserData');
    end
    
    
    c1 = corners(1,:);
    c2 = corners(2,:);
    c3 = corners(3,:);
    c4 = corners(4,:);
    
    num = handles.num;
    col = handles.colorStr(1);
    img = handles.img;
    figure(fig3D);
    surf = surface('XData', [c1(1) c2(1); c3(1) c4(1)],...
        'YData', [c1(2) c2(2); c3(2) c4(2)], 'ZData',...
        [c1(3) c2(3); c3(3) c4(3)], 'CData', img(:,:,num),...
        'FaceColor', 'texturemap', 'EdgeColor', col); hold on;
    colormap(gray); hold on;
    set(surf,'EdgeAlpha', 0);
    c = [c1; c2; c4; c3; c1];
    surfPlot = plot3(c(:,1), c(:,2),c(:,3), col, 'LineWidth', 4);
    hold on;
    if j == 1 || j == 2 || j == 3
        AB =c1-c2;
        AC = c1-c3;
        n = cross(AB,AC)./norm(cross(AB,AC));
        a = getPosition(a);
        if a(1,1) < a(2,1)
            n = -n;
        end
        
        if j == 1
           n = -n; 
        end
        
        c1 = c1- 1*n;
        c2 = c2 -1*n;
        c3 = c3 - 1*n;
        c4 = c4 - 1*n;
        if handles3D.mask == 1
            mask = surface('XData', [c1(1) c2(1); c3(1) c4(1)],...
                'YData', [c1(2) c2(2); c3(2) c4(2)], 'ZData',...
                [c1(3) c2(3); c3(3) c4(3)], 'CData', zeros(size(img(:,:,num))),...
                'FaceColor', 'texturemap', 'EdgeColor', col);
        end
    end
    
    if j ==1
        handles3D.surf2 = surf;
        handles3D.surfPlot2 = surfPlot;
        if handles3D.mask ==1
            handles3D.mask2 = mask;
        end
    elseif j==2
        handles3D.surf3 = surf;
        handles3D.surfPlot3 = surfPlot;
        if handles3D.mask ==1
            handles3D.mask3 = mask;
        end
    elseif j ==3
        handles3D.surf4 = surf;
        handles3D.surfPlot4 = surfPlot;
        if handles3D.mask ==1
            handles3D.mask4 = mask;
        end
    end
    
end

switch handles3D.invisible
    case 2
        set(handles3D.surf4,'visible', 'on');
        set(handles3D.surf3,'visible', 'on');
        set(handles3D.surf2,'visible', 'off');
        delete(handles3D.surfPlot2);
        if handles3D.mask == 1
            delete(handles3D.mask2);
        end
    case 3
        set(handles3D.surf4,'visible', 'on');
        set(handles3D.surf2,'visible', 'on');
        set(handles3D.surf3,'visible', 'off');
        delete(handles3D.surfPlot3);
        if handles3D.mask == 1
            delete(handles3D.mask3);
        end
    case 4
        set(handles3D.surf3,'visible','on');
        set(handles3D.surf2,'visible','on');
        set(handles3D.surf4,'visible', 'off');
        delete(handles3D.surfPlot4);
        if handles3D.mask == 1
            delete(handles3D.mask4);
        end
    otherwise
        set(handles3D.surf3,'visible','on');
        set(handles3D.surf2,'visible','on');
        set(handles3D.surf4,'visible','on');
end


handlesSA = get(figSA,'UserData');
handlesSA.which = 3;
set(figSA,'UserData',handlesSA);

set(handles3D.ax3D, 'XLim', [0 400]);
set(handles3D.ax3D, 'YLim', [0 400]);
set(handles3D.ax3D, 'ZLim', [0 400]);
set(handles3D.ax3D, 'XTick', [], 'YTick', [], 'ZTick', []);
set(fig3D, 'Color', [1 1 1]);

end

