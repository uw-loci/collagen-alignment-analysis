function [angFI, angFS] = show2Dangle_K_0531(data,LL,FNL,edges,ii);

%% plot_angle_results
% output:
% run after FIRE_2D..
% angFI: indivual fiber angles
% angFS: fiber segments angles
% data: FIRE output
% LL: fiber length limit
% FNL: fiber number limit:
% ii : image #
% edges: edges of the histogram bin

angFI  = [];
angFS  = [];
bin = length(edges);
FNum = 36;
FLen1 = LL;
iN = ii;

Fnum = length(data.Fa);  % Number of Fibers  

FN = find(data.M.L>FLen1);
LFa = length(FN)
if LFa > FNL
    LFa = FNL;
end


%case1: show the individual fibers with their lengths larger than a
% specified value. the angle is obtained based on the start point and end
% point of each fiber
figure(7);clf;

ang_xy = data.M.angle_xy(FN);
temp = ang_xy;
ind1 = find(temp>0);
ind2 = find(temp<0);
ang_xy(ind1)= pi-ang_xy(ind1);
ang_xy(ind2) = -ang_xy(ind2);

angFI = ang_xy*180/pi;

[NE, BE] = histc(angFI,edges);
bar(edges, NE, 'histc');
axis square
title('Extracted Angle-XY Hist - Individual fiber') 
xlabel('Angle(degree)','fontsize',12)
ylabel('Frequency','fontsize',12)
% 
% figure(8);clf
% [NExy0 NNExy0] = histnorm2(angFI,edges,1,1);


% case 2: show angle_xy of fiber segements with their length are larger than a
% specified value. The discretized fibers do not necessarily have the identical lengths 


figure(18);clf;
 
clr = 'rgbmck';
sym = 'o*^s+x';


for ii = 1:LFa
    
    ang_xy = data.M.Fang(1,FN(ii)).angle_xy;
    ang_xz = data.M.Fang(1,FN(ii)).angle_xz;
    
    % switch positive(negative) angle to negative(positive) angle 
%     ang_xy = -ang_xy;
    temp = ang_xy;
    ind1 = find(temp>0);
    ind2 = find(temp<0);
    ang_xy(ind1)= pi-ang_xy(ind1);
    ang_xy(ind2) = -ang_xy(ind2);
   
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

angFS1 = angALL*180/pi;
[NS1 BE1] = histc(angFS1,edges);
bar(edges,NS1,'histc');
axis square
title('Extracted Fiber segments Angle-XY Hist - no INT')
xlabel('Angle(degree)','fontsize',12)
ylabel('Frequency','fontsize',12)

%  
% 
% case 3

figure(28);clf;

clr = 'rgbmck'
sym = 'o*^s+x'
% if LFa >36
%     LFa = 36;
% end

for ii = 1:LFa
    
    ang_xy = data.M.FangI(1,FN(ii)).angle_xy;
    ang_xz = data.M.FangI(1,FN(ii)).angle_xz;
    
 % switch positive(negative) angle to negative(positive) angle 
%       ang_xy = -ang_xy;   
    temp = ang_xy;
    ind1 = find(temp>0);
    ind2 = find(temp<0);
    ang_xy(ind1)= pi-ang_xy(ind1);
    ang_xy(ind2) = -ang_xy(ind2);
       

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
angFS2 = angIALL*180/pi;
[NS2 BE2] = histc(angFS2,edges);
bar(edges,NS2,'histc');
title('Extracted fiber segments Angle-XY Hist - with INT')
xlabel('Angle(degree)','fontsize',12)
ylabel('Frequency','fontsize',12)
axis square

% [NxyI,NNxyI] = histnor1(angIALL*180/pi,edges);
 




% break

% case 4: show angle_xz of fibers with their length are larger than a
% specified value. The discretized 

% FN = find(data.M.L>FLen1);
% LFa = length(FN)
% figure(38);clf;
% 
% clr = 'rgbmck'
% sym = 'o*^s+x'
% 
% for ii = 1:LFa
%       
%     ang_xz = data.M.Fang(1,FN(ii)).angle_xz;
%     
%     % covert convert negtive theta angle to pi-theta
%     temp = ang_xz;
%     ind2 = find(temp<0);
%     ang_xz(ind2) = pi-abs(ang_xz(ind2));
%            
%             
%      figure(38);
%      if mod(ii,6)== 0
%          Ci = 6;
%      else
%      Ci = mod(ii,6);
%      end
%      Si = ceil(ii/6); 
%      
%     if ii <=FNum 
%   
%      plot(ang_xz(1:end-3),[clr(Ci) sym(Si) ''],'LineWidth',2);
%      
%     end
%     
%      angXZ(ii).his = ang_xz;
%    
%     hold on      
%       
% end
% title('Orientation of the extracted fiber(s) by FIRE without interpolation')
% xlabel('Sampling point (#)','FontSize',12)
% ylabel('Angle-XZ at each points (rad)','FontSize',12);
% axis square 
% 
% % case 5 show angle_xz of fibers with their length are larger than a
% % specified value. The discretized segments have uncontrolled lengths.
% figure(35);clf
% La = length(angXZ);
% angALLxz = [];
% for ia = 1:La
%     starta = 1+length(angALLxz);
%     enda = length(angALLxz)+length(angXZ(ia).his);
%     angALLxz(starta:enda) = angXZ(ia).his;
% end
% hist(angALLxz*180/pi,bin)
% axis square
% title('Extracted Angle-XZ Hist - no INT')
% xlabel('Angle(degree)','fontsize',12)
% ylabel('Frequency','fontsize',12)
% 
% [Nxz0 NNxz0] = histnor1(angALLxz*180/pi,edges);
% 
% pause
% %%case 6
% FN = find(data.M.L>FLen1);
% LFa = length(FN)
% figure(48);clf;
% 
% clr = 'rgbmck'
% sym = 'o*^s+x'
% 
% 
% for ii = 1:LFa
%       
%     ang_xz = data.M.FangI(1,FN(ii)).angle_xz;
%     
%     % covert convert negtive theta angle to pi+theta
%     temp = ang_xz;
%     ind2 = find(temp<0);
%     ang_xz(ind2) = pi-abs(ang_xz(ind2));
% 
%                    
%      figure(48);
%      if mod(ii,6)== 0
%          Ci = 6;
%      else
%      Ci = mod(ii,6);
%      end
%      Si = ceil(ii/6);
%      
% 
% if ii <= FNum
% 
%      plot(ang_xz(1:end-2),[clr(Ci) sym(Si) ''],'LineWidth',2);
% end
% 
%      angIXZ(ii).his = ang_xz;
%    
%     hold on      
%       
% end
% title('Orientation of the extracted fiber(s) by FIRE with interpolation')
% xlabel('Sampling point (#)','FontSize',12)
% ylabel('Angle-XZ at each points (rad)','FontSize',12);
% axis square 
% 
% figure(45);clf
% 
% La = length(angIXZ);
% angIALLxz = [];
% for ia = 1:La
%     starta = 1+length(angIALLxz);
%     enda = length(angIALLxz)+length(angIXY(ia).his);
%     angIALLxz(starta:enda) = angIXZ(ia).his;
% end
% hist(angIALLxz*180/pi,bin)
% title('Extracted Angle-XZ Hist - with INT')
% xlabel('Angle(degree)','fontsize',12)
% ylabel('Frequency','fontsize',12)
% axis square
% 
% [NxzI NNxzI] = histnor1(angIALLxz*180/pi,edges);

