//Apply flat field correction to an entire directory of images

//Assume the file is in the directory of images to be corrected
path = File.openDialog("Select the Flat Field File");
dir = File.getParent(path);
name = File.getName(path);

//open the flat field file
open(dir+"/"+name);
rename("ff");
//split into r, g, & b
run("Split Channels");
//compute mean of r, g, & b
selectWindow("ff (red)");
getStatistics(area,meanR);
selectWindow("ff (green)");
getStatistics(area,meanG);
selectWindow("ff (blue)");
getStatistics(area,meanB);

list = getFileList(dir);

//print(list.length + " files or folders in directory.");
//loop thru all images in directory
for (i = 0; i < list.length; i=i+1)
{
	print("Processing " + i + " of " + list.length);
	//if the file is an image
	if (indexOf(list[i], ".tif") > 0)
	{	
		//open image
		open(dir+"/"+list[i]);
		rename("im");
		//split into r,g,b
		run("Split Channels");
		//correct r
		run("Calculator Plus", "i1=[im (red)] i2=[ff (red)] operation=[Divide: i2 = (i1/i2) x k1 + k2] k1="+meanR+" k2=0 create");
		rename("red");
		//correct g
		run("Calculator Plus", "i1=[im (green)] i2=[ff (green)] operation=[Divide: i2 = (i1/i2) x k1 + k2] k1="+meanG+" k2=0 create");
		rename("gre");
		//correct b
		run("Calculator Plus", "i1=[im (blue)] i2=[ff (blue)] operation=[Divide: i2 = (i1/i2) x k1 + k2] k1="+meanB+" k2=0 create");
		rename("blu");
		//merge channels
		run("Merge Channels...", "c1=red c2=gre c3=blu create");
		run("RGB Color");
		//save resulting image
		selectWindow("Composite (RGB)");
		run("Size...", "width=512 height=382 constrain average interpolation=Bilinear");
		save(dir+"/ff/ff_"+list[i]);
		//close images, except for flat field ones
		close();
		selectWindow("Composite");
		close();
		selectWindow("im (red)");
		close();
		selectWindow("im (green)");
		close();
		selectWindow("im (blue)");
		close();
	}

}
