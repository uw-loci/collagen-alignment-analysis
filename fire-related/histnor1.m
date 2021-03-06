 % normalize the Hist
% Fib200N = find(fiberATR(:,2)>150);
% Fib200 = fiberATR(Fib200N,1)*180/pi;
% 
% x0 = fiberATR(:,1)*180/pi;
% x1 = Fib200;
% whos x1
function [Nx1,NNx1] = histnor1(x,bins)

x1 = x;
Egs = bins;
% Egs = -5:10:175;
 %Egs = 0:10:180;

Nx1 = histc(x1,Egs);

figure(3);clf
set(gcf,'position',[50 50 350 350])
bar(Egs,Nx1,'histc');
axis square
xlim([0 180])
title('Angle Hist by FIRE, original','fontsize',12)
xlabel('Angle(degree)','fontsize',12)
ylabel('Frequency','fontsize',12)


figure(4);clf
% EgsN = 5:10:175;
set(gcf,'position',[550 50 350 350])
NNx1 = Nx1/max(Nx1);
bar(Egs,NNx1,'histc');
axis square
xlim([0 180])

title('Angle Hist by FIRE, normalized','fontsize',12)
xlabel('Angle(degree)','fontsize',12)
ylabel('Normalized Frequency','fontsize',12)


