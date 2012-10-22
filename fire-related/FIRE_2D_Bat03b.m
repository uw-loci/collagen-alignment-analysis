%% FIRE_2D_Bat03b.m
%% batch processing both 2D original images and  2D Curvelets transform based reconstructed images by FIRE 
%% run after CTreconstruction01.m
% June 27 2012, add the overlay of the extracted fibers on the original
% image by controlling the transparency
% June 28 2012: use imshow to complete overylay of image and line plot.
% June 28 2012: add curveAlign result, FIRE, CT + FIRE in a same figure
% July 31,2012: run on cases 21-24
% Aug 16,2012: ((Based on FIRE_2D_Bat03a.m) (1) load parameters directly from a
% common parameter setting function except of the intensity threshold;
% (2)process four kinds of images by FIRE, respectively: i)original image ii)CT-based reconstruction image;
% iii) gaussian filtered images; iv)SpirialTV based filtered image 
% Aug 21, 2012: add the function of processing tube filtered images
% Aug 24, 2012: add the function of processing spirial tv filtered images
% Aug 28,2012: use the Aug24 FIRE result, but set different length
% limitation for showing the fibers
%% Yuming Liu, LOCI, UW-Madison, since Feb 2012

clear; 
close all;
home

cd D:\UW-MadisonSinceFeb_01_2012\download\FIRE\example;
pd1 = pwd;
addpath(genpath('../')); 


%%FIRE
     tic
    dir1 = 'D:\UW-MadisonSinceFeb_01_2012\download\testimages\';
    dir2 = 'D:\UW-MadisonSinceFeb_01_2012\download\testresults\';

    dateP = '\100812\';
    dir4 = ['Z:\liu372\fiberextraction\testoverlay',dateP];
    dir5 = ['Z:\liu372\fiberextraction\testimages',dateP];
    dir6 = ['Z:\liu372\fiberextraction\testresults',dateP];
    dir7 = ['Z:\liu372\fiberextraction\testcontrols',dateP];
 
% test cases

    fileN(1).name = 'Substack (5)_L200N50A2.tif';   
    fileN(2).name = 'N50L200AUniC.tif';
    fileN(3).name = 'Substack (110)_Kgel5.tif';
    fileN(4).name = '11250_SKOV_Substack (8).tif';

    fileN(5).name = 'Substack (103)_tissue_SHG_J1.tif';       % size: 512 by 512
    fileN(6).name = '12_30_08 Slide 1B-c7-01_C2.tiff';       % size: 512 by 512
    fileN(7).name = 'TACS-3a.tif';       % size: 600 by 600
    fileN(8).name = 'TACS-3b.tif';       % size: 600 by 600
    fileN(9).name = 'R_62211_40x_2z_64mw_ser1_a1_angle000.tif';  % size: 512 by 512
    fileN(10).name = 'JSim_test10.tif';
    fileN(11).name = 'CP_Test_Image1.tif';  % size: 1024 by 1024
    fileN(12).name = 'CP_Test_Image2.tif';  % size: 1024 by 1024
    fileN(13).name = 'CP_Test_Image2Noise.tif';  % size: 1024 by 1024
    fileN(14).name = 'CP_Test_Image4.tif';  % size: 1024 by 1024
    fileN(15).name = 'CP_Test_Image5.tif';  % size: 1024 by 1024

    fileN(16).name = '04_10_12 Trentham DCIS 543509 -02.tif'; % size: 1024 by 1024
    fileN(17).name = '04_11_12 Trentham DCIS 543509 -01.tif'; % size: 1024 by 1024
    fileN(18).name = '04_11_12 Trentham DCIS 543654 -01.tif'; % size: 1024 by 1024
    fileN(19).name = 'strained-center-1_C1_TP0_SP0_FW0.tiff'; % size: 512 by 512 from KristinRiching
    fileN(20).name = '04_25_12 Trentham DCIS 542805 -02 FW.tif';%  size: 1024 by 1024,BC, from Conklin
    fileN(21).name = '04_25_12 Trentham DCIS 542805 -02.tif';
    fileN(22).name = '04_25_12 Trentham DCIS 542805 -03.tif';
    fileN(23).name = '03_07_08 Slide 2B-f7-02_C2_wl.tif';
    fileN(24).name = '03_07_08 Slide 2B-g3-02_C2_wl.tif';

    fileN(25).name = '04_25_12 Trentham DCIS 542805 -01 FW.tif';
    fileN(26).name = '04_25_12 Trentham DCIS 542805 -04 FW.tif';
    fileN(27).name = '04_25_12 Trentham DCIS 542805 -05 FW.tif';
    fileN(28).name = '04_25_12 Trentham DCIS 542821 -01 FW.tif';
    fileN(29).name = '04_25_12 Trentham DCIS 542825 -01 FW.tif';   
    fileN(30).name = '04_25_12 Trentham DCIS 542825 -02 FW.tif';   
    fileN(31).name = '04_25_12 Trentham DCIS 542825 -05 FW.tif';   
    fileN(32).name = '04_25_12 Trentham DCIS 542825 -06 FW.tif';  
    
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
    % 081012
    fileN(51).name = 'case30_nf100_ps1.00e-007_noise.tif';
    fileN(52).name = 'case31_nf100_ps1.00e-007_noise.tif';
    fileN(53).name = 'case32_nf100_ps1.00e-007_noise.tif'; 
    fileN(54).name = 'case33_nf100_ps1.00e-007_noise.tif';
    fileN(55).name = 'case34_nf100_ps1.00e-007_noise.tif';


iNF  = [29:32];%[7 21:24];  %number of the images to be processed
LW1 = 0.5;         % line width of the extracted fibers 
fst = 4.5;           % font size of fiber text label
% fst2 = 4; % font size of fiber text label
% fst3 = 5; % font size of fiber text label
% fst4 = 6; % font size of fiber text label

LL1 = 30;  %082812: length limit(threshold), only show fibers with length >LL
FNL = 2999; %: fiber number limit(threshold), maxium fiber number to be shown 
clrr0 = 'rgbmcyg'; 
texton = 0;  % texton = 1, label the fibers; texton = 0: no label
% set the method to run, 1: run; 0:not run
    
runCT = 1; runCA =0; runGF = 0; runSTV = 0; runTUB = 0; % 

for iN = iNF   
 
   
    fname =[dir5(1:end-7), fileN(iN).name];
    fmat1 = [dir6,sprintf('test%d-FIREout.mat',iN)];
    fmat2 = [dir6,sprintf('test%d-FIREoutCTr.mat',iN)];
    fmat3 = [dir6,sprintf('test%d-CAout.mat',iN)];
    fmat4 = [dir6,sprintf('test%d-FIREoutGF.mat',iN)];
    fmat5 = [dir6,sprintf('test%d-FIREoutSTV.mat',iN)];
    fmat6 = [dir6,sprintf('test%d-FIREoutTUB.mat',iN)];
    
    ffigO = [dir6,sprintf('test%d-FIREfigO.tif',iN)]; % original figure
    ffigE = [dir6,sprintf('test%d-FIREfigE.tif',iN)]; % extracted figure
    fctr = [dir5, sprintf('test%d-CTR.mat',iN)];  % filename of the curvelet transformed reconstructed image
    fgf = [dir5, sprintf('test%d_GFf.mat',iN)];  % filename of the Gaussian filtered image
    fstv = [dir5, fileN(iN).name,'_8.mat.TIF'];  % filename of the spirial TV filtered image
    ftub = [dir5,fileN(iN).name,'_tube.tif'];  % filename of the tube filtered image

        
    fOL1 = [dir4, sprintf('test%d_OL_FIRE.tif',iN)]; %filename of overlay 1
    fOL2 = [dir4, sprintf('test%d_OL_CTpFIRE.tif',iN)]; %filename of overlay 2
    fOL3 = [dir4, sprintf('test%d_OL_CA.tif',iN)]; %filename of overlay 3
    fOL4 = [dir4, sprintf('test%d_OL_GFFIRE.tif',iN)]; %filename of overlay 4
    fOL5 = [dir4, sprintf('test%d_OL_STVFIRE.tif',iN)]; %filename of overlay 5
    fOL6 = [dir4, sprintf('test%d_OL_TUBFIRE.tif',iN)]; %filename of overlay 6
    
 %set FIRE parameters for different image types
     p1.path = pd1;

     p1 = param_com0816(p1);   % for the original image
     p2 = param_com0816(p1);   % for the CT based reconstruction image 
     p4 = param_com0816(p1);   % for the Gaussian filtered image
     p5 = param_com0816(p1);   % for the Spirial TV filtered image
     p6 = param_com0816(p1);   % for the tube filtered image
     
 % set threshold to binarize the image 
     p2.thresh_im2 = 0; 
     p6.thresh_im2 = 0;

 if iN == 7 | iN == 8
     th2 = 30; 
     p1.thresh_im2 = th2;
     p4.thresh_im2 = th2;
     p5.thresh_im2 = th2;
    
     
 elseif iN == 21 | iN == 22
     th2 = 10;
     p1.thresh_im2 = th2;
     p4.thresh_im2 = th2;
     p5.thresh_im2 = th2;
     
     
 elseif  iN == 23 | iN == 24
     th2 = 30;
     p1.thresh_im2 = th2;
     p4.thresh_im2 = th2;
     p5.thresh_im2 = th2;
 else
     th2 = 10;
     p1.thresh_im2 = th2;
     p4.thresh_im2 = th2;
     p5.thresh_im2 = th2;
     
 end
      
  
 % FIRE on original image    
    p = p1;
    % IS is the image of a slice
  
    info = imfinfo(fname);
    num_images = numel(info);
    pix = info(1).Width;  % find the image size
     % initialization 
    ImgL = [200,1000];  % imagesc scale
    OUT = []; 
    kk = 0;
    IS1 =[];
    IS = [];
    im3 = [];
    
   ii = 1; % choose the first slice for image stack

   if iN == 0
        IS = imread(fname,ii,'PixelRegion', {[1 pix] [1 pix]});   
   else
      IS0 = imread(fname);  
      if length(size(IS0)) > 2
          IS1 =IS0(:,:,1);
      else
        IS1 = IS0;
      end
   end
   
    disp(sprintf('reading slice %d of %d ',ii,num_images))
    im3(1,:,:) = IS1;
    IS = IS1; 
    IS1 = flipud(IS1);  % associated with the following 'axis xy'
    
    % mask_ori to reduce the artifacts in the reconstructed image
    mask_ori = IS > 0.8*p1.thresh_im2; 

%073112: comment out the automatic threshold
%     ISresh = sort(reshape(IS,1,pix*pix));        
%     Ith(ii,1:15) = ISresh(ceil(pix*pix*[0.85:0.01:0.99]));
%     p.thresh_im2= ISresh(ceil(pix*pix*0.85));

    
%     Llow = p.thresh_im2-400;
%     Llow = 0;%p.thresh_im2-20;
%     Lup =  ISresh(ceil(pix*pix*0.99));
%     ImgL = [Llow,Lup];


try
%run main FIRE code

%      figure(1); clf
    if iN <25 %7  
        load(fmat1,'data');
    else
          data1 = fire_2D_ang1(p,im3,0);  %uses im3 and p as inputs and outputs everything
          data = data1;
          save(fmat1,'data','fname','iN','p');
    end
     home
     disp(sprintf('Original image of Test%d has been processed',iN))
  
   
    figure(100+iN); clf
    set(gcf, 'position',[100 100 1268 634]);
    subplot(2,5,1); imagesc(IS1);axis xy; axis square; colormap gray;
    title(sprintf('Original image, test0%d',iN), 'fontsize',12);
    
    FN = find(data.M.L > LL1);
    FLout = data.M.L(FN);
    LFa = length(FN);

    if LFa > FNL
        LFa = FNL;
    end
     rng(1001)           
     clrr1 = rand(LFa,3); % set random color 
     clrr0 = 'rgbmcyg';
    
    for LL = 1:LFa
       
        VFa.LL = data.Fa(1,FN(LL)).v;
        XFa.LL = data.Xa(VFa.LL,:);
        figure(100+iN);subplot(2,5,6);
        cn = mod(LL,7);
        if cn == 0;
            cn = 7;
        end
        plot(XFa.LL(:,1),abs(XFa.LL(:,2)-pix-1), [clrr0(cn),'-'],'linewidth',LW1);
        
%         plot(XFa.LL(:,1),abs(XFa.LL(:,2)-pix-1), '-','linewidth',LW1);
%         set(gca,'colororder',clrr1(LL,1:3));
        hold on
        axis equal;
        axis([1 pix 1 pix]);

    end
    title(sprintf('%d fibers,ORI,length>%d',LFa,LL1),'fontsize',12);
%     titlename = imgname(20:end-5);
%     titlenameS = strrep(titlename,'_','\_');
%     title(sprintf('reg...%s.tiff,#%d',titlenameS,iN),'fontsize',12)
%   
  
  % overlay FIRE extracted fibers on the original image
    figure(51);clf;
    set(gcf,'position',[100 50 512 512]);
    set(gcf,'PaperUnits','inches','PaperPosition',[0 0 pix/128 pix/128]);
    imshow(IS1); colormap gray; axis xy; hold on;
%     clrr0 = 'rgbmcky';
%     rng(1001); % same random number seed
%     clrr1 = rand(LFa,3);
    
   for LL = 1:LFa
       
        VFa.LL = data.Fa(1,FN(LL)).v; 
        XFa.LL = data.Xa(VFa.LL,:);
        
%         cn = mod(LL,7);
%         if cn == 0;
%             cn = 7;
%         end
%         plot(XFa.LL(:,1),abs(XFa.LL(:,2)-pix-1), [clrr0(cn),'-'],'linewidth',LW1);
       
         plot(XFa.LL(:,1),abs(XFa.LL(:,2)-pix-1), '-','color',clrr1(LL,1:3),'linewidth',LW1);
         
         if texton
         text(XFa.LL(2,1),abs(XFa.LL(2,2)-pix-1),sprintf('%d',LL),'color',clrr1(LL,1:3),...
             'VerticalAlignment','baseline', 'HorizontalAlignment','left','fontsize',fst);             
         end
         
        hold on
        axis equal;
        axis([1 pix 1 pix]);

   end
   set(gca, 'visible', 'off')
%    title(sprintf('Extracted %d fibers for ORI image,length>%d(pixel) ',LFa,LL1),'fontsize',12);
%     print('-dtiff', '-r128', 'lineplotIMGori.tif');
     print('-dtiff', '-r128', fOL1);  % overylay FIRE extracted fibers on the original image

%    disp('Press any key to continue ...')
%     pause
%     
     
catch
    home
    kk = kk +1;
    sskipped(kk) = ii;                   % slice skipped
    disp(sprintf('Test %d is skipped',iN));
    disp('Press any key to continue ...')
    pause
    
end    
  
%  pause


%% FIRE on curvelet transform based reconstruction image
    figure(100+iN);subplot(2,5,2); 
    load(fctr,'CTr');
    
 % add mask_ori
    CTr = CTr.*mask_ori;
     
    IS2 = flipud(CTr);
    pix = size(IS2,1);
    imagesc(IS2);axis xy; axis square; colormap gray;
    title(sprintf('CT-based reconstructed image'), 'fontsize',12);
    
%run main FIRE code 

     p = p2;
     
     ImgL = [0  p.thresh_im2*2]
     im3 = [];
     im3(1,:,:) = CTr;
     ii = 1;

    if iN <25 % 
        load(fmat2,'data');
    else
        figure(1); clf
        data2 = fire_2D_ang1(p,im3,0);  %uses im3 and p as inputs and outputs everything listed below
        home
        disp(sprintf('Reconstructed image of Test%d has been processed',iN))
        data = data2; 
        save(fmat2,'data','fname','iN','p');
    end    
 
    FN = find(data.M.L>LL1);
    FLout = data.M.L(FN);
    LFa = length(FN);

    if LFa > FNL
        LFa = FNL;
    end
    
    rng(1001)           
    clrr2 = rand(LFa,3); % set random color 
    figure(100+iN);subplot(2,5,7);
    for LL = 1:LFa
       
        VFa.LL = data.Fa(1,FN(LL)).v;
        XFa.LL = data.Xa(VFa.LL,:);
              
        cn = mod(LL,7);
        if cn == 0;
            cn = 7;
        end
        plot(XFa.LL(:,1),abs(XFa.LL(:,2)-pix-1), [clrr0(cn),'-'],'linewidth',LW1);
%         set(gca,'colororder',clrr2(LL,1:3));

        hold on
        axis equal;
        axis([1 pix 1 pix]);

    end
    title(sprintf('%d fibers,REC, length>%d',LFa,LL1),'fontsize',12);
  
    % overlay CTpFIRE extracted fibers on the original image
    figure(52);clf;
    set(gcf,'position',[300 50 512 512]);
    set(gcf,'PaperUnits','inches','PaperPosition',[0 0 pix/128 pix/128])
    imshow(IS1); colormap gray; axis xy; hold on;
%     clrr0 = 'rgbmcyg';
    for LL = 1:LFa
       
        VFa.LL = data.Fa(1,FN(LL)).v;
        XFa.LL = data.Xa(VFa.LL,:);
%         cn = mod(LL,7);
%         if cn == 0;
%             cn = 7 ;
%         end
%          plot(XFa.LL(:,1),abs(XFa.LL(:,2)-pix-1), [clrr0(cn),'-'],'linewidth',LW1);
%         %         set(gca,'colororder',clrr2(LL,1:3));
        plot(XFa.LL(:,1),abs(XFa.LL(:,2)-pix-1), '-','color',clrr2(LL,1:3),'linewidth',LW1);
        if texton
        text(XFa.LL(2,1),abs(XFa.LL(2,2)-pix-1),sprintf('%d',LL),'color',clrr2(LL,1:3),...
             'VerticalAlignment','baseline', 'HorizontalAlignment','left','fontsize',fst);             
        end

        hold on
        axis equal;
        axis([1 pix 1 pix]);
    end
     set(gca, 'visible', 'off')
 %   title(sprintf('Extracted %d fibers for REC image, length>%d(pixel)',LFa,LL1),'fontsize',12);
%    print('-dtiff', '-r128', 'lineplotIMGrec.tif');
     print('-dtiff', '-r128', fOL2);
     
%% FIRE on Gaussian fiterered image
if runGF == 1
    figure(100+iN);subplot(2,5,3); 
    load(fgf,'GFf');
   
    IS2 = flipud(GFf);
    pix = size(IS2,1);
    imagesc(IS2);axis xy; axis square; colormap gray;
    title(sprintf('GF filtered image'), 'fontsize',12);
        
try
%run main FIRE code 

     p = p4;
      
     ImgL = [0  p.thresh_im2*2]
     im3 = [];
     im3(1,:,:) = GFf;
     ii = 1;

    if iN ~= 0% 
        load(fmat4,'data');
    else
        figure(1); clf
        data4 = fire_2D_ang1(p,im3,0);  %uses im3 and p as inputs and outputs everything listed below
        home
        disp(sprintf('Gaussian filtered image of Test%d has been processed',iN))
        data = data4; 
        save(fmat4,'data','fname','iN','p');
    end    
    
%     LL1 = 30;
%     FNL = 200;
    FN = find(data.M.L>LL1);
    FLout = data.M.L(FN);
    LFa = length(FN);

    if LFa > FNL
        LFa = FNL;
    end

    figure(100+iN);subplot(2,5,8);
    for LL = 1:LFa
       
        VFa.LL = data.Fa(1,FN(LL)).v;
        XFa.LL = data.Xa(VFa.LL,:);
              
        plot(XFa.LL(:,1),abs(XFa.LL(:,2)-pix-1), '-','linewidth',LW1);
        
        cn = mod(LL,7);
        if cn == 0;
            cn = 7;
        end
        plot(XFa.LL(:,1),abs(XFa.LL(:,2)-pix-1), [clrr0(cn),'-'],'linewidth',LW1);
%         set(gca,'colororder',clrr2(LL,1:3));
        hold on
        axis equal;
        axis([1 pix 1 pix]);

    end
    title(sprintf('%d fibers,GF, length>%d',LFa,LL1),'fontsize',12);
  
    % overlay CTpFIRE extracted fibers on the original image
    figure(54);clf;
    set(gcf,'position',[300 50 512 512]);
    set(gcf,'PaperUnits','inches','PaperPosition',[0 0 pix/128 pix/128])
    imshow(IS1); colormap gray; axis xy; hold on;
%     clrr0 = 'rgbmcyg';

    rng(1001)           
    clrr4 = rand(LFa,3); % set random color 
        for LL = 1:LFa
       
        VFa.LL = data.Fa(1,FN(LL)).v;
        XFa.LL = data.Xa(VFa.LL,:);
%         cn = mod(LL,7);
%         if cn == 0;
%             cn = 7 ;
%         end
%          plot(XFa.LL(:,1),abs(XFa.LL(:,2)-pix-1), [clrr0(cn),'-'],'linewidth',LW1);
%         %         set(gca,'colororder',clrr2(LL,1:3));
        plot(XFa.LL(:,1),abs(XFa.LL(:,2)-pix-1), '-','color',clrr4(LL,1:3),'linewidth',LW1);
        
        if texton
         text(XFa.LL(2,1),abs(XFa.LL(2,2)-pix-1),sprintf('%d',LL),'color',clrr4(LL,1:3),...
             'VerticalAlignment','baseline', 'HorizontalAlignment','left','fontsize',fst);             
        end
         hold on
        axis equal;
        axis([1 pix 1 pix]);
    end
     set(gca, 'visible', 'off')
 %   title(sprintf('Extracted %d fibers for REC image, length>%d(pixel)',LFa,LL1),'fontsize',12);
%    print('-dtiff', '-r128', 'lineplotIMGrec.tif');
     print('-dtiff', '-r128', fOL4);
end
      
end % runGF    
 
if runSTV ==1
%% FIRE on spirial tv fiterered image
    figure(100+iN);subplot(2,5,4); 
    STVf = imread(fstv);
   
    IS2 = flipud(STVf);
    pix = size(IS2,1);
    imagesc(IS2);axis xy; axis square; colormap gray;
    title(sprintf('STV filtered image'), 'fontsize',12);
        

%run main FIRE code 

     p = p5;
      
     ImgL = [0  p.thresh_im2*2]
     im3 = [];
     im3(1,:,:) = STVf;
     ii = 1;

    if iN ~= 0% 
        load(fmat5,'data');
    else
        figure(1); clf
        data5 = fire_2D_ang1(p,im3,0);  %uses im3 and p as inputs and outputs everything listed below
        home
        disp(sprintf('STV filtered image of Test%d has been processed',iN))
        data = data5; 
        save(fmat5,'data','fname','iN','p');
    end 
    
    FN = find(data.M.L>LL1);
    FLout = data.M.L(FN);
    LFa = length(FN);

    if LFa > FNL
        LFa = FNL;
    end

    figure(100+iN);subplot(2,5,9);
    for LL = 1:LFa
       
        VFa.LL = data.Fa(1,FN(LL)).v;
        XFa.LL = data.Xa(VFa.LL,:);
              
        plot(XFa.LL(:,1),abs(XFa.LL(:,2)-pix-1), '-','linewidth',LW1);
        
        cn = mod(LL,7);
        if cn == 0;
            cn = 7;
        end
        plot(XFa.LL(:,1),abs(XFa.LL(:,2)-pix-1), [clrr0(cn),'-'],'linewidth',LW1);
%         set(gca,'colororder',clrr2(LL,1:3));
        hold on;
        axis equal;
        axis([1 pix 1 pix]);

    end
    title(sprintf('%d fibers, STV, length>%d',LFa,LL1),'fontsize',12);
  
    % overlay extracted fibers on the original image
    figure(55);clf;
    set(gcf,'position',[600 50 512 512]);
    set(gcf,'PaperUnits','inches','PaperPosition',[0 0 pix/128 pix/128])
    imshow(IS1); colormap gray; axis xy; hold on;


    rng(1001)           
    clrr5 = rand(LFa,3); % set random color 
    for LL = 1:LFa

    VFa.LL = data.Fa(1,FN(LL)).v;
    XFa.LL = data.Xa(VFa.LL,:);
%         cn = mod(LL,7);
%         if cn == 0;
%             cn = 7 ;
%         end
%          plot(XFa.LL(:,1),abs(XFa.LL(:,2)-pix-1), [clrr0(cn),'-'],'linewidth',LW1);
%         %         set(gca,'colororder',clrr2(LL,1:3));
    plot(XFa.LL(:,1),abs(XFa.LL(:,2)-pix-1), '-','color',clrr5(LL,1:3),'linewidth',LW1);
    
    if texton
    text(XFa.LL(2,1),abs(XFa.LL(2,2)-pix-1),sprintf('%d',LL),'color',clrr5(LL,1:3),...
         'VerticalAlignment','baseline', 'HorizontalAlignment','left','fontsize',fst);             
    end
    
    hold on
    axis equal;
    axis([1 pix 1 pix]);
    
    end
    set(gca, 'visible', 'off')
 %   title(sprintf('Extracted %d fibers for REC image, length>%d(pixel)',LFa,LL1),'fontsize',12);
%    print('-dtiff', '-r128', 'lineplotIMGrec.tif');
     print('-dtiff', '-r128', fOL5);
     
end  % runSTV
 
%% FIRE on tube fiterered image
if runTUB == 1
    figure(100+iN);subplot(2,5,5); 
    TUBf = imread(ftub);
   
    IS2 = flipud(TUBf);
    pix = size(IS2,1);
    imagesc(IS2);axis xy; axis square; colormap gray;
    title(sprintf('Tube filtered image'), 'fontsize',12);
        

%run main FIRE code 

     p = p6;
      
     ImgL = [0  p.thresh_im2*2]
     im3 = [];
     im3(1,:,:) = TUBf;
     ii = 1;

    if iN ~= 0% 
        load(fmat6,'data');
    else
        figure(1); clf
        data6 = fire_2D_ang1(p,im3,0);  %uses im3 and p as inputs and outputs everything listed below
        home
        disp(sprintf('Tube filtered image of Test%d has been processed',iN))
        data = data6; 
        save(fmat6,'data','fname','iN','p');
    end 
    
    FN = find(data.M.L>LL1);
    FLout = data.M.L(FN);
    LFa = length(FN);

    if LFa > FNL
        LFa = FNL;
    end

    figure(100+iN);subplot(2,5,10);
    for LL = 1:LFa
       
        VFa.LL = data.Fa(1,FN(LL)).v;
        XFa.LL = data.Xa(VFa.LL,:);
              
        plot(XFa.LL(:,1),abs(XFa.LL(:,2)-pix-1), '-','linewidth',LW1);
        
        cn = mod(LL,7);
        if cn == 0;
            cn = 7;
        end
        plot(XFa.LL(:,1),abs(XFa.LL(:,2)-pix-1), [clrr0(cn),'-'],'linewidth',LW1);
%         set(gca,'colororder',clrr2(LL,1:3));
        hold on;
        axis equal;
        axis([1 pix 1 pix]);

    end
    title(sprintf('%d fibers,TUB, length>%d',LFa,LL1),'fontsize',12);
  
    % overlay extracted fibers on the original image
    figure(56);clf;
    set(gcf,'position',[600 50 512 512]);
    set(gcf,'PaperUnits','inches','PaperPosition',[0 0 pix/128 pix/128])
    imshow(IS1); colormap gray; axis xy; hold on;


    rng(1001)           
    clrr6 = rand(LFa,3); % set random color 
    for LL = 1:LFa

    VFa.LL = data.Fa(1,FN(LL)).v;
    XFa.LL = data.Xa(VFa.LL,:);
%         cn = mod(LL,7);
%         if cn == 0;
%             cn = 7 ;
%         end
%          plot(XFa.LL(:,1),abs(XFa.LL(:,2)-pix-1), [clrr0(cn),'-'],'linewidth',LW1);
%         %         set(gca,'colororder',clrr2(LL,1:3));
    plot(XFa.LL(:,1),abs(XFa.LL(:,2)-pix-1), '-','color',clrr6(LL,1:3),'linewidth',LW1);
    if texton
    text(XFa.LL(2,1),abs(XFa.LL(2,2)-pix-1),sprintf('%d',LL),'color',clrr6(LL,1:3),...
         'VerticalAlignment','baseline', 'HorizontalAlignment','left','fontsize',fst);             
    end
    hold on
    axis equal;
    axis([1 pix 1 pix]);
    
    end
    set(gca, 'visible', 'off')
 %   title(sprintf('Extracted %d fibers for REC image, length>%d(pixel)',LFa,LL1),'fontsize',12);
%    print('-dtiff', '-r128', 'lineplotIMGrec.tif');
     print('-dtiff', '-r128', fOL6);    
     
end % runTUB
   
%% overlay curvealign result with on the original image
 if runCA == 1
    figure(53);clf;
    set(gcf,'position',[400 50 512 512]);
    set(gcf,'PaperUnits','inches','PaperPosition',[0 0 pix/128 pix/128])
    imshow(IS1); colormap gray; axis xy; hold on;
 
   %ym: param to be determined is pkeep

    jj = 0;
         
    pkeeptest([7:8 21:24]) = 0.01;

    for pkeep = pkeeptest(iN)%: 0.0005: 0.01

    if iN ~= 0 %iN == 7 | iN == 8 |iN == 21|iN == 22 | iN == 23 | iN == 24
          load(fmat3);
    else
        [object, Ct, inc] = newCurvMar(IS,pkeep);

        angs = vertcat(object.angle);
        angles = group5(angs,inc);
        % bins = min(angles):inc:max(angles);                
        % [n xout] = hist(angles,bins); imHist = vertcat(n,xout);
        temp = ifdct_wrapping(Ct,0);
        recon = real(temp);

        save(fmat3,'object','Ct','inc','angles','recon');
    end
    end
         
    deltax = pix/128;
    for ii = 1:length(object)
           ca = object(ii).angle*pi/180;
           xc = object(ii).center(1,2);
           yc = pix+1-object(ii).center(1,1);
           figure(53);
           plot(xc,yc,'r.','MarkerSize',5); % show curvelet center
           hold on
           % show curvelet direction
           xc1 = (xc - deltax * cos(ca));
           xc2 = (xc + deltax * cos(ca));
           yc1 = (yc - deltax * sin(ca));
           yc2 = (yc + deltax * sin(ca));
%            annotation('arrow',[xc1 xc2],[yc1 yc2],'HeadStyle','cback3','HeadWidth',1,'linewidth',1);
%            axis(axis)
%            arrow([xc1 yc1],[xc2 yc2])

           plot([xc1 xc2],[yc1 yc2],'g-','linewidth',0.8); % show curvelet center
           hold on
           axis([1 pix 1 pix])
    end
    
    set(gca, 'visible', 'off')
 %   title(sprintf('Extracted %d fibers for REC image, length>%d(pixel)',LFa,LL1),'fontsize',12);
%      print('-dtiff', '-r128', 'lineplotIMGrec.tif');
     print('-dtiff', '-r128', fOL3); 
     
 end %runCA
    
%     xlabel('X position (pixel)', 'fontsize',12)
%     ylabel('Y position (pixel)', 'fontsize',12) 
%     title(sprintf('Curvelet center and direction, p=%.4f',pkeep),'fontsize',12)
   
% %
%     
% %      disp('Press any key to continue ...')
% %      pause
%         
% %       % Zoom in images in a number of random positions 
% %        iaN = 10; 
% %        rng(1001); % same random number seed
% %        isr = rand(iaN,2);
% %        
% %       for ia = iaN 
% %     %      is = [round(pix/(ia+0.2)),round(pix/(ia+0.2))];
% %          is = isr(ia,1:2)*pix;
% %          isx = is(1);
% %          isy = is(2);
% %          iw = round(pix/4);
% %          ih = iw;
% %          if isx+iw > pix
% %              isx = pix - iw;
% %          end
% % 
% %          if isy+ih > pix
% %              isy = pix - ih;
% %           end
% % 
% %          axislim3 = [isx isx+iw isy isy+iw];
% % %          axislim3 = [1 pix 1 pix];
% %         figure(100+iN);
% %         subplot(2,2,1); axis(axislim3);
% %         subplot(2,2,2); axis(axislim3); 
% % %         subplot(2,2,3); axis(axislim3); 
% %         subplot(2,2,4); axis(axislim3); 
% %         subplot(2,2,3); axis(axislim3); 
% %         home
% %         disp(sprintf('zoom in the image, %d of %d', ia, iaN));
% % %         disp('Press any key to continue ...')
% % %         pause
% %       end   % ia
     
 %% overlay the extracted fibers on the original image
%      
%     figure(200+iN); clf;
%     set(gcf,'position',[100,50,1152 768]);
%   
%     ax(1) = subplot(2,3,1)
%     imagesc(IS); axis square; colormap gray;
%     title1 = sprintf('Original image of test%d',iN);
%     title(title1,'fontsize',12)
%     
%     ax(2) = subplot(2,3,2)
%     mOL2 = imread(fOL2);
%     imagesc(mOL2); axis square;
%     title2 = sprintf('Overlay of extracted fibers by  CT image');
%     title(title2,'fontsize',12);
%    
%     ax(3) = subplot(2,3,3)
%     mOL3 = imread(fOL3);
%     imagesc(mOL3); axis square;
%     title3 = sprintf('CA curvelts center and direction');
%     title(title3,'fontsize',12);
%     
%     
%     ax(4) = subplot(2,3,4)
%     mOL4 = imread(fOL4);
%     imagesc(mOL4); axis square;
%     title3 = sprintf('Overlay of extracted fibers by GF image');
%     title(title3,'fontsize',12);
%     
%     ax(5) = subplot(2,3,5)
%     mOL5 = imread(fOL5);
%     imagesc(mOL5); axis square;
%     title5 = sprintf('Overlay of extracted fibers by STV image');
%     title(title5,'fontsize',12);
%     
%     ax(6) = subplot(2,3,6)
%     mOL6 = imread(fOL6);
%     imagesc(mOL6); axis square;
%     title2 = sprintf('Overlay of extracted fibers by TUBf image',iN);
%     title(title2,'fontsize',12)
%   
%      pause(5);
%     linkaxes([ax(6) ax(5) ax(4) ax(3) ax(2) ax(1)],'xy');
%     disp('Press any key to continue ...')
%     pause
    
%     set(gcf,'PaperUnits','inches','PaperPosition',[0 0 3*pix/128 pix/128])
%     print('-dtiff', '-r128', fOL1);
 


end

t_run = toc;  
fprintf('total run time = %2.1f minutes\n',t_run/60)

  
    
    