
%pull out the automated fibers extracted by FIRE in only the regions where
%we have cropped. This is for evaluation of the accuracty of the FIRE fiber
%segmentation compared to manual segmentation.

clear all;
close all;
%clc;
display_on = 0;

%cases (order really matters)
num_cases = 5; %full images
num_crops = 5; %cropped out regions from each image
num_params = 5; %number of parameters we are optimizing over for each algorithm
num_algorithms = 4; %ways of processing the data
case_struct(num_cases) = struct('name', [], 'crop_x', [], 'crop_y', []);
case_struct(1).name = 'test7';
case_struct(2).name = 'test21';
case_struct(3).name = 'test22';
case_struct(4).name = 'test23';
case_struct(5).name = 'test24';

%algorithms (order doesn't matter as much)
algo_str(num_algorithms) = struct('name', []);
%algo_str(5).name = '-FIREout';
algo_str(4).name = '-FIREoutGF';
algo_str(3).name = '-FIREoutSTV';
algo_str(2).name = '-FIREoutTUB';
algo_str(1).name = '-FIREoutCTr';



%-----------------------------------------
%x positions of crops
case_struct(1).crop_x = [
    68, ...
    401,...
    480,...
    1,  ...
    345];

case_struct(4).crop_x = [
    630,...
    333,...
    800,...
    350,...
    630];

case_struct(5).crop_x = [
    728,...
    174,...
    640,...
    180,...
    500];

case_struct(2).crop_x = [
    820,...
    310,...
    370,...
    680,...
    620];

case_struct(3).crop_x = [
    568,...
    704,...
    400,...
    810,...
    180];
%-----------------------------------------
%y positions of crops
case_struct(1).crop_y = [
    230,...
    22, ...
    460,...
    450,...
    345];

case_struct(4).crop_y = [
    662,...
    545,...
    450,...
    50, ...
    770];

case_struct(5).crop_y = [
    147,...    
    417,...
    450,...
    760,...
    580];

case_struct(2).crop_y = [
    534,...
    230,...
    120,...
    70, ...
    830];

case_struct(3).crop_y = [
    72, ...    
    634,...
    80,...
    300,...
    550];

crop_w = 128;
crop_h = 128;


%directory where all the fiber results are stored
src_dir = 'E:\Images\FIRE_Results\';

complete_struct(num_cases*num_algorithms*num_params*num_crops) = struct('case_name', [], 'case_idx', [], 'algo_name', [], 'algo_idx', [], 'param_name', [], 'param_idx', [], 'crop_name', [], 'crop_idx', [], 'fiber_list', []);

str_idx = 1; %structure index
%exp_struct(num_cases) = struct('name', [], 'method_struct', []);
for i = 1:num_cases
%for i = 2:2    
    case_name = case_struct(i).name;                
    for j = 1:num_algorithms
        algo_name = algo_str(j).name;                
        for jj = 1:num_params
            mat_path = [src_dir case_name algo_name '_P' num2str(jj) '.mat']
            full_fib_struct = load(mat_path);
            if (j == 1 && display_on)
                %open and display the image
                %full_image = imread('Z:\liu372\fiberextraction\testimages\073112\test_image_annotation\original_images\TACS-3a.tif');
                full_image = imread('Z:\liu372\fiberextraction\testimages\073112\test_image_annotation\original_images\04_25_12 Trentham DCIS 542805 -02.tif');
                figure(1); hold off; imshow(full_image); hold on;
            end
                        
            for k = 1:num_crops
                disp(['crop number = ' int2str(k)]);
                %these are the positions of the crops
                x1 = case_struct(i).crop_x(k);
                x2 = x1 + crop_w;
                y1 = case_struct(i).crop_y(k);
                y2 = y1 + crop_h;
                %create a new fiber structure for fibers that are inside cropped region
                crop_fib_ind = 0;
                                              
                num_fib = length(full_fib_struct.data.Fai);
                complete_struct(str_idx).fiber_list = struct('indiv_fib_struct', []);
                %loop through each fiber in entire structure
                for m = 1:num_fib
                    fib_len = 0;
                    num_pts = length(full_fib_struct.data.Fai(m).v);
                    %loop through all points in the fiber
                    for n = 1:num_pts
                        ind = full_fib_struct.data.Fai(m).v(n);
                        %row_pt and col_pt are the positions in the full image
                        row_pt = full_fib_struct.data.Xai(ind,2);
                        col_pt = full_fib_struct.data.Xai(ind,1);
                        if (row_pt >= y1 && row_pt <= y2 && col_pt >= x1 && col_pt <= x2)

                            %there is a point on this fiber that is in the cropped
                            %region

                            %have we already entered this fiber into the new structure?
                            if (fib_len < 0)
                                %start a new fiber and add the point                    
                                indiv_fib_struct = struct('x', [], 'y', [], 'crop_pos_col', [], 'crop_pos_row', []);   
                            end
                            fib_len = fib_len + 1;
                            indiv_fib_struct.x(fib_len) = col_pt; %position in full image
                            indiv_fib_struct.y(fib_len) = row_pt;

                            if (j == 1 && display_on)
                                figure(1); plot(gca, col_pt, row_pt, 'o','MarkerSize',1,'MarkerEdgeColor','r');
                            end
                        end
                    end
                    if (fib_len > 0)
                        %add fiber to collection of fibers in crop
                        indiv_fib_struct.crop_pos_col = x1;
                        indiv_fib_struct.crop_pos_row = y1;
                        crop_fib_ind = crop_fib_ind + 1;
                        %crop_struct(crop_fib_ind).indiv_fib_struct = indiv_fib_struct;
                        complete_struct(str_idx).fiber_list(crop_fib_ind).indiv_fib_struct = indiv_fib_struct;
                        clear('indiv_fib_struct');
                    end
                end
                complete_struct(str_idx).case_name = case_name;
                complete_struct(str_idx).algo_name = algo_name;
                complete_struct(str_idx).param_name = ['P' num2str(jj)];
                complete_struct(str_idx).crop_name = ['crop' num2str(k)];
                
                %these are used by the next program for relating manual to auto
                complete_struct(str_idx).case_idx = i;
                complete_struct(str_idx).algo_idx = j;
                complete_struct(str_idx).param_idx = jj;
                complete_struct(str_idx).crop_idx = k; 
                str_idx = str_idx + 1; %structure index
            end
        end
    end
end
%after done, save the whole structure
save('all_extracted_crops.mat','complete_struct','num_cases','num_crops','num_params','num_algorithms');