% Writing reconstructed movies properly to tiff. This is crucial for event related movies
%For single image just set the MaxV_Frame =1. 
%%
clear;clc;
addpath(genpath(pwd));
%% Section 1: Read in Mat Files
Mat_datasetdir='E:\yangyang\FLFM_reconstruction_My\Data_Seisure\2023_Sebfish_seisure\Reconstruction\2023_05_26_Sample1_15s_Activity\';
img_folder='matfile\All\';
imglist=dir([Mat_datasetdir,img_folder]);
imglist = extractfield(imglist,'name');
imglist=imglist(3:end);  %from T2
%% Section 2: Setting Nomalization frame
MaxV_Frame=411; % 411
Numcolor = 65536;

img_fileName=imglist{MaxV_Frame};
MaxV_Img = load([Mat_datasetdir,img_folder,img_fileName]);
MaxV_Img=MaxV_Img.reconmasked;

Imgmax = full(max(MaxV_Img(:))) ;
Imgmin = 0;

%% Section 3: Write out Tiff file
Tiff_datasetdir='E:\yangyang\FLFM_reconstruction_My\Data_Seisure\2023_Sebfish_seisure\Reconstruction\2023_05_26_Sample1_15s_Activity\Tiffile\All\';
if ~exist(Tiff_datasetdir,'dir')
    mkdir(Tiff_datasetdir);
end

for t=1:length(imglist)
    img_fileName=imglist{t};
    img=load([Mat_datasetdir,img_folder,img_fileName]);
    img=img.reconmasked;

    mappedImage = uint16((img-Imgmin)./(Imgmax-Imgmin).* (Numcolor-1)) ;
   
    TiffName=img_fileName(1:end-4);
    Outputfilename=[Tiff_datasetdir,TiffName,'.tif'];
    imwrite(mappedImage(:,:,1),Outputfilename);

    if size(mappedImage,3) > 1
        for i=2:size(mappedImage,3)
            imwrite(mappedImage(:,:,i),Outputfilename,'WriteMode','append');
        end
    end
    fprintf('finish writing %d. \n',t);
end





