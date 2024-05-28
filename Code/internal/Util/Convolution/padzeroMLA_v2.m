function Imgcell_padded=padzeroMLA_v2(Imgcell,LensletCenters,MLANump_d,R_pad,cellsize)
 % version2: align in 3rd dimention

LensletCenters=squeeze(LensletCenters);
[LensletCenters(:,1),I_sorted] = sort(LensletCenters(:,1),1); 
LensletCenters(:,2)=LensletCenters(I_sorted,2);
R_MLA=floor(MLANump_d/2);

for i=1:length(Imgcell)
    Img_let_all=[];
    Img_let_all=cell(cellsize);
    for ct=1:length(LensletCenters)
        Img_let = curve_circ(Imgcell{i},LensletCenters(ct,:),MLANump_d);
        Img_let=Img_let(LensletCenters(ct,2)-R_MLA:LensletCenters(ct,2)+R_MLA,LensletCenters(ct,1)-R_MLA:LensletCenters(ct,1)+R_MLA);
        Img_let=padarray(Img_let,[R_pad R_pad],0,'both');
        
        Img_let_all{ct}=Img_let;
    end
    Imgcell_padded{1,1,i}=cell2mat(Img_let_all);
    fprintf('finish padding %d\n',i);
end

end