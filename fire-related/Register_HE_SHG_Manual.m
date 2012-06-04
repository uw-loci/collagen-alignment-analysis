%Image registration

%clear all;
close all;
clc;

%open the image lists
shg_list = '.\shg_filelist.txt'
he_list = '.\he_filelist.txt'
shg_fid = fopen(shg_list,'r');
he_fid = fopen(he_list,'r');

%input directories *****************
shg_dir = fgetl(shg_fid);
he_dir = fgetl(he_fid);
he_dir_seg = fgetl(he_fid); %this could be used at the input directory, depending on if we have preprocessed the data or not

%output directory (he image doesn't change) ****************
shg_dir_out = fgetl(shg_fid);

%number of images listed in the file
shg_num = str2num(fgetl(shg_fid));
he_num = str2num(fgetl(he_fid));

%verify there are the same number of files in each
if (shg_num ~= he_num)
    %do something in this case
end

shg_files = cell(shg_num,1);
he_files = cell(he_num,1);

%get filename lists
for i = 1:shg_num
    shg_files{i} = fgetl(shg_fid);
    he_files{i} = fgetl(he_fid); %he file name
end
fclose(shg_fid);
fclose(he_fid);

%manually register all images, store transforms
%%
%for i = 1:shg_num
for i = 34:34
    i
    shg_fname = sprintf('%s%s',shg_dir,shg_files{i}); %full path
    he_fname = sprintf('%seosin_%s',he_dir_seg,he_files{i}); %full path
    %he_fname = regexprep(he_fname,'.JPG','.tif'); %this is temporary

    shg = imread(shg_fname);
    %crop shg image a little, due to stuff on right side
    shg = shg(:,1:1014);
    shg_adj = imadjust(shg);
    he = imread(he_fname);

    
    %figure; imshow(shg_adj);
    %figure; imshow(he);
    
    %edit away the right edge of the SHG image
    

    %manually register
    [shg_pts,he_pts] = cpselect(shg_adj,he,'Wait',true);
    tform = cp2tform(shg_pts, he_pts, 'affine');
    out = 'imtransform'
    pre_registered = imtransform(shg,tform,...
                             'FillValues', 0,...
                             'XData', [1 size(he,2)],...
                             'YData', [1 size(he,1)]);        
  
%%    
    %save the results
    shg_fname_out = sprintf('%sreg_%s',shg_dir_out,shg_files{i}); %full path
    imwrite(pre_registered,shg_fname_out,'tiff','Compression','packbits');
    
    shg_fname_stack = sprintf('%sshg_stack.tif',shg_dir_out); %full path
    he_fname_stack = sprintf('%she_stack.tif',shg_dir_out); %full path
    imwrite(pre_registered,shg_fname_stack,'tiff','Compression','packbits','WriteMode','append');
    imwrite(he(:,:,1),he_fname_stack,'tiff','Compression','packbits','WriteMode','append');
    
    tform_fname = sprintf('%stform_%s.mat',shg_dir_out,shg_files{i});
    save(tform_fname, 'tform');
    
    if (1)%i == 1 || i == 2)
        figure(1); imshow(he);
        hold on;
        h = imshow(imadjust(pre_registered),'Colormap',copper);
        set(h, 'AlphaData', 0.5);
        %set(h, 'Colormap',jet);
        pause on;
        pause (10);
    end    
        

end

