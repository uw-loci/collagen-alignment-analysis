%% plot_angle_results
% run after FIRE_2D_0508_Bbat.m
% compare angle distribution of a experimental SHG fiber network  
close all; clear;clc;
home
% close all;
% filedir = 'D:\UW-MadisonSinceFeb_01_2012\download\results\';
% filesave = [filedir,'N50L200AngC_FIRE'];
  dir2 = 'F:\UW-MadisonSinceFeb_01_2012\download\testresults\';
  
bin = 18;
bins = -5:10:175;
FNum = 36;
FLen1 = 30;

iNF = [1:9];  % iN numbers in Fire

for iN = iNF              %
FIREangS = [dir2, sprintf('test%d-FIREang.mat',iN)];
fmat = [dir2,sprintf('test%d-FIREout.mat',iN)];
load(fmat)
DFa = data.Fa;
Fsta = data.M;       % fiber network statistics
Fnum = length(DFa);  % Number of Fibers  


% case 2: show angle_xy of fibers with their length are larger than a
% specified value. The discretized 

FN = find(data.M.L>FLen1);
LFa = length(FN)
figure(18);clf;

clr = 'rgbmck'
sym = 'o*^s+x'
% if LFa >36
%     LFa = 36;
% end

for ii = 1:LFa
    
    ang_xy = Fsta.Fang(1,FN(ii)).angle_xy;
    ang_xz = Fsta.Fang(1,FN(ii)).angle_xz;
    
    % switch positive(negative) angle to negative(positive) angle 
%     ang_xy = -ang_xy;
    temp = ang_xy;
    ind1 = find(temp>0);
    ind2 = find(temp<0);
    ang_xy(ind1)= pi-ang_xy(ind1);
    ang_xy(ind2) = -ang_xy(ind2);
           
             
     figure(18);
     if mod(ii,6)== 0
         Ci = 6;
     else
     Ci = mod(ii,6);
     end
     Si = ceil(ii/6);
     
    if ii <=FNum 
  
     plot(ang_xy(1:end-3),[clr(Ci) sym(Si) ''],'LineWidth',2);
     
    end
    
     angXY(ii).his = ang_xy;
   
    hold on      
      
end
title('Orientation of the extracted fiber(s) by FIRE without interpolation')
xlabel('Sampling point (#)','FontSize',12)
ylabel('Angle-XY at each points (rad)','FontSize',12);
axis square 

figure(15);clf

La = length(angXY);
angALL = [];
for ia = 1:La
    starta = 1+length(angALL);
    enda = length(angALL)+length(angXY(ia).his);
    angALL(starta:enda) = angXY(ia).his;
end
hist(angALL*180/pi,bin)
axis square
title('Extracted Angle-XY Hist - no INT') 
xlabel('Angle(degree)','fontsize',12)
ylabel('Frequency','fontsize',12)


[Nxy0 NNxy0] = histnor1(angALL*180/pi,bins);
 
%  pause;

% case 3

FN = find(data.M.L>FLen1);
LFa = length(FN)
figure(28);clf;

clr = 'rgbmck'
sym = 'o*^s+x'
% if LFa >36
%     LFa = 36;
% end

for ii = 1:LFa
    
    ang_xy = Fsta.FangI(1,FN(ii)).angle_xy;
    ang_xz = Fsta.FangI(1,FN(ii)).angle_xz;
    
 % switch positive(negative) angle to negative(positive) angle 
%       ang_xy = -ang_xy;   
    temp = ang_xy;
    ind1 = find(temp>0);
    ind2 = find(temp<0);
    ang_xy(ind1)= pi-ang_xy(ind1);
    ang_xy(ind2) = -ang_xy(ind2);
       
            
     figure(28);
     if mod(ii,6)== 0
         Ci = 6;
     else
     Ci = mod(ii,6);
     end
     Si = ceil(ii/6);
     

if ii <= FNum

     plot(ang_xy(1:end-2),[clr(Ci) sym(Si) ''],'LineWidth',2);
end

     angIXY(ii).his = ang_xy;
   
    hold on      
      
end
title('Orientation of the extracted fiber(s) by FIRE with interpolation')
xlabel('Sampling point (#)','FontSize',12)
ylabel('Angle_xy at each points (rad)','FontSize',12);
axis square 

figure(25);clf

La = length(angIXY);
angIALL = [];
for ia = 1:La
    starta = 1+length(angIALL);
    enda = length(angIALL)+length(angIXY(ia).his);
    angIALL(starta:enda) = angIXY(ia).his;
end
hist(angIALL*180/pi,bin)
title('Extracted Angle-XY Hist - with INT')
xlabel('Angle(degree)','fontsize',12)
ylabel('Frequency','fontsize',12)
axis square

[NxyI,NNxyI] = histnor1(angIALL*180/pi,bins);
 
save(FIREangS,'fmat','NxyI', 'NNxyI','angALL','Nxy0', 'NNxy0','angIALL')

pause
end %iN
 break

% case 4: show angle_xz of fibers with their length are larger than a
% specified value. The discretized 

FN = find(data.M.L>FLen1);
LFa = length(FN)
figure(38);clf;

clr = 'rgbmck'
sym = 'o*^s+x'

for ii = 1:LFa
      
    ang_xz = Fsta.Fang(1,FN(ii)).angle_xz;
    
    % covert convert negtive theta angle to pi-theta
    temp = ang_xz;
    ind2 = find(temp<0);
    ang_xz(ind2) = pi-abs(ang_xz(ind2));
           
            
     figure(38);
     if mod(ii,6)== 0
         Ci = 6;
     else
     Ci = mod(ii,6);
     end
     Si = ceil(ii/6); 
     
    if ii <=FNum 
  
     plot(ang_xz(1:end-3),[clr(Ci) sym(Si) ''],'LineWidth',2);
     
    end
    
     angXZ(ii).his = ang_xz;
   
    hold on      
      
end
title('Orientation of the extracted fiber(s) by FIRE without interpolation')
xlabel('Sampling point (#)','FontSize',12)
ylabel('Angle-XZ at each points (rad)','FontSize',12);
axis square 

% case 5 show angle_xz of fibers with their length are larger than a
% specified value. The discretized segments have uncontrolled lengths.
figure(35);clf
La = length(angXZ);
angALLxz = [];
for ia = 1:La
    starta = 1+length(angALLxz);
    enda = length(angALLxz)+length(angXZ(ia).his);
    angALLxz(starta:enda) = angXZ(ia).his;
end
hist(angALLxz*180/pi,bin)
axis square
title('Extracted Angle-XZ Hist - no INT')
xlabel('Angle(degree)','fontsize',12)
ylabel('Frequency','fontsize',12)

[Nxz0 NNxz0] = histnor1(angALLxz*180/pi,bins);

pause
%%case 6
FN = find(data.M.L>FLen1);
LFa = length(FN)
figure(48);clf;

clr = 'rgbmck'
sym = 'o*^s+x'


for ii = 1:LFa
      
    ang_xz = Fsta.FangI(1,FN(ii)).angle_xz;
    
    % covert convert negtive theta angle to pi+theta
    temp = ang_xz;
    ind2 = find(temp<0);
    ang_xz(ind2) = pi-abs(ang_xz(ind2));

                   
     figure(48);
     if mod(ii,6)== 0
         Ci = 6;
     else
     Ci = mod(ii,6);
     end
     Si = ceil(ii/6);
     

if ii <= FNum

     plot(ang_xz(1:end-2),[clr(Ci) sym(Si) ''],'LineWidth',2);
end

     angIXZ(ii).his = ang_xz;
   
    hold on      
      
end
title('Orientation of the extracted fiber(s) by FIRE with interpolation')
xlabel('Sampling point (#)','FontSize',12)
ylabel('Angle-XZ at each points (rad)','FontSize',12);
axis square 

figure(45);clf

La = length(angIXZ);
angIALLxz = [];
for ia = 1:La
    starta = 1+length(angIALLxz);
    enda = length(angIALLxz)+length(angIXY(ia).his);
    angIALLxz(starta:enda) = angIXZ(ia).his;
end
hist(angIALLxz*180/pi,bin)
title('Extracted Angle-XZ Hist - with INT')
xlabel('Angle(degree)','fontsize',12)
ylabel('Frequency','fontsize',12)
axis square

[NxzI NNxzI] = histnor1(angIALLxz*180/pi,bins);

