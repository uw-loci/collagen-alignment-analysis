%% hypothesis test for angle distribution

% Kolmogorov–Smirnov test
% function KSTest_exp1

function err  = fitKSTest_e1(start,img,x0,bins)

pkeep = start;
IMG = img;
Lx0 = length(x0);
x0r = randsample(x0,Lx0);


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

x2 = CAresulta;
Lx2 = length(x2);
iN = 1;
x2r= randsample(x2,floor(Lx2/iN));
alpha = 0.05;
tail = 'unequal';

[H02r, pValue02r, KS02r] = kstest2(x0r, x2r, alpha, tail) ;
err = 1-pValue02r;
if pkeep > 0.01 | pkeep < 0
    err = 999*err ;
end

figure(11);
set(gcf, 'position',[999   350  350   350]);
plot(pkeep,err,'ro')
xlabel('coeff percentage','fontsize',12);
% ylabel ('[Pvalue of KS test','fontsize',12);
ylabel ('1-pValue','fontsize',12);
axis([0.001 0.01 0 1])

hold on 





