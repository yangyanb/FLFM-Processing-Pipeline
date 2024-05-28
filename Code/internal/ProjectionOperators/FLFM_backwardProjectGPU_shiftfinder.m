% oLaF - a flexible 3D reconstruction framework for light field microscopy
% Copyright (c)2017-2020 Anca Stefanoiu

function BackProjection = FLFM_backwardProjectGPU_shiftfinder(Ht, projection,d,yx_offset)
% backwardProjectFLFM: back projects a lenslet image into a volume.
if ~isgpuarray(projection)|| issparse(projection)
    projection = full(gpuArray(projection));       
end

% if ~isgpuarray(bpjmask)
%     bpjmask = gpuArray(bpjmask);       
% end
 midfft=ceil((size(projection)+size(Ht{1,1,1})-1)./2);  % should be the middle fft size
 midfft=midfft+yx_offset;

H_gpu = gpuArray(full(Ht{1}));    

tmp = abs(conv_fft2(H_gpu,projection, 'full'));

BackProjection= tmp(midfft(1)-floor(d/2):midfft(1)+floor(d/2),...
                                    midfft(2)-floor(d/2):midfft(2)+floor(d/2));
figure;imagesc(BackProjection);

figure;imagesc(tmp);
hold on;plot(midfft(2),midfft(1),'r*','MarkerSize',10)


