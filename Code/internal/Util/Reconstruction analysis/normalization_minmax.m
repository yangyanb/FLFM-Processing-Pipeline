function mappedImage=normalization_minmax(MyImage,minV,maxV)


Imgmin = full(min(MyImage(:))) ;
Imgmax = full(max(MyImage(:)) );
mappedImage =minV+((MyImage-Imgmin)./(Imgmax-Imgmin).* (maxV-minV) );

end