%fiji.sc/RoiDecoder.java
%fiji.sc/PolygonRoi.java

%Miji - need to start Miji before running this

clear all;
close all;
clc;

roi_path = 'Z:\liu372\fiberextraction\testimages\073112\test_image_annotation\seg_eval\0007-0061.roi';
roidec = ij.io.RoiDecoder(roi_path);
roig = roidec.getRoi();

x_coords = roig.getXCoordinates();
y_coords = roig.getYCoordinates();

pts = roig.getNCoordinates();

flPoly = roig.getFloatPolygon();

npts = flPoly.npoints;
flx = flPoly.xpoints;
fly = flPoly.ypoints;