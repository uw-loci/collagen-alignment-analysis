

clear all;
close all;
clc;

iJ_top_dir = 'Z:\liu372\fiberextraction\testimages\073112\test_image_annotation\ROI_JB\unzipped\';

case_list = dir(iJ_top_dir);

num_cases = length(case_list)-2;

rater_struct(num_cases) = struct('roi_struct', []);

lumped_struct(num_cases) = struct('xpoints', [], 'ypoints', []);

case_cnt = 0;

%Loop through all cases
for n = 1:length(case_list)
    list_name = case_list(n).name;
    tif_ext = regexp(list_name,'.tif');
    if (tif_ext ~= 0)
        %This is a good directory
        case_cnt = case_cnt + 1;
        case_dir = [iJ_top_dir list_name '\'];
        roi_list = dir(case_dir);
        roi_struct(length(roi_list)-2) = struct('npoints', [],... 
                                                'xpoints', [],...
                                                'ypoints', []);
                                            
        roi_cnt = 0;
        
        %Loop through all roi's
        for m = 1:length(roi_list)
            roi_name = roi_list(m).name;
            roi_ext = regexp(roi_name,'.roi');
            if (roi_ext ~= 0)
                %This is a good roi filename
                roi_cnt = roi_cnt + 1;
                roi_path = [case_dir roi_name];
                %get x-y coordinates of every fiber in the roi file
                [npoints xpoints ypoints] = get_roi_points(roi_path);
                roi_struct(roi_cnt).npoints = npoints;
                roi_struct(roi_cnt).xpoints = xpoints;
                roi_struct(roi_cnt).ypoints = ypoints;
                
                lumped_struct(case_cnt).xpoints = [lumped_struct(case_cnt).xpoints; xpoints];
                lumped_struct(case_cnt).ypoints = [lumped_struct(case_cnt).ypoints; ypoints];
            else
                continue;
            end
        end
        
        rater_struct(case_cnt).roi_struct = roi_struct;
        save('..\roi_jb.mat','rater_struct');
    
    else
        continue;
    end
end


fire_top_dir



%compute delauny triangulation for these points

%open the fire result file
%get x-y coordinates of every fiber in the fire result file
%compute delauny triangulation for these points

%compute nearest neighbor to fire result for each point in roi file
%compute nearest neighbor to roi file for each point in fire result

%compute the Housdorff distance
%compute the Mean distance