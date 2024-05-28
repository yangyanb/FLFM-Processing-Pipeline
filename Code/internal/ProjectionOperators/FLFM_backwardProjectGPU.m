% oLaF - a flexible 3D reconstruction framework for light field microscopy
% Copyright (c)2017-2020 Anca Stefanoiu

function BackProjection = FLFM_backwardProjectGPU(Ht, projection,d,midfft)
% backwardProjectFLFM: back projects a lenslet image into a volume.
if ~isgpuarray(projection)|| issparse(projection)
    projection = full(gpuArray(projection));       
end

% if ~isgpuarray(bpjmask)
%     bpjmask = gpuArray(bpjmask);       
% end
if isempty(midfft)
    midfft=ceil((size(projection)+size(Ht{1,1,1})-1)./2);  % should be the middle fft size
end
Nslices=size(Ht,3);

BackProjection = gpuArray.zeros(d, d, Nslices , 'double');

for j = 1:Nslices
    H_gpu = gpuArray(full(Ht{1,1,j}));       
    tmp = real(conv_fft2(H_gpu,projection, 'full'));
    BackProjection(:,:,j)= tmp(midfft(1)-floor(d/2):midfft(1)+floor(d/2),...
                                        midfft(2)-floor(d/2):midfft(2)+floor(d/2));
end

% figure;imagesc(tmp);
% hold on;plot(midfft(2),midfft(1),'r*','MarkerSize',10)
% figure;imagesc(BackProjection(:,:,1));




