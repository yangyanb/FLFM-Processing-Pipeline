function shift=peakalign2D_computeshift(ref,temp)


   
[~,ind]= max(ref(:));
[ymax_ref,xmax_ref] = ind2sub(size(ref),ind);
   
[~,ind]= max(temp(:));
[ymax_temp,xmax_temp] = ind2sub(size(temp),ind);

shift=[xmax_ref-xmax_temp,ymax_ref-ymax_temp];

  
end