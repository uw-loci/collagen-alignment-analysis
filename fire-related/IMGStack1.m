% IMGStack1, make image stack
 clear 

 dir2 = 'Z:\bredfeldt\Conklin data - Invasive tissue microarray\Slide 2B man reg_FIREresult\0531\FIREoutput\';
 
 
%  fmat = [dir2,'FIREdata_',fname0(1:end-5),'.mat'];
%  

 FIREdataN = [dir2,'FIREdata_*'];
 FIREdataR = dir(FIREdataN);
 
iNF = 1:length(FIREdataR);
iNF([2 10 12 20 22 30 32 40 42 50 52 60 62 70]) = [10 2 20 12 30 22 40 32 50 42 60 52 70 62];

LL = 30;
FNL = 800;
pixel = [2560 1920];
tempIMG1 = 'tempimg1.tif';
tempIMG2 = 'temping2.tif';
jj = 0;

stacksave = [dir2,'FIREstack1'];
for ii = 1%:2%iNF
jj = jj +1;
FILEN = [dir2 FIREdataR(ii).name];
load(FILEN,'data','fname0');   
show2Dfibers_0531(data,LL,FNL,pixel,ii,fname0);


figure(100);
figure('visible','off')

% set(gcf,'PaperUnits','inches','PaperPosition',[0 0 4 3])

print('-dtiff', '-r640', tempIMG1);

tempmat1 = imread(tempIMG1);

tempmat2 = imshow(tempmat1,'bord','tight');

rectangle('Position', [100, 100, 10, 10]);

print('-dtiff', '-r640', tempIMG2);

% iptsetpref('ImshowBorder','tight');

% set(0,'DefaultFigureMenu','none');
% set(0,'Default');


% imwrite(tempmat1,stacksave,'tiff','Compression','packbits','WriteMode','append');
% imwrite(tempmat1,stacksave,'tiff','WriteMode','append');

end