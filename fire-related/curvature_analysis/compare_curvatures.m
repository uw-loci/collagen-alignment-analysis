%% post-process the output of ctFIRE: straight or wavy fibers
clear;clc;home;
pd1 = pwd;
pd2 = 'Z:\liu372\images\HuBrImages\ctFIREout\';
pd3 = 'Z:\liu372\images\forJBOrevision\ctFIREout\results1\';
% pd4 = 'Z:\liu372\images\forJBOrevision\orginalimages2\imagetobeprocessed\ctFIREout3\';
% pd4 = 'C:\CAA_x220\github\curveletsbak\ctFIRE\jboimages\imagecrops\ctFIREout\';
% pd4 = 'Z:\liu372\images\forJBOrevision\imagecrops\';
% pd5 = [pd4,'ctFIREout2\'];
% pd4= 'C:\CAA_x220\github\curveletsbak\ctFIRE\jboimages\m0820\';
% pd4 = 'C:\CAA_x220\github\curveletsbak\ctFIRE\jboimages\imagecrops\';
pd4= 'Z:\liu372\images\forJBOrevision\071913_analysis\images_analyzed\';
pd5 = [pd4 'ctFIREout\'];


OUT1 = dir([pd2,'ctFIREout_NAT*.mat']);
OUT2 = dir([pd2,'ctFIREout_IDC*.mat']);
OUT3 = dir([pd3, 'ctFIREout*crop1.mat']);
OUT4 = dir([pd4,'*.tif']);
OUT5 = dir([pd5,'ctFIREout*.mat']);

%case 3: waviness or straightness

LL1 = 30;   % set length threshold of fibers to be shown
filenum = length(OUT4);
binc = 0.5:0.05:1.0;
wlim = 1.08;

sz0 = get(0,'screensize');
sw0 = sz0(3);
sh0 = sz0(4);

LW1 = 0.5;
LW2 = 2;
plotflag =0;

for i = 1:filenum
    matname1 = [pd5,OUT5(i).name];
    imgname1 = [pd4, OUT4(i).name];
    IS1 = imread(imgname1); IS1 = flipud(IS1);
    fOLws = [pd5,'OLws_ctFIRE_',OUT4(i).name];
    info = imfinfo(imgname1);
    pixw = info(1).Width;  % get the image size
    pixh = info(1).Height;
    pix = [pixw pixh];
%     IS1 = imread(imgname1);
    load(matname1,'data','ctfP');
    wavall = CALwaviness(data);        % waviness for all fibers
    FN = find(data.M.L > LL1);        % apply length threshold
    LFa = length(FN);
    wav = wavall(FN);                 % waviness remained after applying length threshold
    wfnum(i) = length(find(wav>=wlim));% wavy fiber number
    wfrat(i) = wfnum(i)/length(wav);   % percentage of wavy fiber
    strt = wav.^-1; 
%     figure(40+i);clf
%      hist(strt,binc);
%      axis([0.5 1.0 0 100])
         
    if plotflag == 1
        rng(1001) ;
        clrr1 = rand(LFa,3); % set random color
        % overlay FIRE extracted fibers on the original image
        gcf51 = figure(50+i);clf;
        set(gcf51,'name','ctFIRE output: overlaid image, wavy fiber has larger line width','numbertitle','off')
        imshow(IS1); colormap gray; axis xy; hold on;
        
        for LL = 1:LFa
            
            VFa.LL = data.Fa(1,FN(LL)).v;
            XFa.LL = data.Xa(VFa.LL,:);
            if wav(LL) >= wlim
                LW = LW2;   % wavy fiber 
            else
                LW = LW1;    % straight fiber
            end
            plot(XFa.LL(:,1),abs(XFa.LL(:,2)-pixh-1), '-','color',clrr1(LL,1:3),'linewidth',LW);
            hold on
            axis equal;
            axis([1 pixw 1 pixh]);
            
        end
        set(gca, 'visible', 'off')
        set(gcf51,'PaperUnits','inches','PaperPosition',[0 0 pixw/128 pixh/128]);
        print(gcf51,'-dtiff', '-r128', fOLws);  % overylay FIRE extracted fibers on the original image
        set(gcf51,'position',[0.01*sw0 0.2*sh0 0.5*sh0,0.5*sh0*pixh/pixw]);
    end   % plotflag
    
     
end


wfnummean = [mean(wfnum(1:3)) mean(wfnum(4:6)) mean(wfnum(7:9))];
wfratmean = [mean(wfrat(1:3)) mean(wfrat(4:6)) mean(wfrat(7:9))];

wfnumstd = [std(wfnum(1:3)) std(wfnum(4:6)) std(wfnum(7:9))];
wfratstd = [std(wfrat(1:3)) std(wfrat(4:6)) std(wfrat(7:9))];


wf1 = [wfnum;wfrat];
fz = 12;

figure(10);clf;set(gcf,'position',[100 200 800 300]);
subplot(1,2,1);
bar(wfnummean,0.5);
set(gca,'XTickLabel',{'Day 1', 'Day 8', 'Day 25'})
hold on;
h1 = errorbar(wfnummean,wfnumstd);
set(h1,'color','r','linestyle','none','linewidth',4);
title('Wavy fiber number','fontsize',fz);
xlabel('Imaging date','fontsize',fz);
ylabel('Number(#)','fontsize',fz)
axis square

subplot(1,2,2);
bar(wfratmean,0.5);
hold on;
h2 = errorbar(wfratmean,wfratstd);
set(h2,'color','r','linestyle','none','linewidth',4);
set(gca,'XTickLabel',{'Day 1', 'Day 8', 'Day 25'})
title('Wavy fiber percentage','fontsize',fz);
xlabel('Imaging date','fontsize',fz);
ylabel('Percentage(%)','fontsize',fz)

axis square


break

% wf1 = [wfnum;wfrat];
% fz = 12;
% 
% figure(10);clf;set(gcf,'position',[100 200 800 400]);
% subplot(1,2,1);
% plot(wfnum(1:6), 'ro-');
% hold on
% plot(wfnum(7:12),'b*-');
% title('Wavy fiber number','fontsize',fz);
% legend('early stage', 'later stage');
% axis([1 6 0 50]);
% xlabel('Image(#)','fontsize',fz);
% ylabel('Number(#)','fontsize',fz)
% 
% subplot(1,2,2);
% plot(wfrat(1:6), 'ro-');
% hold on
% plot(wfrat(7:12),'b*-');
% title('Wavy fiber percentage','fontsize',fz);
% legend('early stage', 'later stage');
% axis([1 6 0 1]);
% xlabel('Image(#)','fontsize',fz);
% ylabel('Percentage(%)','fontsize',fz)
% 
% break
% 
% 
% % [mean(wfnum(1:3)),std(wfnum(1:3));mean(wfnum(4:6)), std(wfnum(4:6))]
% % [mean(wfrat(1:3)),std(wfrat(1:3));mean(wfrat(4:6)), std(wfrat(4:6))]
% wf2 = [mean(wfnum(1:6)),std(wfnum(1:6));mean(wfnum(7:12)), std(wfnum(7:12))];
% wf3 = [mean(wfrat(1:6)),std(wfrat(1:6));mean(wfrat(7:12)), std(wfrat(7:12))];
% 
% figure(11);clf;set(gcf,'position',[900 500 400 200]);
% subplot(1,2,1);
% % errorbar(wf2(:,1), wf2(:,2));
% bar(wf2(:,1),0.5);
% title('Wave fiber number');
% 
% 
% subplot(1,2,2)
% bar(wf3(:,1),0.5);
% title('Wave fiber percentage');
% 
% % errorbar(wf3(:,1), wf3(:,2));
% 
% 
% 
% 
% 
