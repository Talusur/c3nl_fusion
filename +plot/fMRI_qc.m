function M=fMRI_qc(N,R,O)
%    ___________ _   ____ 
%   / ____|__  // | / / / 
%  / /     /_ </  |/ / /  
% / /___ ___/ / /|  / /___
% \____//____/_/ |_/_____/
% Richard E. Daws 
% Imperial College London
% Nov 2017
%
% Extract & plot motion characteristics inline with J. Power. 
% Requires SPM in path. 
% Will display figure if outDir is not defined, otherwise will just save to outDir location. 
% 
% COMPULSORY ARGUMENTS
%  N - Path to 4D nifti
%  R - path to realignment parameter txt file (nx6)
%
% OPTIONAL ARGUMENTS
%  O - path to Directory
%
% OUTPUT 
%  M - struct containing motion parameters. 
%

%% Load R & calculate motion metrics

    R=detrend(load(R));
    R(:,4:6)=R(:,4:6)*50; % Assuming that rotations are radians. 

    % RMS motion & RMS d/dt motion
    dtRP = [R [zeros(1,size(R(:,1:6),2)); diff(R(:,1:6))]];
    RMS = mean(sqrt(mean(dtRP.^2)));

    % FD   
    FD=sum(abs([zeros(1,size(R,2)); diff(R)]),2);    

    % Absolute Displacement
    ad.Trns = sum(abs(R(:,1:3)),2);
    ad.Rots = sum(abs(R(:,4:6)),2);

%% QC Voxel intensity
    
    %4D data
    N=nifti(N);
    disp('Reshaping 4D into voxeltube...')
    X = zscore(reshape(N.dat(:) ,prod(N.dat.dim(1:3)),N.dat.dim(4)),[],2); % Reshape into a voxel*time matrix
    
    %DVARS GLOBAL - temporal Derivatives RMS variance over voxels something is wrong with this calc 
    disp('Calculating DVARS...')
    DVARS=sqrt(mean( [zeros(size(X,1),1) diff(X,[],2)].^2));  
    
    %GLobal Mask
    disp('Masking...')
    mask=std(X,[],2)>0;        
    
    %St.D
    disp('Calculating SD...')
    SD = std(X(mask,:));    
    
%% Plot
    disp('plotting...')
    fsize=20;
    lwth=1.5;
    
    if ~exist('outDir','var');fg=figure('visible','on','pos',[10 10 800 800]);else;fg=figure('visible','off','pos',[10 10 800 800]);end
    
    sb.a = subplot(5,1,1); % Realignment Parameters
    h=plot(R,'LineWidth',lwth); h(1).Color = [190 180 252]/255; h(1).LineStyle = '-';
                                    h(2).Color = [190 180 252]/255; h(2).LineStyle = ':';
                                    h(3).Color = [202 188 133]/255; h(3).LineStyle = '-';
                                    h(4).Color = [202 188 133]/255; h(4).LineStyle = ':';
                                    h(5).Color = [215 133 132]/255; h(5).LineStyle = '-';                                       
                                    h(6).Color = [215 133 132]/255; h(6).LineStyle = ':';
                                    legend({'X','pitch','Y','yaw','Z','roll'},'orientation','horizontal','box','off','Location','Best');
                                    ylabel('mm','FontSize',fsize);
                                                                              
    sb.b = subplot(5,1,2); % FD & absolute displacement
    h=plot([FD ad.Trns ad.Rots],'LineWidth',lwth); h(1).Color = [203 24 27]/255; h(1).LineStyle = '-';
                                                    h(2).Color = [148 18 19]/255; h(2).LineStyle = '--';
                                                    h(3).Color = [148 18 19]/255; h(3).LineStyle = ':';
                                                    legend({'FD','Abs. Trn','Abs. Rts'},'orientation','horizontal','box','off','Location','Best');
                                                    ylabel('mm','FontSize',fsize);
 
    sb.c = subplot(5,1,3); % DVARS
    h=plot(DVARS,'LineWidth',lwth); h(1).Color = [38 0 247]/255; h(1).LineStyle = '-';
                                    ylabel('DVARS','FontSize',fsize);
                               
    sb.d = subplot(5,1,4); % SD of the Global Signal
    hp=plot(SD,'LineWidth',lwth); h(1).Color = [64 121 26]/255; h(1).LineStyle = '-';
                                  ylabel('SD:GS','FontSize',fsize);  
                                  
    sb.e = subplot(5,1,5); % Voxeltube
    h=imagesc(X(mask,:)); colormap('gray'); sb.e.CLim = [-3 3]; ylabel('Voxel','FontSize',fsize); xlabel('Volume','Fontsize',fsize);                                                                   
    axis([sb.a sb.b sb.c sb.d sb.e],'tight')
    suptitle(sprintf('Mean FD: %f mm RMS Movement: %f mm',mean(FD),RMS));
    
%%  Save & define output   
    M=struct('FD',FD,'DVARS',DVARS,'SD',SD,'abs',ad);  
    if exist('outDir','var') 
        if ~exist(O, 'dir')
            mkdir(O); 
        end 
        print(fg, '-djpeg', [O filesep 'QC.png']);
        save([O filesep 'motion'],'motion')
    end  
    
end  