function [ImgA_crop,ImgB_crop]=Crop_overlay (ImgA_scale_Shift,ImgB)
% A is the smaller one and B is the bigger one 
[Rindx,Cindx]=find(ImgA_scale_Shift~=0);

ImgB_crop=ImgB(min(Rindx):max(Rindx),min(Cindx):max(Cindx));
ImgA_crop=ImgA_scale_Shift(min(Rindx):max(Rindx),min(Cindx):max(Cindx));


end