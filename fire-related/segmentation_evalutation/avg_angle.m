function [ ang_array avg_ang std_ang ent_ang curvature ] = avg_angle( x, y )
%Compute the length weighted average angle.
% The percentage of the total length of the fiber of each segment weights
% the angle in the sum.
% x is a 1Xn array of column positions, length should be > 1
% y is a 1Xn array of row positions, length should be > 1

len_x = length(x);
len_y = length(y);

if (len_x <= 1 || len_y <= 1 || len_x ~= len_y)
    ang_array = NaN;
    avg_ang = NaN;
    std_ang = NaN;
    ent_ang = NaN;
    curvature = NaN;
    return;
end

ang_array = zeros(1,len_x-1);
[len_array total_len] = fiber_length(x, y);
avg_ang = 0;
prev_ang = 0;

for i = 1:len_x-1
    rise = y(i+1)-y(i);
    run = x(i+1)-x(i);
    ang = atan(rise/run);
    %unwrap phase here, this preserves the std, entr, and curvature
    %measures
    if i > 1
        if ang-prev_ang > 3*pi/4
            ang = ang - pi;
        elseif ang-prev_ang < -3*pi/4
            ang = ang + pi;
        end
    end
    prev_ang = ang;
    %if ang < 0
        %wrap angle to only 0 to pi
    %    ang = pi - abs(ang);
    %end
    wt_ang = ang*(len_array(i)/total_len);
    avg_ang = avg_ang + wt_ang;
    ang_array(i) = ang;
end

std_ang = std(ang_array);
ent_ang = entropy(ang_array);

%compute curvature
len_ang_array = length(ang_array);
if len_ang_array > 1
    for i = 1:len_ang_array - 1
        %first derivative of angle array
        d_ang_array(i) = ang_array(i+1) - ang_array(i);
    end
    curvature = sum(d_ang_array.^2)/length(d_ang_array);
else
    curvature = 0;
end


end

