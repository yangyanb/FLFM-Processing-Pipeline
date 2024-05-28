function LensletCenters=lensletcenterfinder(MLAMask,Lenslet_Mask,draw_center)
%%
MLAMask(MLAMask>0)=1;
Lenslet_Mask(Lenslet_Mask>0)=1;

Rfcenter=squeeze(find_Apcenter(Lenslet_Mask,0,0));   %x y
c = xcorr2(MLAMask,Lenslet_Mask);
%
[Ycenter_xc,Xcenter_xc]=find(c==length(find(Lenslet_Mask>0)));  %rows colums
Rfcenter_xc=flip(size(Lenslet_Mask))';       %x y
offset_xc=Rfcenter_xc-Rfcenter;            %x y

LensletCenters=[Xcenter_xc-offset_xc(1),Ycenter_xc-offset_xc(2)];  %x y
if draw_center
    figure;imagesc(MLAMask);hold on; 
    plot(LensletCenters(:,1),LensletCenters(:,2),'r*','Markersize',20);
end

end




