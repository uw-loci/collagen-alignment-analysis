%% load .tif image stack
% FIRE_2D_050812_Bbat
clear
home
teston = 1 ;  % 0: use the FIRE images; 1: use our test images

cd H:\UW-MadisonSinceFeb_01_2012\download\FIRE\example;
pd1 = pwd;
addpath(genpath('../')); 

%% Testing FIRE
    
 if teston
     tic
         
     dir1 = 'H:\UW-MadisonSinceFeb_01_2012\download\testimages\';
     dir2 = 'H:\UW-MadisonSinceFeb_01_2012\download\testresults\';
     fileN(1).name = 'Substack (5)_L200N50A2.tif';   
     fileN(2).name = 'N50L200AUniC.tif';
     fileN(3).name = 'Substack (110)_Kgel5.tif';
     fileN(4).name = '11250_SKOV_Substack (8).tif';
     fileN(5).name = 'Substack (103)_tissue_SHG_J1.tif';       % size: 512 by 512
     fileN(6).name = '12_30_08 Slide 1B-c7-01_C2.tiff';       % size: 512 by 512
     fileN(7).name = 'TACS-3a.tif';       % size: 600 by 600
     fileN(8).name = 'TACS-3b.tif';       % size: 600 by 600
     fileN(9).name = 'R_62211_40x_2z_64mw_ser1_a1_angle000.tif';  % size: 512 by 512
iNF = 1%[1:9];  % iN numbers in Fire
for iN = iNF  
    fname =[dir1, fileN(iN).name];
    fmat = [dir2,sprintf('test%d-FIREout.mat',iN)];
    ffigO = [dir2,sprintf('test%d-FIREfigO.tif',iN)]; % original figure
    ffigE = [dir2,sprintf('test%d-FIREfigE.tif',iN)]; % extracted figure
    %fire parameters
     p.path = pd1;
     p = param_example_2D_0502B(p);
     
    info = imfinfo(fname);
    num_images = numel(info);
    
    % IS is the image of a slice
    LL= 30; %length limit(threshold), only choose fiber with length >LL
    FNL = 200; %: fiber number limit(threshold), maxium fiber number to be shown
    %
    % maually set the image size to be read
%     pix = 512; % pixel: pixel by pixel image
    if iN == 1 |iN == 2|iN == 6
        pix = 1024;
    elseif iN == 7 |iN == 8
        pix = 600; 
    else
        pix = 512;
    end
    
    % initialization 
    ImgL = [200,1000];
    OUT = [];
    kk = 0;
    IS1 =[];
    IS = [];
    im3 = [];
   for ii = 1; %1:num_images

   if iN == 6| iN == 7| iN ==8 

       IS1 = imread(fname);   
       IS =IS1(:,:,1);
   else
       IS = imread(fname,ii,'PixelRegion', {[1 pix] [1 pix]});   
   end
     

    disp(sprintf('reading slice %d of %d ',ii,num_images))
    im3(1,:,:) = IS;

    ISresh = sort(reshape(IS,1,pix*pix));        
    Ith(ii,1:15) = ISresh(ceil(pix*pix*[0.85:0.01:0.99]));
    p.thresh_im2= ISresh(ceil(pix*pix*0.85));

    if iN == 1 | iN == 2 
        p.thresh_im2 = 50;
    elseif iN == 6
        p.thresh_im2 = 20;
    end
%         Llow = p.thresh_im2-400;
    Llow = 0;%p.thresh_im2-20;
    Lup =  ISresh(ceil(pix*pix*0.99));
    ImgL = [Llow,Lup];

try
%run main FIRE code
     figure(1); clf
     data = fire_2D_ang1(p,im3,0);  %uses im3 and p as inputs and outputs everything listed below
     home
     disp(sprintf('Image of Test%d has been processed',iN))

     OUT(ii).length = data.M.L;
     OUT(ii).Xa = data.Xa;
     OUT(ii).Fa = data.Fa;
     OUT(ii).Xai = data.Xai;
     OUT(ii).Fai = data.Fai;
%      OUT(ii).angxy = data.M.Fang.angle_xy;
%      OUT(ii).angxyI = data.M.FangI.angle_xy;
%      

    show2Dfibers_0508(OUT(ii),IS,LL,FNL,ImgL,pix,iN);
    disp('Press any key to continue ...')
     pause
    
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

% save(fmat,'data','fname','iN','p');
     
     
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

  
    
    