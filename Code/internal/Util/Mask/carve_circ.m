function Imgcurve=carve_circ(Img,center,d)
%center=[x;y]
circ = @(x,xc,y,yc,r) ((x-xc).^2.+(y-yc).^2 < r.^2);
makesensor = zeros(size(Img));  % make square box 

x = linspace(1, size(makesensor,2), size(makesensor,2)); 
y = linspace(1,size(makesensor,1), size(makesensor,1));


[X,Y] = meshgrid(x,y);
R=floor(d/2);
Imgcurve = Img .* circ(X, center(1),Y,center(2),R);

end 