%% Deconvolution for FLFM images 
%% run after initialization file!
%% Section 1: Set FLFM Images directory
FLFMimg_datasetdir='E:\yangyang\FLFM_reconstruction_My\Data_Seisure\2023_Sebfish_seisure\2023_05_26_Sample1_15s_Activity\';
FLFMimg_folder='Raw_Cropped_Bg400\';
imglist_FLFMimg=dir([FLFMimg_datasetdir,FLFMimg_folder]);
imglist_FLFMimg = extractfield(imglist_FLFMimg,'name');
imglist_FLFMimg=imglist_FLFMimg(3:end);  %from T2

%% Section 2: Richardson Lucy deconvolution
iter =10; % number of iterations for each image

for t=1:2
% for t=1:length(imglist_FLFMimg)

    FLFMimg_fileName=imglist_FLFMimg{t};
    FLFMimg={MLAMask.*single(makeOddSize(imread([FLFMimg_datasetdir,FLFMimg_folder,FLFMimg_fileName])))};
    
    fprintf('start initialzation....\n');
    tic;
    init = backwardFUN(FLFMimg{1}); 
    toc
    fprintf('finish initialzation. \n');
    
    % for quick in MATLAB checking of the 3D reconstruction
    % initmask=init(midfft(1)-floor(cut/2):midfft(1)+floor(cut/2),midfft(2)-floor(cut/2):midfft(2)+floor(cut/2),:);
    % imshow3D(gather(initmask), [], 'inferno'); 
    
    recon = FLFdeconvRL_G_earlyStop(forwardFUN, backwardFUN, FLFMimg, iter, init);
    reconmasked=recon(midfft(1)-floor(cut/2):midfft(1)+floor(cut/2),midfft(2)-floor(cut/2):midfft(2)+floor(cut/2),:);
    reconmasked=gather(reconmasked);
    
    % output
    OutputName=FLFMimg_fileName(1:end-4);
    OutputfolderName=fullfile(Rc_datasetdir,psfHt_folderName(1:end-4));
    if ~exist(OutputfolderName, 'dir')
        mkdir(OutputfolderName);
    end
    
    % array2tiffstack(gather(reconmask),[OutputfolderName,'\'],OutputName);
    save([OutputfolderName,'\',OutputName,'.mat'],"reconmasked");

end


%% Section 3: for video normaliztion 
% Mat2Tiff

%%
% figure;imagesc(tmp);
% hold on;plot(midfft(2),midfft(1),'r*','MarkerSize',10)
% figure;imagesc(BackProjection);
% bpjmask=makecircMask(Vol_D,Vol_D-20);
% Outputpath=['..\..\SampleData\',datasetName ,'\Results\mask_midaverRecon\'];
% OutputName='Reconslice';
% array2tiffslices(recon.*bpjmask,Outputpath,OutputName)



