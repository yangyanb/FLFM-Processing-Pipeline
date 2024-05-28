%% Examples showing the functionality of depthVolumeColorCoder Version 1
% By: Joaquin Quintana     
% May 13, 2021

%% Example 1: Using MATLAB's spiralVol

%clear workspace
clear; close all; clc;
addpath(genpath(pwd));

%% Display Grayscale Spiral
%set colormap to use for depth coding
colormap = hsv;

%load data from MATLAB
filename='D:\PHD\Research\FLFM\FLFM_reconstruction_My\SampleData\20220526_beads_Exppsf\30x_oil_1.05NA\170nm\cropped\FLFMstack_170nmbeads-R4C4.tif';
Num_Z = size(imfinfo(filename),1); 
vol =[]; 
for z = 1 : Num_Z
    vol = cat(3 , vol, double(imread(filename,z)));
end

%% Display Color Coded Spiral 

%colorcode the spiral
CCz_vol=depthVolumeColorCoder(vol,colormap,30000);
imshow3D(CCz_vol, [],colormap);
%% display grayscale volume
% volshow(vol)

%snap pic of the grayscale volume for publishing 
% snapnow
% close;