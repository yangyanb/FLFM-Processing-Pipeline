% oLaF - a flexible 3D reconstruction framework for light field microscopy
% Copyright (c)2017-2020 Anca Stefanoiu 

function Resolution = FLFM_computePerformance(Camera,depthRange,depthStep,Performance)

%% Compute sensor resolution
if(strcmp(Camera.gridType, 'square'))
    sensorRes = [Camera.pixelPitch, Camera.pixelPitch];
    Nnum = [floor(Camera.lensPitch/Camera.pixelPitch),...
            floor(Camera.lensPitch/Camera.pixelPitch)];
end
Nnum=min(Nnum,Camera.MLANump_d);
Nnum = Nnum - (1-mod(Nnum,2));

%% Object space resolution (voxel size in um) 
texRes(1:2) = Performance.Rxy_pixel;
% texRes(3) = Performance.Rz_pixel;
texRes(3) = depthStep;

% field of view in voxels
Resolution.fovDiaVox = [floor(Camera.fovDia./texRes(1)), ...
                        floor(Camera.fovDia./texRes(2))];
Resolution.fovDiaVox= Resolution.fovDiaVox - mod(Resolution.fovDiaVox+1,2);

%% Set up a struct containing the resolution related info
Resolution.Nnum = Nnum;
Resolution.sensorRes = sensorRes;
Resolution.texRes = texRes;
Resolution.depthStep = texRes(3);
Resolution.depthRange = depthRange;

Resolution.depths = [0:texRes(3): depthRange(2)];
Resolution.depths=[flip(-(Resolution.depths(2:end))),Resolution.depths];


