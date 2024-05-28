%% Voxel wise lower pass filtering 
% Over space -> Voxel wise over time
% Here we filter within a mask of ROI 
%% Import dependecies & compute hardware performance
clear;clc;
addpath(genpath(pwd));
%% Section 1: Read in Mat Files
Mat_datasetdir='E:\yangyang\FLFM_reconstruction_My\Data_Seisure\2023_Sebfish_seisure\Reconstruction\2023_05_26_Sample1_15s_Activity\matfile\';
img_folder='Substack (47-97)\';
imglist=dir([Mat_datasetdir,img_folder]);
imglist = extractfield(imglist,'name');
imglist=imglist(3:end);  %from T2

%% Section 2: Read in Mask (mask of ROI)
% Note that it could be a subsection of interest in 3D where signals are
% intersting to you 

Mask_datasetdir='E:\yangyang\FLFM_reconstruction_My\Data_Seisure\2023_Sebfish_seisure\Reconstruction\2023_05_26_Sample1_15s_Activity\';
fileName='ROI_Mask.tif';
ROIMask=tiffreadVolume([Mask_datasetdir,fileName]);

ROI_ind=find(ROIMask~=0); % find ROI indice: location of the Voxels

%% Section 3: Read in Voxel signals

Event_Tpts=1:100;
% Event_Tpts=1:length(imglist);
Voxel.traces=zeros(length(ROI_ind),length(Event_Tpts)); % #Voxels * #Tpts

for t=1:length(Event_Tpts)
    img_fileName=imglist{Event_Tpts(t)};
    img=load([Mat_datasetdir,img_folder,img_fileName]);
    Voxel.traces(:,t)=single(img.reconmask(ROI_ind));
    fprintf('finish reading %d. \n',t);
end

%% Section 4 : 3D Spatial filter

Voxel.Spftraces=zeros(length(ROI_ind),length(Event_Tpts)); % #Voxels * #Tpts
fprintf('start medfilt3 spatial filter...\n');
for t=1:length(Event_Tpts)
    img=zeros(single(size(ROIMask)));
    img(ROI_ind)=Voxel.traces(:,t);
    img =medfilt3(img,[5 5 5]) ; % median 3D filter with cubic of 5 Voxels

    Voxel.Spftraces(:,t)=img(ROI_ind);
    fprintf('finish filter %d. \n',t);
end

%% Section 5: Temporal filtering butterworth 
d = designfilt("lowpassiir",'SampleRate',20,...
               'HalfPowerFrequency',3,'DesignMethod',"butter",FilterOrder=20);

tic;
Voxel_step=5000;
Voxel.filttraces=[];
% for i=1:Voxel_step:1000
fprintf('start temporal filter...\n');
for i=1:Voxel_step:length(ROI_ind)
    V_ind=i:i+Voxel_step-1;
    if i+Voxel_step > length(ROI_ind)
        V_ind=i:length(ROI_ind);
    end
    Voxel.filttraces = [Voxel.filttraces; gather(filtfilt(d,gpuArray(Voxel.Spftraces(V_ind,:)'))')];
    fprintf('finish filter %d. \n',i);
    
end
toc;

%% Section 6: write out

% Setting Nomalization 
Numcolor = 65536;
Imgmax=max(Voxel.filttraces(:));
Imgmin = 0;

Tiff_datasetdir='E:\yangyang\FLFM_reconstruction_My\Data_Seisure\2023_Sebfish_seisure\Reconstruction\2023_05_26_Sample1_15s_Activity\TestFilter\';

if ~exist(Tiff_datasetdir,'dir')
    mkdir(Tiff_datasetdir);
end
tic;
for t=1:length(Event_Tpts)
    img=zeros(single(size(ROIMask)));
    img(ROI_ind)=Voxel.filttraces(:,t);
   
    mappedImage = uint16((img-Imgmin)./(Imgmax-Imgmin).* (Numcolor-1) ) ;
   
    img_fileName=imglist{t};
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
toc;




