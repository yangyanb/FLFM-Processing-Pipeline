%% save 3D array to 3D tiff
function cell2tiffslices(Imagestck,Outputpath,OutputName)

if ~exist(Outputpath,'dir')
    mkdir(Outputpath);
end
Numcolor = 65536;

if length(Imagestck) > 1
    for i=1:length(Imagestck)
        MyImg=Imagestck{i};
        Imgmin = full(min(MyImg(:))) ;
        Imgmax = full(max(MyImg(:)) );
        mappedImage = uint16((MyImg-Imgmin)./(Imgmax-Imgmin).* (Numcolor-1) ) ;
        Outputfilename=[Outputpath,OutputName,'_',sprintf('%04d ',i),'.tiff'];
        imwrite(mappedImage,Outputfilename);
    end
else
    Outputfilename=[Outputpath,OutputName,'.tiff'];
    imwrite(mappedImage,Outputfilename);
end

end 


