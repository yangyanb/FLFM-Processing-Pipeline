function Results=FLFM_performance(Camera)
%%
% Light source
lamda=Camera.WaveLength; % wave length in um

% Camera:
p=Camera.pixelPitch;  % um
% Np=min(Camera.Np_X,Camera.Np_Y);
% Dcam=Np*p;    % um

% Objective:
NA=Camera.NA;
M=Camera.M;                       % change M by changing f1
field_num=Camera.Field_Num;               % um

f1=Camera.f1;                 % um
fobj=f1/M;
FOV_obj=field_num/M;        % um
Ap_Dia=2*NA*fobj;         % um

% FLFM arm:
f2=Camera.f2;  % um
Ap_DiaS=Ap_Dia*f2/f1;
% mla
d_mla=Camera.lensPitch;                  % um
f_mla=Camera.fm;                   % um
Nmla=Camera.gridDim;

Sr_actual=lamda/((d_mla/f_mla)*p);
Nr=floor(2*NA*f2/(M*d_mla));

fprintf('d_mla= %.1fum, f_mla= %.1fum \n',d_mla,f_mla)
fprintf('sampling rate: %.2f , Number of mla: %d \n',Sr_actual,Nr);
fprintf('Ap_DiaRelay= %.1f um,  Ap_Diaobj= %.1f um\n',Ap_DiaS,Ap_Dia);

Camera.sysM = Camera.fm*Camera.f1/(Camera.f2*fobj); %total system magnification

%%  Performance parameters: 
DOF=(f2/(M*d_mla))^2*8*lamda*(1+1/(2*Sr_actual));  %in um

FOV_mla=(d_mla/f_mla)*f2/M;     % um
FOV_fs=(p*Camera.MLANump_d)/Camera.sysM;
FOV= min(FOV_fs,min(FOV_obj,FOV_mla));  % um

if Sr_actual >= 2
    Rxy=lamda*f2/M/d_mla;           %in um
    Rz=2*lamda*f2^2/(2*NA*f2*M*d_mla-(M*d_mla)^2);               %in um
else
    Rxy=(2/Sr_actual)*lamda*f2/M/d_mla;
    Rz=(2/Sr_actual)*2*lamda*f2^2/(2*NA*f2*M*d_mla-(M*d_mla)^2);
end
Results.FOV=FOV;
Results.DOF=DOF;
Results.Rxy=Rxy;
Results.Rz=Rz;
Results.Nmla=Nr;

%% other results
Results.Sr_actual=Sr_actual;
%lateral pixel shift map to lateral direction in Object space:
Results.Rxy_pixel= p*(f2*fobj)/(f_mla*f1);

%lateral pixel shift map to axial direction in Object space:
kd_mla=NA*f2/M-d_mla/2;          % max distance to optical axis mm
Results.Rz_pixel= p*(f2^2*fobj^2)/(kd_mla*f_mla*f1^2);

Results.FOV_mla=FOV_mla;                 %in um
Results.FOV_obj=FOV_obj;

%%
fprintf('DOF:%.1f um, FOV: %.1f um\n',DOF,FOV);
fprintf('Rxy:%.1f um, Rz:%.1f um \n',Rxy,Rz);
fprintf('Obj: NA_%.2f, Mag_%.1f ----------------------\n',NA,M);
fprintf('\n');

end
