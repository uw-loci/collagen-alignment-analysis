function  err = fitAngHist(start,IMG,ActAng,bins)
 
pkeep = start(1);
SA0N = ActAng;

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

err = (CA0N-SA0N)'*(CA0N-SA0N)/length(bins);

if pkeep > 0.01 | pkeep < 0.001
    err = 999*err ;
end

figure(11);
set(gcf, 'position',[999   350  350   350]);
plot(pkeep,err,'ro')
xlim([0.001 0.01]);
xlabel('coeff percentage','fontsize',14);
ylabel ('Mean square error','fontsize',14);
hold on 

% ylim = [0 1];
hold on
end   % Pkeep 