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
dir_col = "P:\\Conklin data - Invasive tissue microarray\\TrainingSets20130827\\T"+np+"\\Originals\\SHG";
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
			if (indexOf(list_col[j], nm) == 0 && indexOf(list_col[j], "_SHG") > 0)
			{
				//print(list_ep[i]);
				//print(list_col[j]);				
				//print("Processing "+nm);
				open(dir_col+"/"+list_col[j]);				
				run("32-bit");
				rename("shg density");			
				run("Gaussian Blur...", "sigma=48");
				wait(100);
				//return;
				setThreshold(40, 255);
				run("Set Measurements...", "area integrated limit redirect=None decimal=3");
				run("Measure");
				//inv_pix = getResult("Area",nResults-1);
				shg_area = getResult("Area",nResults-1);				
				selectWindow("shg density");				
				save(outpath+" "+nm+"_SHG_den.tif");


				open(dir_ep+"/"+list_ep[i],2);
				rename("ep density");				
				run("Gaussian Blur...", "sigma=16");
				wait(100);
				setThreshold(0.6, 1.0);			
				run("Set Measurements...", "area integrated limit redirect=None decimal=3");
				run("Measure");
				//inv_pix = getResult("Area",nResults-1);
				ep_area = getResult("Area",nResults-1);	
				
				//pic = inv_area/inv_col;

				//compute percent of involved epithelium (pie)
				//selectWindow("ep_prob");
				//setThreshold(0.7000, 1.0);
				//wait(3000);				

				print(nm+","+shg_area+","+ep_area);
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