function [f,lhv,rhv] = findFWHM(b)

%get full width at half max of vector in samples

[m,ind] = max(b);
m2 = m/2;

%search for left half value
i = ind;
while b(i) > m2 && i ~= 2
   i = i-1;
end
%interpolate
p1 = i - (m2 - b(i))/(b(i+1) - b(i));
lhv = [p1;m2];

%search for right half value
i = ind;
while b(i) > m2 && i ~= length(b)-1
    i = i+1;
end
%interpolate
p2 = i + (m2 - b(i))/(b(i-1) - b(i));
rhv = [p2;m2];

%compute fwhm
f = p2 - p1;

end