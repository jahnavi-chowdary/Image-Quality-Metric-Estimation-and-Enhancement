# Image-Quality-Metric-Estimation-and-Enhancement
Built a system which estimates the quality of a given 'Retinal Image' and passes it to an enhancement block if it fits in as a normal quality image and rejects it otherwise. Various methods including Image Structural Clustering along with other pattern recognition techniques were implemented to build the above system. </br>

GETTING GROUND TRUTH QUALITY METRIC </br>
DatasetRet.m , Dmed.m, quality.m , creeEq.m , exDetect.m , getFovmask.m , kirschEdges.m , ReadGNDFile.m are used to get the ground truth - a quality metric between 1-10 for the retinal images in the Dmed dataset. </br>
</br>
ENHANCEMENT </br>
enhancing.m uses enhancement.m to enhance a given retinal image. enhancement.m uses the following functions : </br>
-> computebgimg.m , computebgimgnur.m to compute the background image.</br>
-> create_mask.m to create the mask of the retinal image. </br>
-> extension.m to extend the retinal image inorder to avoid artifacts. </br>
-> getmeanvar.m to get the mean and variance. </br>
-> LumConDrift.m computes the luminosity and contrast in the given retinal image. </br>
</br>
QUALITY ESTIMATIOM USING VARIOUS HISTOGRAMS AS FEATURE VECTOR AND USING DIFFERENT CLASSIFIERS. </br>
targetvector.m, targetvector_test.m compute the feature vector of the training and testing samples. The following functions are used : </br>
rgb_features.m , lab_features.m, hsv_features.m , ycbcr_featires.m , xyz_features.m , yiq_features.m compute 4 moments in respective color spaces. </br>
KLDiv.m computes the KL divergence between 2 histograms. </br>
Naivebayeis_normal.m classifies the data using Naive bayes classifier. </br>
backprop.m , nn.m is used to classify the data using neural network back propagation. </br>
accuracy.m , avcost.m are used to compute the accuracy of the system. </br>
PCA.m is used for dimensionality reduction. </br>
svm.m classifies the data using an appropriate svm classifier with best parameters. </br>
</br>
USING IMAGE STRUCTURAL CLUSTERING TO ESTIMATE QUALITY </br>
filterderivative_withLoc_save.m computes the feature vector for the Image structural clustering method. </br>
full_code.m contains the main code that uses image structural clustering to get the quality of the given retinal image. </br>
 




