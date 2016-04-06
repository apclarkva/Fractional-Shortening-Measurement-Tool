% New Version MainScript
close all;close all hidden;clear all;clc

% variables for figures
figure2 = figure;
figure3 = figure;
figure4 = figure;
figureSA = figure;

whichImg = '88';



switch whichImg
    case '85'
        esImg = 9;
    case '86'
        esImg = 9;
    case '87'
        esImg = 11;
    case '88'
        esImg = 9;
    case '99'
        esImg = 15;
    case '112'
        esImg = 12;
    case '129'
        esImg = 12;
    case '183'
        esImg = 9;
    case '191'
        esImg = 9;
    case '196'
        esImg = 11;
end 

load(['ProjectImages\corners&IMG' whichImg '_1']);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% load(['ProjectImages\viewPoints' whichImg]);
% load(['ProjectImages\translations_of_interest']);
% thetaTilt = translations_of_interest(1,1);
% thataRot = translations_of_interest(1,2);
% zDelt = translations_of_interest(1,3);
% 
% [cornersSA,viewPoints] = tiltSA(cornersSA_initial,viewPoints_initial,thetaTilt,edores);
% cornersSA = rotateSA(cornersSA,viewPoints,thetaRot);
% [cornersSA,viewPoints] = moveSAZ(cornersSA,viewPoints,zDelt);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

img2 = [];
img3 = [];
img4 = [];
imgSA = [];

for i = 1:length(img(1,1,1,:))
    img2(:,:,i) = imresize(imrotate(findPixels(corners2,img,'LA',i),90),'OutputSize',[300 400]);
    img3(:,:,i) = imresize(imrotate(findPixels(corners3,img,'LA',i),90),'OutputSize',[300 400]);
    img4(:,:,i) = imresize(imrotate(findPixels(corners4,img,'LA',i),90),'OutputSize',[300 400]);
    imgSA(:,:,i) = imresize(findPixels(cornersSA,img,'SA',i),'OutputSize',[300 400]);;
end

% variable for 3D fig
figure3D = figure;

% Tag the figures
set(figure2,'Tag','figure2');
set(figure3,'Tag','figure3');
set(figure4,'Tag','figure4');
set(figureSA,'Tag','figureSA');
set(figure3D,'Tag','figure3D');

% initial handles for all
handles.which = 1; 
handles.num = 1; 
handles.mask = 1;%for masking the back in 3D
% when 0 then selecting points and allow to play movie.  Also
% allow to go back with back space.  When 1, allow to play
% movie while person is moving slices.
handles.selectORmove = 0;%Becomes one later on - purpose is to prevent from activating lockUnlock and maskUnmask too early
handles.recursionPrevent= 1;%Figure this out
handles.alex = 1;
handles.distMoved = 1;
handles.esImg = esImg;
handles.shift = 0; %This is for lock-unlock toggle

set(figure2,'UserData',handles);
set(figure3,'UserData',handles);
set(figure4,'UserData',handles);
set(figureSA,'UserData',handles);

% Only difference in figure userdata at this point is the image
handles = get(figure2,'UserData');
handles.img = img2;
handles.num = 4;%The chamber 2 ED is one frame after others
handles.position = [450 470 400 300];
handles.color = [1 0 1];
handles.colorStr = 'm-';
handles.text1 = 'Inferior';
handles.text2 = 'Anterior';
set(figure2,'UserData',handles);

% setting userdata specific for fig3
handles = get(figure3,'UserData');
handles.img =img3;
handles.num = 1;
handles.position = [450 100 400 300];
handles.color = [0 1 1];
handles.colorStr = 'c-';
handles.text1 = 'Inferoseptal';
handles.text2 = 'AnteroLateral';
set(figure3,'UserData',handles);

% setting userdata specific for fig4
handles = get(figure4, 'UserData');
handles.img = img4;
handles.num = 1;
handles.position = [875 470 400 300];
handles.color = [1 1 0];
handles.colorStr = 'y-';
handles.text1 = 'Septal';
handles.text2 = 'Lateral';
set(figure4,'UserData',handles);

% setting userdata specific for figSA
handles = get(figureSA, 'UserData');
handles.img = imgSA;
handles.num = 1;
handles.recursionPrevent = 1; %when shifted - need to call LonS multiple times.
%This is to make sure it doesn't call itself
%again and again
handles.position = [875 100 400 300];
handles.color = [0 1 0];
handles.colorStr = 'g-';
set(figureSA,'UserData',handles);



handles3D = get(figure3D,'UserData');
ax3D = axes;
set(ax3D,'CameraPosition', [498 214 3650],...
    'CameraTarget', [170 207 203],...
    'CameraUpVector', [0 0 1],...
    'CameraViewAngle',5.32, 'CameraTargetMode', 'manual',...
    'CameraPositionMode', 'manual');
handles3D.ax3D = ax3D;
handles3D.mask = 1;
handles3D.invisible = 3;
set(figure3D,'UserData',handles3D);
set(figure3D, 'WindowKeyPressFcn',@keyPress3D);
set(figure3D, 'Position', [20 50 400 300]); %set figure properties


% Start of Actual Code
% plots the images in three separate figures
graphimgs(figure2, figure3, figure4, figureSA);

% Input the figures with stuff saved in figure userdata
% have it output the figure with new userdata
[figure2,figure3,figure4,figureSA, instruct] = selectRefPoints(figure2,figure3,figure4,figureSA);

% set(figure2, 'WindowKeyPressFcn', {@keyPress,figure3,figure4,figureSA,instruct});
% set(figure3,'WindowKeyPressFcn', {@keyPress,figure2,figure4,figureSA,instruct});
% set(figure4, 'WindowKeyPressFcn', {@keyPress,figure2,figure3,figureSA,instruct});
% set(figureSA, 'WindowKeyPressFcn', {@keyPress,figure2,figure3,figure4,instruct});

% Using imline now, because I know how to constrain the movements of it
% Develop a function that draws all of the lines on the image.
interactiveLines(figure2,figure3,figure4,figureSA,instruct,figure3D);


initialCorners(figure2,figure3,figure4,figureSA,figure3D);



controlFig = figure;

set(controlFig,'Position',[15 440 325 320],'Toolbar', 'none',...
    'Menu', 'none', 'Color', [0 0 0]);

% Other Steps are: 
handlesControl.steps = {'LA4withLA2','LA3withLA2','SAwithLA'};
handlesControl.step = 'LA4withLA2';

uicontrol('Style', 'pushbutton', 'String', '4ch and 2ch', 'ForegroundColor',[1 1 1],...
          'FontSize', 12, 'BackgroundColor', [0 0 0], 'Position',[15 200 295 40],...
          'Callback', {@adj2and4,figure2,figure3,figure4,figureSA,figure3D});
      
uicontrol('Style', 'pushbutton', 'String', '3ch and 2ch', 'ForegroundColor', [1 1 1],...
          'FontSize', 12, 'BackgroundColor', [0 0 0], 'Position', [15 140 295 40],...
          'Callback', {@adj2and3,figure2,figure3,figure4,figureSA,figure3D});
      
uicontrol('Style', 'pushbutton', 'String', 'SA Adjustments', 'ForegroundColor', [1 1 1],...
          'FontSize', 12, 'BackgroundColor', [0 0 0], 'Position', [15 80 295 40],...
          'Callback', {@adjSA,figure2,figure3,figure4,figureSA,figure3D});

adj2and4(1,1,figure2,figure3,figure4,figureSA,figure3D);


