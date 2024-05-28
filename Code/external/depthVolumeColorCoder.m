function [] = depthVolumeColorCoder(vol,colormap,doubleThreshold)
%Function creates a color coded depth using the specified colormap along the 
%z-axis. This is, the bottom of the volume is colored differently than the 
%center and each are differently colored from the top. Enabling users to easily
% distinguish the depth in the volume. 

% Function requires at minimum two parameters:
% 1. vol be a 3D grayscale matrix 
% 2. colormap be a MATLAB defined colormap 
% 3. doubleThreshold is optional and is user defined threshold used to
% convert the volume to binary. doubleThreshold must be type double
% precision [0,1].

% depthVolumeColorCoder~~~~~~~~~~~~~~~~~~~~~~~~~demo showing functionality.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%% ~Exmaples~ %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Example 1
% colormap = hsv;
% load('spiralVol.mat');
% vol = spiralVol;
% depthVolumeColorCoder(vol,colormap)
%V.CameraPosition and V.CameraTarget control the view
%% Example 2
% colormap = jet;
% load(fullfile(toolboxdir('images'),'imdata','BrainMRILabeled','images','vol_001.mat'));
% depthVolumeColorCoder(vol,colormap)

%% Begin Function
%convert volume to double
vol = im2double(vol);

%get the size of the volumes z dimension
[x,y,z] = size(vol);

%make adding user defined threshold optional if not use imbinarize
%user defined threshold must be double precision
if ~exist('doubleThreshold','var')
    doubleThreshold = 0;
end

if doubleThreshold > 0 
    BW = vol > doubleThreshold;
    
else
    %binarize volume data
    BW = imbinarize(vol);
end

%mask image to get just pixles from object to colorcode
masked = vol;
masked(~BW) = 0;  % Zero out where mask is 0.

%normalize data to help with setting values for each slice
A = normalize(masked);

%remove all values which are not above zero
A(A<0) = 0;

%generate linearly spaced vector to replace current intenstiy values with
% evenly spaced intensity values over each slice 
spacer = linspace(0,1,z);

%preallocate array to help MATLAB with memory allocation
arr(:,:,:)= zeros(x, y, z);

%replace current intenstiy values with evenly spaced intensity values 
% over each slice in z. start at bottom and increase intensity from bottom
% to top. 
for i = 1:z
    out = A(:,:,i);
    out(out>0) = spacer(i);
    arr(:,:,i) = im2double(out);
end
%ensure all other figures are closed as volshow is computationally
%expensive
close all;
%%

%set colormap to use for depth color coding
cmp = colormap;

%display depth color coded volume using volshow
V = volshow(arr,...
'Renderer', 'MaximumIntensityProjection',...
'Colormap', cmp,...
'BackgroundColor', [0, 0, 0]);
end




