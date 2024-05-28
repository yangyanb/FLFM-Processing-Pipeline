function ImgA_Shift=corrAB (ImgA,ImgB)

crrAB = xcorr2(ImgB,ImgA);
[~,Indmax] = max(crrAB(:));

[rshift,cshift] = ind2sub(size(crrAB),Indmax);
rcshift=[cshift,rshift]-size(ImgA);
ImgA_Shift=imtranslate(ImgA,rcshift,'FillValues',0);

end