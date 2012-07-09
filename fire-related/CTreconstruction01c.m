% CTreconstruction01c.m
% obtain curvelet transform based reconstruction image 
% use curvelet transform to denoise the image and highlight the fiber edges.
% the threshold is set to keep the top % curvelet coefficients,
% save the output reconstructed data to be processed by FIRE-related alogrithm
% 06182012: add different scale comparison
% 07022012: get scale combination 
% Yuming Liu, LOCI, UW-Madison, June 2012

clear;
close all;
home
path(path,'Z:\liu372\download\CurveLab-2.1.2\fdct_wrapping_matlab\'); % add serach path of the curvelet transform  



iNF  = 19 % file name number to be analyzed

% file directories possibly be used
dir1 = 'D:\UW-MadisonSinceFeb_01_2012\download\testimages\';
dir2 = 'D:\UW-MadisonSinceFeb_01_2012\download\testresults\';
dir3 = 'D:\UW-MadisonSinceFeb_01_2012\download\testcontrols\';

dir4 = 'Z:\liu372\fiberextraction\testoverlay\070212\';
dir5 = 'Z:\liu372\fiberextraction\testimages\070512\';
dir6 =  'Z:\liu372\fiberextraction\testresults\070512\';
dir7 = 'Z:\liu372\fiberextraction\testcontrols\070512\';

dir9 =  'Z:\liu372\fiberextraction\testtemp\';

fileN(1).name = 'Substack (5)_L200N50A2.tif';   % simulated case
fileN(2).name = 'N50L200AUniC.tif';              % simulated case
fileN(3).name = 'Substack (110)_Kgel5.tif';
fileN(4).name = '11250_SKOV_Substack (8).tif';           % 
fileN(5).name = 'Substack (103)_tissue_SHG_J1.tif';       % size: 512 by 512, from Jeremy
fileN(6).name = '12_30_08 Slide 1B-c7-01_C2.tiff';       % size: 512 by 512,BC,from Conklin
fileN(7).name = 'TACS-3a.tif';       % size: 600 by 600 ,BC, from Carolyn 
fileN(8).name = 'TACS-3b.tif';       % size: 600 by 600, BC, from Carolyn
fileN(9).name = 'R_62211_40x_2z_64mw_ser1_a1_angle000.tif';  % size: 512 by 512
fileN(10).name = 'JSim_test10.tif';         % size: 1024 by 1024,simulated case
fileN(11).name = 'CP_Test_Image1.tif';      % size: 1024 by 1024,simulated case
fileN(12).name = 'CP_Test_Image2.tif';      % size: 1024 by 1024,simulated case
fileN(13).name = 'CP_Test_Image2Noise.tif'; % size: 1024 by 1024,simulated case
fileN(14).name = 'CP_Test_Image4.tif';      % size: 1024 by 1024,simulated case
fileN(15).name = 'CP_Test_Image5.tif';      % size: 1024 by 1024,simulated case
fileN(16).name = '04_10_12 Trentham DCIS 543509 -02.tif'; % size:1024 by 1024,BC,from Conklin
fileN(17).name = '04_11_12 Trentham DCIS 543509 -01.tif'; % size: 1024 by 1024,BC,from Conklin
fileN(18).name = '04_11_12 Trentham DCIS 543654 -01.tif'; % size: 1024 by 1024,BC, from Conklin
fileN(19).name = 'strained-center-1_C1_TP0_SP0_FW0.tiff'; % size: 512 by 512 from KristinRiching


% add scale or scale combination to be investigated
if iNF == 19
    scalesc(1).name = 'sc45';
    scalesc(2).name = 'sc34';
    scalesc(3).name = 'sc345';
    scalesc(4).name = 'sc234';
    scalesc(5).name = 'sc2345';
    scalesc(6).name = 'sc12345';
    scalesc(7).name = 'sc123456';
else
    scalesc(1).name = 'sc56';
    scalesc(2).name = 'sc45';
    scalesc(3).name = 'sc456';
    scalesc(4).name = 'sc345';
    scalesc(5).name = 'sc3456';
    scalesc(6).name = 'sc23456';
    scalesc(7).name = 'sc123456';
    scalesc(8).name = 'sc1234567';
  
end

ssc = 1:length(scalesc); % selected scale combination number


for iN = iNF

    
%    fname0 = [dir3,sprintf('test%d-control.mat',iN)];
%    fname1 = [dir2,sprintf('test%d-FIREang.mat',iN)];
%    fmat = [dir2,sprintf('test%d-FIREout.mat',iN)];
%    fctr = [dir1, sprintf('test%d-CTR.mat',iN)];  % filename of the curvelet transformed reconstructed image
   

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
%     cfs = sort(cfs); cfs = cfs(end:-1:1);
    cfs = sort(cfs,'descend');
    nb = round(pctg*length(cfs));
    cutoff = cfs(nb);

    % Set small coefficients to zero
    for s=1:length(C)
      for w=1:length(C{s})
        C{s}{w} = C{s}{w} .* (abs(C{s}{w})>cutoff);
      end
    end

    disp('Take inverse curvelet transform: ifdct_wrapping');
    
    for iNs =ssc 
        
       scN = scalesc(iNs).name;
        
    % create an empty cell array of the same dimensions
    Ct = cell(size(C));
    for cc = 1:length(C)
        for dd = 1:length(C{cc})
            Ct{cc}{dd} = zeros(size(C{cc}{dd}));
        end
    end
      
   % select the scale at which the coefficients will be used
%     s = length(C) - 3:length(C)-2;

    sstart = str2double(scN(3));
    send =   str2double(scN(end));
    s = sstart:send;
    

    for iS = s 
        Ct{iS} = C{iS};
    end
    tic; Y = ifdct_wrapping(Ct,0); toc;
    CTr = real(Y);
   figure(100+20*iN+iNs);clf
   set(gcf,'position',[50+20*iNs 50+20*iNs 512 256]);
   subplot(1,2,1); colormap gray; imagesc(real(IS)); axis('image'); title('original image');
   subplot(1,2,2); colormap gray; imagesc(real(CTr)); axis('image');
   title(sprintf('partial reconstruction,%s',scN));
   
   fctr = [dir5, sprintf('test%d-CTR%s.mat',iN,scN)];  % filename of the curvelet transformed reconstructed image
   save(fctr,'CTr'); 
   
   home; disp(sprintf('scale combination  %s , of image %d', scN,iN));
%    disp('Press any key to continue ...');pause 
   end
   

end  %iN