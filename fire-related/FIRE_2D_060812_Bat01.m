%% FIRE_2D_060812_Bat01.m
%% batch processing  2D Curvelets transform based reconstructed images by FIRE 
%% run after CTreconstruction01.m
%% Yuming Liu, LOCI, UW-Madison, June 2012

clear
home
teston = 1 ;  % 0: use the FIRE images; 1: use customized images
REC = 0       % 1: work on REConstructed image; 0: work on original image

cd F:\UW-MadisonSinceFeb_01_2012\download\FIRE\example;
pd1 = pwd;
addpath(genpath('../')); 

kk =0; 

%% Testing FIRE
    
 if teston
    tic

    dir1 = 'F:\UW-MadisonSinceFeb_01_2012\download\testimages\';
    dir2 = 'F:\UW-MadisonSinceFeb_01_2012\download\testresults\';
    
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
 

iNF = 7 %11:15;  % iN numbers

for iN = iNF   
    
    fname =[dir1, fileN(iN).name];
    fmat = [dir2,sprintf('test%d-FIREout.mat',iN)];
    fmat2 = [dir2,sprintf('test%d-FIREoutCTr.mat',iN)];
    ffigO = [dir2,sprintf('test%d-FIREfigO.tif',iN)]; % original figure
    ffigE = [dir2,sprintf('test%d-FIREfigE.tif',iN)]; % extracted figure
    fctr = [dir1, sprintf('test%d-CTR.mat',iN)];  % filename of the curvelet transformed reconstructed image
    
    %fire parameters
     p1.path = pd1;
     p1 = param_ORI01(p1);   % set FIRE parameters
     p = p1;
     
    % IS is the image of a slice
    LL1 = 30;  %length limit(threshold), only show fibers with length >LL
    FNL = 200; %: fiber number limit(threshold), maxium fiber number to be shown
    
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
    
   for ii = 1; % choose the first slice for image stack

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
    ISresh = sort(reshape(IS,1,pix*pix));        
    Ith(ii,1:15) = ISresh(ceil(pix*pix*[0.85:0.01:0.99]));
    p.thresh_im2= ISresh(ceil(pix*pix*0.85));
    if iN == 1 | iN == 2 | iN == 10 
        p.thresh_im2 = 50;
    elseif iN == 6
        p.thresh_im2 = 20;
    elseif iN == 11 | iN == 12 | iN == 13 | iN == 14 | iN == 15 
         p.thresh_im2 = 100;        
    end
%         Llow = p.thresh_im2-400;
    Llow = 0;%p.thresh_im2-20;
    Lup =  ISresh(ceil(pix*pix*0.99));
    ImgL = [Llow,Lup];
  
try
%run main FIRE code
%      figure(1); clf
%      data = fire_2D_ang1(p,im3,0);  %uses im3 and p as inputs and outputs everything 
     load(fmat,'data');
     home
     disp(sprintf('Original image of Test%d has been processed',iN))
  
    IS1 = flipud(IS1);  % associated with the following 'axis xy'
    figure(100+iN); clf
    set(gcf, 'position',[100 100 868 868]);
    subplot(2,2,1); imagesc(IS1);axis xy; axis square; colormap gray;
    title(sprintf('Original image, test0%d',iN), 'fontsize',12);
    
    FN = find(data.M.L > LL1);
    FLout = data.M.L(FN);
    LFa = length(FN);

    if LFa > FNL
        LFa = FNL;
    end
     
    for LL = 1:LFa
       
        VFa.LL = data.Fa(1,FN(LL)).v;
        XFa.LL = data.Xa(VFa.LL,:);
        figure(100+iN);subplot(2,2,2);
        
        plot(XFa.LL(:,1),abs(XFa.LL(:,2)-pix-1), '-','linewidth',2);
        set(gca,'colororder',rand(1,3));
        hold on
        axis equal;

    end
    title(sprintf('Extracted %d fibers for ORI image,length>%d(pixel) ',LFa,LL1),'fontsize',12);
%     titlename = imgname(20:end-5);
%     titlenameS = strrep(titlename,'_','\_');
%     title(sprintf('reg...%s.tiff,#%d',titlenameS,iN),'fontsize',12)
%   
    disp('Press any key to continue ...')
    pause
    
     
catch
    home
    kk = kk +1;
    sskipped(kk) = ii;                   % slice skipped
    disp(sprintf('Test %d is skipped',iN));
    disp('Press any key to continue ...')
    pause
    
end    
  
%  pause

end  %%ii
     
    load(fctr,'CTr');
    IS2 = flipud(CTr);
    pix = size(IS2,1);
    subplot(2,2,3); imagesc(IS2);axis xy; axis square; colormap gray;
    title(sprintf('CT-based reconstructed image'), 'fontsize',12);
        
try
%run main FIRE code 

     p2.path = pd1;
     p2 = param_CTr01(p2);
     p = p2;
     
     ImgL = [0  p.thresh_im2*2]
     im3 = [];
     im3(1,:,:) = CTr;
     ii = 1;

    if iN == 7
        load(fmat2,'data');
    else
        figure(1); clf
        data2 = fire_2D_ang1(p,im3,0);  %uses im3 and p as inputs and outputs everything listed below
        home
        disp(sprintf('Reconstructed image of Test%d has been processed',iN))
        data = data2; 
        save(fmat2,'data','fname','iN','p');
    end    
    
    FN = find(data.M.L>LL);
    FLout = data.M.L(FN);
    LFa = length(FN);

    if LFa > FNL
        LFa = FNL;
    end
     
    for LL = 1:LFa
       
        VFa.LL = data.Fa(1,FN(LL)).v;
        XFa.LL = data.Xa(VFa.LL,:);
        figure(100+iN);subplot(2,2,4);
        
        plot(XFa.LL(:,1),abs(XFa.LL(:,2)-pix-1), '-','linewidth',2);
        set(gca,'colororder',rand(1,3));
        hold on
        axis equal;

    end
    title(sprintf('Extracted %d fibers for REC image, length>%d(pixel)',LFa,LL1),'fontsize',12);
    % titlename = imgname(20:end-5);
    % titlenameS = strrep(titlename,'_','\_');
    % title(sprintf('reg...%s.tiff,#%d',titlenameS,SN),'fontsize',12)

    
     disp('Press any key to continue ...')
     pause
        
      % Zoom in images in a number of random positions 
       iaN = 20; 
       rng(1001); % same random number seed
       isr = rand(iaN,2);
       
      for ia = 1: iaN
    %      is = [round(pix/(ia+0.2)),round(pix/(ia+0.2))];
         is = isr(ia,1:2)*pix;
         isx = is(1);
         isy = is(2);
         iw = round(pix/4);
         ih = iw;
         if isx+iw > pix
             isx = pix - iw;
         end

         if isy+ih > pix
             isy = pix - ih;
          end

         axislim3 = [isx isx+iw isy isy+iw];
    %      axislim3 = axislim1;
        figure(100+iN);
        subplot(2,2,1); axis(axislim3);axis square;
        subplot(2,2,2); axis(axislim3);axis square;
        subplot(2,2,3); axis(axislim3);axis square;
        subplot(2,2,4); axis(axislim3);axis square;

        home
        disp(sprintf('zoom in the image, %d of %d', ia, iaN));
        disp('Press any key to continue ...')
        pause
      end   % ia
     
     
catch
    home
    kk = kk +1;
    sskipped(kk) = ii;                   % slice skipped
    disp(sprintf('Test %d is skipped',iN));
    disp('Press any key to continue ...')
    pause
      
end    
        
        
    
    
 


end


 else 
     
% teston = 0, fire example program

 %headers
    tic
  
    mfn = mfilename;
    

%parameters for preprocessing of image and dist. func. calculation
    p.Nimages   = 100; %last image in sequence
    p.yred      = 1:100;
    p.xred      = 1:100;     
    
% % fire parameters
    p = param_example(p); 
       
%plotflag - for plotting intermediate results
    plotflag = 1;%1;
    if plotflag == 1
        ifig     = 0;
        rr = 3; cc = 3;
        figure(1); clf
        pause(0.1);
    elseif plotflag == 2
        rr = 2; cc = 2;        
    end
    
    fprintf('loading image\n');

    im3 = loadim3('./images',p.Nimages,'s5part1__cmle','.tif',2,p.yred,p.xred);
    %run main FIRE code
    data = fire(p,im3,1);  %uses im3 and p as inputs and outputs everything listed below
    
    
    
 end   % teston
 
t_run = toc;  
fprintf('total run time = %2.1f minutes\n',t_run/60)

  
    
    