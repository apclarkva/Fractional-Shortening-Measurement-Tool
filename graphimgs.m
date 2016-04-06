function [] = graphimgs( figure2, figure3, figure4, figureSA)
%plots the three separate images in different figures
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

% What is being added to handles:
    %ui1 = userInterface component to toggle lock - unlock (SA only)
    %border = color border corners
    %ishow = current image on figure

for i = 1:4
    switch i
        case 1
            handles = get(figure2,'UserData');
            figure(figure2);
        case 2
            handles = get(figure3,'UserData');
            figure(figure3);
        case 3
            handles = get(figure4,'UserData');
            figure(figure4);
        case 4
            handles = get(figureSA,'UserData');
            figure(figureSA);
    end
    
    % plot the 2 chamber view
    handles.ishow = imshow(handles.img(:,:,handles.num),[0 256]);hold on;
    
    %     set position and color of figures
    set(gcf, 'Position', handles.position, 'Toolbar', 'none',...
        'Menubar', 'none', 'Color', handles.color); %set figure properties
    handles.border = [399, 299; 1 299; 1 1; 399 1; 399, 299];
    %     plot border around
    plot(handles.border(:,1), handles.border(:,2) , handles.colorStr, 'LineWidth', 3); hold on;%plot 2 chamber border color
    
    if i < 4 %plot text on long axis views
        text(30, 80, handles.text1, 'Color', [1 1 1], 'FontSize', 12);hold on; %Text specifying the location
        text(300, 80, handles.text2, 'Color', [1 1 1], 'FontSize', 12); hold on; %Text specifying the location
    else
        %       Attach the lock-unlock toggle to the structure
        handles.ui1 = uicontrol('Style', 'Text', 'String',...
            'U',...
            'ForegroundColor', [1 0 0], 'FontSize', 26,...,...
            'BackgroundColor', [1 1 1],...
            'Position', [350, 250, 50, 50], 'tooltip',...
            'Select to unlock');hold on;
    end
%     Adding border to all and user interface to short axis
    set(gcf,'UserData',handles);
end
end
