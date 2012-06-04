% simulation about hist, histc, bar, histnorbymax, histnorbyarea
 close all; clear; clc;home
 x = rand(100,1);
 edges =0:0.1:1
 figure(1);clf
 [Nx1 NNx1] = histnorm2(x,edges,1,1);
  figure(2);clf
 [Nx2 NNx2] = histnorm2(x,edges,2,1);
 
 break
 
%  [N,bin] = hist(x,0:9)
%  figure(1);clf
%   bar(bin,N,'hist')
%   figure(2);clf
%  hist(x,0:9)
%  break
 
 bins =0:0.1:1; % bin center
 [x1,x2]= hist(x,bins);  % x1: frequency, x2:bin centers
 figure(1);clf; 
 set(gcf,'position',[50 300 600 300])
 subplot(1,2,1)
 hist(x,bins);
 title('hist default plot')
 axis square
 subplot(1,2,2)
 bar(x2,x1);
 title('bar of the hist output')
 axis square

pause
 edges =0:0.1:1;
 [x3,x4]= histc(x,edges); % x3:frequecy, x4: bin index 
 figure(2);clf; 
 set(gcf,'position',[650 300 600 300])
 subplot(1,2,1);
 bar(edges,x3);  % edges actually as center
 title('Histc: edges are looked as bin centers')
 axis square

 subplot(1,2,2)
 bar(edges,x3,'histc')
 title('Histc: edges are correctly recognized')
 axis square

 
 