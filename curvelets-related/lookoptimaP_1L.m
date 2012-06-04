%% find best coeff percentage using fminsearch.m, based on the MSE

% Yuming Liu
clear;
close all;
clc;home

err0 = 1E-3;   % Mean Square Error between the real angles and the CA angles
err1 = 1E-5;   % MSE of CA angles with adjactent parameter "pkeep"
bins = -5:10:175;
MSE0 = 999;
MSE1 = 999;

%load true angles
dir0 = 'D:\UW-MadisonSinceFeb_01_2012\download\results\';
dir1 = 'D:\UW-MadisonSinceFeb_01_2012\download\CurveMeasure_LOCI\';


fname0 = [dir0,'nf50_len200_2DAng80-100.mat'];
fname1  =[dir1, 'Substack (5)_L200N50A2.tif'];

% fname0 = [dir0,'N50L200AngC_ORI.mat'];
% fname1 = [dir1,'N50L200AUniC.tif'];


load(fname0);
IMG = imread(fname1);
fclose all;

% LS = find(fiberATR(:,2)>150);      % length shreshold
% x0 = (pi-fiberATR(LS,1))*180/pi;
% Lx0 = length(x0);

% add the fiber length as the weight for the angles
LL = fiberATR(:,2);   % unit: pixel
AngO = (pi-fiberATR(:,1))*180/pi; % original angles
LLN = length(LL);     % original fiber number
LLr = round(LL/10);
Astart = 0;
Aend = 0;
for i = 1: LLN
    Astart = Aend +1;
    Aend = Astart+LLr(i)-1;
    AngW(Astart:Aend,1) =repmat(AngO(i),LLr(i),1);   % add the length weight on each angle
end    
figure(12);clf;plot(AngW,'ro-','linewidth',2);
pause
x0 = AngW;
Lx0 = length(x0);
%

[SA0,SA0N] = histnor0(x0,bins);


% parameters and options for fminsearch;
alpha = 0.05;
tail = 'unequal';
options = optimset('Display','notify','TolFun',1.0e-4,'TolX',1.0e-4,'FunValCheck','off');

pkr = [0.001 0.01]; % pkeep range
nrs = 10;           % number of random startpoints
rsp = rand(nrs,1)*(pkr(2)-pkr(1))+pkr(1); % random start points of pkeep 

for ir = 1:nrs

% start = 0.005;   %initial pkeep
start = rsp(ir);   %initial pkeep
pks(ir,1) = start; % start point for fminsearch
% fminsearch to find the pkeep with the maximum pvalue
[pko,err] = fminsearch('fitAngHist',start,options,IMG,SA0N, bins);

pks(ir,2) = pko;   % pkeep optimized 
pks(ir,3) = err; %  MSE with the opitma pkeep

end

mseo = min(pks(:,3));  % mseo optimized
pki  =find(pks(:,3) ==mseo);
pkx = pki(1);
PO =  pks(pkx,2);       % pkeep optima 
disp(sprintf('The optima curve coeff percentage = %f', PO));

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
[CA0,CA0N] = histnor2(CAresulta,bins);

jj = jj +1;

ResCA0N(:,jj)=CA0N;
ResCA0 (:,jj) = CA0;
ResMSE(jj,1) = jj;
ResMSE(jj,2) = pkeep;

disp(sprintf('jj = %d',jj))

MSE0 = (CA0N-SA0N)'*(CA0N-SA0N)/length(bins);

ResMSE(jj,4) = MSE0;

if jj > 1
    
    MSE1 = (ResCA0N(:,jj)- ResCA0N(:,jj-1))'*(ResCA0N(:,jj)- ResCA0N(:,jj-1))/length(bins);
    ResMSE(jj,3) = MSE1;
        
    if MSE0 < err0 && MSE1< err1
        disp(sprintf(' Optima coeff percentage is %f, MSE = %f',pkeep, MSE1))
        disp(sprintf(' Stop loop'))
        break
           
    end
else
    
   ResMSE(jj,3) = 999;
   
            
end   % jj

   disp(sprintf(' searching optima curvelet coeffs...,MSE0 = %f, MSE1 = %f,MSEopt = %f',MSE0,MSE1,mseo))

 
end   % keep


