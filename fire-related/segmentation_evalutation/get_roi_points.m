function [ npoints xpoints ypoints  ] = get_roi_points( roiPath )
%returns the points in the ImageJ ROI
%   Detailed explanation goes here
%Requires Fiji/scripts to be in the path def for Matlab to run MIJI

%fiji.sc/RoiDecoder.java
%fiji.sc/PolygonRoi.java
%fiji.sc/FloatPolygon.java

%Miji

%roiPath = 'Z:\liu372\fiberextraction\testimages\073112\test_image_annotation\seg_eval\0131-0297.roi';
decRoi = ij.io.RoiDecoder(roiPath);
baseRoi = decRoi.getRoi();
floatPoly = baseRoi.getFloatPolygon();


%gives the points with respect to the edge of the cropped image, not full
%image
npoints = floatPoly.npoints;
xpoints = floatPoly.xpoints;
ypoints = floatPoly.ypoints;
total_seg_pts = [];

for i = 1:npoints-1
    pt1 = [ypoints(i) xpoints(i)];
    pt2 = [ypoints(i+1) xpoints(i+1)];
    
    [seg_pts, ~] = GetSegPixels( pt1, pt2 );
    total_seg_pts = [total_seg_pts; seg_pts];
end

npoints = length(total_seg_pts);
ypoints = total_seg_pts(:,1);
xpoints = total_seg_pts(:,2);

%MIJ.exit


end

