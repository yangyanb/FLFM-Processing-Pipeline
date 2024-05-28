%% save 3D array to 3D tiff
function array2tiffstack(MyImage,Outputpath,OutputName)

if ~exist(Outputpath,'dir')
    mkdir(Outputpath);
end

% Numcolor = 256;
Numcolor = 65536;
 
Imgmin = full(min(MyImage(:))) ;
Imgmax = full(max(MyImage(:)) );

mappedImage = uint16((MyImage-Imgmin)./(Imgmax-Imgmin).* (Numcolor-1) ) ;
% mappedImage = uint8((MyImage-Imgmin)./(Imgmax-Imgmin).* (Numcolor-1) ) ;

% mappedImage = im2uint16(MyImage);

Outputfilename=[Outputpath,OutputName,'.tif'];
imwrite(mappedImage(:,:,1),Outputfilename);

if size(mappedImage,3) > 1
    for i=2:size(mappedImage,3)
        imwrite(mappedImage(:,:,i),Outputfilename,'WriteMode','append');
    end
end

end 


