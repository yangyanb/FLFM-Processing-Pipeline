%% save 3D array to 3D tiff
function array2tiffslices(MyImage,Outputpath,OutputName)

if ~exist(Outputpath,'dir')
    mkdir(Outputpath);
end

% Numcolor = 256;
Numcolor = 65536;

Imgmin = full(min(MyImage(:))) ;
Imgmax = full(max(MyImage(:)) );
mappedImage = uint16((MyImage-Imgmin)./(Imgmax-Imgmin).* (Numcolor-1) ) ;
% mappedImage =(MyImage-Imgmin)./(Imgmax-Imgmin).* (Numcolor-1)  ;

% mappedImage = uint8((MyImage-Imgmin)./(Imgmax-Imgmin).* (Numcolor-1) ) ;



if size(mappedImage,3) > 1
    for i=1:size(mappedImage,3)
        Outputfilename=[Outputpath,OutputName,sprintf('%04d',i),'.tif'];
        imwrite(mappedImage(:,:,i),Outputfilename);
    end
else
    Outputfilename=[Outputpath,OutputName,'.tif'];
    imwrite(mappedImage,Outputfilename);
end

end 


