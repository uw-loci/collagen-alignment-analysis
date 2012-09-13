function [ tot_dist ] = dist_btwn_fibers( man_fib, auto_fib )

%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

man = [man_fib.xpoints man_fib.ypoints];
auto = [(auto_fib.x' - auto_fib.crop_pos_col) (auto_fib.y' - auto_fib.crop_pos_row)];

[idx,dist] = knnsearch(auto,man);

tot_dist = sum(dist);

end

