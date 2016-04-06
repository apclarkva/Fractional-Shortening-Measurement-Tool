function [ fig2,fig3,fig4,figSA, inst ] = selectRefPoints(figure2, figure3, figure4, figureSA)
%Have user select some simple reference points to allow easy placement of
%the images in 3D

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

% Added to handles:
%instruct
%mask
%shift
%selectORmove
%uiToggleMask
%uiToggleLock
%uiFinish
%others
%base -LA
%apex -LA
%leafD -LA
%leafS -LA
%medial -SA
%lateral -SA

% an instructions figure:
instruct = figure;
set(instruct, 'Position', [15 440 325 320],'Toolbar', 'none',...
    'Menu', 'none', 'Color', [0 0 0]);
handles2 = get(figure2,'UserData');

% Saving mask and shift to instruct handles (shift is for lock-unlock)
handles.mask = handles2.mask;
handles.shift = handles2.shift;
handles.which = handles2.which;
handles.selectORmove = handles2.selectORmove;
set(instruct,'UserData',handles);

% getting the height of each text box
height = floor(320/14);
imy = [];
for i = 1:14
    imy(i) = 320-i*height;
end

% The instructions
titles = {'Select Apex of 2 Chamber',...
    'Select Base of 2 Chamber',...
    'Select Mitral Leaflet Att of 2 Ch (ED)',...
    'Select Mitral Leaflet Att of 2 Ch (ES)',...6
    'Select Apex of 4 Chamber',...
    'Select Base of 4 Chamber',...
    'Select Mitral Leaflet Att of 4 Ch (ED)',...
    'Select Mitral Leaflet Att of 4 Ch (ES)',...12
    'Select Apex of 3 Chamber',...
    'Select Base of 3 Chamber',...
    'Select Mitral Leaflet Att of 3 Ch (ED)',...
    'Select Mitral Leaflet Att of 2 Ch (ES)',...18
    'Select Medial Papillary Muscle',...
    'Select Lateral Papillary Muscle'};%20

% Tips, explaining the instructions - shows up when you scroll over
% instruction
tips = {'Select the endocardial apex of the 2 chamber view',...
    'Select the point where the 4 chamber view intersects the mitral valve of the 2 chamber view',...
    'Select the mitral leaflet attachment points on the 2 chamber view at end diastole',...
    'Select the mitral leaflet attachment points on the 2 chamber view at end systole',...
    'Select the point where the 2 chamber endocardial apex intersect the 4 chamber view',...
    'Select the point where the 2 chamber view intersects the mitral valve of the 4 chamber view',...
    'Select the mitral leaflet attachment points on the 4 chamber view at end diastole',...
    'Select the mitral leaflet attachment points on the 4 chamber view at end systole',...
    'Select the point where the 2 chamber endocardial apex intersects the 4 chamber view',...
    'Select the point where the 2 chamber view intersect the mitral valve of the 4 chamber view',...
    'Select the mitral leaflet attachment points on the 3 chamber view at end diastole',...
    'Select the mitral leaflet attachment points on the 3 chamber view at end systole',...
    'Select the interface between the medial papillary muscle and the endocardium',...
    'Select the lateral papillary muscle-endocardium interface to set the angle of the 4 chamber view'};

step = 1;
uiArray = [];
refPoints = [];
numLeaflets = 0;
while step < 15
    %   I want to make the image that will have points selected saved as fig
    if step > 0 && step <= 4 %setting current figure and handles
        fig = figure2;
        handles = get(figure2,'UserData');
    elseif step>4 && step<= 8
        fig = figure4;
        handles = get(figure4,'UserData');
    elseif step >8 && step<=12
        fig = figure3;
        handles = get(figure3,'UserData');
    else
        fig = figureSA;
        handles = get(figureSA,'UserData');
    end
    %setting figure present
    figure(instruct);%set instruction figure present
    ui = plottingInstructions(imy(step),height, titles(step),tips(step)); %add instruction
    uiArray(step) = ui; %start saving user interface instructions to array
    figure(fig); %make figure of interest present
    
    button = 2;
    %check to make sure that you are not selecting the leaflet attachment
    %points
    if step == 1 || step == 2 || step == 5 || step == 6 || step == 9 || step == 10 || step == 13 || step == 14
        while button ~= 1 %select next point, or go back
            [x,y,button] = ginput(1); %get coordinates and button pressed
            
            if button == 8 %if backspace is selected then you will go to previous instruction
                step = step-1;
                delete(uiArray(step)); %delete current instruction
                delete(uiArray(step+1)); %delete previous instruction
                break %break out of this while
            elseif button == 29
                if handles.num == length(handles.img(1,1,:));
                    handles.num = handles.num-1;
                else
                    handles.num = handles.num+1;
                end
                if step == 13 || step == 14
                    plottingImages(fig, handles.img, handles.position, handles.color, handles.colorStr, '', '', 'ED', handles.num);
                end
            elseif button == 28
                if handles.num == 1
                    handles.num = length(handles.img(1,1,:));
                else
                    handles.num = handles.num-1;
                end
                if step == 13 || step == 14
                    plottingImages(fig, handles.img, handles.position, handles.color, handles.colorStr, '', '', 'ED', handles.num);
                end
            end
        end
        
        if button == 8
            continue %jump to top of while loop if backspace pressed
        else
            refPoints(step+numLeaflets,:) = [x y]; %save the coordinates to refPoints if point selected
        end
    else %If you are selecting leaflet attachment points
        %         Change to end systolic
        if step == 4 || step==8 || step == 12 %after end diastolic leaflet attachment points are selected, go back to end systolic
            plottingImages(fig, handles.img, handles.position, handles.color, handles.colorStr, handles.text1,handles.text2, 'ES' ,handles.esImg);
        end
        
        for j = 1:2 %2, because selecting 2 points
            if j ==2
                numLeaflets = numLeaflets +1; %since step doesnt change when you select each leaflet, you have to increase the number to save to new array spot
            end
            button = 2;
            while button ~=1
                [x, y, button] = ginput(1);
                if button == 8
                    step = step-1;
                    delete(uiArray(step));
                    delete(uiArray(step+1));
                    if j ==2
                        numLeaflets = numLeaflets-1;
                    end
                    plottingImages(fig, handles.img, handles.position, handles.color, handles.colorStr, handles.text1,handles.text2, 'ED' ,handles.num);
                    break
                elseif button == 29
                    if handles.num == length(handles.img(1,1,:));
                        handles.num = handles.num-1;
                    else
                        handles.num = handles.num+1;
                    end
                    plottingImages(fig, handles.img, handles.position, handles.color, handles.colorStr, handles.text1, handles.text2, 'ED', handles.num);
                elseif button == 28
                    if handles.num == 1
                        handles.num = length(handles.img(1,1,:));
                    else
                        handles.num = handles.num-1;
                    end
                    plottingImages(fig, handles.img, handles.position, handles.color, handles.colorStr, handles.text1, handles.text2, 'ED', handles.num);
                end
                
            end
            if button ==8
                break
            else
                refPoints(step+numLeaflets,:) = [x y]; %save the coordinates to refPoints if point selected
            end
        end
        if button == 8
            continue
        end
        %         Change back to end diastolic
        if step == 4 || step == 8 || step == 12%go back to end diastolic image
            plottingImages(fig, handles.img, handles.position, handles.color, handles.colorStr, handles.text1,handles.text2, 'ED' ,handles.num);
        end
    end
    
    set(ui,'ForegroundColor', [.2 .2 .2]);
    step = step+1;
end

% adding ch4 refpoints to fig4 userdata
%%
handles = get(figure2,'UserData');
handles.base = refPoints(1,:);
handles.apex = refPoints(2,:);
handles.leafD = refPoints(3:4,:);
handles.leafS = refPoints(5:6,:);
set(figure2,'UserData',handles);

%adding ch4 ref points to fig4 userdata
handles = get(figure4,'UserData');
handles.base = refPoints(7,:);
handles.apex = refPoints(8,:);
handles.leafD = refPoints(9:10,:);
handles.leafS = refPoints(11:12,:);
set(figure4,'UserData',handles);

%adding ch3 ref points to fig3 userdata
handles = get(figure3,'UserData');
handles.base = refPoints(13,:);
handles.apex = refPoints(14,:);
handles.leafD = refPoints(15:16,:);
handles.leafS = refPoints(17:18,:);
set(figure3,'UserData',handles);

%adding chSA ref points to figSA userdata
handles = get(figureSA,'UserData');
handles.medial = refPoints(19,:);
handles.lateral = refPoints(20,:);
set(figureSA,'UserData',handles);
%%

% Now, from the medial and lateral papillary muscles I want to find the SA
% intersection with the BA axis, and the point in the RV that the 4 chamber
% intersects.
chSALateral = refPoints(20,:);
chSAMedial = refPoints(19,:);

chSACenter = mean([chSALateral;chSAMedial]);
centMedVect = chSAMedial-chSACenter;
angle = atand(centMedVect(2)./centMedVect(1));
angle = angle + 10;
chSARV = [chSACenter(1)-10.*cosd(angle), chSACenter(2)-10.*sind(angle)];

figure(instruct);
handles = get(instruct,'UserData');

handles.uiToggleMask = uicontrol('Style', 'checkbox', 'String',...
    'Mask',...
    'ForegroundColor', [1 1 1], 'FontSize', 10,...
    'BackgroundColor', [0 0 0],...
    'Position', [250, 200, 100, 25], 'tooltip',...
    'Mask the back face of the views', 'Value', handles.mask,...
    'Callback', @maskUnmask);

handles.uiToggleLock = uicontrol('Style', 'checkbox', 'String',...
    'Lock',...
    'ForegroundColor', [1 1 1], 'FontSize', 10,...
    'BackgroundColor', [0 0 0],...
    'Position', [250, 165, 100, 25], 'tooltip',...
    'Lock the long axis lines together in the short axis view','Callback',...
    @lockUnlock);

handles.uiFinish = uicontrol('Style', 'pushbutton', 'String',...
    'Done',...
    'ForegroundColor', [1 1 1], 'FontSize', 10,...
    'BackgroundColor', [0 0 0],...
    'Position', [230, 100, 90, 50], 'tooltip',...
    'Select when finished realigning slice planes','Callback',...
    @fsrp);

set(instruct,'UserData',handles);

% Outputs of this function
fig2 = figure2;
fig3 = figure3;
fig4 = figure4;
figSA = figureSA;
inst = instruct;
end

function plottingImages(fig, im, position, color, pcolor, t1,t2, which, imNum)


figure(fig);
% plot the 2 chamber view at ES
imshow(im(:,:,imNum),[0 256]);hold on;

set(fig, 'Position', position, 'Toolbar', 'none',...
    'Menubar', 'none', 'Color', color); %set figure properties
border = [399, 299; 1 299; 1 1; 399 1; 399, 299];
plot(border(:,1), border(:,2) , pcolor, 'LineWidth', 3); hold on;%plot 2 chamber border color
text(30, 80, t1, 'Color', [1 1 1], 'FontSize', 12);hold on; %Text specifying the location
text(300, 80, t2, 'Color', [1 1 1], 'FontSize', 12); hold on;

end

function userInterface = plottingInstructions(y, height,title,tip)
font = 10;
userInterface = uicontrol('Style', 'Text', 'String',...
    title,...
    'ForegroundColor', [1 1 1], 'FontSize', font,...
    'BackgroundColor', [0 0 0],...
    'Position', [10, y, 220, height],'tooltip',cell2mat(tip));
end


