 % normalize the Hist by its max frequency

function [Nx1,NNx1,Nind] = histnorbymax(x,edges,plot)

if nargs <3
    plot = 0;
end
[Nx1,Nind] = histc(x,edges);

% figure(1);clf
% set(gcf,'position',[950 50 350 350])
% bar(Egs,Nx1,'histc');
% axis square
% xlim([0 180])
% title('Simulated or Manual Angle Hist , original','fontsize',12)
% xlabel('Angle(degree)','fontsize',12)
% ylabel('Frequency','fontsize',12)

NNx1 = Nx1/max(Nx1);

if plot on

set(gcf,'position',[50 200 350 350])
bar(Egs,NNx1,'histc');
axis square
% xlim([0 180])
title('Normalized hist by max frequency','fontsize',12)
xlabel('Angle(degree)','fontsize',12)
ylabel('Normalized Frequency','fontsize',12)
end

