function [ output_args ] = maskUnmask ( key, a )
global mask;
global uiToggleMask;

if ischar(key)
    if strcmp(key, 'm')&& (mask == 1)
        mask = 0;
    else
        mask = 1;
    end
    set(uiToggleMask,'Value',mask);
else
%    value = 0 means unmasked 
    mask = get(key,'Value');
end
plot3D();
end