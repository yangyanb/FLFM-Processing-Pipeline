function MLANump_d=getlensletD(Lenslet_Mask)

% MLA_Numd 
MLANump_d=2*floor(sqrt(length(find(Lenslet_Mask>0))/pi)); % -6: avoid edge artifacet
MLANump_d=MLANump_d-(~mod(MLANump_d,2));

end




