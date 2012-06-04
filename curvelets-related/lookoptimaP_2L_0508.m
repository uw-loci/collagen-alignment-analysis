%% find best coeff percentage using fminsearch.m, based on the MSE

% Yuming Liu
clear;
close all;
clc;home
flagsave = 1;   % 1: save the optima result; 0: do not save if there is any error occuring during optimization 
LWon = 0;      % lenght weight(LW), LWon=1: consdier add LW; LWon=0: not consdier LW

FS0 = 1;   % fraction of the sample 0
FS1 = 1;   % fraction of the sample 1
FS2 = 1;   % fraction of the sample 2

err0 = 1E-3;   % Mean Square Error between the real angles and the CA angles
err1 = 1E-5;   % MSE of CA angles with adjactent parameter "pkeep"
% edges = -5:10:175; 
% edges = 0:10:180; 
MSE0 = 999;
MSE1 = 999;

%load true angles
dir1 = 'D:\UW-MadisonSinceFeb_01_2012\download\testimages\';
dir2 = 'D:\UW-MadisonSinceFeb_01_2012\download\testresults\';
dir3 = 'D:\UW-MadisonSinceFeb_01_2012\download\testcontrols\';

fileN(1).name = 'Substack (5)_L200N50A2.tif';   
fileN(2).name = 'N50L200AUniC.tif';
fileN(3).name = 'Substack (110)_Kgel5.tif';
fileN(4).name = '11250_SKOV_Substack (8).tif';
fileN(5).name = 'Substack (103)_tissue_SHG_J1.tif';       % size: 512 by 512
fileN(6).name = '12_30_08 Slide 1B-c7-01_C2.tiff';       % size: 512 by 512
fileN(7).name = 'TACS-3a.tif';       % size: 600 by 600
fileN(8).name = 'TACS-3b.tif';       % size: 600 by 600
fileN(9).name = 'R_62211_40x_2z_64mw_ser1_a1_angle000.tif';  % size: 512 by 512
fileN(10).name = 'JSim_test10.tif';
fileN(11).name = 'CP_Test_Image1.tif';  % size: 1024 by 1024
fileN(12).name = 'CP_Test_Image2.tif';  % size: 1024 by 1024
fileN(13).name = 'CP_Test_Image2Noise.tif';  % size: 1024 by 1024
fileN(14).name = 'CP_Test_Image4.tif';  % size: 1024 by 1024
fileN(15).name = 'CP_Test_Image5.tif';  % size: 1024 by 1024
iNF = 2;

for iN = iNF
    if iN < 10
       edges = 5:10:175;
    elseif iN >= 10 && iN <= 15
       edges = 0:10:180; 
    end
       
  try
   fname0 = [dir3,sprintf('test%d-control.mat',iN)];
   fname1 = [dir2,sprintf('test%d-FIREang.mat',iN)];
   
   figname = [dir1, fileN(iN).name];
     
   load(fname0);
   load(fname1);
   IMG = imread(figname);
   fclose all;

if LWon == 0
    
    x0 = testcon.degree;
    Lx0 = length(x0);
else
    x0 = testcon.degreeLW;
    Lx0 = round(length(x0)*FS0);
end

[SA0,SA0N] = histnor0(x0,edges);
x0r = randsample(x0,Lx0);

x1 = angIALL*180/pi;
Lx1 = length(x1)*FS1;
[SA1,SA1N] = histnor1(x1,edges);
x1r = randsample(x1,Lx1);

% parameters for kstest2;
alpha = 0.05;
tail = 'unequal';

% parameters and options for fminsearch;
options = optimset('Display','notify','TolFun',1.0e-4,'TolX',1.0e-4,'FunValCheck','off');

%set random start points to reduce the possibility of stucking to local minimum  
nrs = 10;                 % number of random startpoints
pkr = [0.001 0.01];      % pkeep range
rsp = rand(nrs,1)*(pkr(2)-pkr(1))+pkr(1); % random start points of pkeep 
pks = [];

for ir = 1:nrs
    home;
    disp(sprintf('test%iN, searching start point No#%d of %d', iN, ir, nrs))
% start = 0.005;   %initial pkeep
start = rsp(ir);   %initial pkeep
pks(ir,1) = start; % start point for fminsearch
% fminsearch to find the pkeep with the maximum pvalue
[pko,err] = fminsearch('fitAngHist',start,options,IMG,SA0N, edges);

pks(ir,2) = pko;   % pkeep optimized 
pks(ir,3) = err; %  MSE with the opitma pkeep

end

PKsave(:,:,iN) = pks;

mseo = min(pks(:,3));  % mseo optimized
pki  =find(pks(:,3) ==mseo);
pkx = pki(1);
PO(iN) =  pks(pkx,2);       % pkeep optima 
disp(sprintf('The optima curve coeff percentage = %f for test %d' , PO(iN),iN));
% disp('press any key to continue ...')
% pause


  catch
      flagsave = 0;
      disp(sprintf('test %d is skipped', iN))
  end
    
end % iN

if flagsave == 1
 CApk = [dir2,sprintf('test%d-%d-CApk.mat',min(iNF),max(iNF))];
 save(CApk,'PO','PKsave');
end

break

jj = 0;
% figure(1);clf
% set(gcf,'position',[100 200 400 400]);

for pkeep = PO

[object, Ct, inc] = newCurv(IMG,pkeep);

angs = vertcat(object.angle);
angles = group5(angs,inc);
% bins = min(angles):inc:max(angles);                
% [n xout] = hist(angles,bins); imHist = vertcat(n,xout);
CAresult = angles;
CAresulta = CAresult;
CA0 = find(CAresult<0);
CApi = find(CAresult >180);
CAresulta(CA0) = 180 + CAresult(CA0);
CAresulta(CApi) = CAresult(CApi)-180;
[CA0,CA0N] = histnor2(CAresulta,edges);

jj = jj +1;

ResCA0N(:,jj)=CA0N;
ResCA0 (:,jj) = CA0;
ResMSE(jj,1) = jj;
ResMSE(jj,2) = pkeep;

disp(sprintf('jj = %d',jj))

MSE0 = (CA0N-SA0N)'*(CA0N-SA0N)/length(edges);

ResMSE(jj,4) = MSE0;

if jj > 1
    
    MSE1 = (ResCA0N(:,jj)- ResCA0N(:,jj-1))'*(ResCA0N(:,jj)- ResCA0N(:,jj-1))/length(edges);
    ResMSE(jj,3) = MSE1;
        
    if MSE0 < err0 && MSE1< err1
        disp(sprintf(' Optima coeff percentage is %f , MSE = %f',pkeep, MSE1))
        disp(sprintf(' Stop loop'))
        break
           
    end
else
    
   ResMSE(jj,3) = 999;
   
            
end   % jj

   disp(sprintf(' searching optima curvelet coeffs...,MSE0 = %f, MSE1 = %f,MSEopt = %f',MSE0,MSE1,mseo))

 
end   % keep


