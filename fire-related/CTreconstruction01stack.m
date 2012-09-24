% CTreconstruction01stack.m
% Aug 22, 2012: reconstruct the image stack by curvelet transform
% Yuming Liu, LOCI, UW-Madison

clear;
close all;
home
path(path,'Z:\liu372\download\CurveLab-2.1.2\fdct_wrapping_matlab\'); % add serach path of the curvelet transform  

dateP = '\KT081512\';
dir4 = ['Z:\liu372\download\FIRE\testcases\testoverlay',dateP];
dir5 = ['Z:\liu372\download\FIRE\testcases\testimages',dateP];
dir6 = ['Z:\liu372\download\FIRE\testcases\testresults',dateP];
dir7 = ['Z:\liu372\download\FIRE\testcases\testcontrols',dateP];

% create new folders
% mkdir(dir4);
% mkdir(dir5);
% mkdir(dir6);
% mkdir(dir7);

% file name of the stack(s) to be processed
fileN(1).name = '10ng_mL_FW_substack_SHG_ser1.tif';   % 
fileN(2).name = '25ng_mL_FW_substack_SHG_ser1.tif';   % 
fileN(3).name = '50ng_mL_FW_SHG_ser1.tif';   % 
fileN(4).name = 'cells_FW_SHG_ser1.tif';   % 

% file name number to be analyzed
iNF  = 1:4 % 1:length(fileN)

for iN = iNF

   figname = [dir5, fileN(iN).name];

   fctsr = [dir5, sprintf('test%d-stack_CTR.mat',iN)];  % filename of the curvelet transformed reconstructed image stack
   CTsimg = [dir5, sprintf('test%d-stack_CTimg.tif',iN)];  % filename of the curvelet transformed reconstructed image stack

   info = imfinfo(figname);
   num_images = numel(info);
   IMG = [];
   pix = info(1).Width;  % each image of the same stack has the same size
 
   for iSN = 1: num_images
       IS = imread(figname,iSN); 
       % Set the percentage of coefficients used in the partial reconstruction 
    pctg = 0.2;  % 0803: 0.2 ; 
    
    % Forward curvelet transform
    disp('Take curvelet transform: fdct_wrapping');
    tic; C = fdct_wrapping(double(IS),0); toc;

    % Get the threshold value
    cfs =[];
    for s=1:length(C)
      for w=1:length(C{s})
        cfs = [cfs; abs(C{s}{w}(:))];
      end
    end
%     cfs = sort(cfs); cfs = cfs(end:-1:1);
    cfs = sort(cfs,'descend');
    nb = round(pctg*length(cfs));
    cutoff = cfs(nb);

    % Set small coefficients to zero
    for s=1:length(C)
      for w=1:length(C{s})
        C{s}{w} = C{s}{w} .* (abs(C{s}{w})>cutoff);
      end
    end

    disp('Take inverse curvelet transform: ifdct_wrapping');
        
    % create an empty cell array of the same dimensions
    Ct = cell(size(C));
    for cc = 1:length(C)
        for dd = 1:length(C{cc})
            Ct{cc}{dd} = zeros(size(C{cc}{dd}));
        end
    end
    
   % select the scale(s) at which the coefficients will be used
     s = length(C) - 3:length(C)-1 ;
%    s = 1:length(C);
    
    for iS = s 
        Ct{iS} = C{iS};
    end
    tic; Y = ifdct_wrapping(Ct,0); toc;
    CTr = real(Y);
    CTsr(:,:,iSN) = CTr;  % stack reconstruction
    
  if iSN == 1  
        figure(100+iN);clf
        ax(1) = subplot(1,2,1); colormap gray; imagesc(IS); axis('image'); title(sprintf('original image %d',iN));
        ax(2) = subplot(1,2,2); colormap gray; imagesc(CTr); axis('image'); title(sprintf('partial reconstruction,s%d - s%d',s(1),s(end)));
        pause(2);
        linkaxes([ax(2) ax(1)],'xy');
%         save(fctr,'CTr'); 
%         set(gcf,'PaperUnits','inches','PaperPosition',[0 0 2*pix/128 pix/128]);
%         print('-dtiff', '-r128', CTimg);  % CT reconstructed image
  end
  
%    figure(1);clf ; colormap gray; 
%    tempIMG = imagesc(CTr); axis('image'); 
%    title(sprintf('partial reconstruction,s%d - s%d',s(1),s(end)));
%    imwrite(CTr,CTsimg,'tiff','WriteMode','append','Compression','none');
   
end  % iSN
   
 save(fctsr,'CTsr');   
     
 end  %iN