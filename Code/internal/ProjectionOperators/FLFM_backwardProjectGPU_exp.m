% oLaF - a flexible 3D reconstruction framework for light field microscopy
% Copyright (c)2017-2020 Anca Stefanoiu

function BackProjection = FLFM_backwardProjectGPU_exp(Ht, projection,d)

% backwardProjectFLFM: back projects a lenslet image into a volume.
if ~isgpuarray(projection)|| issparse(projection)
    projection = full(gpuArray(projection));       
end

% if ~isgpuarray(bpjmask)
%     bpjmask = gpuArray(bpjmask);       
% end
midfft=ceil(size(projection)./2);  % should be the middle fft size

Nslices=size(Ht,3);

% BackProjection = gpuArray.zeros(d, d, Nslices , 'single');

for j = 1:Nslices
    H_gpu = gpuArray(full(Ht{j}));       
    tmp = abs(conv_fft2(projection, H_gpu,'same'));

    tmpmask=zeros(size(tmp));
    tmpmask(midfft(1)-floor(d/2):midfft(1)+floor(d/2),midfft(2)-floor(d/2):midfft(2)+floor(d/2)) = 1;
    BackProjection(:,:,j)=tmpmask.*tmp;

end

% figure;imagesc(tmp);figure;imagesc(BackProjection(:,:,j));
% hold on;plot(midfft(2),midfft(1),'r*','MarkerSize',10)



