function  [FLout] = show2Dfibers_0530(data,IS,LL,FNL,pixel,SC,SN,imgname)

 % data is from the output from the FIRE_2D_K042612.m
 % IS is the image of a slice
 % LL: length limit(threshold), only choose fiber with length >LL
 % FNL: fiber number limit(threshold), maxium fiber number to be shown
 % pixel: 1x2 array, pixel-width by pixel-height image
 % SC: scale of the image
 % SN: slice number
 
pixw = pixel(1);
pixh = pixel(2);
LL1 = LL;    % length limit No.1
LL2 = LL;    % length limit No.2
FNL1 = FNL;  % Fiber Number Limit No.1
FNL2 = FNL;  % Fiber Number Limit No.2
plotboth = 0 % plot both original image and the FIRE



 %% show the final fibers
pd1 = pwd;
iSN = 0;
figure(100+iSN);clf;
set(gcf,'position', [100 100 1024 768])

if plotboth
subplot(1,2,1)
IS = flipud(IS);
imagesc(IS,SC);colormap gray;
axis xy;
axis equal
axis([1 pixw 1 pixh]);
titlename = imgname(20:end-5);
titlenameS = strrep(titlename,'_','\_');
title(sprintf('reg...%s.tiff,#%d',titlenameS,SN),'fontsize',12)
xlabel('X position (pixel)', 'fontsize',12)
ylabel('Y position (pixel)', 'fontsize',12) 
 
%show FIRE fiber

FN = find(data.M.L>LL1);
FLout = data.M.L(FN);
LFa = length(FN);

if LFa > FNL1
    LFa = FNL1;
end

for LL = 1:LFa
    
    VFa.LL = data.Fa(1,FN(LL)).v;
    XFa.LL = data.Xa(VFa.LL,:);
   

    subplot(1,2,2);
    
    plot(XFa.LL(:,1),abs(XFa.LL(:,2)-pixh-1), '-','linewidth',2);
    set(gca,'colororder',rand(1,3));
    hold on
            
end
title(sprintf('Extracted %d fibers with lengths > %d (pixel) by FIRE',LFa,LL1),'fontsize',12);
axis equal;
axis([1 pixw 1 pixh]);
xlabel('X position (pixel)', 'fontsize',12)
ylabel('Y position (pixel)', 'fontsize',12)

% pause
% disp('press any key to continue ...')
% 
%    if 0
%      figure(100+SN);
%      iaN = 40;
%     for ia = 1: iaN
%      is = [round(pixw/(ia+0.2)),round(pixh/(ia+0.2))];
% %       is = [1 1]
%      isx = is(1);
%      isy = is(2);
%      iw = round(pixh/8);
%      axislim3 = [isx isx+iw isy isy+iw];
%     figure(100+SN);
%     subplot(1,2,1); axis(axislim3)
%     subplot(1,2,2); axis(axislim3)
%     home
%     disp(sprintf('zoom in the image, %d of %d', ia, iaN));
%     disp('Press any key to continue ...')
%     pause
%   end
%     end
% 

else 
    
    FN = find(data.M.L>LL1);
    FLout = data.M.L(FN);
    LFa = length(FN);

    if LFa > FNL1
        LFa = FNL1;
    end

    for LL = 1:LFa

        VFa.LL = data.Fa(1,FN(LL)).v;
        XFa.LL = data.Xa(VFa.LL,:);
        plot(XFa.LL(:,1),abs(XFa.LL(:,2)-pixh-1), '-','linewidth',2);
        set(gca,'colororder',rand(1,3));
        hold on

    end
    title(sprintf('Extracted %d fibers with lengths > %d (pixel) by FIRE',LFa,LL1),'fontsize',12);
    axis equal;
    axis([1 pixw 1 pixh]);
    xlabel('X position (pixel)', 'fontsize',12)
    ylabel('Y position (pixel)', 'fontsize',12)


end

    
