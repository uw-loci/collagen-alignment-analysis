
function wav = CALwaviness(data)

fnum = length(data.Fa);  % nuber of the extracted fibers
%
% waviness = (fiber length)/ (length of the straight line connecting the fiber start point and the end point )
fsp = zeros(fnum,1); % fiber start point
fep = zeros(fnum,1); % fiber end point
dse = zeros(fnum,1); % distance between start point and end point
for i = 1:fnum
    fsp(i) = data.Fa(i).v(1);
    fep(i) = data.Fa(i).v(end);
    dse(i) = norm(data.Xa(fep(i),:)-data.Xa(fsp(i),:));
  
end

wav = data.M.L./dse;



