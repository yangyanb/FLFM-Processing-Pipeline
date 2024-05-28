% oLaF - a flexible 3D reconstruction framework for light field microscopy
% Copyright (c)2017-2020 Anca Stefanoiu

function image = makeOddSize(image)

[rowsNo, colsNo] = size(image);
if(~mod(rowsNo, 2))
    if(~mod(colsNo, 2))
        image = image(1:end-1,1:end-1);  % even row & even colum 
    else
        image = image(1:end-1,:);        % even row & odd colum
    end
else
    if(~mod(colsNo, 2))
        image = image(:,1:end-1);       % odd row & even colum
    end
end