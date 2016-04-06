function [  ] = keyPress( fig,b,fig1,fig2,fig3,instruct )
% This is for playing the movie

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
    
    %instruct
        %mask
        %shift
        %selectORmove
        %uiToggleMask
        %uiToggleLock
        %uiFinish
        
    %Future Additions
        %Interactive lines
            %line1,line2,...
        %interactive line colors
        %[1 0 1], [0 1 0],...

handlesIn = get(instruct,'UserData');

handlesMain = get(fig,'UserData');

% if the key pressed is l, then lock the two together...
if strcmp(b.Key,'l') || strcmp(b.Key, 'u') && (handlesIn.selectORmove == 1)%after interactive lines made and 3d plot
    if strcmp(b.Key, 'l') || strcmp(b.Key,'u')
        lockUnlock(b.Key);
    end
end

if strcmp(b.Key,'m') && (handlesIn.selectORmove ==1)%after interactive lines made and 3d plot
    maskUnmask(b.Key);
end

if (strcmp(b.Key, 'leftarrow') || strcmp(b.Key,'rightarrow'))&&(handlesIn.selectORmove == 1)%after interactive lines made and 3d plot
    
    figure(fig);
    line1Pos = getPosition(handlesMain.line1);
    line2Pos = getPosition(handlesMain.line2);
    line3Pos = getPosition(handlesMain.line3);
    
    delete(handlesMain.line1);
    delete(handlesMain.line2);
    delete(handlesMain.line3);
    % delete(gca);
    
%     This if statement is for playing the movie
    if strcmp(b.Key,'rightarrow')
        if (length(handlesMain.img(1,1,:)) - handlesMain.num) < 3
            handlesMain.num = 3 + (handlesMain.num - length(handlesMain.img(1,1,:)));
        else
            handlesMain.num = handlesMain.num + 3;
        end
        figure(fig);
        a = imshow(handlesMain.img(:,:,handlesMain.num)); hold on;
        set(fig, 'Position', handlesMain.position, 'Toolbar', 'none',...
            'Menubar', 'none', 'Color', handlesMain.color); %set figure properties
        border = [399, 299; 1 299; 1 1; 399 1; 399, 299];
        plot(border(:,1), border(:,2) , handlesMain.colorStr, 'LineWidth', 3); hold on;%plot 2 chamber border color
    elseif strcmp(b.Key, 'leftarrow')
        if handlesMain.num < 4
            handlesMain.num = length(handlesMain.img(1,1,:)) + handlesMain.num - 3;
        else
            handlesMain.num = handlesMain.num - 3;
        end
        
        a = imshow(handlesMain.img(:,:,handlesMain.num));hold on;
        set(fig, 'Position', handlesMain.position, 'Toolbar', 'none',...
            'Menubar', 'none', 'Color', handlesMain.color); %set figure properties
        border = [399, 299; 1 299; 1 1; 399 1; 399, 299];
        plot(border(:,1), border(:,2) , handlesMain.colorStr, 'LineWidth', 3); hold on;%plot 2 chamber border color
    end
    
    % I think if I don't do this, the figure will store all of the images on
    % top of one another, causing the program to slow down.
    delete(handlesMain.ishow);
    handlesMain.ishow = a;
    
%     Remake the interactive lines
    handlesMain.line1 = imline(gca, line1Pos);
    a = get(handlesMain.line1, 'Children');
    set(a(1), 'Color', handlesMain.lineCLR(1,:));
    set(a(2), 'Color', handlesMain.lineCLR(1,:));
    set(a(3), 'Color', handlesMain.lineCLR(1,:));
    set(a(4), 'Color', handlesMain.lineCLR(1,:));
    
    handlesMain.line2 = imline(gca, line2Pos);
    a = get(handlesMain.line2, 'Children');
    set(a(1), 'Color', handlesMain.lineCLR(2,:));
    set(a(2), 'Color', handlesMain.lineCLR(2,:));
    set(a(3), 'Color', handlesMain.lineCLR(2,:));
    set(a(4), 'Color', handlesMain.lineCLR(2,:));
    
    handlesMain.line3 = imline(gca, line3Pos);
    a = get(handlesMain.line3, 'Children');
    set(a(1), 'Color', handlesMain.lineCLR(3,:));
    set(a(2), 'Color', handlesMain.lineCLR(3,:));
    set(a(3), 'Color', handlesMain.lineCLR(3,:));
    set(a(4), 'Color', handlesMain.lineCLR(3,:));
    
    % Reset the position constraints
    
    % Make a callback function here to be called when each line is moved
    %first time you have to worry about which one is called 
    %This could change if trans is combined into one general method
    switch get(fig,'Tag')
        case 'figure2'
            setPositionConstraintFcn(handlesMain.line1,@(position,fig,instruct,x)editLine(position, fig, instruct, 1));
            setPositionConstraintFcn(handlesMain.line2,@(position,fig,instruct,x)editLine(position, fig, instruct, 2));
            setPositionConstraintFcn(handlesMain.line3,@(position,fig,instruct,x)editLine(position, fig, instruct, 3));            
        case 'figure3'
            setPositionConstraintFcn(handlesMain.line1,@(position,fig,instruct,x)editLine(position, fig, instruct, 1));
            setPositionConstraintFcn(handlesMain.line2,@(position,fig,instruct,x)editLine(position, fig, instruct, 2));
            setPositionConstraintFcn(handlesMain.line3,@(position,fig,instruct,x)editLine(position, fig, instruct, 3));            
        case 'figure4'
            setPositionConstraintFcn(handlesMain.line1,@(position,fig,instruct,x)editLine(position, fig, instruct, 1));
            setPositionConstraintFcn(handlesMain.line2,@(position,fig,instruct,x)editLine(position, fig, instruct, 2));
            setPositionConstraintFcn(handlesMain.line3,@(position,fig,instruct,x)editLine(position, fig, instruct, 3));              
        case 'figureSA'
            setPositionConstraintFcn(handlesMain.line1,@(position,fig,instruct,x)editLine(position, fig, instruct, 1));
            setPositionConstraintFcn(handlesMain.line2,@(position,fig,instruct,x)editLine(position, fig, instruct, 2));
            setPositionConstraintFcn(handlesMain.line3,@(position,fig,instruct,x)editLine(position, fig, instruct, 3));              
    end
        
    plot3D;
elseif (strcmp(b.Key, 'leftarrow') || strcmp(b.Key,'rightarrow'))&&(handlesIn.selectORmove == 0)%after interactive lines made and 3d plot
    %    This is where it is sent if you are selecting points.    
    figure(fig);
    % delete(gca);
    
    a = length(handlesMain.img(:,:,1));
    if strcmp(b.Key,'rightarrow')
        if (length(handlesMain.img(1,1,:)) - handlesMain.num) < 3
            handlesMain.num = 3 + (handlesMain.num - length(handlesMain.img(1,1,:)));
        else
            handlesMain.num = handlesMain.num + 3;
        end
        figure(fig);
        a = imshow(handlesMain.img(:,:,handlesMain.num)); hold on;
        set(fig, 'Position', handlesMain.position, 'Toolbar', 'none',...
            'Menubar', 'none', 'Color', handlesMain.color); %set figure properties
        border = [399, 299; 1 299; 1 1; 399 1; 399, 299];
        plot(border(:,1), border(:,2) , handlesMain.colorStr, 'LineWidth', 3); hold on;%plot 2 chamber border color
    elseif strcmp(b.Key, 'leftarrow')
        if handlesMain.num < 4
            handlesMain.num = length(handlesMain.img(1,1,:)) + handlesMain.num - 3;
        else
            handlesMain.num = handlesMain.num - 3;
        end
        
        a = imshow(handlesMain.img(:,:,handlesMain.num));hold on;
        set(fig, 'Position', handlesMain.position, 'Toolbar', 'none',...
            'Menubar', 'none', 'Color', handlesMain.color); %set figure properties
        border = [399, 299; 1 299; 1 1; 399 1; 399, 299];
        plot(border(:,1), border(:,2) , handlesMain.colorStr, 'LineWidth', 3); hold on;%plot 2 chamber border color
    end
    
    % I think if I don't do this, the figure will store all of the images on
    % top of one another, causing the program to slow down.
    delete(handlesMain.ishow);
    handlesMain.ishow = a;
end
set(fig,'UserData',handlesMain);
set(instruct,'UserData',handlesIn);
end

