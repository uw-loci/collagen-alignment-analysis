//This script converts a directory of multichannel image into RGBs
//All files must be in one directory

path = File.openDialog("Please Select one File From the Directory");
dir = File.getParent(path);
name = File.getName(path);
print(dir+"/");

//make new folders
File.makeDirectory(dir+"/RGB");

list = getFileList(dir);

for (i = 0; i < list.length; i=i+1)
{
	print("Processing " + i + " of " + list.length);
	//if the file is an image
	if (indexOf(list[i], ".tif") > 0)
	{
		fn = list[i];
		//open image
		open(dir+"/"+list[i]);	
		run("RGB Color");
		save(dir+"/RGB/"+substring(fn,0,lengthOf(fn)-4)+"_RGB.tif");		
		run("Close All");
	}

}
