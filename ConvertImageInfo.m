function [settings, g_settings] = ConvertImageInfo(filename, pathname, filterindex)

% prepare settings
settings.file = filename;
settings.path = pathname;

fname = [settings.path, settings.file];

if filterindex == 1 && (strcmpi(fname(end-3:end), '.tif') || strcmpi(fname(end-4:end), '.tiff'))
    imgInfoAll = imfinfo(fname);
    imgInfo.image_num_x = imgInfoAll(1).Width;
    imgInfo.image_num_y = imgInfoAll(1).Height;
    imgInfo.image_num_z = length(imgInfoAll);
    settings.size = sprintf('%d, %d, %d', imgInfo.image_num_x, imgInfo.image_num_y, imgInfo.image_num_z);
    settings.max_frame = 1;
    settings.format = imgInfoAll(1).Format;
    settings.max_channel = 1;
    settings.frame = 1;
    settings.channel = 1;
%     desc = imgInfoAll(1).ImageDescription;
%     idxSpacing = strfind(desc, 'spacing');
%     if isempty(idxSpacing)
%         imgInfo.pixel_resolution_z = 2;
%     else
%         desc = desc(idxSpacing:end);
%         idxEq = find(desc == '=', 1);
%         idxSep = find(desc == 10, 1);
% %         imgInfo.pixel_resolution_z = str2num(desc(idxEq+1:idxSep));
%         imgInfo.pixel_resolution_z = 1;
%     end
%     imgInfo.pixel_resolution_x = imgInfo.pixel_resolution_z / imgInfoAll(1).XResolution;
%     imgInfo.pixel_resolution_y = imgInfo.pixel_resolution_z / imgInfoAll(1).XResolution;
%     imgInfo.pixel_resolution_z = 1;
%     settings.pixel_resolutions = sprintf('%.2f, %.2f, %.2f', imgInfo.pixel_resolution_x, imgInfo.pixel_resolution_y, imgInfo.pixel_resolution_z);    

    settings.pixel_resolutions = sprintf('%.2f, %.2f, %.2f', 1, 1, 1);
    
    % update the gloabl settings
    g_settings.file = filename;
    g_settings.path = pathname;
    g_settings.filterindex = 2;
    g_settings.z_ratio = 1;
    g_settings.frame = 1;
    g_settings.channel = 1;
else
    imgInfo = bioiminfo(fname);
    settings.size = sprintf('%d, %d, %d', imgInfo.image_num_x, imgInfo.image_num_y, imgInfo.image_num_z);
    settings.max_frame = imgInfo.image_num_t;
    settings.format = imgInfo.format;
    settings.max_channel = imgInfo.image_num_c;
    settings.frame = 1;
    settings.channel = 1;
    if ~isfield(imgInfo, 'pixel_resolution_x') || ~isfield(imgInfo, 'pixel_resolution_y') || ~isfield(imgInfo, 'pixel_resolution_z')
        imgInfo.pixel_resolution_x = 1;
        imgInfo.pixel_resolution_y = 1;
        imgInfo.pixel_resolution_z = 1;
    end
    settings.pixel_resolutions = sprintf('%.2f, %.2f, %.2f', imgInfo.pixel_resolution_x, imgInfo.pixel_resolution_y, imgInfo.pixel_resolution_z);
    

    % update the gloabl settings
    g_settings.file = filename;
    g_settings.path = pathname;
    g_settings.filterindex = 2;
    g_settings.z_ratio = imgInfo.pixel_resolution_x / imgInfo.pixel_resolution_z;
    g_settings.frame = 1;
    g_settings.channel = 1;
end