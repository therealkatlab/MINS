function imgInfo = bioiminfo(fname)

% get image info
[img, format, pages, xyzr, imgInfo] = bimread(fname);
I = strfind(imgInfo, 'display_channel_blue');
if isempty(I)
    error('Fail to retrive information from the input image file!');
end
imgInfo = imgInfo(I:end);

% convert to struct data
imgInfo = strrep(imgInfo, ': ', ''', ''');
imgInfo = strrep(imgInfo, '; ', ''', ''');
imgInfo = ['''', imgInfo];
imgInfo = imgInfo(1:length(imgInfo)-3);
eval(sprintf('imgInfo = struct(%s);', imgInfo));

% convert string to number
fields = fieldnames(imgInfo);
for i = 1:length(fields)
    v = imgInfo.(fields{i});
    if sum((v >= '0' & v <= '9') | v(1) == '-' | v == '.') == length(v)
        imgInfo.(fields{i}) = str2num(imgInfo.(fields{i}));
    end
end
