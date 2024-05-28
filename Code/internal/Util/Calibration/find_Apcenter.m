function OC=find_Apcenter(ApertureImage,threshold,draw_center)

pedel=ApertureImage>threshold;
[prow,pcol] = find(pedel);

OC=cat(3,ceil(mean(pcol)),ceil(mean(prow)));
if draw_center
    figure;imagesc(pedel);hold on;plot(OC(:,:,1),OC(:,:,2),'r*','Markersize',30);
end
end