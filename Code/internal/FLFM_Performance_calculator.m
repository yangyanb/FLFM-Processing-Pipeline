%% Section 1:  Import dependecies & compute hardware performance
clear;clc;
addpath(genpath(pwd));
%% set path...
datasetName='C:\Users\yangyanb\Documents\MATLAB\FLFM Design\Doc\';
configFile ='configFile.xlsx';
Camera = table2struct(rmmissing(readtable([datasetName,configFile]),2));

%% in um
Camera.Field_Num=Camera.Field_Num*1e3;
Camera.f1=Camera.f1*1e3;
Camera.f2=Camera.f2*1e3;
Camera.fm=Camera.fm*1e3;

Camera.mla2sensor=Camera.mla2sensor*1e3;
Camera.lensPitch=Camera.lensPitch*1e3;
Camera.Dcam=Camera.Dcam*1e3;

Performance=FLFM_performance(Camera);