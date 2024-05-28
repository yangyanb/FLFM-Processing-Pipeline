function midfft=adjustconv(projection,H_gpu,pd,d,adj)

if ~isgpuarray(projection)|| issparse(projection)
    projection = full(gpuArray(projection));       
end
H_gpu = gpuArray(full(H_gpu));

tmp = real(conv_fft2(projection,H_gpu, 'full'));

area=floor((d/8)^2*pi);
[~,Indx]=sort(tmp(:),'descend');

[rows,cols]=ind2sub(size(tmp),Indx(1:area));
midfft=ceil(mean([rows,cols]))+adj;

BackProjection= tmp(midfft(1)-floor(pd/2):midfft(1)+floor(pd/2),...
                                    midfft(2)-floor(pd/2):midfft(2)+floor(pd/2));

figure;imagesc(BackProjection);
figure;imagesc(tmp);
hold on;plot(midfft(2),midfft(1),'g*','Markersize',10)

end