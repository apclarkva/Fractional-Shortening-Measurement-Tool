function [ output_args ] = keyPress3D( input_args )
%KEYPRESS3D Summary of this function goes here
%   Detailed explanation goes here
global selectORmove;
if strcmp(b.Key,'l') || strcmp(b.Key, 'u')&&(selectORmove == 1)
    if strcmp(b.Key, 'l') || strcmp(b.Key,'u')
        lockUnlock(b.Key);
    end
end

if strcmp(b.Key,'m') && (selectORmove ==1)
    maskUnmask(b.Key);
end
end

