function mappedImage=normalization_Img(MyImage,Numcolor)


Imgmin = full(min(MyImage(:))) ;
Imgmax = full(max(MyImage(:)) );
mappedImage = single((MyImage-Imgmin)./(Imgmax-Imgmin).* (Numcolor-1) ) ;

end