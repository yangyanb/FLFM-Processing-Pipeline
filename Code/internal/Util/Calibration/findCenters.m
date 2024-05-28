function LensletCenters=findCenters(CalibrationImage,threshold)
%% LensletCenters : cat(3,x,y)=cat(3,colums,rows)
LensletCenters=[];
%initilization
spotsImage=CalibrationImage>=threshold;
[spotsrow,spotscol] = find(spotsImage);
allmask=zeros(size(spotsImage));

% make spots 
spotsize=50;
circ = @(x,y,r) (x.^2.+y.^2.<r.^2)*1.0;
maskSensor = zeros(spotsize);  % make square box 
y = linspace(-floor(size(maskSensor,1)/2), floor(size(maskSensor,1)/2), size(maskSensor,1));
x = linspace(-floor(size(maskSensor,2)/2), floor(size(maskSensor,2)/2), size(maskSensor,2)); 
[X,Y] = meshgrid(x,y);
maskSensor = circ(X, Y, spotsize);

% start looping 
while(~isempty(spotsrow))
spotscenter = zeros(size(spotsImage));
spotscenter(spotsrow(1),spotscol(1))=1;
spotmask  = conv2(spotscenter, maskSensor, 'same');
[rows,colums]=find(spotmask.*spotsImage);
%
LensletCenters=[LensletCenters;cat(3,ceil(mean(colums)),ceil(mean(rows)))];

allmask = spotmask | allmask;
[spotsrow,spotscol]=find(~allmask.*spotsImage);
fprintf('spot detected %d\n',size(LensletCenters,1));

end


%% comparison plot
% make spots 
spotsize=30;
circ = @(x,y,r) (x.^2.+y.^2.<r.^2)*1.0;
maskSensor = zeros(spotsize);  % make square box 
y = linspace(-floor(size(maskSensor,1)/2), floor(size(maskSensor,1)/2), size(maskSensor,1));
x = linspace(-floor(size(maskSensor,2)/2), floor(size(maskSensor,2)/2), size(maskSensor,2)); 
[X,Y] = meshgrid(x,y);
maskSensor = circ(X, Y, spotsize);

% create the sim center spots
y_CIsize=size(CalibrationImage,1);
x_CIssize=size(CalibrationImage,2);
MLcenters = zeros(y_CIsize,x_CIssize);

for i=1:size(LensletCenters,1)
    MLcenters(LensletCenters(i,:,2),LensletCenters(i,:,1))=1;
end
simMLAcenters  = conv2(MLcenters, maskSensor, 'same');
imshowpair(CalibrationImage, simMLAcenters,'Scaling','independent')

end