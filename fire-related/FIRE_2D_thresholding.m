%% FIRE_2D_thresholding.m
% Oct 09, 2012: investigate the affect of the FIRE parameters of intensity of threshold 
%% Yuming Liu, LOCI, UW-Madison, since Feb 2012

clear; clc; close all;
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

  


iNF  = 24%[7 21:24];  %number of the images to be processed
LW1 = 0.5;         % line width of the extracted fibers 
fst = 4.5;           % font size of fiber text label
% fst2 = 4; % font size of fiber text label
% fst3 = 5; % font size of fiber text label
% fst4 = 6; % font size of fiber text label

LL1 = 30;  %082812: length limit(threshold), only show fibers with length >LL
FNL = 2999; %: fiber number limit(threshold), maxium fiber number to be shown 
clrr0 = 'rgbmcyg'; 
texton = 0;  % texton = 1, label the fibers; texton = 0: no label

 %set the FIRE parameters for all the approaches and  run on the original image
    p1.path = pd1;
    p1 = param_com0816(p1);   % for the original image
    th2base([7 21 22 23 24]) = [30 10 10 30 30];  % 
    th2adj = [0.5 0.75 1 1.25 1.5];
    jj = 0;
for iN = iNF
    
     
     fname =[dir5(1:end-7), fileN(iN).name];
    
 for iT  = 1:5  % number of threshold
    
    fmat1 = [dir6,sprintf('test%d_FIREout_T%d.mat',iN,iT)];
    fOL1 = [dir4, sprintf('test%d_OL_FIRE_T%d.tif',iN,iT)]; %filename of overlay 1

 
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
%     mask_ori = IS > 0.8*p1.thresh_im2; 

%073112: comment out the automatic thresholding
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
    if iN == 0 %7  
        load(fmat1,'data');
       else
        
         % set FIRE parameters for the original image    
          p = p1; 
          th2 = th2base(iN)*th2adj(iT);  % 5 different th2 thresholds for each test image
          p.thresh_im2 = th2;
          
          data1 = fire_2D_ang1(p,im3,0);  %uses im3 and p as inputs and outputs everything
          data = data1;
          save(fmat1,'data','fname','iN','p','iT');
    end
     home
     disp(sprintf('Original image of Test%d with threshold T%d has been processed',iN,iT))
  
   
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
  
  % overlay FIRE extracted fibers on the original image
    figure(51);clf;
    set(gcf,'position',[100 50 512 512]);
    set(gcf,'PaperUnits','inches','PaperPosition',[0 0 pix/128 pix/128]);
    imshow(IS1); colormap gray; axis xy; hold on;
 
    
   for LL = 1:LFa
       
        VFa.LL = data.Fa(1,FN(LL)).v; 
        XFa.LL = data.Xa(VFa.LL,:);
        
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
    disp(sprintf('Test %d, threshold#%d is skipped',iN,iT));
    disp('Press any key to continue ...')
    pause
    
end    
  
%  pause
    
    
    end % iT
    
end %iN

t_run = toc;  
fprintf('total run time = %2.1f minutes\n',t_run/60)

  
    
    