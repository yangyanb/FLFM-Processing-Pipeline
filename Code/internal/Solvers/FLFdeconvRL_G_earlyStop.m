% oLaF - a flexible 3D reconstruction framework for light field microscopy
% Copyright (c)2017-2020 Anca Stefanoiu

function recon = FLFdeconvRL_G_earlyStop(forwardFUN, backwardFUN, img, iter, init)
% Richardson-Lucy deconvolution algorithm
fprintf('\nDeconvolution:\n')

% Initialize volume
recon = init; 
Nmod=max(size(img));
m=1;
errorBack=cell(Nmod,1);
error=[];

for i = 1:iter
    tic
    % simulate forward projection of the current reconstructed volume 
    fpj = {forwardFUN(recon)};
    if length(error) > 2
        if (error(end) - error(end-1))>=0
            recon=reconold;
            break; 
        end
    end
    if i~=1
        error=[error,sum(abs(img{m}(:)-fpj{m}(:)))];
        fprintf(['\n','error = ',num2str(error(end)),' for iter ',num2str(i-1),'\n']);
    end

    % compute error towards the real image
    fpj{m}=floor(fpj{m});
%     fpj{m}(fpj{m}<0.1)=0;
    
    bpjError=init./backwardFUN(fpj{m});
    % make sure the computations are safe

    bpjError(isnan(bpjError)) = 0;
    bpjError(isinf(bpjError)) = 0;
    bpjError(bpjError < 0) = 0;
    

    % update the result
    reconold=recon;
    recon = recon.*bpjError;
    
    ttime = toc;
    fprintf(['\niter ' num2str(i) ' | ' num2str(iter) ', took ' num2str(ttime) ' secs']);
end

if i==iter
    fpj =  {forwardFUN(recon)};
end
error=sum(abs(img{1}(:)-fpj{1}(:)));
fprintf(['\n','final error = ',num2str(error),' for iter ',num2str(i),'\n']);


