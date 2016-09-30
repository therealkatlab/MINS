% function [data, seg, settings, g_settings, status] = ModuleLoadImage(data, seg, settings, g_settings, command)
function varargout = ModuleLoadImage(varargin)

settings_struct = {...
    'separator', 'Image Info:', '', '';...
    'Image file', 'file', 'File not specified', 'off';...
    'Image path', 'path', 'Path not specified', 'off';...
    'Image format', 'format', 'Format not specified', 'off';...
    'Image size', 'size', '0, 0, 0', 'off';...
    'Total number of time frames', 'max_frame', 1, 'off';...
    'Total number of channels', 'max_channel', 1, 'off';...
    'Pixel resolutions', 'pixel_resolutions', '1, 1, 1', 'off';...
    'separator', 'Select frame and channel:', '', '';...
    'Select a frame', 'frame', 1, 'on';...
    'Select a channel', 'channel', 1, 'on';...
    };

if nargin == 0
    varargout{1} = settings_struct;
    return ;
elseif nargin == 1
    if strcmpi(varargin{1}, 'name')
        varargout{1} = 'Load Image';
    end
    return ;
else
    data = varargin{1};
    seg = varargin{2};
    settings = varargin{3};
    g_settings = varargin{4};
    command = varargin{5};
end

status = 'ok';
if strcmpi(command, 'open')
    % load file
    [filename, pathname, filterindex] = uigetfile( ...
        {'*.raw;*.lsm;*.zvi;*.ics;*.nd2;*.pic;*.dv;*.img;*.oif;*.tif;*.tiff', '3D Image Files (*.lsm;*.zvi;*.ics;*.nd2;*.pic;*.tif;*.tiff;)';
        '*.tif;*.tiff;*.png;*.jpg;*.bmp;','2D Image Files (*.tif;*.tiff;*.png;*.jpg;*.bmp)';}, ...
        'Pick image data');
    
    if isequal(filename,0) || isequal(pathname,0)
        status = 'cancel'; 
    else
        % prepare settings
        [settings, g_settings] = ConvertImageInfo(filename, pathname, filterindex);

        % show settings dialog
        cDialogInputs = PrepareSettingDialog('Load Image', settings_struct, settings);
        [settings, status] = settingsdlg(cDialogInputs{:});
        if strcmpi(status, 'cancel')
            status = 'cancel'; 
        else
            % update the gloabl settings
            g_settings.frame = settings.frame;
            g_settings.channel = settings.channel;
        end
    end
elseif strcmpi(command, 'run')
    % load the image
    sz = str2num(settings.size);
    if sz(3) > 1
        if strcmpi(settings.file(end-3:end), '.tif') || strcmpi(settings.file(end-4:end), '.tiff')
            data = ReadTiff([settings.path, settings.file]);
        else
            data = bioimread([settings.path, settings.file], settings.frame, settings.channel);
        end
    else
        data = imread([settings.path, settings.file]);
        if size(data, 3) > 1
            data = rgb2gray(data);
        end
    end
    if ~strcmpi(class(data), 'uint8')
        data = convert(data, 'uint8');
    end
elseif strcmpi(command, 'view')
    if ~isempty(data)
        h = VisualizeImage(data, seg, 'name', [g_settings.path, g_settings.file]);
        maximize(h);
    end
else
    error('Unknown command: %s', command);
end

varargout{1} = data;
varargout{2} = seg;
varargout{3} = settings;
varargout{4} = g_settings;
varargout{5} = status;