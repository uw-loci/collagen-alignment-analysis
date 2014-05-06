clear all;
close all;

num_x = 64;
num_y = 12;

fname = sprintf('TileConfiguration_%0.2f.txt',cputime);
fid = fopen(fname,'w+');

fname_base = sprintf(['D:\\CAMM_ovary\\20140311_OvTMA2\\row3_5\\HE\\ff\\ff_ovTMA_HE_C0']);

%fname_base = sprintf('ff_2B_WL_C0');

nl = sprintf('\r\n');
fprintf(fid,'# Define the number of dimensions we are working on\r\n');
fprintf(fid,'dim = 2\r\n');
fprintf(fid,'\r\n\');

fprintf(fid,'# Define the image coordinates\r\n');

posx = 0.0;
posy = 0.0;
rotx = 0;
roty = 0;
shft = 340;
sp = 0;

for y = 1:num_y
    for x = 1:num_x
        sp = (y-1)*num_x + (x-1);
        
        fprintf(fid,'%s_TP0_SP%d_FW0.ome.tiff; ; (%0.2f, %0.2f)\r\n',fname_base,sp,posx,posy);
        
        if x == 1
            fposx = posx;
            fposy = posy;
        end        
        posx = posx + shft;
        posy = posy + roty;               
                
    end
    posx = fposx - rotx;
    posy = fposy + shft;
end

fclose(fid);