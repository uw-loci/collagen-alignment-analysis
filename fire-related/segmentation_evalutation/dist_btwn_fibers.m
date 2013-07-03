function [ tot_dist ] = dist_btwn_fibers( man_fib, auto_fib )

%Find the median of the minimum distance between each point on two fibers

% ideas
% Compute distance between best fit lines or best fit quadratics for the fibers

i = 1;
manf = GetSegPixels( [man_fib.ypoints(i), man_fib.xpoints(i)], [man_fib.ypoints(i+1), man_fib.xpoints(i+1)] );
for i = 2:length(man_fib.xpoints)-1
    [man ang] = GetSegPixels( [man_fib.ypoints(i), man_fib.xpoints(i)], [man_fib.ypoints(i+1), man_fib.xpoints(i+1)] );
    manf = vertcat(manf, man);
end
    
auto = [(auto_fib.y' - auto_fib.crop_pos_row) (auto_fib.x' - auto_fib.crop_pos_col)];

[idx,dist] = knnsearch(auto,manf);

tot_dist = sum(dist)/length(idx);
%tot_dist = median(dist);

end

