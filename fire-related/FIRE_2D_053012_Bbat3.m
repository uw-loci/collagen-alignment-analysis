%% load .tif image stack
% FIRE_2D_050812_Bbat
clear
home
teston = 1 ;  % 0: use the FIRE images; 1: use our test images

% cd C:\Users\yuming\Documents\MATLAB\FIRE\example;
pd1 = pwd;
addpath(genpath('../')); 

%% Testing FIRE
    
 if teston
     tic
         
     dir1 = 'C:\Users\yuming\Slide 2B man reg\';
     dir2 = 'C:\Users\yuming\Slide 2B man reg\';
     imagenames = [dir1 'reg*.tiff'];
     Fnum = dir(imagenames);
        
%     firePara(13).name = 'para_test13.m'

    iNF = 1:length(Fnum);%[11 22] %11:15;  % iN numbers in Fire
for iN = iNF 
    fname0 = Fnum(iN).name;
    fname =[dir1, fname0];
    fmat = [dir2,'FIREdata_',fname0(1:end-5),'.mat'];
%     ffigO = [dir2,sprintf('test%d-FIREfigO.tif',iN)]; % original figure
%     ffigE = [dir2,sprintf('test%d-FIREfigE.tif',iN)]; % extracted figure
    %fire parameters
     p.path = pd1;
     p = param_reg1_0530(p);
     
    info = imfinfo(fname);
    num_images = numel(info);
    pixw = info(1).Width;  % find the image size
    pixh = info(1).Height;   
    pix = [pixw pixh];
    % IS is the image of a slice
    LL = 30; %length limit(threshold), only choose fiber with length >LL
    FNL = 800; %: fiber number limit(threshold), maxium fiber number to be shown
    %
    % maually set the image size to be read
%     if iN == 1 |iN == 2|iN == 6
%         pix = 1024;
%     elseif iN == 7 |iN == 8
%         pix = 600; 
%     else
%         pix = 512;
%     end
    
    % initialization 
    ImgL = [0,100];
    OUT = [];
    kk = 0;
    IS1 =[];
    IS = [];
    im3 = [];
   for ii = 1; %1:num_images

   if iN == 0
        IS = imread(fname,ii,'PixelRegion', {[1 pixw] [1 pixh]});   
   else
      IS1 = imread(fname);  
      if length(size(IS1)) > 2
          IS =IS1(:,:,1);
      else
        IS = IS1;
      end
   end
     
    disp(sprintf('reading slice %d of %d ',ii,num_images))
    im3(1,:,:) = IS;

    ISresh = sort(reshape(IS,1,pixw*pixh));        
    Ith(ii,1:15) = ISresh(ceil(pixw*pixh*[0.85:0.01:0.99]));
    p.thresh_im2= ISresh(ceil(pixw*pixh*0.90));
   

%     if iN == 1 | iN == 2 | iN == 10 
%         p.thresh_im2 = 50;
%     elseif iN == 6
%         p.thresh_im2 = 20;
%     elseif iN == 11 | iN == 12 | iN == 13 | iN == 14 | iN == 15 
%          p.thresh_im2 = 100;        
%     end
%         Llow = p.thresh_im2-400;
    Llow = 0; %p.thresh_im2-20;
    Lup =  p.thresh_im2*2;
    ImgL = [Llow,Lup];
   clear ISresh
try
%run main FIRE code
     figure(1); clf
     data = fire_2D_ang1(p,im3,0);  %uses im3 and p as inputs and outputs everything listed below
     home
     disp(sprintf('Image -%s: Test%d of %d has been processed',fname0,iN,length(Fnum)))

%      OUT(ii).length = data.M.L;
%      OUT(ii).Xa = data.Xa;
%      OUT(ii).Fa = data.Fa;
%      OUT(ii).Xai = data.Xai;
%      OUT(ii).Fai = data.Fai;
%      OUT(ii).angxy = data.M.Fang.angle_xy;
%      OUT(ii).angxyI = data.M.FangI.angle_xy;
%      

    show2Dfibers_0530(data,IS,LL,FNL,pix,ImgL,iN,fname0);

    
    firefigN = [dir1, 'FIREfig_',fname0]; 
    print('-dtiff', '-r600', firefigN);
    
%     disp('Press any key to continue ...')
%     pause
    save(fmat,'data','fname','fname0','iN','p','LL');
 
% print -dtiff -r600 'test2.tif';
% set(gcf, 'Renderer', 'ZBuffer')
%% Overlay two images
% figure(8)
% print('-dtiff','-r300', ffigE)
% figure(20)
% print('-dtiff','-r300', ffigO)
% ISO = imread(ffigO);
% ISE = imread(ffigE);
% figure(22);clf;
% imagesc(ISO);colormap gray; 
% hold on
% h = imagesc(ISE);colormap copper; 
% set(h, 'AlphaData', 0.5);
%  pause

     
     
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
       
       
   fclose all;
   
%    cd(pd1);
%    
%     outsave = [fileN, '-result.mat'];
%     save(outsave,'OUT','fileN')
    
   
 %% plot thresholds for all each slices
%  figure(3);clf;
%  set(gcf,'position',[100 100 800 600])
%  clr= 'rgbmck'
%  Thd = Ith(:,[1 6 10 11 13 15]);
%  for i = 1:6
%      plot(Thd(:,i),[clr(i),'o-'],'linewidth',2)
%      hold on
%  end
%  title('Choose intensity threshold for stack gel05','fontsize',14) 
%  xlabel('Slice number(#)','fontsize',14);
%  ylabel('Intensity (a.u.)','fontsize',14);
% %  set(gca,'fontsize',18)
%  axis equal
%  legend('85%limit','90%limit','94%limit','95%limit','97%limit','99%limit')
%  %% 

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

  
    
    