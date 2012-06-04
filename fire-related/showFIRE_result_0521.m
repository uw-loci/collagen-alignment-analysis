 clear;
 
 dir1 = 'D:\UW-MadisonSinceFeb_01_2012\download\testimages\';
 dir2 = 'D:\UW-MadisonSinceFeb_01_2012\download\testresults\';
 
 fileN(1).name = 'Substack (5)_L200N50A2.tif';   % size: 1024 by 1024
 fileN(2).name = 'N50L200AUniC.tif';        % size: 1024 by 1024
 fileN(3).name = 'Substack (110)_Kgel5.tif';  % size: 512 by 512
 fileN(4).name = '11250_SKOV_Substack (8).tif';  % size: 512 by 512
 fileN(5).name = 'Substack (103)_tissue_SHG_J1.tif';       % size: 512 by 512
 fileN(6).name = '12_30_08 Slide 1B-c7-01_C2.tiff';       % size: 512 by 512
 fileN(7).name = 'TACS-3a.tif';       % size: 600 by 600
 fileN(8).name = 'TACS-3b.tif';       % size: 600 by 600
 fileN(9).name = 'R_62211_40x_2z_64mw_ser1_a1_angle000.tif';  % size: % size: 512 by 512
 fileN(10).name = 'JSim_test10.tif';
 fileN(11).name = 'CP_Test_Image1.tif';  % size: 1024 by 1024
 fileN(12).name = 'CP_Test_Image2.tif';  % size: 1024 by 1024
 fileN(13).name = 'CP_Test_Image2Noise.tif';  % size: 1024 by 1024
 fileN(14).name = 'CP_Test_Image4.tif';  % size: 1024 by 1024
 fileN(15).name = 'CP_Test_Image5.tif';  % size: 1024 by 1024
 
 LL= 30; %length limit(threshold), only choose fiber with length >LL
 FNL = 200; %: fiber number limit(threshold), maxium fiber number to be shown

 
for iN = 11:15
    fname =[dir1, fileN(iN).name];
    fmat = [dir2,sprintf('test%d-FIREout.mat',iN)];
    % save(fmat,'data','fname','iN','p');
 
    IS1 = imread(fname);
    load(fmat,'data');
    
    if length(size(IS1)) > 2
          IS =IS1(:,:,1);
    else
        IS = IS1;
    end
    pix = size(IS,1);
       
     ii = 1
     OUT(ii).length = data.M.L;
     OUT(ii).Xa = data.Xa;
     OUT(ii).Fa = data.Fa;
     OUT(ii).Xai = data.Xai;
     OUT(ii).Fai = data.Fai;
     show2Dfibers_0521(OUT(ii),IS,LL,FNL,pix,iN);
     
end

    
    