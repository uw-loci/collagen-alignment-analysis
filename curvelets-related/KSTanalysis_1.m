% troubleshooting kstest2 analysis
%yuming
figure(13);clf;
set(gcf,'position', [900 300 400 400])
F1 = cdfplot(x0);
hold on
F2 = cdfplot(x2)

hold on
F3 = cdfplot(x0r);
hold on
F4 = cdfplot(x2r)

set(F1,'LineWidth',2,'Color','r')
set(F2,'LineWidth',2,'Color','m')
set(F3,'LineWidth',2,'Color','g')
set(F4,'LineWidth',2,'Color','b')

