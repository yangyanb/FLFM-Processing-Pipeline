% oLaF - a flexible 3D reconstruction framework for light field microscopy
% Copyright (c)2017-2020 Anca Stefanoiu

function recon = FLFdeconvRL_P_earlyStop(forwardFUN, backwardFUN, img, iter, init, MLAMask,rcshift)
% Richardson-Lucy deconvolution algorithm
fprintf('RL Deconvolution:\n')
% Initialize volume
recon = init; 
Nmod=max(size(img));
m=1;
errorBack=cell(Nmod,1);
error=[];

% MLAMask=logical(MLAMask);
% img{m}=MLAMask.*img{m};
% minV=min(img{m}(img{m}>0));
% maxV=max(img{m});


for i = 1:iter
    tic
    % simulate forward projection of the current reconstructed volume 
    fpj = {forwardFUN(recon)};
    
    %     fpj_Shift{1}=imtranslate(gather(fpj{1}),rcshift,'FillValues',0);

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
%     fpj{m}=normalization_minmax(fpj{m},0,1);
%     fpj{m} =(fpj{m}-min(fpj{m}(:)))./(max(fpj{m}(:))-min(fpj{m}(:)));

%     fpj{m}(fpj{m}<100) =0;
    errorBack{m} = img{m}./fpj{m};     
    
    % make sure the computations are safe
    errorBack{m}(isnan(errorBack{m})) = 0;
    errorBack{m}(isinf(errorBack{m})) = 0;
%     errorBack{m}(errorBack{m} > 3) = 3;
    
    % backproject the error
    bpjError = backwardFUN(errorBack{m});
    % update the result
    reconold=recon;
    recon = recon.*bpjError;

    ttime = toc;
    fprintf(['\n',' iter ' num2str(i) ' | ' num2str(iter) ', took ' num2str(ttime) ' secs','\n']);
end

if i==iter
    fpj =  {forwardFUN(recon)};
    error=sum(abs(img{m}(:)-fpj{m}(:)));
    fprintf(['\n','final error = ',num2str(error),' for iter ',num2str(i),'---(Final results did not converge after maximum iteration','\n']);
end



