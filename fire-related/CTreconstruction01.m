%% CTreconstruction01.m
%% obtain curvelet transform based reconstruction image 
%% use curvelet transform to denoise the image and highlight the fiber edges.
%% save the output reconstructed data to be processed by FIRE-related alogrithm
%% Yuming Liu, LOCI, UW-Madison, June 2012

clear;
close all;
home
LWon = 0;   % lenght weight(LW), LWon=1: consdier add LW; LWon=0: not consdier LW
hn = 2;     % 1: hist normalized by max frequency; 2: hist normalized by frequency area
hnplot = 0;  % 1: plot each normalized hist; 0: do not plot 
FS0 = 1;   % fraction of the sample 0
FS1 = 1;   % fraction of the sample 1
FS2 = 0.05;   % fraction of the sample 2



LLf = 30; %Length limit(threshold) for FIRE, only choose fiber with length >LLf
FNL = 200; %: Fiber number limit(threshold), maxium fiber number to be shown

% load true angles
dir1 = 'F:\UW-MadisonSinceFeb_01_2012\download\testimages\';
dir2 = 'F:\UW-MadisonSinceFeb_01_2012\download\testresults\';
dir3 = 'F:\UW-MadisonSinceFeb_01_2012\download\testcontrols\';

%
fileN(1).name = 'Substack (5)_L200N50A2.tif';   
fileN(2).name = 'N50L200AUniC.tif';
fileN(3).name = 'Substack (110)_Kgel5.tif';
fileN(4).name = '11250_SKOV_Substack (8).tif';
fileN(5).name = 'Substack (103)_tissue_SHG_J1.tif';       % size: 512 by 512
fileN(6).name = '12_30_08 Slide 1B-c7-01_C2.tiff';       % size: 512 by 512
fileN(7).name = 'TACS-3a.tif';       % size: 600 by 600
fileN(8).name = 'TACS-3b.tif';       % size: 600 by 600
fileN(9).name = 'R_62211_40x_2z_64mw_ser1_a1_angle000.tif';  % size: 512 by 512
fileN(10).name = 'JSim_test10.tif';         % size: 1024 by 1024
fileN(11).name = 'CP_Test_Image1.tif';      % size: 1024 by 1024
fileN(12).name = 'CP_Test_Image2.tif';      % size: 1024 by 1024
fileN(13).name = 'CP_Test_Image2Noise.tif'; % size: 1024 by 1024
fileN(14).name = 'CP_Test_Image4.tif';      % size: 1024 by 1024
fileN(15).name = 'CP_Test_Image5.tif';      % size: 1024 by 1024

iNF  = 3:9%1:15 % 1:length(fileN)

for iN = iNF

    
%    fname0 = [dir3,sprintf('test%d-control.mat',iN)];
%    fname1 = [dir2,sprintf('test%d-FIREang.mat',iN)];
%    fmat = [dir2,sprintf('test%d-FIREout.mat',iN)];
   fctr = [dir1, sprintf('test%d-CTR.mat',iN)];  % filename of the curvelet transformed reconstructed image
   figname = [dir1, fileN(iN).name];

%    load(fname0);
%    load(fname1,'angEALL','angIALL');
%    load(fmat,'data');
   IMG = imread(figname);
   fclose all;
 
    if length(size(IMG)) > 2
          IS =IMG(:,:,1);
    else
        IS = IMG;
    end
    pix = size(IS,1);

    % Set the percentage of coefficients used in the partial reconstruction 
    pctg = 0.2;
    
    % Forward curvelet transform
    disp('Take curvelet transform: fdct_wrapping');
    tic; C = fdct_wrapping(double(IS),0); toc;

    % Get threshold value
    cfs =[];
    for s=1:length(C)
      for w=1:length(C{s})
        cfs = [cfs; abs(C{s}{w}(:))];
      end
    end
    cfs = sort(cfs); cfs = cfs(end:-1:1);
    nb = round(pctg*length(cfs));
    cutoff = cfs(nb);

    % Set small coefficients to zero
    for s=1:length(C)
      for w=1:length(C{s})
        C{s}{w} = C{s}{w} .* (abs(C{s}{w})>cutoff);
      end
    end

    disp('Take inverse curvelet transform: ifdct_wrapping');
    
    
    % create an empty cell array of the same dimensions
    Ct = cell(size(C));
    for cc = 1:length(C)
        for dd = 1:length(C{cc})
            Ct{cc}{dd} = zeros(size(C{cc}{dd}));
        end
    end
    
   % select the scale at which the coefficients will be used
    s = length(C) - 3:length(C) - 2;
    
%     % find the maximum coefficient value, then discard the lowest (1-keep)*100%
% 
% % figure; image(abs(C{s}{1}))
%     absVal = cellfun(@abs,C{s},'UniformOutput',0);   
%     absMax = max(cellfun(@max,cellfun(@max,absVal,'UniformOutput',0)));
%     bins = 0:.01*absMax:absMax;
% 
%     histVals = cellfun(@(x) hist(x,bins),absVal,'UniformOutput',0);
%     sumHist = cellfun(@(x) sum(x,2),histVals,'UniformOutput',0);
% 
%     aa = 1:length(sumHist);
% 
%     totHist = horzcat(sumHist{aa});
%     sumVals = sum(totHist,2);
%     cumVals = cumsum(sumVals);
% 
%     cumMax = max(cumVals);
%     loc = find(cumVals > (1-keep)*cumMax,1,'first');
%     maxVal = bins(loc);
% 
%     Ct{s} = cellfun(@(x)(x .* abs(x >= maxVal)),C{s},'UniformOutput',0);


    for iS = s 
        Ct{iS} = C{iS};
    end
    tic; Y = ifdct_wrapping(Ct,0); toc;
    CTr = real(Y);
   figure(100+iN);clf
   subplot(1,2,1); colormap gray; imagesc(real(IS)); axis('image'); title('original image');
   subplot(1,2,2); colormap gray; imagesc(real(CTr)); axis('image'); title('partial reconstruction');
%    save(fctr,'CTr'); 
   
   
end  %iN