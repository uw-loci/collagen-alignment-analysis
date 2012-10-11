%compare_man_auto_seg.m

%loop through all methods
%loop through all images
%loop through all crops
%loop through all manually segmented fibers in crop

%compare man fiber to each auto fiber

%Is angle similar
    %Is position similar
        %Is length similar

%clear all;
%close all;
%clc;

plot_on = 0;

ang_thresh = 0.3;
dist_thresh = 0.5; %relative to fiber length
len_thresh = 2; %relative to fiber length

%open the manual segmentation mat file

%open the auto segmentation mat file
auto_mat = load('all_extracted_crops.mat');
%output file
%out_fname = 'compare_man_auto_seg_out_jb.txt';
%file_id = fopen(out_fname, 'w+');
%fprintf(file_id,'%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\r\n', 'name', 'precision', 'recall', 'fmeas', 'overseg', 'underseg', 'num_man_fibers', 'num_auto_fibers', 'true_pos_rt', 'false_pos_rt');
%fclose(file_id);

%first image, first method, first crop, first fiber
%pts_x = auto_mat.exp_struct(1).method_struct(1).image_struct(1).crop_struct(1).indiv_fib_struct.x;
%pts_y = auto_mat.exp_struct(1).method_struct(1).image_struct(1).crop_struct(1).indiv_fib_struct.y;
%[ang_array avg_ang std_ang ent_ang curvature] = ...
%    avg_angle(pts_x, pts_y);

num_images = auto_mat.num_cases;
num_methods = auto_mat.num_algorithms;
num_crops = auto_mat.num_crops;
num_params = auto_mat.num_params;
num_raters = 3;

precision = zeros(num_raters,num_images,num_methods,num_params,num_crops);
recall = zeros(num_raters,num_images,num_methods,num_params,num_crops);
fmeas = zeros(num_raters,num_images,num_methods,num_params,num_crops);
true_pos_rt = zeros(num_raters,num_images,num_methods,num_params,num_crops);
false_pos_rt = zeros(num_raters,num_images,num_methods,num_params,num_crops);

for r = 1:num_raters
    if r == 1
        man_mat = load('roi_jb.mat');
    elseif r == 2
        man_mat = load('roi_ym.mat');
    else
        man_mat = load('roi_mc.mat');
    end
for i = 1:length(auto_mat.complete_struct)
%for i = 1:25
    case_idx = auto_mat.complete_struct(i).case_idx;
    method_idx = auto_mat.complete_struct(i).algo_idx;
    param_idx = auto_mat.complete_struct(i).param_idx;
    crop_idx = auto_mat.complete_struct(i).crop_idx;
    man_idx = (case_idx-1)*num_images+crop_idx;
    man_name = man_mat.rater_struct(man_idx).case_name;
    auto_name = [auto_mat.complete_struct(i).case_name '_' auto_mat.complete_struct(i).algo_name '_' auto_mat.complete_struct(i).param_name '_' auto_mat.complete_struct(i).crop_name];
    disp(man_name);
    disp(auto_name);
    
    num_man_fibers = length(man_mat.rater_struct(man_idx).roi_struct);
    num_auto_fibers = length(auto_mat.complete_struct(i).fiber_list);

    disp(['num_man_fibers = ' num2str(num_man_fibers)]);
    disp(['num_aut_fibers = ' num2str(num_auto_fibers)]);
    
    ang_arr_man = zeros(1,num_man_fibers);
    ang_arr_auto = zeros(1,num_auto_fibers);
    len_arr_man = zeros(1,num_man_fibers);
    len_arr_auto = zeros(1,num_auto_fibers);

    assoc_arr_man = zeros(1,num_man_fibers); %keep track of associations
    assoc_arr_auto = zeros(1,num_auto_fibers);

    if (plot_on == 1)
        figure(crop_idx); hold off;
    end    
    
    %loop through the manual fibers
    for m = 1:num_man_fibers
        %compute length and angle information for each fiber
        %is there an auto fiber with similar angle?
        pts_x = man_mat.rater_struct(man_idx).roi_struct(m).xpoints;
        pts_y = man_mat.rater_struct(man_idx).roi_struct(m).ypoints;

        if (plot_on == 1)
            figure(crop_idx); plot(pts_x,pts_y,'-*'); hold on;
        end

        [ang_array avg_ang std_ang ent_ang curvature] = avg_angle(pts_x, pts_y);

        [len_array total_len] = fiber_length(pts_x, pts_y);

        ang_arr_man(m) = avg_ang;
        len_arr_man(m) = total_len;             
    end    
    
    %Loop through the auto fibers
    for m = 1:num_auto_fibers
        %compute length and angle information for each fiber
        %values below put the fibers on a 128 by 128 pixel grid,
        %with origin at 0,0 (auto fibers are with respect to full
        %image)
        offset_x = auto_mat.complete_struct(i).fiber_list(m).indiv_fib_struct.crop_pos_col;
        offset_y = auto_mat.complete_struct(i).fiber_list(m).indiv_fib_struct.crop_pos_row;

        pts_x = auto_mat.complete_struct(i).fiber_list(m).indiv_fib_struct.x - offset_x;
        pts_y = auto_mat.complete_struct(i).fiber_list(m).indiv_fib_struct.y - offset_y;

        if (plot_on == 1)
            figure(k); plot(pts_x,pts_y,'-or'); hold on;
        end                

        [ang_array avg_ang std_ang ent_ang curvature] = avg_angle(pts_x, pts_y);

        [len_array total_len] = fiber_length(pts_x, pts_y);

        ang_arr_auto(m) = avg_ang;
        len_arr_auto(m) = total_len;
    end    
    
    if (plot_on == 1)
        figure(crop_idx*100); hold off;
    end
    
    %cross check to find matching fibers
    for m = 1:num_man_fibers
        for n = 1:num_auto_fibers
            %check angle
            ang_man = ang_arr_man(m);
            ang_auto = ang_arr_auto(n);
            ang_dif = ang_man - ang_auto;
            %unwrap phase here, we want pi out of phase angles to
            %be considered similar
            if ang_dif > 3*pi/4
                ang_dif = ang_dif - pi;
            elseif ang_dif < -3*pi/4
                ang_dif = ang_dif + pi;
            end

            len_man = len_arr_man(m);
            len_auto = len_arr_auto(n);                    
            len_dif = abs(len_man - len_auto);

            if ((ang_dif < ang_thresh && ang_dif > -ang_thresh) || (ang_dif < (pi+ang_thresh)) && (ang_dif > (pi-ang_thresh))) %second condition is for similar angles but near pi
                %possible association based on angle                                                
                %check position
                tot_dist = dist_btwn_fibers(man_mat.rater_struct(man_idx).roi_struct(m), ...
                                 auto_mat.complete_struct(i).fiber_list(n).indiv_fib_struct);
                if (tot_dist < len_man*dist_thresh)
                    %possible association based on position                            
                    %check length                            
                    %if(len_dif < len_man/2)\
                    if(len_dif < len_man*len_thresh)
                        %possible association based on length
                        assoc_arr_man(m) = assoc_arr_man(m) + 1;
                        assoc_arr_auto(n) = assoc_arr_auto(n) + 1;

                        if(plot_on == 1)

                            %plot the manual fiber
                            pts_x = man_mat.rater_struct(man_idx).roi_struct(m).xpoints;
                            pts_y = man_mat.rater_struct(man_idx).roi_struct(m).ypoints;
                            figure(crop_idx*100); plot(pts_x,pts_y); xlim([0 128]); ylim([0 128]); hold on;

                            %plot the auto fiber
                            offset_x = auto_mat.complete_struct(i).fiber_list(n).indiv_fib_struct.crop_pos_col;
                            offset_y = auto_mat.complete_struct(i).fiber_list(n).indiv_fib_struct.crop_pos_row;
                            pts_x = auto_mat.complete_struct(i).fiber_list(n).indiv_fib_struct.x - offset_x;
                            pts_y = auto_mat.complete_struct(i).fiber_list(n).indiv_fib_struct.y - offset_y;                                    

                            figure(crop_idx*100); plot(pts_x,pts_y,'r');
                            disp(['ang_dif = ' num2str(ang_dif)]);
                            disp(['tot_dist = ' num2str(tot_dist)]);
                            disp(['len_dif = ' num2str(len_dif)]);                                    
                            pause;
                        end                                
                    end
                end
            end
        end
    end %cross check all fibers in this crop
    
    [precision(r, case_idx, method_idx, param_idx, crop_idx)...
        recall(r, case_idx, method_idx, param_idx, crop_idx)...
         fmeas(r, case_idx, method_idx, param_idx, crop_idx)...
       overseg(r, case_idx, method_idx, param_idx, crop_idx)...
      underseg(r, case_idx, method_idx, param_idx, crop_idx)...
   true_pos_rt(r, case_idx, method_idx, param_idx, crop_idx)...
  false_pos_rt(r, case_idx, method_idx, param_idx, crop_idx)] = comp_roc(assoc_arr_man, assoc_arr_auto, len_arr_man, len_arr_auto);    
    disp('0000000000000000000000000');
end
%save here to get the results before it's all over, in case I want to quit
save('compare_results.mat','precision','recall','fmeas','overseg','underseg','true_pos_rt','false_pos_rt');
end

%save('compare_results.mat','precision','recall','fmeas','overseg','underseg','true_pos_rt','false_pos_rt');