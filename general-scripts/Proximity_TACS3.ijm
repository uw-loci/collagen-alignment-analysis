run("Close All");
run("Clear Results");
print("\\Clear");

for (n = 0; n < 2; n=n+1)
{
	
if (n==0){
	np = "Pos";	
} else {
	np = "Neg";
}

//Pick the directory with the epithelial segmentation
//path_ep = File.openDialog("Please Select the epithelial directory");
//dir_ep = File.getParent(path_ep);
dir_ep = "P:\\Conklin data - Invasive tissue microarray\\TrainingSets20130827\\T"+np+"\\epithelialSeg\\part1_try2";
//name = File.getName(path);

//List epithelial
list_ep = getFileList(dir_ep);


//path_col = File.openDialog("Please Select the collagen directory");
//dir_col = File.getParent(path_col);
dir_col = "P:\\Conklin data - Invasive tissue microarray\\TrainingSets20130827\\T"+np+"\\Originals\\SHG\\CA_Out";
//name2 = File.getName(path2);

//List collagen
list_col = getFileList(dir_col);

//Output directory
outpath = dir_ep+"/TACS3/";
File.makeDirectory(outpath);

//print(list_ep.length);

//Loop through all images
for (i = 0; i < list_ep.length; i=i+1)
{
	//Check to make sure epithelial is an image
	if (indexOf(list_ep[i], "_HE.tif") > -1)
	{
		//Search collagen list for matching filename
		nm = replace(list_ep[i],"_HE.tif","");
		//print(nm);
		for (j = 0; j < list_col.length; j=j+1)
		{
			if (indexOf(list_col[j], nm) == 0 && indexOf(list_col[j], "_rawmap") > 0)
			{
				//print(list_ep[i]);
				//print(list_col[j]);				
				//print("Processing "+nm);
				open(dir_col+"/"+list_col[j]);
				run("32-bit");
				rename("align_prob");	
				run("Maximum...", "radius=16");
				setThreshold(240, 255);	
				run("Convert to Mask");
				//return;		
				run("Gaussian Blur...", "sigma=4");
				getStatistics(area, mean, min, max);
				run("Multiply...", "value="+1/max);
				//run("Square");
				run("Enhance Contrast", "saturated=0.35");

				open(dir_ep+"/"+list_ep[i],2);
				rename("ep_prob");
				//run("Square");
				run("Gaussian Blur...", "sigma=1.5");
				
				imageCalculator("Multiply create 32-bit", "align_prob","ep_prob");
				//run("8-bit");								
				rename("inv_area");				
				//setThreshold(0.2, 1.0);				
				run("Set Measurements...", "area integrated limit redirect=None decimal=3");
				run("Measure");
				//inv_pix = getResult("Area",nResults-1);
				inv_area = getResult("IntDen",nResults-1);				
				
				//save involved area image
				selectWindow("inv_area");				
				save(outpath+" "+nm+".tif");

				//compute percent of involved collagen (pic)
				selectWindow("align_prob");
				//setThreshold(0.7000, 1.0);
				//wait(3000);
				run("Measure");
				inv_col = getResult("IntDen",nResults-1);
				pic = inv_area/inv_col;

				//compute percent of involved epithelium (pie)
				selectWindow("ep_prob");
				//setThreshold(0.7000, 1.0);
				//wait(3000);
				run("Measure");
				inv_ep = getResult("IntDen",nResults-1);
				pie = inv_area/inv_ep;

				//compute ratio of col to ep
				cte = inv_col/inv_ep;

				selectWindow("inv_area");
				//wait(3000);

				print(nm+","+inv_area+","+pic+","+pie+","+cte+","+inv_ep+","+inv_col);
				//return;
				run("Close All");
				
			}
		}
	}

//Open collagen image

//Max Filter collagen

//Gaussian filter collagen

//Normalized filtered collagen

//Open epithelial image

//Multiply alignment and epithelial images

//Compile results!!! Awesome, measure, but first set measurements.
//Save resulting image

//Compute involved/epithelial
//Compute involved/collagen

}
}