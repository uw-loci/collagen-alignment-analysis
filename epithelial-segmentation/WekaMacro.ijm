
run("Close All");
run("Leaf (36K)");
// start plugin
run("Advanced Weka Segmentation");
 
// wait for the plugin to load
wait(3000);
selectWindow("Trainable Weka Segmentation");
//classFile = "Z:\\bredfeldt\\Conklin data - Invasive tissue microarray\\FijiResults\\Segmentation\\Weka\\test_cases\\epithelial_classifier2.model";
//classFile = "Y:\\bredfeldt\\Conklin data - Invasive tissue microarray\\FijiResults\\Segmentation\\Weka\\Training20130923\\smallerStack\\classifier.model";
//classFile = "L:\\Conklin data - Invasive tissue microarray\\CasesForJohannes\\EpiTrainclassifier.model";
classFile = "C:\\Users\\bredfeldt\\Desktop\\ConklinAJP\\EpiTrainclassifier.model";
print("Loading classifier: " + classFile);
call("trainableSegmentation.Weka_Segmentation.loadClassifier", classFile);

//inDir = "Z:\\bredfeldt\\Conklin data - Invasive tissue microarray\\Slide 1B\\Slide 1B\\";
//outDir = "Z:\\bredfeldt\\Conklin data - Invasive tissue microarray\\FijiResults\\Segmentation\\Weka\\results_1B_part1\\";

//inDir = "Z:\\Conklin data - Invasive tissue microarray\\ValidationSets20130923\\HE\\";
//outDir = "Z:\\Conklin data - Invasive tissue microarray\\ValidationSets20130923\\\\HE\\epithelialSeg\\part1\\";

inDir = "C:\\Users\\bredfeldt\\Desktop\\ConklinAJP\\Originals\\HE\\";
outDir = "C:\\Users\\bredfeldt\\Desktop\\ConklinAJP\\Originals\\HE\\epithelialSeg\\part1_try3";

//inDir = "L:\\Conklin data - Invasive tissue microarray\\TrainingSets20130827\\TPos\\Originals\\HE";
//outDir = "L:\\Conklin data - Invasive tissue microarray\\TrainingSets20130827\\TPos\\epithelialSeg\\part1_try3";

//list1 = getFileList("P:\\Conklin data - Invasive tissue microarray\\Slide 2B he\\");
list1 = getFileList(inDir);

for (k = 0; k <  list1.length; k = k + 1)
//for (k = 0; k <  1; k = k + 1)
{
	print("Applying classifier to " + list1[k]);
	call("trainableSegmentation.Weka_Segmentation.applyClassifier",inDir, list1[k], "showResults=true","storeResults=true", "probabilityMaps=true", outDir);
}
print("Done segmenting " + k + "images.");

