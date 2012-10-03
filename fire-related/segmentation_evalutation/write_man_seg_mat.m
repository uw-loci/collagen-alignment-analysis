

%This script takes the manual segmentation ROI's from FIJI and puts them
%into a .mat file. Now I'm using it to compare manual segmentation to auto
%segmentation.

%NEED TO START MIJI


clear all;
close all;
clc;

iJ_top_dir = 'Z:\liu372\fiberextraction\testimages\073112\test_image_annotation\ROI_Conklin\unzipped\';
out_name = '.\roi_mc2.mat';

case_list = dir(iJ_top_dir);

num_cases = length(case_list)-2; %should check more rigourously for the number of cases

rater_struct(num_cases) = struct('case_name', [], 'roi_struct', []);

case_cnt = 0;
tot_fib_num = 0;

%Loop through all raters
%Loop through all cases
for n = 1:length(case_list)
    case_name = case_list(n).name;
    tif_ext = regexp(case_name,'.tif');
    if (tif_ext ~= 0)
        %This is a good directory
        case_cnt = case_cnt + 1;
        case_dir = [iJ_top_dir case_name '\'];
        roi_list = dir(case_dir);
        %subtract 2 below to account for ./ and ../
        num_rois = length(roi_list)-2;
        roi_struct(num_rois) = struct('npoints', [],... 
                                      'xpoints', [],...
                                      'ypoints', [],...
                                      'lengths', [],...
                                      'angles', [],...
                                      'tot_len', [],...
                                      'ep_ang', [],...                                      
                                      'avg_ang', [],...
                                      'stdev_ang', []);
                                            
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
                
                sum_len = 0;
                sum_ang = 0;
                %compute the length and angle of each segment in the fiber
                for k = 1:npoints-1
                    seg_len = sqrt( (ypoints(k+1)-ypoints(k)).^2 + (xpoints(k+1)-xpoints(k)).^2);
                    seg_ang = atan2( ypoints(k+1)-ypoints(k), xpoints(k+1)-xpoints(k) );
                    roi_struct(roi_cnt).lengths(k) = seg_len;
                    roi_struct(roi_cnt).angles(k) = seg_ang;
                    sum_len = sum_len + seg_len;
                    sum_ang = sum_ang + seg_ang;
                end
                roi_struct(roi_cnt).tot_len = sum_len;
                roi_struct(roi_cnt).avg_ang = sum_ang/(npoints-1);
                
                %compute the standard deviation of angles in the fiber
                sum_dif = 0;
                for k = 1:npoints-1
                    difsq = (roi_struct(roi_cnt).avg_ang - roi_struct(roi_cnt).angles(k)).^2;
                end    
                
                %compute the angle of the line connecting the endpoints of
                %the fiber
                roi_struct(roi_cnt).ep_ang = atan2( ypoints(npoints)-ypoints(1), xpoints(npoints)-xpoints(1) );
            else
                continue;
            end
        end
        
        tot_fib_num = tot_fib_num + roi_cnt;
        rater_struct(case_cnt).case_name = case_name;
        rater_struct(case_cnt).roi_struct = roi_struct;
        
        clear('roi_struct');
    
    else
        continue;
    end
end

%compute length distribution

%compute end point angle distribution

%compute complete angle distribution

%compute curvature distribution


save(out_name,'tot_fib_num','rater_struct');