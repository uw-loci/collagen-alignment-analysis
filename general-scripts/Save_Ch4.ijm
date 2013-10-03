//All files must be in one directory
path = File.openDialog("Please Select one File From the Directory");
dir = File.getParent(path);
name = File.getName(path);
print(dir+"/");


//make new folders
File.makeDirectory(dir+"/SHG");
File.makeDirectory(dir+"/HE");

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
	
		run("Split Channels");
		run("Merge Channels...", "c1=C1-"+fn+" c2=C2-"+fn+" c3=C3-"+fn+" create");
		selectWindow(fn);
		run("RGB Color");
		save(dir+"/HE/"+substring(fn,0,lengthOf(fn)-4)+"_HE.tif");
		selectWindow("C4-"+fn);
		run("Grays");
		save(dir+"/SHG/"+substring(fn,0,lengthOf(fn)-4)+"_SHG.tif");
		run("Close All");
	}

}
