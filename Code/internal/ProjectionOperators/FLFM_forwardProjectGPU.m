% oLaF - a flexible 3D reconstruction framework for light field microscopy
% Copyright (c)2017-2020 Anca Stefanoiu

function Projection = FLFM_forwardProjectGPU(H, realSpace)
% forwardProjectFLFM: Forward projects a volume to a lenslet image by applying the LFPSF
if ~isgpuarray(realSpace)
    realSpace = gpuArray(realSpace);       
end
% if ~isgpuarray(MLAmask)
%     MLAmask = gpuArray(MLAmask);       
% end
%%
Projection = gpuArray.zeros(size(H{1,1,1}),'single');

for j = 1:size(H,3)
    H_gpu = gpuArray(full(H{1,1,j}));       
    tmp = abs(conv_fft2(H_gpu,realSpace(:,:,j), 'same'));
    Projection = Projection + tmp;
end

% Projection=Projection.*MLAmask;

end

