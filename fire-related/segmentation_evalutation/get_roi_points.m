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

%MIJ.exit


end

