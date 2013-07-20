% postposting_2, image show
clear; clc;
% pd1 = 'C:\Users\youmap\Google Drive\CAA_GD\curveletsbak_v1.1_070813\ctFIRE\jboimages\';
% pd1 = 'Z:\liu372\images\forJBOrevision\orginalimages2\imagetobeprocessed\';
% pd1= 'C:\CAA_x220\github\curveletsbak\ctFIRE\jboimages\m0813\';
% pd1= 'C:\CAA_x220\github\curveletsbak\ctFIRE\jboimages\middlestage_0822\imgtobeprocessed\';
% pd1 = 'C:\CAA_x220\github\curveletsbak\ctFIRE\jboimages\imagecrops\';
pd1 = 'Z:\liu372\images\forJBOrevision\071913_analysis\images_analyzed\';
pd2 = [pd1,'ctFIREout\'];

% pd3 = 'Z:\liu372\images\forJBOrevision\imagecrops\ctFIREout2\';
% mkdir(pd3);
% copyfile([pd2 '*.*'],pd3)
% break

% pd4 = 'Z:\liu372\images\forJBOrevision\imagecrops\';
% pd5 = [pd4,'ctFIREout2\'];

pd4 = pd1;
pd5 = pd2;


oriimgs = dir([pd4,'*.tif'])

showall = 0;
showwav = 0;
showwav123 = 1;

for i = 1:length(oriimgs)
    imgname = oriimgs(i).name;
    if showall == 1
    outname = ['OL_ctFIRE_',imgname];
    figure(10+i);clf;set(gcf,'position',[100+20*i,200-10*i,1000 500]);
    ax(1) = subplot(1,2,1);
    imshow([pd4,imgname]);
    ax(2) = subplot(1,2,2);
    imshow([pd5, outname]);
    linkaxes([ax(1),ax(2)],'xy');
    end
    
    if showwav == 1
        outname2 = ['OLws_ctFIRE_',imgname];
        figure(80+i);clf;set(gcf,'position',[200+20*i,100-10*i,1000 500]);
        ax(1) = subplot(1,2,1);
        imshow([pd4,imgname]);
        ax(2) = subplot(1,2,2);
        imshow([pd5, outname2]);
        linkaxes([ax(1),ax(2)],'xy');
       
   end
    
    if showwav123 == 1
        
        outname2 = ['OLws_ctFIRE_',imgname];
        figure(100);set(gcf,'position',[200,100,900 300]);
        if i== 3
        ax(1) = subplot(1,3,1);
        imshow([pd5, outname2]);
        title('Day 1','fontsize',12)
        axis([0 511 0 1000]);
        
        elseif i == 6;
        ax(2) = subplot(1,3,2);
        imshow([pd5, outname2]);
         title('Day 8','fontsize',12)
        elseif i == 8;
             ax(3) = subplot(1,3,3);
             imshow([pd5, outname2]);
              title('Day 25','fontsize',12)
             linkaxes([ax(1),ax(2) ax(3)],'xy');
             axis([0 511 0 511]);
             line([100 480], [50 50]);
        end
            
        
        
    end
    
   
   
       
       
    
end

