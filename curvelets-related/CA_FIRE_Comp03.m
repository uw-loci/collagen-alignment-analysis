%% to automatially choose the coeff. percentage of P in CurveAlign program
%% kstest2 is used to compare the output angle distributions until it has no significant change 
%% Yuming Liu 
clear;
close all;
home
LWon = 0;   % lenght weight(LW), LWon=1: consdier add LW; LWon=0: not consdier LW
hn = 2;     % 1: hist normalized by max frequency; 2: hist normalized by frequency area
hnplot = 0;  % 1: plot each normalized hist; 0: do not plot 
FS0 = 1;   % fraction of the sample 0
FS1 = 1;   % fraction of the sample 1
FS2 = 0.05;   % fraction of the sample 2


err0 = 1E-3;   % Mean Square Error between the real angles and the CA angles
err1 = 1E-5;   % MSE of CA angles with adjactent parameter "pkeep"
% bins = -5:10:175;
% edges = 5:10:180;

 LLf = 30; %Length limit(threshold) for FIRE, only choose fiber with length >LLf
FNL = 200; %: Fiber number limit(threshold), maxium fiber number to be shown

% load true angles
dir1 = 'F:\UW-MadisonSinceFeb_01_2012\download\testimages\';
dir2 = 'F:\UW-MadisonSinceFeb_01_2012\download\testresults\';
dir3 = 'F:\UW-MadisonSinceFeb_01_2012\download\testcontrols\';

%
fileN(1).name = 'Substack (5)_L200N50A2.tif';   
fileN(2).name = 'N50L200AUniC.tif';
fileN(3).name = 'Substack (110)_Kgel5.tif';
fileN(4).name = '11250_SKOV_Substack (8).tif';
fileN(5).name = 'Substack (103)_tissue_SHG_J1.tif';       % size: 512 by 512
fileN(6).name = '12_30_08 Slide 1B-c7-01_C2.tiff';       % size: 512 by 512
fileN(7).name = 'TACS-3a.tif';       % size: 600 by 600
fileN(8).name = 'TACS-3b.tif';       % size: 600 by 600
fileN(9).name = 'R_62211_40x_2z_64mw_ser1_a1_angle000.tif';  % size: 512 by 512
fileN(10).name = 'JSim_test10.tif';  % size: 1024 by 1024
fileN(11).name = 'CP_Test_Image1.tif';  % size: 1024 by 1024
fileN(12).name = 'CP_Test_Image2.tif';  % size: 1024 by 1024
fileN(13).name = 'CP_Test_Image2Noise.tif';  % size: 1024 by 1024
fileN(14).name = 'CP_Test_Image4.tif';  % size: 1024 by 1024
fileN(15).name = 'CP_Test_Image5.tif';  % size: 1024 by 1024

iNF  = 4%1:15 % 1:length(fileN)

for iN = iNF
    iIFa = 1;
%     % show angles of individual fibers extracted by FIRE
%     if iN == 1 |iN == 2 |iN == 3 |iN == 4 |iN == 10 |iN == 11|iN ==15
%         iIFa = 1
%     else
%         iIFa = 0
%     end
    
    if iN <10      
        edges = 5:10:175;
    elseif iN == 15
        edges = 0:10:170;
    else
        edges = 10:10:180;
    end
    
   fname0 = [dir3,sprintf('test%d-control.mat',iN)];
   fname1 = [dir2,sprintf('test%d-FIREang.mat',iN)];
   fmat = [dir2,sprintf('test%d-FIREout.mat',iN)];

   figname = [dir1, fileN(iN).name];

   load(fname0);
   load(fname1,'angEALL','angIALL');
   load(fmat,'data');
   IMG = imread(figname);
   fclose all;
   
    if length(size(IMG)) > 2
          IS =IMG(:,:,1);
    else
        IS = IMG;
    end
    pix = size(IS,1);
    
%     LLf = 30 % round(pix/20); %Length limit(threshold) for FIRE, only choose fiber with length >LLf

    
    axislim1 = [1 pix   1 pix];
    axislim2 = [pix/2 pix/2+100 pix/2 pix/2+100];
    axislim = 1; % chose image/figure axis limit   
        
   figure(100+iN);clf;
   set(gcf,'position',[100 100 768 768])
% show original image   
    subplot(2,2,1)
    ISflip = flipud(IS);
    imagesc(ISflip);colormap gray;
    axis xy
    
    if axislim ==1
        axis(axislim1);
    else
        axis(axislim2);
    end
    
    axis square
    title(sprintf('Original image, test%d',iN),'fontsize',12)
    xlabel('X position (pixel)', 'fontsize',12)
    ylabel('Y position (pixel)', 'fontsize',12) 

%show FIRE fiber

    FN = find(data.M.L>LLf);
    FLout = data.M.L(FN);
    LFa = length(FN);

    if LFa > FNL
        LFa = FNL;
    end

    for ii = 1:LFa

        VFa.LL = data.Fa(1,FN(ii)).v;
        XFa.LL = data.Xa(VFa.LL,:);
        
        figure(100+iN); subplot(2,2,2)
        plot(XFa.LL(:,1),pix+1-XFa.LL(:,2), '-','linewidth',2);
        set(gca,'colororder',rand(1,3));
        hold on

    end
    title(sprintf('Extracted %d fibers with lengths > %d (pixel) by FIRE',LFa,LLf),'fontsize',12);
    
    if axislim ==1
        axis(axislim1);
    else
        axis(axislim2);
    end
    
    axis square
    xlabel('X position (pixel)', 'fontsize',12)
    ylabel('Y position (pixel)', 'fontsize',12)
    
          
    if LWon == 0

        x0 = testcon.degree;
        Lx0 = length(x0);
    else
        x0 = testcon.degreeLW;
        Lx0 = round(length(x0)*FS0);
    end

    [N0,NN0] = histnorm2(x0,edges,hn,hnplot);
    x0r = randsample(x0,Lx0);
    
    if iIFa == 1
        x1 = angEALL'*180/pi;  % individual fiber
    else
        x1 = angIALL*180/pi;   % fiber segments
    end
    
    Lx1 = length(x1)*FS1;
    [N1,NN1] = histnorm2(x1,edges,hn,hnplot);
    x1r = randsample(x1,Lx1);

    % KStest2 parameters
    alpha = 0.05;
    tail = 'unequal';

    %ym: param to be determined is pkeep

    jj = 0;
    pkeeptest(1:9) = [ 0.0041    0.0050    0.0048    0.0090    0.0074    0.0024    0.0028    0.0091    0.0047]; %pks = 10
    pkeeptest(10:15) = [ 0.0010    0.0100    0.0100    0.0097    0.0100    0.0097];
%   pkeeptest(3) = 0.0088;
    % pkeeptest(8) = 0.005;
%     pkeeptest(10) = 0.001;
%     pkeeptest(11) = 0.005;
%      pkeeptest(15) = 0.002;
    
    for pkeep = pkeeptest(iN)%: 0.0005: 0.01

    [object, Ct, inc] = newCurv(IS,pkeep);

    angs = vertcat(object.angle);
    angles = group5(angs,inc);
    % bins = min(angles):inc:max(angles);                
    % [n xout] = hist(angles,bins); imHist = vertcat(n,xout);
    temp = ifdct_wrapping(Ct,0);
    recon = real(temp);
    reconflip = flipud(recon);
    
    figure(100+iN); subplot(2,2,3); 
%     imshow(recon); 
    imagesc(reconflip);
    axis xy
 
     if axislim ==1
        axis(axislim1);
    else
        axis(axislim2);
     end
    
    axis square
    xlabel('X position (pixel)', 'fontsize',12)
    ylabel('Y position (pixel)', 'fontsize',12) 
    title(sprintf('Reconstruction by CurveAlign, test%d, p=%.4f',iN,pkeep),'fontsize',12)
    
    
    figure(100+iN);subplot(2,2,4); 
    deltax = pix/128;
    for ii = 1:length(object)
           ca = object(ii).angle*pi/180;
           xc = object(ii).center(1,2);
           yc = pix+1-object(ii).center(1,1);
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

           plot([xc1 xc2],[yc1 yc2],'k-','linewidth',0.8); % show curvelet center
           hold on
          
    end
    
    if axislim ==1
            axis(axislim1);
        else
            axis(axislim2);
     end
    
    axis square
    xlabel('X position (pixel)', 'fontsize',12)
    ylabel('Y position (pixel)', 'fontsize',12) 
    title(sprintf('Curvelet center and direction, test%d, p=%.4f',iN,pkeep),'fontsize',12)
   
    
%      pause(5)
     
    
%     saveRecon = fullfile(tempFolder,strcat(imgName,'_reconstructed'));
%     fmt = getappdata(imgOpen,'type');
%     imwrite(recon,saveRecon,fmt)
    
    
    CAresult = angles;
    CAresulta = CAresult;
    N2 = find(CAresult<0);
    CApi = find(CAresult >180);
    CAresulta(N2) = 180 + CAresult(N2);
    CAresulta(CApi) = CAresult(CApi)-180;
    [N2,NN2] = histnorm2(CAresulta,edges,hn,hnplot);

    x2 = CAresulta;
    Lx2 = round(length(x2)*FS2);
    x2r = randsample(x2,Lx2);


    [H02r, pValue02r, KS02r] = kstest2(x0r, x2r, alpha, tail);

    jj = jj +1;

    ResNN2(:,jj)= NN2;
    ResN2 (:,jj) = N2;
    ResMSE(jj,1) = jj;
    ResMSE(jj,2) = pkeep;

    ResKSt(jj,1) = jj;
    ResKSt(jj,2) = pkeep;
    ResKSt(jj,3) = +H02r;
    ResKSt(jj,4) = pValue02r;
    ResKSt(jj,5) =  KS02r;
    ResKSt(jj,6) =  Lx0;
    ResKSt(jj,7) =  Lx2;


    disp(sprintf('jj = %d, pkeep = %f',jj,pkeep))

    MSE20 = (NN2-NN0)'*(NN2-NN0)/(length(edges)+1);

    ResMSE(jj,4) = MSE20;

    ResKSt(jj,8) =  MSE20;

    % if jj > 1
    %     
    %     MSE1 = (ResNN2(:,jj)- ResNN2(:,jj-1))'*(ResNN2(:,jj)- ResNN2(:,jj-1))/(length(edges)+1);
    %     ResMSE(jj,3) = MSE1;
    %         
    %     if MSE20 < err0 && MSE1< err1
    %         disp(sprintf(' Optima coeff percentage is %f,  = %f',pkeep, MSE1))
    %         disp(sprintf(' Stop loop'))
    %         break
    %            
    %     end
    % else
    %     
    %    ResMSE(jj,3) = 999;
    %    
    %             
    % end   % jj

       disp(sprintf(' searching optima curvelet coeffs...,MSE20 = %f,KSH = %d, KSpv = %f, KSS = %f',MSE20,+H02r,pValue02r,KS02r))


    end   % keep

    [H01r, pValue01r, KS01r] = kstest2(x0r, x1r, alpha, tail);
    MSE10 = (NN1'-NN0)'*(NN1'-NN0)/(length(edges)+1);
    testresults = [MSE20 pValue02r MSE10 pValue01r]'
    test(iN).finalresult = testresults;
    testcomp(:,iN)= testresults;
    
    figure(iN);clf; 
    set(gcf,'position',[50+iN*10 100+20*iN 900 350])
    subplot(1,3,1)
    bar(edges,NN0,'histc');
    axis square
    xlim([edges(1) edges(end)]);
    title(sprintf('Control angle hist,test%d',iN'),'fontsize',12)
    xlabel('Angle(degree)','fontsize',12)
    ylabel('Normalized Frequency','fontsize',12)
    
    subplot(1,3,2)
    bar(edges,NN2,'histc');
    axis square
    xlim([edges(1) edges(end)]);
    title(sprintf(' Angle hist by CurveAlign,test%d',iN'),'fontsize',12)
    xlabel('Angle(degree)','fontsize',12)
    ylabel('Normalized Frequency','fontsize',12)
    
    subplot(1,3,3)
    bar(edges,NN1,'histc');
    axis square
    xlim([edges(1) edges(end)]);
    title(sprintf('Angle hist by FIRE,test%d',iN'),'fontsize',12)
    xlabel('Angle(degree)','fontsize',12)
    ylabel('Normalized Frequency','fontsize',12)
    
    cas = sprintf('MSE = %.4f,  P = %.4f',MSE20,pValue02r);
    annotation(figure(iN),'textbox',[0.41 0.05 0.2 0.075],'string',cas,'LineStyle','none','color','r');
    fis = sprintf('MSE = %.4f,  P = %.4f',MSE10,pValue01r);
    annotation(figure(iN),'textbox',[0.70 0.05 0.2 0.075],'string',fis,'LineStyle','none','color','r');


     pause
% compare local 'zoom in' figures
  figure(100+iN);
  iaN = 41;
  for ia = 1: iaN
%      is = [round(pix/(ia+0.2)),round(pix/(ia+0.2))];
     is = rand(1,2)*pix;
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
     subplot(2,2,1); axis(axislim3)
    subplot(2,2,2); axis(axislim3)
    subplot(2,2,3);axis(axislim3)
    subplot(2,2,4);axis(axislim3)
    home
    disp(sprintf('zoom in the image, %d of %d', ia, iaN));
    disp('Press any key to continue ...')
    pause
  end
end   %  iN

resulttosave = testcomp';
% saveresults = [dir2,'finalresults0527.mat'];
% save(saveresults,'resulttosave');

%MSE and Pvalue consistent?
% CAmse = resulttosave(:,1);
% FIREmse = resulttosave(:,3);
% CApv = resulttosave(:,2);
% FIREpv = resulttosave(:,4);
% figure(25);clf
% set(gcf,'position',[50 100 900 450])
% subplot(1,2,1)
% plot(CAmse,'ro-','linewidth',2);
% hold on
% plot(FIREmse,'bo-','linewidth',2);
% legend('CurveAlign','FIRE','fontsize',12,'location','north')
% axis square
% title(sprintf('Mean Square Error(MSE) of Histograms'),'fontsize',12)
% xlabel('Test case number(#)','fontsize',12)
% ylabel('MSE value(a.u.)','fontsize',12)
% 
% subplot(1,2,2)
% plot(CApv,'ro-','linewidth',2);
% hold on
% plot(FIREpv,'bo-','linewidth',2);
% legend('CurveAlign','FIRE','fontsize',12,'location','north')
% axis square
% title(sprintf('P value of KS-test'),'fontsize',12)
% xlabel('Test case number(#)','fontsize',12)
% ylabel('P value(-)','fontsize',12)

%length dependence
% figure(28);clf
% set(gcf,'position',[50 100 400 200])
% CANN2 = NN2([1 2 4 7 8 10]);
% CANN2n = CANN2/max(CANN2);
% LenT15 = [336.856
% 374.775
% 386.083
% 1138.771
% 1040.755
% 435.036
% ];
% LenT15n = LenT15/max(LenT15);
% 
% plot(CANN2n,'ro-','linewidth',2);
% hold on
% plot(LenT15n,'bo-','linewidth',2);
% legend('angle frequecy ','fiber length','fontsize',12,'location','west')
% % axis square
% title(sprintf('Dependency of angle frequency on fiber length  '),'fontsize',12)
% xlabel('Angle number(#)','fontsize',12)
% ylabel('Normalized value(-)','fontsize',12)




