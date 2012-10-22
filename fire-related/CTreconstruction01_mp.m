% CTreconstruction01_mp.m
% basic verson, can choose any arbitory scale, or continuous scales 
% obtain curvelet transform based reconstruction image 
% use curvelet transform to denoise the image and highlight the fiber edges.
% the threshold is set to keep the top % curvelet coefficients,
% save the output reconstructed data to be processed by FIRE-related alogrithm
% 081612: print (save) the reconstructed images
% 10082012: use multiple parameters to generate different reconstructed images, 
% Yuming Liu, LOCI, UW-Madison, June 2012

clear;
close all;
home
path(path,'Z:\liu372\download\CurveLab-2.1.2\fdct_wrapping_matlab\'); % add serach path of the curvelet transform  

% file directories possibly be used
dir1 = 'D:\UW-MadisonSinceFeb_01_2012\download\testimages\';
dir2 = 'D:\UW-MadisonSinceFeb_01_2012\download\testresults\';
dir3 = 'D:\UW-MadisonSinceFeb_01_2012\download\testcontrols\';

dateP = '\100812\';
dir4 = ['Z:\liu372\fiberextraction\testoverlay',dateP];
dir5 = ['Z:\liu372\fiberextraction\testimages',dateP];
dir6 = ['Z:\liu372\fiberextraction\testresults',dateP];
dir7 = ['Z:\liu372\fiberextraction\testcontrols',dateP];

% mkdir(dir4);
% mkdir(dir5);
% mkdir(dir6);
% mkdir(dir7);

fileN(1).name = 'Substack (5)_L200N50A2.tif';   % simulated case
fileN(2).name = 'N50L200AUniC.tif';              % simulated case
fileN(3).name = 'Substack (110)_Kgel5.tif';
fileN(4).name = '11250_SKOV_Substack (8).tif';           % 
fileN(5).name = 'Substack (103)_tissue_SHG_J1.tif';       % size: 512 by 512, from Jeremy
fileN(6).name = '12_30_08 Slide 1B-c7-01_C2.tiff';       % size: 1024 by 1024,BC,from Conklin
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
fileN(20).name = '04_25_12 Trentham DCIS 542805 -02 FW.tif';%  size: 1024 by 1024,BC, from Conklin
fileN(21).name = '04_25_12 Trentham DCIS 542805 -02.tif';
fileN(22).name = '04_25_12 Trentham DCIS 542805 -03.tif';
fileN(23).name = '03_07_08 Slide 2B-f7-02_C2_wl.tif';
fileN(24).name = '03_07_08 Slide 2B-g3-02_C2_wl.tif';
fileN(25).name = 'nf300_len7.803166e+001_ps1.00e-007_noise.tif';
fileN(26).name = 'nf300_len7.803166e+001_ps1.00e-007.tif';
fileN(27).name = 'nf100_len1.287532e+001_ps1.00e-007_noise.tif';
fileN(28).name = 'nf100_len1.520168e+001_ps1.00e-007_noise.tif';
fileN(29).name = 'nf100_len1.835288e+001_ps1.00e-007_noise.tif';
fileN(30).name = 'nf100_len3.250304e+001_ps1.00e-007_noise.tif';
fileN(31).name = 'nf100_len5.119927e+001_ps1.00e-007_noise.tif';
fileN(32).name = 'nf100_1_noise.tif';
fileN(33).name = 'nf100_2_noise.tif';
fileN(34).name = 'nf100_3_noise.tif';
fileN(35).name = 'nf100_4_noise.tif';
fileN(36).name = 'nf100_5_noise.tif';
fileN(37).name = 'nf100_6_noise.tif';
fileN(38).name = 'nf100_7_noise.tif';
fileN(39).name = 'nf100_8_noise.tif';
fileN(40).name = 'nf100_9_noise.tif';

fileN(41).name = 'case1_nf100_ps1.00e-007_noise.tif';
fileN(42).name = 'case2_nf100_ps1.00e-007_noise.tif';
fileN(43).name = 'case3_nf100_ps1.00e-007_noise.tif'; 
fileN(44).name = 'case4_nf100_ps1.00e-007_noise.tif';
fileN(45).name = 'case5_nf100_ps1.00e-007_noise.tif';
fileN(46).name = 'case6_nf100_ps1.00e-007_noise.tif';
fileN(47).name = 'case7_nf100_ps1.00e-007_noise.tif';
fileN(48).name = 'case8_nf100_ps1.00e-007_noise.tif';
fileN(49).name = 'case9_nf100_ps1.00e-007_noise.tif';
fileN(50).name = 'case10_nf100_ps1.00e-007_noise.tif';

fileN(51).name = 'case30_nf100_ps1.00e-007_noise.tif';
fileN(52).name = 'case31_nf100_ps1.00e-007_noise.tif';
fileN(53).name = 'case32_nf100_ps1.00e-007_noise.tif'; 
fileN(54).name = 'case33_nf100_ps1.00e-007_noise.tif';
fileN(55).name = 'case34_nf100_ps1.00e-007_noise.tif';


% file name number to be analyzed
jj = 0;
iNF  = 8%[7 21:24]%
PO.CT = [1 5 10 20 30];

for iN = iNF
    jj = jj +1; 

   figname = [dir5(1:end-7), fileN(iN).name];

   IMG = imread(figname);
   fclose all;
 
    if length(size(IMG)) > 2
          IS =IMG(:,:,1);
    else
        IS = IMG;
    end
    pix = size(IS,1);

    % Set the percentage of coefficients used in the partial reconstruction 
    
    for iP = 1:5
        
       disp(sprintf('reconstructing test#%d, para#%d',iN, iP)); 
       fctr = [dir5, '\ct_mult_params\',sprintf('test%d_CTR_%d.mat',iN,PO.CT(iP))];  % filename of the curvelet transformed reconstructed image dataset
       CTimg = [dir5, '\ct_mult_params\',sprintf('test%d_CTimg_%d.tif',iN,PO.CT(iP))];  % filename of the curvelet transformed reconstructed image
 
%     pctg = 0.2;  % 0803: 0.2 ; 
    pctg = PO.CT(iP)*0.01;
    
    % Forward curvelet transform
%     disp('Take curvelet transform: fdct_wrapping');
%     tic; C = fdct_wrapping(double(IS),0); toc;
    C = fdct_wrapping(double(IS),0);
    % Get the threshold value
    cfs =[];
    for s=1:length(C)
      for w=1:length(C{s})
        cfs = [cfs; abs(C{s}{w}(:))];
      end
    end
%     cfs = sort(cfs); cfs = cfs(end:-1:1);
    cfs = sort(cfs,'descend');
    
%082012: show different cutoff values of the coefficients
%     figure(iN);clf
%     set(gcf,'position', [200+20*jj 150+20*jj 600 400]);
%     cutoffshow = [0.05 0.10 0.20 0.30 0.40]; %show the cutoff value
%     cutvalue = round(cutoffshow*length(cfs));
%     cfsmax = cfs(500)*[0.85:-0.125:0.35];
%     plot(cfs,'b-','linewidth',1.2); hold on;
%     axis ([0 length(cfs) 0 cfsmax(1)*1/0.85]);
%     xlabel('Number of sorted coefficients', 'fontsize',12);
%     ylabel('Curvelet coefficients','fontsize', 12);

%     for ic = 1:length(cutoffshow)
%         plot([cutvalue(ic) cutvalue(ic)],[0 cfsmax(ic)], 'r--','linewidth',0.5);
%         text(cutvalue(ic),cfsmax(ic),sprintf('%d%% cutoff', cutoffshow(ic)*100))
%         hold on
%     end %ic

%% reconstruct img used the threshold percentage pctg   
    nb = round(pctg*length(cfs));
    cutoff = cfs(nb);

    % Set small coefficients to zero
    for s=1:length(C)
      for w=1:length(C{s})
        C{s}{w} = C{s}{w} .* (abs(C{s}{w})>cutoff);
      end
    end

%     disp('Take inverse curvelet transform: ifdct_wrapping');
        
    % create an empty cell array of the same dimensions
    Ct = cell(size(C));
    for cc = 1:length(C)
        for dd = 1:length(C{cc})
            Ct{cc}{dd} = zeros(size(C{cc}{dd}));
        end
    end
    
   % select the scale(s) at which the coefficients will be used
     s = length(C) - 3:length(C)-1 ;
%    s = 1:length(C);
    
    for iS = s 
        Ct{iS} = C{iS};
    end
%     tic; Y = ifdct_wrapping(Ct,0); toc;
   Y = ifdct_wrapping(Ct,0);
   CTr = real(Y);
   figure(100+iN+10*iP);clf
   set(gcf,'position',[100 50 1024 512]);
   ax(1) = subplot(1,2,1); colormap gray; imagesc(IS); axis('image'); title(sprintf('Original image %d',iN));
   ax(2) = subplot(1,2,2); colormap gray; imagesc(CTr); axis('image'); title(sprintf('CT partial reconstruction,s%d - s%d',s(1),s(end)));
   pause(2);
   linkaxes([ax(2) ax(1)],'xy');
   save(fctr,'CTr'); 
   
   set(gcf,'PaperUnits','inches','PaperPosition',[0 0 2*pix/128 pix/128]);
   print('-dtiff', '-r128', CTimg);  % CT reconstructed image
   
%    break
%    pause(5)
%    % Zoom in images in a number of random positions 
%        iaN = 20; 
%        rng(1001); % same random number seed
%        isr = rand(iaN,2);
%        
%       for ia = 1:iaN 
%     %    is = [round(pix/(ia+0.2)),round(pix/(ia+0.2))];
%          is = isr(ia,1:2)*pix;
%          isx = is(1);
%          isy = is(2);
%          iw = round(pix/4);
%          ih = iw;
%          if isx+iw > pix
%              isx = pix - iw;
%          end
% 
%          if isy+ih > pix
%              isy = pix - ih;
%           end
% 
%          axislim3 = [isx isx+iw isy isy+iw];
% %          axislim3 = [1 pix 1 pix];
%         figure(100+iN);
%         subplot(1,2,1); axis(axislim3);
%         subplot(1,2,2); axis(axislim3); 
% %         subplot(2,2,3); axis(axislim3); 
%         home
%         disp(sprintf('zoom in the image, %d of %d', ia, iaN));
%         disp('Press any key to continue ...')
%         pause
%       end   % ia

    end % iP

end  %iN