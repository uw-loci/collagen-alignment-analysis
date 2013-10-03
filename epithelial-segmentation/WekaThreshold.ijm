
run("Close All");

np = "Neg";

//dir1 = "Z:\\bredfeldt\\Conklin data - Invasive tissue microarray\\FijiResults\\Segmentation\\Weka\\results_1B_part1\\";
dir1 = "Y:\\Conklin data - Invasive tissue microarray\\TrainingSets20130827\\T"+np+"\\epithelialSeg\\part1_try2\\";
list1 = getFileList(dir1);
//dir2 = "Z:\\bredfeldt\\Conklin data - Invasive tissue microarray\\Slide 1B\\Slide 1B\\"
dir2 = "Y:\\Conklin data - Invasive tissue microarray\\TrainingSets20130827\\T"+np+"\\Originals\\HE\\";
list2 = getFileList(dir2);
//outpath = "Z:\\bredfeldt\\Conklin data - Invasive tissue microarray\\FijiResults\\Segmentation\\Weka\\results_1B_part2\\";
outpath = "Y:\\Conklin data - Invasive tissue microarray\\TrainingSets20130827\\T"+np+"\\epithelialSeg\\part2_try2C\\";

for (k = 0; k <  list1.length; k = k + 1)
//for (k = 0; k < 1; k = k + 1)
{
	name = list1[k];
	open(dir1 + name,1); //only open first image
	name = replace(name,'_HE',''); //remove _HE from the filename
	run("Gaussian Blur...", "sigma=2");
	setThreshold(0.0, 0.35);
	run("Create Mask");
	run("Analyze Particles...", "size=100-Infinity circularity=0.00-1.00 show=Masks include");	
	run("Gaussian Blur...", "sigma=8");
	setThreshold(90, 255);
	run("Create Mask");
	run("Analyze Particles...", "size=100-Infinity circularity=0.00-1.00 show=Masks include");
	//run("Convert to Mask", "method=Default");	
	rename("epithelial_clusters");
	//run("Duplicate...", "title=[epithelial_skeleton]");
	//run("Skeletonize (2D/3D)");
	//run("Invert LUT");
	//save(outpath+"sboundary for "+name+".tif");
	selectWindow("epithelial_clusters");
	run("Invert LUT");	
	save(outpath+"mask for "+name+".tif");
	selectWindow("epithelial_clusters");	
	run("Outline");	
	rename("epithelial_cluster_outlines");
	run("Invert");	
	save(outpath+"boundary for "+name+".tif");

	open(dir2 + list2[k]);
	rename("he");
	run("Split Channels");
	run("Merge Channels...", "c1=[he (red)] c2=[he (green)] c3=[he (blue)] c7=epithelial_cluster_outlines create");
	//run("Add Image...", "image=epithelial_cluster_outlines x=0 y=0 opacity=50");
	run("RGB Color");
	save(outpath+"weka_epithelial_over_"+name);
	
	run("Close All");
}

