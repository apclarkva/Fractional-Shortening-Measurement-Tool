function [ output_args ] = lockUnlock( key, a )
global ui1;
global shift;
global uiToggleLock
if ischar(key)
    if strcmp(key, 'l')&& shift == 1
        set(ui1,'ForegroundColor', [1 0 0], 'BackgroundColor',...
            [1 1 1], 'String', 'U');
        shift = 0;
    else
        set(ui1,'ForegroundColor', [1 1 1], 'BackgroundColor',...
            [1 0 0], 'String', 'L');
        shift = 1;
    end
    set(uiToggleLock,'Value',shift);
else
    %    value = 0 means unmasked
    shift = get(key,'Value');
    if get(key,'Value') == 1
        set(ui1,'ForegroundColor', [1 1 1], 'BackgroundColor',...
            [1 0 0], 'String', 'L');
    elseif get(key,'Value') == 0
        set(ui1,'ForegroundColor', [1 0 0], 'BackgroundColor',...
            [1 1 1], 'String', 'U');
    end
end
end

