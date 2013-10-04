
clear all;
close all;

%data = csvread('P:\Conklin data - Invasive tissue microarray\TACS3_Survival.csv');
data = csvread('dataTACS.csv');
%gather the data from the spread sheet
score1 = data(:,1);
score2 = data(:,2);
score3 = data(:,3);
dfs = data(:,4);
dfse = data(:,5);
dss = data(:,6);
dsse = data(:,7);

%Cox Prop Hazard Fit to DFS
[b_1,logL_1,H,stats_1] = coxphfit(score1,dfs,'censoring',~dfse);
[b_2,logL_2,H,stats_2] = coxphfit(score2,dfs,'censoring',~dfse);
[b_3,logL_3,H,stats_3] = coxphfit(score3,dfs,'censoring',~dfse);

disp('DFS exponents:');
disp(sprintf('  sc1: %0.3f\n  sc2: %0.3f\n  sc3: %0.3f',exp(b_1),exp(b_2),exp(b_3)));
disp('DFS p values:');
disp(sprintf('  sc1: %0.3f\n  sc2: %0.3f\n  sc3: %0.3f',stats_1.p,stats_2.p,stats_3.p));

% %Cox Prop Hazard Fit to DSS
[b_1,logL_1,H,stats_1] = coxphfit(score1,dss,'censoring',~dsse);
[b_2,logL_2,H,stats_2] = coxphfit(score2,dss,'censoring',~dsse);
[b_3,logL_3,H,stats_3] = coxphfit(score3,dss,'censoring',~dsse);

disp('DSS exponents:');
disp(sprintf('  sc1: %0.3f\n  sc2: %0.3f\n  sc3: %0.3f',exp(b_1),exp(b_2),exp(b_3)));
disp('DSS p values:');
disp(sprintf('  sc1: %0.3f\n  sc2: %0.3f\n  sc3: %0.3f',stats_1.p,stats_2.p,stats_3.p));

%for i = 0.0001:0.001:0.05
    %compute cutoff for score 1
    th1 = 0;

    %get dfs
    idx1 = score1>th1;
    dfs1pos = dfs(idx1);
    dfs1pose = dfse(idx1);
    dfs1neg = dfs(~idx1);
    dfs1nege = dfse(~idx1);

    %KM curve
    figure(1);
    hold off;
    [f,x,flo,fup] = ecdf(dfs1pos,'censoring',~dfs1pose,'function','survivor');
    %[f,x,flo,fup] = ecdf(dfs1pos,'function','survivor');
    stairs(x,f,'LineWidth',2)
    hold on;
    %stairs(x,flo,'r:','LineWidth',2)
    %stairs(x,fup,'r:','LineWidth',2)

    [f,x,flo,fup] = ecdf(dfs1neg,'censoring',~dfs1nege,'function','survivor');
    %[f,x,flo,fup] = ecdf(dfs1neg,'function','survivor');
    stairs(x,f,'g','LineWidth',2)        
    %stairs(x,flo,'r:','LineWidth',2)
    %stairs(x,fup,'r:','LineWidth',2)
   
    drawnow; %pause(0.5);
    disp(num2str(th1));
%end