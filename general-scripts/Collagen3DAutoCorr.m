%This script attempts to compute the autocorrelation of a 3D image of
%collagen.
%Then the width of the autocorrelation function in each dimension gives
%information about the extent of the fibers in each dimension.

%If the same volume is captured with 2 modalities, then the fiber extent in
%each dimension can be compared.

clear all;
%close all;

%open the 3D image
pathNameGlobal = 'G:\Ultra\20140520_Gels\bovine';
%[fileName pathName] = uigetfile({'*.tif;*.tiff;*.jpg;*.jpeg';'*.*'},'Select Image',pathNameGlobal,'MultiSelect','off');
fileName = 'z4_60x_pa20_C0_TP0_SP0_FW0.ome.tiff';
pathName = pathNameGlobal;

if isequal(pathName,0)
    return;
end

ff = fullfile(pathName,fileName);
info = imfinfo(ff);
numSections = numel(info);
imw = info.Width;
imh = info.Height;

imw2 = round(imw/2);
imh2 = round(imh/2);

%pixel widths
pwx = 0.07; %microns/pixel
pwy = 0.07;
pwz = 0.5;

xvec = linspace(0,pwx*imw,imw);
yvec = linspace(0,pwy*imh,imh);
zvec = linspace(0,pwz*numSections,numSections);

%allocate space for 3D image
img = zeros(imw,imh,numSections);

for i = 1:numSections
    img(:,:,i) = imread(ff,i,'Info',info);
end



init = 0;
%X & Y autocorr
for i = 1:numSections
    %figure(1);
    imgA = img(:,:,i);
    imgB = flipud(fliplr(imgA));          
    
    %only accumulate if there is data in image
    if mean(mean(imgA)) > 5
        %use convn to get autocorr
        cc = convn(imgA,imgB,'same');
        if init == 0
            %init filter
            %X = row
            xc = cc(imh2,:);
            %Y = column
            yc = cc(:,imw2);
            init = 1;
        else
            %IIR filter autocorrelation
            %X = row
            xc = 0.5*cc(imh2,:) + 0.5*xc;
            %Y = column
            yc = 0.5*cc(:,imw2) + 0.5*yc;
        end
        i
        figure(1);
        plot(xvec,xc);
        title('x-dir autocorr');
        xlabel('microns');

        figure(2);
        plot(yvec,yc);
        title('y-dir autocorr');
        xlabel('microns');
    end            
end

