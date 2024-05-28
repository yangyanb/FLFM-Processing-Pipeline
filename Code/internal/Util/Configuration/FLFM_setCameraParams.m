% oLaF - a flexible 3D reconstruction framework for light field microscopy
% Copyright (c)2017-2020 Anca Stefanoiu 

function [Camera, Performance] = FLFM_setCameraParams(configFile)

%% set FLFM parameters:
%%%% microscope params
% fobj-> objective magnification
% NA-> objective aperture
% f1 -> relay lens 1
% f2 -> relay lens 2

%%%% sensor
% lensPitch-> lenslet pitch
% pixelPitch-> sensor pixel pitch

%%%% MLA params
% gridType-> microlens grid type: "reg" -> regular grid array; "hex" -> hexagonal grid array 
% fm-> focal length of the lenslets

%%%% light characteristics
% n-> refraction index (1 for air)
% wavelenght-> wavelenght of the the emission light

%%%% distances
% mla2sensor-> distance between MLA and sensor

%%% MLA array descriptor 
% spacingPixels-> number of pixels between horizontal neighboring elemental (sub-aperture) images
% noLensHoriz-> number of elemental images horizontally 
% noLensVert-> number of elemental images vertically
% shiftRow-> '1' or '2' when odd or even rows are shifted, respectively (in hex grid only)

%% Initiation:
Camera = table2struct(rmmissing(readtable(configFile),2));
%% reset
Camera.Field_Num=Camera.Field_Num*1e3;
Camera.f1=Camera.f1*1e3;
Camera.f2=Camera.f2*1e3;
Camera.fm=Camera.fm*1e3;
Camera.mla2sensor=Camera.mla2sensor*1e3;
Camera.lensPitch=Camera.lensPitch*1e3;

Performance=FLFM_performance(Camera);

%% Camera descriptor
Camera.fobj=Camera.f1/Camera.M;      
Camera.objRad = Camera.fobj * Camera.NA; % objective radius
Camera.k = 2*pi*Camera.n/Camera.WaveLength; % wave number
%total FLFM system magnification
Camera.sysM = Camera.fm*Camera.f1/(Camera.f2*Camera.fobj); 

% field stop radius um
Camera.fsRad = min(Camera.lensPitch/2,...
                   Camera.pixelPitch*Camera.MLANump_d/2)* ...
                   Camera.f2/Camera.fm;

% field of view radius
if isfield(Camera, 'WpixelPitch')
    Camera.fovDia =  min(Performance.FOV,...
                         Camera.WpixelPitch*Camera.WNump_d/Camera.Wrelay_M/Camera.M);
else
    Camera.fovDia =  Performance.FOV;
end  
Camera.fovDia_obj =  Performance.FOV_obj;

end