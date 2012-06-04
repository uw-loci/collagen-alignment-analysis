function  [FLout] = show2Dfibers_0508(data,IS,LL,FNL,pixel,SN)

 % data is from the output from the FIRE_2D_K042612.m
 % IS is the image of a slice
 % LL: length limit(threshold), only choose fiber with length >LL
 % FNL: fiber number limit(threshold), maxium fiber number to be shown
 % pixel: pixel by pixel image
 % SN: slice number
 
pix = pixel;
LL1 = LL;    % length limit No.1
LL2 = LL;    % length limit No.2
FNL1 = FNL;  % Fiber Number Limit No.1
FNL2 = FNL;  % Fiber Number Limit No.2

 %% show the final fibers
pd1 = pwd;
figure(100+SN);clf;
set(gcf,'position', [100 100 1024 512])
 
subplot(1,2,1)
imagesc(IS);colormap gray;
axis square
title(sprintf('Original image, test0%d',SN),'fontsize',12)
xlabel('X position (pixel)', 'fontsize',12)
ylabel('Y position (pixel)', 'fontsize',12) 
 
%show FIRE fiber

FN = find(data.length>LL1);
FLout = data.length(FN);
LFa = length(FN);

if LFa > FNL1
    LFa = FNL1;
end

for LL = 1:LFa
    
    VFa.LL = data.Fa(1,FN(LL)).v;
    XFa.LL = data.Xa(VFa.LL,:);
   

    figure(100+SN); subplot(1,2,2)
    
    plot(XFa.LL(:,1),abs(XFa.LL(:,2)-pix-1), '-','linewidth',2);
    set(gca,'colororder',rand(1,3));
    hold on
    
    
 
    
end
title(sprintf('Extracted %d fibers with lengths > %d (pixel) by FIRE',LFa,LL1),'fontsize',12);
axis([1 pix 1 pix]);
axis square
xlabel('X position (pixel)', 'fontsize',12)
ylabel('Y position (pixel)', 'fontsize',12)


cd(pd1)
% 



