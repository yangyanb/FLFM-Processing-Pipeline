%% FLFM Reconstruction with FFT GPU accelaration: 
%% Trimed out padding and filtering; Requires PSF near the center of the FOV
clear;clc;
addpath(genpath(pwd));
%% Section 1: Read in MLA Masks
datasetdir='E:\yangyang\FLFM_reconstruction_My\Data_Seisure\202230516_4umBeads10X0.4NA\Center_3C\Mask\';
fileName='MLA_Mask.tif';
MLAMask=true(makeOddSize(imread([datasetdir,fileName])));

fileName='Lenslet_Mask.tif';
Lenslet_Mask=true(makeOddSize(imread([datasetdir,fileName])));

%% Section 2: read in Configuration file

[MLANump_d,LensletCenters]=FLFM_Getcenters(MLAMask,Lenslet_Mask);

%% Section 3: read in PSF data
psf_datasetdir='E:\yangyang\FLFM_reconstruction_My\Data_Seisure\202230516_4umBeads10X0.4NA\Center_3C\TXRD\Extracted_profiled-51\';
psfHt_folderName='All\Ht\';
imglist_Ht=dir([psf_datasetdir,psfHt_folderName]);
imglist_Ht = extractfield(imglist_Ht,'name');
imglist_Ht=imglist_Ht(3:end);

psfH_folderName='All\H\';
imglist_H=dir([psf_datasetdir,psfH_folderName]);
imglist_H = extractfield(imglist_H,'name');
imglist_H=imglist_H(3:end);

% z step for reconstruction
Zstep=1;
Zpos=1:Zstep:length(imglist_Ht);
imglist_H=imglist_H(Zpos);

for i=1:length(imglist_H)
    H{:,:,i}=MLAMask.*single(makeOddSize(imread([psf_datasetdir,psfH_folderName,imglist_H{i}])));    
    Ht{:,:,i}=MLAMask.*single(makeOddSize(imread([psf_datasetdir,psfHt_folderName,imglist_Ht{i}])));  
    fprintf('finish slice %d\n',i);
end
H = ignoreSmallVals(H, 0);% normalization
Ht = ignoreSmallVals(Ht, 0);% normalization

%% Section 4: Assign deconvolution operator

backwardFUN= @(projection) FLFM_backwardProjectGPU_exp(Ht, projection,MLANump_d); 
forwardFUN = @(volume) FLFM_forwardProjectGPU(H,volume);

midfft=ceil(size(MLAMask)./2);
cut=MLANump_d;

%% Section 5: Set output directory 
Rc_datasetdir='E:\yangyang\FLFM_reconstruction_My\Data_Seisure\2023_Sebfish_seisure\Reconstruction\2023_05_26_Sample1_15s_Activity\matfile\';
if ~exist(Rc_datasetdir,'dir')
    mkdir(Rc_datasetdir);
end
%%
% figure;imagesc(tmp);
% hold on;plot(midfft(2),midfft(1),'r*','MarkerSize',10)
% figure;imagesc(BackProjection);
% bpjmask=makecircMask(Vol_D,Vol_D-20);
% Outputpath=['..\..\SampleData\',datasetName ,'\Results\mask_midaverRecon\'];
% OutputName='Reconslice';
% array2tiffslices(recon.*bpjmask,Outputpath,OutputName)



