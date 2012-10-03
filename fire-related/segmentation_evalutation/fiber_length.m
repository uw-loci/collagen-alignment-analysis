function [ len_array total_len ] = fiber_length( x, y )
%Compute the length of each segment of a fiber, also return total length

len_x = length(x);
len_y = length(y);

if (len_x <= 1 || len_y <= 1 || len_x ~= len_y)
    len_array = NaN;
    total_len = NaN;
    return;
end

len_array = zeros(1,len_x-1);
total_len = 0;

for i = 1:len_x-1
    seg_len = compute_length(x(i+1), x(i), y(i+1), y(i));
    len_array(i) = seg_len;
    total_len = total_len + seg_len;
end

end

