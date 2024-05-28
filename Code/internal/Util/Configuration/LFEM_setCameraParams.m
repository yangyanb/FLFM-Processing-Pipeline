% oLaF - a flexible 3D reconstruction framework for light field microscopy
% Copyright (c)2017-2020 Anca Stefanoiu 

function [Camera, LensletGridModel,Performance] = LFEM_setCameraParams(configFile)

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

%% MLA array descriptor
LensletGridModel.gridType = Camera.gridType;
LensletGridModel.UMax = Performance.Nmla ;
LensletGridModel.VMax = Performance.Nmla ;

LensletGridModel.HSpacing = Camera.spacingPixels;

% make sure it is even
LensletGridModel.HSpacing = LensletGridModel.HSpacing + ...
                                            mod(LensletGridModel.HSpacing,2); 
if(strcmp(Camera.gridType, 'square'))
    LensletGridModel.VSpacing = LensletGridModel.HSpacing;
end
% Coordinate of the first lenslet
% LensletGridModel.HOffset = Camera.horizOffset;
% LensletGridModel.VOffset = Camera.vertOffset;
% LensletGridModel.Rot = Camera.gridRot;

%% manmual subscript (row,colum)
Vsub=[];Usub=[];
if Camera.pickcenters
    [R,C]= ndgrid(2,3:6);
    Vsub=[Vsub;R(:)];Usub=[Usub;C(:)];
    
    [R,C]= ndgrid(7,3:6);
    Vsub=[Vsub;R(:)];Usub=[Usub;C(:)];
    
    [R,C]=ndgrid(3:6,2:7);
    Vsub=[Vsub;R(:)];Usub=[Usub;C(:)];
    LensletGridModel.centers_manual=[Usub,Vsub];
end

