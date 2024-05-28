%% FLFM PSF extraction from beads stack images. 
%% Trimmed out background removal using histogram.-------------------------
clear;clc;
addpath(genpath(pwd));
%% Section 1: Read in psf Mask
datasetdir='E:\yangyang\FLFM_reconstruction_My\Data_Seisure\202230516_4umBeads10X0.4NA\Center_3C\Mask\';
fileName='Inipsf_Mask.tif';
InipsfMask=makeOddSize(double(imread([datasetdir,fileName])));

fileName='Inipsflet_Mask.tif';
Inipsflet_Mask=makeOddSize(double(imread([datasetdir,fileName])));

%% Section 2:Read in raw psf image stack
psf_datasetdir='E:\yangyang\FLFM_reconstruction_My\Data_Seisure\202230516_4umBeads10X0.4NA\Center_3C\TXRD\';
folderName='Raw_Cropped_Bg-190\';
imglist=dir([psf_datasetdir,folderName]);
imglist = extractfield(imglist,'name');
imglist=imglist(3:end);

%Unit: um; set read in step size 
Zstep=1;
Zpos=1:Zstep:length(imglist);
imglist=imglist(Zpos);

% Set diameter of the psf profile, it has to be odd with a center pixel
% it can be the same as or smaller than mask diameter (MLANump_d)
psfprofile_d=51;    
psfprofile_R=floor(psfprofile_d/2);

%% Section 3: Get the centers of each mask and the mask diameter
[MLANump_d,InipsfletCenters]=FLFM_Getcenters(InipsfMask,Inipsflet_Mask);

%% Section 4: Extract PSF at each Z slice with updates on the Lens-let psf mask 
for i=1:length(imglist)
    psfH=makeOddSize(single(imread([psf_datasetdir,folderName,imglist{i}])));
    psfH_extracted=zeros(size(psfH));
% Update center coordinates of the len-let mask 
    for ct=1:length(InipsfletCenters)
        psfH_let = carve_circ(psfH,squeeze(InipsfletCenters(ct,:,:)),MLANump_d);
         [~,ind]= max(psfH_let(:));
         [ymax,xmax] = ind2sub(size(psfH_let),ind);
         psfH_let = carve_circ(psfH_let,[xmax,ymax],psfprofile_d);
         
         psfH_extracted=psfH_extracted+psfH_let;
         InipsfletCenters(ct,:,:)=cat(3,xmax,ymax);  %update center
    end
    H{:,:,i}=psfH_extracted;
    fprintf('finish %d............\n',i);
end

%% Section 5:make Ht from H 
Ht = cell(1, 1, length(H));
for i = 1:length(H)
    Ht{1,1,i} = flip(flip(H{1,1,i}, 1),2);
    fprintf('finish %d............\n',i);
end

%% Section 6:Set saving directory
psf_savedir='E:\yangyang\FLFM_reconstruction_My\Data_Seisure\202230516_4umBeads10X0.4NA\Center_3C\TXRD\';
savefolderName=['Extracted_All_profiled-',num2str(psfprofile_d),'\'];

%% Section 7:Save H and Ht in two folders slice by slice
for i=1:length(imglist)
    array2tiffslices(H{:,:,i},[psf_savedir,savefolderName,'H\'],imglist{i}(1:end-4));
    fprintf('finish  %d\n',i);
end 
for i=1:length(imglist)
    array2tiffslices(Ht{:,:,i},[psf_savedir,savefolderName,'Ht\'],imglist{i}(1:end-4));
    fprintf('finish  %d\n',i);
end

% Comments and notes 
% You can also save it as a tiff stack using the following command but its
% really a personal preference
% array2tiffstack(H{:,:,i},[psf_datasetdir,folderName],imglist{i}(1:end-4));





