function  [FLout] = show2Dfibers_0508(data,IS,LL,FNL,SC,pixel,SN)

 % data is from the output from the FIRE_2D_K042612.m
 % IS is the image of a slice
 % LL: length limit(threshold), only choose fiber with length >LL
 % FNL: fiber number limit(threshold), maxium fiber number to be shown
 % pixel: pixel by pixel image
 % SN: slice number
 
%% show the final fibers
pd1 = pwd;
clr = 'rgbmck';
sym = 'o*^s+x';

pix = pixel;
LL1 = LL;    % length limit No.1
LL2 = LL;    % length limit No.2
FNL1 = FNL;  % Fiber Number Limit No.1
FNL2 = FNL;  % Fiber Number Limit No.2


%% case 1
% break

FN = find(data.length>LL1);
FLout = data.length(FN);
LFa = length(FN);

if LFa > FNL1
    LFa = FNL1;
end

figure(8);clf;
set(gcf,'position', [100 100 512 512])

for LL = 1:LFa
    
    VFa.LL = data.Fa(1,FN(LL)).v;
    XFa.LL = data.Xa(VFa.LL,:);
    

     figure(8);
     if mod(LL,6) == 0
         Ci = 6;
     else
     Ci = mod(LL,6);
     end
     
     Si = ceil(LL/6);
     
    figure(8);
%      plot3(XFa.LL(:,1),abs(XFa.LL(:,2)-512),XFa.LL(:,3),[clr(Ci),sym(Si),'-'],'linewidth',2);
    
    plot(XFa.LL(:,1),abs(XFa.LL(:,2)-pix-1), '-','linewidth',2);
    set(gca,'colororder',rand(1,3));
    hold on
        
    
    
end
title(sprintf('Extracted %d fibers with lengths > %d (pixel) by FIRE',LFa,LL1),'fontsize',12);
axis([1 pix 1 pix]);
axis square
xlabel('X position (pixel)', 'fontsize',12)
ylabel('Y position (pixel)', 'fontsize',12)



%% case 2
% break

FN = find(data.length>LL2);
LFa = length(FN);
figure(9);clf;
set(gcf,'position', [100 200 512 512])
clr = 'rgbmck';
% clr = 'rgbmckrbcy'


for LL = 1:LFa
    
    VFai.LL = data.Fai(1,FN(LL)).v;
    XFai.LL = data.Xai(VFai.LL,:);
    
    if LL <= 200
%        figure(LL+1) 
     if mod(LL,6)== 0
        Ci = 6;
    else
        Ci = mod(LL,6);
    end
    figure(9);
   
    plot(XFai.LL(:,1),abs(XFai.LL(:,2)-pix-1), '-','linewidth',2);
    set(gca,'colororder',rand(1,3));
    hold on
        
    end
    
end
  title('Interpolation of the extracted longest fiber(s) by FIRE')
  axis([1 pix 1 pix]);
  axis square
  title(sprintf('Interpolated extracted fibers by FIRE '),'fontsize',12)
  xlabel('X position (pixel)', 'fontsize',12)
  ylabel('Y position (pixel)', 'fontsize',12)


  
figure(20);clf;
set(gcf,'position', [700 100 512 512])
imagesc(IS,SC);colormap gray;
axis square
title(sprintf('Original image, test0%d',SN),'fontsize',12)
xlabel('X position (pixel)', 'fontsize',12)
ylabel('Y position (pixel)', 'fontsize',12)

% set(gcf,'PaperUnits','inches','PaperPosition',[0 0 8 8])
% print('-dtiff', filename2, '-r64');
% IS2 = imread(filename2);
% figure(21);clf;
% imagesc(IS2);colormap gray;
figure(8);figure(20)
cd(pd1)
% 



