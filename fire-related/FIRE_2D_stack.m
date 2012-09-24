% FIRE_2D_stack.m
% Process image stack, by FIRE and/or CTpFIRE
% Sept 2012, Yuming Liu, LOCI, UW-Madison

tic
clear; close all; home
teston = 1 ;  % 0: use the FIRE images; 1: use customized images

% cd D:\UW-MadisonSinceFeb_01_2012\download\FIRE\example;
pd1 = pwd;
addpath(genpath('../')); 

kk =0; 

%folders
dir4 = ['Z:\liu372\images\Karissa\CTpFIRE\testcases\testoverlay\'];
dir5 = ['Z:\liu372\images\Karissa\CTpFIRE\testcases\testimages\'];
dir6 = ['Z:\liu372\images\Karissa\CTpFIRE\testcases\testresults\'];
dir7 = ['Z:\liu372\images\Karissa\CTpFIRE\testcases\testcontrols\'];

% image stacks to be processed
fileN(1).name = '10ng_mL_FW_substack_SHG_ser1.tif';   % 
fileN(2).name = '25ng_mL_FW_substack_SHG_ser1.tif';   % 
fileN(3).name = '50ng_mL_FW_SHG_ser1.tif';   % 
fileN(4).name = 'cells_FW_SHG_ser1.tif';   % 

iNF  = 1;        %  test case(s) to be analyzed
% iSNF = [1];    %  slice(s) to process    
FIREori = 1 ;     % FIREori = 1: run FIRE on original image
FIREct = 1  ;     % FIREct = 1: run FIRE on original image
LW1 = 0.5;         % fiber line width    
  
for iN = iNF   
    
    fname =[dir5, fileN(iN).name];
    fmat1 = [dir6,sprintf('test%d-FIREout.mat',iN)];
    fmat2 = [dir6,sprintf('test%d-FIREoutCTr.mat',iN)];

    fctsr = [dir5, sprintf('test%d-stack_CTR.mat',iN)];  % filename of the curvelet transformed reconstructed image stack
       
    %fire parameters
     p1.path = pd1;
     p2.path = pd1;
   
     p1 = param_com0816(p1);   % set FIRE parameters
     p2 = param_com0816(p2);   % set CT + FIRE parameters
     
% IS is the image of a slice
    LL1 = 15;  %length limit(threshold), only show fibers with length >LL
    FNL = 1999; %: fiber number limit(threshold), maxium fiber number to be shown
    
    info = imfinfo(fname);
    num_images = numel(info);
    pix = info(1).Width;  % find the image size
    iSNF = 10%1:num_images;  % slices to be processed
   
 %% FIRE on original image stack 
     p = p1;           % parameters for FIRE
    % initialization 
    OUT(1,num_images) = struct( 'length', [], 'Xa', [], 'Fa',[],'Xai',[],'Fai',[]);
    mask_ori = [];
    IS1 =[];
    IS = [];
    im3 = [];
    if max(iSNF) > num_images
        home;
        error('please check the number of the slice to be processed')
%         break
    end
 
        for iSN = iSNF %1:num_images
         
         
        IS = imread(fname,iSN,'PixelRegion', {[1 pix] [1 pix]});   
        disp(sprintf('test%d,reading slice %d of %d ',iN,iSN,num_images))
        
        im3(1,:,:) = IS;
        
% automatically set the threshold 
        ISresh = sort(reshape(IS,1,pix*pix));        
        Ith(iSN,1:15) = ISresh(ceil(pix*pix*[0.85:0.01:0.99]));
        p.thresh_im2= ISresh(ceil(pix*pix*0.85));
        p1.thresh_im2 = p.thresh_im2;
% mask_ori to reduce the artifacts in the reconstructed image
        mask_ori(:,:,iSN) = IS > 0.8* p.thresh_im2; 
        
        Llow = p.thresh_im2*0.75;
        Lup =  ISresh(ceil(pix*pix*0.99));
        ImgL = [Llow,Lup];

if FIREori == 1        
  % run FIRE main code on original image
        try               
             figure(1); clf
             data1 = fire_2D_ang1(p,im3,0);  %uses im3 and p as inputs and outputs everything listed below
             data = data1;
             home
             disp(sprintf('test%d on original image, slice %d has been processed',iN, iSN))
             
             OUT(1,iSN).length = data.M.L;
             OUT(1,iSN).Xa = data.Xa;
             OUT(1,iSN).Fa = data.Fa;
             OUT(1,iSN).Xai = data.Xai;
             OUT(1,iSN).Fai = data.Fai;
             
    % overlay FIRE extracted fibers on the original image
           fOL1 =  [dir4, sprintf('test%d_SL%d_OL_FIRE.tif',iN,iSN)]; %filename of overlay 1
           fOL2 =  [dir4, sprintf('test%d_SL%d_OL_CTpFIRE.tif',iN,iSN)]; %filename of overlay 2
            
            figure(51);clf;
            set(gcf,'position',[100 50 512 512]);
            set(gcf,'PaperUnits','inches','PaperPosition',[0 0 pix/128 pix/128]);
            temp = flipud(IS);
            imshow(temp); colormap gray; axis xy; hold on;
        
            
            FN = find(data.M.L > LL1);
            FLout = data.M.L(FN);
            LFa = length(FN);
            if LFa > FNL
                LFa = FNL;
            end
            
            rng(1001); % same random number seed
            clrr1 = rand(LFa,3);
           for LL = 1:LFa

                VFa.LL = data.Fa(1,FN(LL)).v; 
                XFa.LL = data.Xa(VFa.LL,:);

                plot(XFa.LL(:,1),abs(XFa.LL(:,2)-pix-1), '-','color',clrr1(LL,1:3),'linewidth',LW1);

        %          text(XFa.LL(2,1),abs(XFa.LL(2,2)-pix-1),sprintf('%d',LL),'color',clrr1(LL,1:3),...
        %              'VerticalAlignment','baseline', 'HorizontalAlignment','left','fontsize',fst);             
                hold on
                axis equal;
                axis([1 pix 1 pix]);

           end
           set(gca, 'visible', 'off')
           print('-dtiff', '-r128', fOL1);  % overylay FIRE extracted fibers on the original image


        catch
             
            kk = kk +1;
            sskipped1(kk,1) = iN;                    % test Number            
            sskipped1(kk,2) = iSN;                   % slice skipped
            home;disp(sprintf('test%d on original image, slice %d is skipped',iN, iSN));
            pause(3)
                    
        end  % try
        
%         save(fmat1,'OUT','fname','iN','p');
end  % FIREori         
     end    % iSN

if FIREct == 1     
%% FIRE on CT reconstructed image stack 
 
    p = p2; p.thresh_im2 = 0;   p2.thresh_im2 = p.thresh_im2;        % parameters for FIRE
    % initialization 
    OUT(1,num_images) = struct( 'length', [], 'Xa', [], 'Fa',[],'Xai',[],'Fai',[]);
    load(fctsr,'CTsr');  
    
     for iSN = iSNF %1:num_images
   
        IS1 = CTsr(:,:,iSN);
%         IS1 = mask_ori(:,:,iSN).*IS1;
        im3(1,:,:) = IS1;
        home; disp(sprintf('test%d on the CT reconstructed image,reading slice %d of %d ',iN,iSN,num_images))
          
  % run FIRE main code on the CT reconstructed image
        try               
             figure(1); clf
             data2 = fire_2D_ang1(p,im3,0);  %uses im3 and p as inputs and outputs everything listed below
             data = data2;
             home
             disp(sprintf('test%d on original image, slice %d has been processed',iN, iSN))
             OUT(1,iSN).length = data.M.L;
             OUT(1,iSN).Xa = data.Xa;
             OUT(1,iSN).Fa = data.Fa;
             OUT(1,iSN).Xai = data.Xai;
             OUT(1,iSN).Fai = data.Fai;
             
 % overlay FIRE extracted fibers by CT reconstructed image
           fOL2 =  [dir4, sprintf('test%d_SL%d_OL_CTpFIRE.tif',iN,iSN)]; %filename of overlay 2
            
            figure(52);clf;
            set(gcf,'position',[600 50 512 512]);
            set(gcf,'PaperUnits','inches','PaperPosition',[0 0 pix/128 pix/128]);
            temp = flipud(IS);
            imshow(temp); colormap gray; axis xy; hold on;
                    
            FN = find(data.M.L > LL1);
            FLout = data.M.L(FN);
            LFa = length(FN);
            if LFa > FNL
                LFa = FNL;
            end
            
            rng(1001); % same random number seed
            clrr1 = rand(LFa,3);
           for LL = 1:LFa

                VFa.LL = data.Fa(1,FN(LL)).v; 
                XFa.LL = data.Xa(VFa.LL,:);

                plot(XFa.LL(:,1),abs(XFa.LL(:,2)-pix-1), '-','color',clrr1(LL,1:3),'linewidth',LW1);

        %          text(XFa.LL(2,1),abs(XFa.LL(2,2)-pix-1),sprintf('%d',LL),'color',clrr1(LL,1:3),...
        %              'VerticalAlignment','baseline', 'HorizontalAlignment','left','fontsize',fst);             
                hold on
                axis equal;
                axis([1 pix 1 pix]);

           end
           set(gca, 'visible', 'off')
           print('-dtiff', '-r128', fOL2);  % overylay FIRE extracted fibers on the original image

           
        catch
             
            kk = kk +1;
            % recorde skipped slice(s)
            sskipped2(kk,1) = iN;                    % test skiped for CT images          
            sskipped2(kk,2) = iSN;                   % slice skipped for CT images
            home;disp(sprintf('test%d on the CT reconstructed image, slice %d is skipped',iN, iSN));
            pause(3)
                    
        end  % try
        
%         save(fmat2,'OUT','fname','iN','p');
          
     end    % iSN     
end  % FIREct   
end  % iNF


t_run = toc;  
fprintf('total run time = %2.1f minutes\n',t_run/60)

  
    
    