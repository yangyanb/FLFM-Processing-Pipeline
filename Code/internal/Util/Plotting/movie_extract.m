clear;clc;
addpath(genpath(pwd));

datasetName='20220921_LFEM_heartImaging_simul';
path=['..\..\SampleData\',datasetName, '\Results\Recon_all_ds1\'];
Imglist=dir(path);
Imglist = extractfield(Imglist,'name');
Imglist=Imglist(3:end);
%%
for img=1:length(Imglist)
    for i=1:61
        Recon_volume{img}(:,:,i) = double(imread([path,Imglist{img},'\midaverRecon\Reconslice_',num2str(i),'.tiff']));  
    end 
    fprintf('finish %d\n',img);
    recon=Recon_volume{img};
    Outputpath=['..\..\SampleData\',datasetName, '\Results\Recon_all_ds1_frame\',Imglist{img},'\'];
    OutputName='Reconslice';
    array2tiffslices(recon,Outputpath,OutputName)
end
%%
% imshow3D( Recon_volume{1}, [], 'inferno';
Recon_Slice=cell2mat(Recon_volume);
Recon_Slice=mat2cell(Recon_Slice,217,6510,ones(1,61));
%%
for i=1:61
    recon=reshape(Recon_Slice{i},217,217,30);
    Outputpath=['..\..\SampleData\',datasetName, '\Results\Recon_all_ds1_slice\ReconSlice_',num2str(i),'\'];
    OutputName='Sliceframe_';
    array2tiffslices(recon,Outputpath,OutputName)
end
