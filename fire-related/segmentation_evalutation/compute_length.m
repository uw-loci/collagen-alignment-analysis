function [ len ] = compute_length( x1, x2, y1, y2 )

len = sqrt((y2-y1).^2 + (x2-x1).^2);

end

