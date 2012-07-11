%% FIRE_2D_Bat01Cc.m
%% batch processing both 2D original images and  2D Curvelets transform based reconstructed images by FIRE 
%% run after CTreconstruction01.m
% June 27 2012, add the overlay of the extracted fibers on the original
% image by controlling the transparency
% June 28 2012: use imshow to complete overylay of image and line plot.
% July 2 2012: investigate scale effects by using FIRE on different REC images from different scales
%              run after 'CTreconstruction01c.m'
% July 2 2012: investigate scale combination
% July 9 2012: add CurveAlign to do a comparison
%% Yuming Liu, LOCI, UW-Madison, June-July 2012

clear; 
close all;
home
teston = 1 ;  % 0: use the FIRE images; 1: use customized images

CAflag = 0;   % 1: add CurveAlign result in the final figure
% cd D:\UW-MadisonSinceFeb_01_2012\download\FIRE\example;
pd1 = pwd;
addpath(genpath('../')); 

kk =0; 
jj = 0;

%% Testing FIRE
    
 if teston
    tic
    dir1 = 'D:\UW-MadisonSinceFeb_01_2012\download\testimages\';
    dir2 = 'D:\UW-MadisonSinceFeb_01_2012\download\testresults\';
    
    dir4 = 'Z:\liu372\fiberextraction\testoverlay\070912\';
    dir5 = 'Z:\liu372\fiberextraction\testimages\070912\';
    dir6 =  'Z:\liu372\fiberextraction\testresults\070912\';
    dir7 = 'Z:\liu372\fiberextraction\testcontrols\070912\';
    
    dir9 =  'Z:\liu372\fiberextraction\testtemp\';
    
    fileN(1).name = 'Substack (5)_L200N50A2.tif';   
    fileN(2).name = 'N50L200AUniC.tif';
    fileN(3).name = 'Substack (110)_Kgel5.tif';
    fileN(4).name = '11250_SKOV_Substack (8).tif';

    fileN(5).name = 'Substack (103)_tissue_SHG_J1.tif';       % size: 512 by 512
    fileN(6).name = '12_30_08 Slide 1B-c7-01_C2.tiff';       % size: 1024 by 1024
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

iNF  = 6   % file name number to be analyzed

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

%ssc = 1:length(scalesc)
  ssc = 4  % selected scale combination number for iNF = 6
%  ssc = 2  % selected scale combination number for iNF = 7
% ssc = 6;   % selected scale combination number  for iNF =16
% ssc = 2  % selected scale combination number for iNF = 20

LW1 = 1.5; % line width of the fiber line plot
clrr0 = 'rgbmcyg'; % color of the extracted fibers
 
for iNs = ssc
   
    scN = scalesc(iNs).name;
    jj = jj+1;
    for iN = iNF   

        fname =[dir1, fileN(iN).name];
%       fmat1 = [dir2,sprintf('test%d-FIREout.mat',iN)];
        
        fmat1 = [dir6,sprintf('test%d-FIREout.mat',iN)];  % FIRE output folder 
        fmat2 = [dir6,sprintf('test%d-FIREoutCTr%s.mat',iN,scN)];
        fmat3 = [dir6,sprintf('test%d-CAout.mat',iN)];

        ffigO = [dir2,sprintf('test%d-FIREfigO.tif',iN)]; % original figure
        ffigE = [dir2,sprintf('test%d-FIREfigE.tif',iN)]; % extracted figure
%         fctr = [dir1, sprintf('test%d-CTR.mat',iN)];  % filename of the curvelet transformed reconstructed image
        fctr = [dir5, sprintf('test%d-CTR%s.mat',iN,scN)];  % filename of the curvelet transformed reconstructed image
        fOL1 = [dir4, sprintf('test%d_OL_FIRE.tif',iN)]; %filename of overlay 1
        fOL2 = [dir4, sprintf('test%d_OL_CTpFIRE_%s.tif',iN,scN)]; %filename of overlay 2
        fOL3 = [dir4, sprintf('test%d_OL_CA.tif',iN)]; %filename of overlay 3
        
        fcom23 = [dir4, sprintf('test%d_com23_CTpFIRE_%s.tif',iN,scN)]; %filename of comprison between 2(FIRE) and 3(CT+FIRE)
        %fire parameters
         p1.path = pd1;
         p1 = param_ORI01(p1);   % set FIRE parameters
         p = p1;

        % IS is the image of a slice
        LL1 = 20;  %length limit(threshold), only show fibers with length >LL
        FNL = 1000; %: fiber number limit(threshold), maxium fiber number to be shown

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
             p.thresh_im2 = 10; % 20
%              p.s_xlinkbox = 5;
        elseif iN == 7 | iN == 8
             p.thresh_im2 = 120;  % 162
             p.s_xlinkbox = 10;
        elseif iN == 11 | iN == 12 | iN == 13 | iN == 14 | iN == 15 
             p.thresh_im2 = 100;  
        elseif iN == 16
%              p.thresh_im2 = 50;  % 16 bit image
             p.thresh_im2 = 10;   % 8 bit image
             p.s_xlinkbox = 5;
        elseif iN == 19
             p.thresh_im2 = 60;  
        elseif iN == 20
             p.thresh_im2 = 10; 
             p.s_xlinkbox = 5;
        end
               
         p1.thresh_im2 =  p.thresh_im2;  % update original thresh_im2
         p1.s_xlinkbox = p.s_xlinkbox;
    %         Llow = p.thresh_im2-400;
        Llow = 0;%p.thresh_im2-20;
        Lup =  ISresh(ceil(pix*pix*0.99));
        ImgL = [Llow,Lup];

    try
    %run main FIRE code
    %      figure(1); clf
        if iN == 0| iN == 6 | iN == 7 | iN == 16 | iN == 20 | jj > 1
            load(fmat1,'data');
        else
              data = fire_2D_ang1(p,im3,0);  %uses im3 and p as inputs and outputs everything
              save(fmat1,'data','fname','iN','p');
        end
         home
         disp(sprintf('Original image of Test%d has been processed',iN))

        IS1 = flipud(IS1);  % associated with the following 'axis xy'
        figure(100+iN*20+iNs); clf
        set(gcf, 'position',[100 100 868 868]);
        subplot(2,2,1); imagesc(IS1);axis xy; axis square; colormap gray;
        title(sprintf('Original image, test0%d',iN), 'fontsize',12);

        FN = find(data.M.L > LL1);
        FLout = data.M.L(FN);
        LFa = length(FN);

        if LFa > FNL
            LFa = FNL;
        end
         rng(1001)           
         clrr1 = rand(LFa,3); % set random color 

        for LL = 1:LFa

            VFa.LL = data.Fa(1,FN(LL)).v;
            XFa.LL = data.Xa(VFa.LL,:);
            figure(100+iN*20+iNs);subplot(2,2,2);
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
        title(sprintf('Extracted %d fibers for ORI image,length>%d(pixel) ',LFa,LL1),'fontsize',12);
    %     titlename = imgname(20:end-5);
    %     titlenameS = strrep(titlename,'_','\_');
    %     title(sprintf('reg...%s.tiff,#%d',titlenameS,iN),'fontsize',12)
    %   

      % overlay FIRE extracted fibers on the original image
        figure(51);clf;
        set(gcf,'position',[100 50 512 512]);
        set(gcf,'PaperUnits','inches','PaperPosition',[0 0 pix/128 pix/128]);
        imshow(IS1); colormap gray; axis xy; hold on;
%         clrr0 = 'rgbmcky';
       for LL = 1:LFa

            VFa.LL = data.Fa(1,FN(LL)).v; 
            XFa.LL = data.Xa(VFa.LL,:);

            cn = mod(LL,7);
            if cn == 0;
                cn = 7;
            end
            plot(XFa.LL(:,1),abs(XFa.LL(:,2)-pix-1), [clrr0(cn),'-'],'linewidth',LW1);

    %         plot(XFa.LL(:,1),abs(XFa.LL(:,2)-pix-1), ['-','linewidth',LW1);
    %         set(gca,'colororder',clrr1(LL,1:3));
            hold on
            axis equal;
            axis([1 pix 1 pix]);

       end
       set(gca, 'visible', 'off')
    %    title(sprintf('Extracted %d fibers for ORI image,length>%d(pixel) ',LFa,LL1),'fontsize',12);
    %     print('-dtiff', '-r128', 'lineplotIMGori.tif');
    if jj < 2
         print('-dtiff', '-r128', fOL1);  % overylay FIRE extracted fibers on the original image
    end 

%        disp('Press any key to continue ...')
%         pause


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

    %load Curve Align reconstruction image
    %    fmat3 = [dir2,sprintf('test%d-CAout.mat',iN)];
    %    load(fmat3,'recon');
    %    CTr = recon;

    % load curvelet transform based reconstruction image
        figure(100+iN*20+iNs);subplot(2,2,3); 
        load(fctr,'CTr'); 
        IS2 = flipud(CTr);
        pix = size(IS2,1);

        imagesc(IS2);axis xy; axis square; colormap gray;
        title(sprintf('CT-based reconstructed image,%s',scN), 'fontsize',12);

    try
    %run main FIRE code 

         p2.path = pd1;
         p2 = param_CTr01(p2);
         p = p2;
         
%          
%          IS2resh = sort(reshape(IS2,1,pix*pix));        
%          I2th(ii,1:15) = ISresh(ceil(pix*pix*[0.85:0.01:0.99]));
%          p.thresh_im2= IS2resh(ceil(pix*pix*0.85));

         if iN == 1 |iN == 2 
             p.thresh_im2 = 30;
             
%          elseif iN == 3 | iN == 4
%              p.thresh_im2 = 10;
%          elseif iN == 5
%              p.thresh_im2 = 15;
         elseif iN == 6;
             p.thresh_im2 = 5;
%              p.s_xlinkbox = 5;
             
         elseif iN == 7 | iN == 8;
             p.thresh_im2 = 5;
%              p.s_xlinkbox = 5;
             
%          elseif iN >= 10 & iN <= 15
%              p.thresh_im2 = 50;
          elseif iN == 16
             p.thresh_im2 = 5; 
             p.s_xlinkbox = 5;
%          elseif iN == 19
%              p.thresh_im2 = 5;    
%              
         elseif iN == 20
             p.thresh_im2 = 5; 
             p.s_xlinkbox = 5;

         end
     
         p2.thresh_im2 =  p.thresh_im2;
         p2.s_xlinkbox = p.s_xlinkbox;
         
         ImgL = [0  p.thresh_im2*2]
         im3 = [];
         im3(1,:,:) = CTr;
         ii = 1;

        if iN == 0| iN == 6 | iN == 7 | iN == 16 |iN == 20
            load(fmat2,'data');
        else

            figure(1); clf
            data2 = fire_2D_ang1(p,im3,0);  %uses im3 and p as inputs and outputs everything listed below
            home
            disp(sprintf('Reconstructed image of Test%d has been processed',iN))
            data = data2; 
            save(fmat2,'data','fname','iN','p');
        end    

    %     LL1 = 30;
    %     FNL = 200;
        FN = find(data.M.L>LL1);
        FLout = data.M.L(FN);
        LFa = length(FN);

        if LFa > FNL
            LFa = FNL;
        end

        rng(1001)           
        clrr2 = rand(LFa,3); % set random color 
        figure(100+iN*20+iNs);subplot(2,2,4);
        for LL = 1:LFa

            VFa.LL = data.Fa(1,FN(LL)).v;
            XFa.LL = data.Xa(VFa.LL,:);

            cn = mod(LL,7);
            if cn == 0;
                cn = 7;
            end
            plot(XFa.LL(:,1),abs(XFa.LL(:,2)-pix-1), [clrr0(cn),'-'],'linewidth',LW1);
%             plot(XFa.LL(:,1),abs(XFa.LL(:,2)-pix-1), '-','linewidth',LW1);

%         set(gca,'colororder',clrr2(LL,1:3));
            hold on
            axis equal;
            axis([1 pix 1 pix]);

        end
        title(sprintf('Extracted %d fibers for REC image, length>%d(pixel)',LFa,LL1),'fontsize',12);

        set(gcf,'PaperUnits','inches','PaperPosition',[0 0 pix/128 pix/128])
        print('-dtiff', '-r256', fcom23);
 
        
        % overlay FIRE extracted fibers on the original image
        figure(52);clf;
        set(gcf,'position',[700 50 512 512]);
        set(gcf,'PaperUnits','inches','PaperPosition',[0 0 pix/128 pix/128])
        imshow(IS1); colormap gray; axis xy; hold on;

        for LL = 1:LFa

            VFa.LL = data.Fa(1,FN(LL)).v;
            XFa.LL = data.Xa(VFa.LL,:);
            cn = mod(LL,7);
            if cn == 0;
                cn = 7 ;
            end
             plot(XFa.LL(:,1),abs(XFa.LL(:,2)-pix-1), [clrr0(cn),'-'],'linewidth',LW1);
            %         set(gca,'colororder',clrr2(LL,1:3));
            hold on
            axis equal;
            axis([1 pix 1 pix]);
        end
         set(gca, 'visible', 'off')
     %   title(sprintf('Extracted %d fibers for REC image, length>%d(pixel)',LFa,LL1),'fontsize',12);
    %      print('-dtiff', '-r128', 'lineplotIMGrec.tif');
         print('-dtiff', '-r128', fOL2);

%          disp('Press any key to continue ...')
%          pause

         % Zoom in images in a number of random positions 
%            iaN = 10; 
%            rng(1001); % same random number seed
%            isr = rand(iaN,2);
% 
%           for ia = 1: iaN 
%         %      is = [round(pix/(ia+0.2)),round(pix/(ia+0.2))];
%              is = isr(ia,1:2)*pix;
%              isx = is(1);
%              isy = is(2);
%              iw = round(pix/4);
%              ih = iw;
%              if isx+iw > pix
%                  isx = pix - iw;
%              end
% 
%              if isy+ih > pix
%                  isy = pix - ih;
%               end
% 
%              axislim3 = [isx isx+iw isy isy+iw];
%     %          axislim3 = [1 pix 1 pix];
% %              axislim3 = [200 500  600 900];
%             figure(100+iN*20+iNs);
%             subplot(2,2,1); axis(axislim3);
%             subplot(2,2,2); axis(axislim3); 
%     %         subplot(2,2,3); axis(axislim3); 
%             subplot(2,2,4); axis(axislim3); 
%             subplot(2,2,3); axis(axislim3); 
%             home
%             disp(sprintf('zoom in the image, %d of %d', ia, iaN));
%             disp('Press any key to continue ...')
%             pause
%           end   % ia

    

 % overlay curvealign result with on the original image
 if iN == 6 |iN == 7 |iN == 16 | iN == 20
     CAflag =1 ;
 else
     CAflag = 0;
 end
 
 if CAflag == 1
    figure(53);clf;
    set(gcf,'position',[400 50 512 512]);
    set(gcf,'PaperUnits','inches','PaperPosition',[0 0 pix/128 pix/128])
    imshow(IS1); colormap gray; axis xy; hold on;
 
   %ym: param to be determined is pkeep

    jj = 0;
    pkeeptest(1:9) = [ 0.0041    0.0050    0.0048    0.0090    0.0074    0.0024    0.0028    0.0091    0.0047]; %pks = 10
    pkeeptest(10:15) = [ 0.0010    0.0100    0.0100    0.0097    0.0100    0.0097];
%   pkeeptest(3) = 0.0088;
    pkeeptest(6) = 0.01;
    pkeeptest(7) = 0.0091; % 0.0028
    pkeeptest(8) = 0.0091;
    pkeeptest(16) = 0.01;
    pkeeptest(20) = 0.008;
    
    for pkeep = pkeeptest(iN)%: 0.0005: 0.01 

    if iN == 0 |iN == 7 |iN == 16 | iN == 20
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

           plot([xc1 xc2],[yc1 yc2],'g-','linewidth',0.7); % show curvelet center
           hold on
           axis([1 pix 1 pix])
    end
    
    set(gca, 'visible', 'off')
 %   title(sprintf('Extracted %d fibers for REC image, length>%d(pixel)',LFa,LL1),'fontsize',12);
%      print('-dtiff', '-r128', 'lineplotIMGrec.tif');
     print('-dtiff', '-r128', fOL3); 
 
     
    %% overlay the extracted fibers on the original image
%      
    figure(200+iN*20+iNs); clf;
    set(gcf,'position',[100,50,1152 384]);
    
    subplot(1,3,1)
    mOL3 = imread(fOL3);
    imagesc(mOL3); axis square;
    title3 = sprintf('Overlay of curvelets on image%d(CA)',iN);
    title(title3,'fontsize',12);
    
    subplot(1,3,2)
    mOL1 = imread(fOL1);
    imagesc(mOL1); axis square;
    title1 = sprintf('Overlay of extracted fibers on image%d(FIRE)',iN);
    title(title1,'fontsize',12);
    
    subplot(1,3,3)
    mOL1 = imread(fOL2);
    imagesc(mOL1); axis square;
    title2 = sprintf('Overlay of extracted fibers on image%d(CT+FIRE)',iN);
    title(title2,'fontsize',12);
    home
    disp(sprintf('overlayed images, #%d', iN));
    disp('Press any key to continue ...')
    pause
    
  % Zoom in images in a number of random positions 
       iaN = 10; 
       rng(1001); % same random number seed
       isr = rand(iaN,2);
       
      for ia = 1:iaN 
    %    is = [round(pix/(ia+0.2)),round(pix/(ia+0.2))];
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
%          axislim3 = [1 pix 1 pix];
        figure(200+iN*20 + iNs);
        subplot(1,3,1); axis(axislim3);
        subplot(1,3,2); axis(axislim3); 
        subplot(1,3,3); axis(axislim3); 
%         subplot(2,2,3); axis(axislim3); 
        home
        disp(sprintf('zoom in the image, %d of %d', ia, iaN));
        disp('Press any key to continue ...')
        pause
      end   % ia


%     set(gcf,'PaperUnits','inches','PaperPosition',[0 0 2*pix/128 pix/128])
%     print('-dtiff', '-r128', fOL1);
    
%     xlabel('X position (pixel)', 'fontsize',12)
%     ylabel('Y position (pixel)', 'fontsize',12) 
%     title(sprintf('Curvelet center and direction, p=%.4f',pkeep),'fontsize',12)
 else
     % compare FIRE and CT +FIRE
      %% overlay the extracted fibers on the original image
    %      
        figure(200+iN*20+iNs); clf;
        set(gcf,'position',[100,50,1024 512]);

        subplot(1,2,1)
        mOL1 = imread(fOL1);
        imagesc(mOL1); axis square;
        title1 = sprintf('Overlay of extracted fibers on image%d(FIRE)',iN);
        title(title1,'fontsize',12)

        subplot(1,2,2)
        mOL1 = imread(fOL2);
        imagesc(mOL1); axis square;
        title2 = sprintf('Overlay of extracted fibers on image%d(CT+FIRE)',iN);
        title(title2,'fontsize',12)
        home
        disp(sprintf('overlayed images, #%d, %s', iN,scN));
%         disp('Press any key to continue ...')
        pause(3)

      % Zoom in images in a number of random positions 
%            iaN = 10; 
%            rng(1001); % same random number seed
%            isr = rand(iaN,2);
% 
%           for ia = 1: iaN 
%         %    is = [round(pix/(ia+0.2)),round(pix/(ia+0.2))];
%              is = isr(ia,1:2)*pix;
%              isx = is(1);
%              isy = is(2);
%              iw = round(pix/4);
%              ih = iw;
%              if isx+iw > pix
%                  isx = pix - iw;
%              end
% 
%              if isy+ih > pix
%                  isy = pix - ih;
%               end
% 
%               axislim3 = [isx isx+iw isy isy+iw];
%     %         axislim3 = [1 pix 1 pix];
%             figure(200+iN*20+iNs);
%             subplot(1,2,1); axis(axislim3);
%             subplot(1,2,2); axis(axislim3); 
%     %         subplot(2,2,3); axis(axislim3); 
%             home
%             disp(sprintf('zoom in the image, %d of %d', ia, iaN));
%             disp('Press any key to continue ...')
%             pause
%           end   % ia


    %     set(gcf,'PaperUnits','inches','PaperPosition',[0 0 2*pix/128 pix/128])
    %     print('-dtiff', '-r128', fOL1);

     
 end % CAflag 

    catch
        home
        kk = kk +1;
        sskipped(kk) = ii;                   % slice skipped
        disp(sprintf('Test %d is skipped',iN));
        disp('Press any key to continue ...')
         pause

    end    


    end  % iN


end % iNs
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

  
    
    