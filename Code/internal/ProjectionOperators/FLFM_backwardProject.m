% oLaF - a flexible 3D reconstruction framework for light field microscopy
% Copyright (c)2017-2020 Anca Stefanoiu

function BackProjection = FLFM_backwardProject(Ht, projection,d,~)
% backwardProjectFLFM: back projects a lenslet image into a volume.

Nslices=size(Ht,3);
BackProjection = zeros(d, d, Nslices);

for j = 1:Nslices
     tmp= conv2(projection , full(Ht{1,1,j}),'full');
     midconv2=ceil(size(tmp)/2);
     BackProjection(:,:,j)= tmp(midconv2(1)-floor(d/2):midconv2(1)+floor(d/2),...
                                midconv2(2)-floor(d/2):midconv2(2)+floor(d/2));
end




