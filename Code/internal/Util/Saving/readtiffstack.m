function tiff_stack=readtiffstack(filename,slices)

% tiff_info = imfinfo(filename); % return tiff structure, one element per image
tiff_stack = [];
%concatenate each successive tiff to tiff_stack
for ii = 1 : length(slices)
    temp_tiff = imread(filename, slices(ii));
    tiff_stack = cat(3 , tiff_stack, temp_tiff);
end

end