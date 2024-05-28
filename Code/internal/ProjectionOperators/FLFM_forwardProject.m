% oLaF - a flexible 3D reconstruction framework for light field microscopy
% Copyright (c)2017-2020 Anca Stefanoiu

function Projection = FLFM_forwardProject(H, realSpace,MLAmask)
% forwardProjectFLFM: Forward projects a volume to a lenslet image by applying the LFPSF
Projection = zeros(size(H{1,1,1}));
for j = 1:size(H,3)
    tmp = conv2(full(H{1,1,j}),realSpace(:,:,j), 'same');
    Projection = Projection + tmp;
end

Projection=Projection.*MLAmask;

end

