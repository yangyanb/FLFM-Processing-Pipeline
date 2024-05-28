function [MLANump_d,LensletCenters]=FLFM_Getcenters(MLAMask,Lenslet_Mask)

% MLA_Numd 
MLANump_d=2*floor(sqrt(length(find(Lenslet_Mask>0))/pi)); % -6: avoid edge artifacet
MLANump_d=MLANump_d-(~mod(MLANump_d,2));
% writematrix(MLANump_d,configFile,'Sheet',1,'Range','P2');
%%
MLAMask(MLAMask>0)=1;
Lenslet_Mask(Lenslet_Mask>0)=1;

Rfcenter=squeeze(find_Apcenter(Lenslet_Mask,0,0));   %x y
c = xcorr2(MLAMask,Lenslet_Mask);
%%
[Ycenter_xc,Xcenter_xc]=find(c==length(find(Lenslet_Mask>0)));  %rows colums
Rfcenter_xc=flip(size(Lenslet_Mask))';       %x y
offset_xc=Rfcenter_xc-Rfcenter;            %x y

LensletCenters=[Xcenter_xc-offset_xc(1),Ycenter_xc-offset_xc(2)];  %x y
imagesc(MLAMask);hold on; plot(LensletCenters(:,1),LensletCenters(:,2),'r*','Markersize',30);
LensletCenters=cat(3,LensletCenters(:,1),LensletCenters(:,2));


end




