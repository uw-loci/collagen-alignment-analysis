function[p] = param_com0816(p)

%ym08012012:
% Compared to _CTr01, the following parameters are changed:
%  p.thresh_dang_L; p.thresh_short_L ; p.thresh_linkd

% 081612: common parameters to be used by FIRE for processing images filterred by different methods 

%
    p.sigma_im  =  0;%sqrt(2); %radius of box for smoothing original image
    p.sigma_d   = .3; %radius of box for smoothing of distance function
    p.dtype     = 'cityblock'; %type of distance transform for bwdist 
                               %(cityblock is significantly faster than
                               %Euclidean distance)
    
   %set threshold.  p.thresh_im  is for a percentage of maximum,
   %                p.thresh_im2 is for a hard value
    p.thresh_im = [];
%     p.thresh_im2= 50; %34000; YM: to be replaced(set) by the main program
                               
                               
%parameters for finding xlinks
    p.thresh_Dxlink = 1.5; %dist fun. threshold for a point to be considered an x-link
    p.s_xlinkbox    = 5; %5; %radius of box in which to check to make sure xlink is a local max of the distance function
    
%parameters for extending xlinks
    p.thresh_LMP    = .2; %threshold for a point to be considered an LMP
    p.thresh_LMPdist=  2; %minimum distance apart for two LMPs
    p.thresh_ext    = cos(70*pi/180); %cos(70*pi/180); %angle similarity required for a fiber to extend to the next point
    p.lam_dirdecay  = .5; %decay rate of fiber direction (to make it more difficult for a fiber to turn around)
    p.s_minstep     = 2;  %minimum step size
    p.s_maxstep     = 6;  %max step size

%parameters for removing danglers    
    p.thresh_dang_aextend = cos(10*pi/180);
    p.thresh_dang_L       = 10; %20; %15;    
    p.thresh_short_L      = 10; %20; %15;
        
%parameters for fiber processing 
    p.s_fiberdir    =  4; %number of nodes used for claculating direction of fiber end
    p.thresh_linkd  = 15; %10; %20; %distance for linknig same-oriented fibers
    p.thresh_linka  = cos(-150 *pi/180); %ym,a 130 degree angle is enough to link 2 fibers together
    p.thresh_flen   = 10;%20;%15;%minimum length of a free fiber
    p.thresh_numv   = 3; %minimum number of verties a free fiber can have

%parameters for beam processing    
     p.scale      = [.05 .05 .1];
%    p.scale      = [1 1 1];  % ym

    p.s_boundthick = 10; %pixels of thickness for image boundary
    p.blist      = 1; %indicates which boundaries are controlled (1=x,2=y,3=z)    
    p.s_maxspace = 5;
    p.lambda     = .01;
    
%ym: parameters for calculating angle at each sampling point
   p.ang_interval = 3; 
 
    