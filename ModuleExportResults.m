% function [data, seg, settings, g_settings, status] = ModuleExportResults(data, seg, settings, g_settings, command)
function varargout = ModuleExportResults(varargin)

settings_struct = {...
    'Export segmentation overlay on raw data (.tiff)', 'label_image', true, 'on';...
%     'Scale up this overlay image by', 'scale', 1.0, 'on';...
    'Export overlay on raw image (.tiff)', 'overlaid', true, 'on';...
    'Export summary statistics', 'stats', true, 'on';...
    };

if nargin == 0
    varargout{1} = settings_struct;
    return ;
elseif nargin == 1
    if strcmpi(varargin{1}, 'name')
        varargout{1} = 'Export Results';
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
    % show settings dialog
    cDialogInputs = PrepareSettingDialog('Export Results', settings_struct, settings);
    [settings, status] = settingsdlg(cDialogInputs{:});
    if strcmpi(status, 'cancel')
        data = []; settings = []; status = 'cancel'; 
    end
elseif strcmpi(command, 'run')
    if isempty(data) || isempty(seg)
        msgbox('Missing input data! Make sure previous steps have been completed.', 'Error', 'Error');
        status = 'erroneous';
    else
        if ~isstruct(seg)
            seeds = double(seg);
            cellsEmbryoId = [];
            cellsInlier = [];
            cellsTE = [];
        else
            seeds = double(seg.seg);
            cellsEmbryoId = seg.cellsEmbryoId;
            cellsInlier = seg.cellsInlier;
            cellsTE = seg.cellsTE;
        end
        
        % export file name (w/o extension)
        [pathstr, name, ext] = fileparts([g_settings.path, g_settings.file]);

        % channel & frame
        channel = g_settings.channel;
        frame = g_settings.frame;

        % export colored segmentation
        if settings.label_image
%             masked = MaskImage(zeros(size(data)), seg, 'alpha', 1);
%             filename = sprintf('%s/%s_channel=%04d_frame=%04d_segmentation.tiff', pathstr, name, channel, frame);
%             WriteTiff(filename, masked);
            filename = sprintf('%s/%s_channel=%04d_frame=%04d_segmentation.tiff', pathstr, name, channel, frame);
            WriteTiff(filename, uint16(seeds));
        end

        % export overlaid image
        if settings.overlaid
%             if settings.scale == 1
                masked = MaskImage(data, seeds, 'alpha', 0.5);
                masked = LabelSeedIds(seeds, cellsEmbryoId, cellsInlier, cellsTE, 'overlay', masked);
%             else
%                 dataScaled = imresize(data, settings.scale, 'nearest');
%                 seedsScaled = imresize(seeds, settings.scale, 'nearest');
%                 masked = MaskImage(dataScaled, seedsScaled, 'alpha', 0.5);
%                 masked = LabelSeedIds(seedsScaled, cellsEmbryoId, cellsInlier, cellsTE, 'overlay', masked);
%             end
            filename = sprintf('%s/%s_channel=%04d_frame=%04d_overlaid.tiff', pathstr, name, channel, frame);
            WriteTiff(filename, masked);
        end

        % export statistics
        if settings.stats
            filename = sprintf('%s/%s_channel=%04d_frame=%04d_statistics.csv', pathstr, name, channel, frame);
            ExportSegmentationSummary(filename, [g_settings.path, g_settings.file], seg, g_settings.frame);
        end
    end
elseif strcmpi(command, 'view')
    explorer(g_settings.path);
else
    error('Unknown command: %s', command);
end

varargout{1} = data;
varargout{2} = seg;
varargout{3} = settings;
varargout{4} = g_settings;
varargout{5} = status;
