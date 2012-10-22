%% FIRE_2D_scalecombination.m
%% batch processing both 2D original images and  2D Curvelets transform based reconstructed images by FIRE 
%% run after CTreconstruction01.m
% % Oct 10, 2012: process multi-scale combinations for each test case
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

    
iNF  = [7 21:24];  %number of the images to be processed
LW1 = 0.5;         % line width of the extracted fibers 
fst = 4.5;           % font size of fiber text label
% fst2 = 4; % font size of fiber text label
% fst3 = 5; % font size of fiber text label
% fst4 = 6; % font size of fiber text label

LL1 = 30;  %082812: length limit(threshold), only show fibers with length >LL
FNL = 2999; %: fiber number limit(threshold), maxium fiber number to be shown 
clrr0 = 'rgbmcyg'; 
texton = 0;  % texton = 1, label the fibers; texton = 0: no label

scalesc(1).name = 'sc56';
scalesc(2).name = 'sc45';
scalesc(3).name = 'sc456';
scalesc(4).name = 'sc345';
scalesc(5).name = 'sc3456';
scalesc(6).name = 'sc23456';
scalesc(7).name = 'sc123456';
scalesc(8).name = 'sc1234567';

% set the method to run, 1: run; 0:not run
runCT = 1; %runCA =0; runGF = 0; runSTV = 0; runTUB = 1; % 

for iN = iNF
 
    fname =[dir5(1:end-7), fileN(iN).name];
    fmat1 = [dir6,sprintf('test%d-FIREout.mat',iN)];
    fOL1 = [dir4, sprintf('test%d_OL_FIRE.tif',iN)]; %filename of overlay 1

    
%set the FIRE parameters for all the approaches and  run on the original image
    %set FIRE parameters for different image types
         p1.path = pd1;

         p1 = param_com0816(p1);   % for the original image
         p2 = param_com0816(p1);   % for the CT based reconstruction image 
         p4 = param_com0816(p1);   % for the Gaussian filtered image
         p5 = param_com0816(p1);   % for the Spirial TV filtered image
         p6 = param_com0816(p1);   % for the tube filtered image
     
 % set threshold to binarize the image 
         p2.thresh_im2 = 0; 
         p6.thresh_im2 = 5;  % for test 7, 21 ,22

         if iN == 7 | iN == 8
             th2 = 30; 
             p1.thresh_im2 = th2;
            
         elseif iN == 21 | iN == 22
             th2 = 10;
             p1.thresh_im2 = th2;
             
         else       % for iN == 23 | iN == 24
             th2 = 30;
             p1.thresh_im2 = th2;
             
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
    if iN ~= 0 %7  
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
%      clrr0 = 'rgbmcyg';
%     
%     for LL = 1:LFa
%        
%         VFa.LL = data.Fa(1,FN(LL)).v;
%         XFa.LL = data.Xa(VFa.LL,:);
%         figure(100+iN);subplot(2,5,6);
%         cn = mod(LL,7);
%         if cn == 0;
%             cn = 7;
%         end
%         plot(XFa.LL(:,1),abs(XFa.LL(:,2)-pix-1), [clrr0(cn),'-'],'linewidth',LW1);
%         
% %         plot(XFa.LL(:,1),abs(XFa.LL(:,2)-pix-1), '-','linewidth',LW1);
% %         set(gca,'colororder',clrr1(LL,1:3));
%         hold on
%         axis equal;
%         axis([1 pix 1 pix]);
% 
%     end
%     title(sprintf('%d fibers,ORI,length>%d',LFa,LL1),'fontsize',12);
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
    ssc = 1:length(scalesc); % selected scale combination number
   for iNs =ssc 
        
       disp(sprintf('reconstructing test%d,sc#%d of %d',iN, iNs, length(ssc))); 
       scN = scalesc(iNs).name;
       fctrsc = [dir5,'\ctsc_mult_params\', sprintf('test%d-CTR%s.mat',iN,scN)];  % filename of the curvelet transformed reconstructed image
       fmat2sc = [dir6,sprintf('test%d-FIREoutCTr_sc%d.mat',iN,iNs)];
       fOL2sc = [dir4, sprintf('test%d_OL_CTpFIRE_Psc%d.tif',iN,iNs)]; %filename of overlay 2
    

%% run FIRE on curvelet transform based reconstruction image
   if runCT == 1 %
   
    figure(100+iN);subplot(2,5,2); 
    load(fctrsc,'CTr');
    
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

    if iN == 0% 
        load(fmat2sc,'data');
    else
        figure(1); clf
        data2 = fire_2D_ang1(p,im3,0);  %uses im3 and p as inputs and outputs everything listed below
        home
        disp(sprintf('Reconstructed image of Test%d, sc%d has been processed',iN,iNs))
        data = data2; 
        save(fmat2sc,'data','fname','iN','p','iNs');
    end    
 
    FN = find(data.M.L>LL1);
    FLout = data.M.L(FN);
    LFa = length(FN);

    if LFa > FNL
        LFa = FNL;
    end
    
    rng(1001)           
    clrr2 = rand(LFa,3); % set random color 
%     figure(100+iN);subplot(2,5,7);
%     for LL = 1:LFa
%        
%         VFa.LL = data.Fa(1,FN(LL)).v;
%         XFa.LL = data.Xa(VFa.LL,:);
%               
%         cn = mod(LL,7);
%         if cn == 0;
%             cn = 7;
%         end
%         plot(XFa.LL(:,1),abs(XFa.LL(:,2)-pix-1), [clrr0(cn),'-'],'linewidth',LW1);
% %         set(gca,'colororder',clrr2(LL,1:3));
% 
%         hold on
%         axis equal;
%         axis([1 pix 1 pix]);
% 
%     end
%     title(sprintf('%d fibers,REC, length>%d',LFa,LL1),'fontsize',12);
%   
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
     print('-dtiff', '-r128', fOL2sc);
     
   end %runCT
   


    end % iNs
    
end  % iN
t_run = toc;  
fprintf('total run time = %2.1f minutes\n',t_run/60)

  
    
    