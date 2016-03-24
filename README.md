Cluster analysis of image RGB colors
====================================

This repository contains Python and R scripts for reducing the number of colors in images using K-Means++ clustering.

You can view the animated GIF [here](image_output_files/Newport_seafood_k_means++_cluster_animated.gif).  To see a larger image click "raw" there to download the image in it's 1024x768 size.  Open the file in a browser or other tool that will run an animated gif.

The code in this repository takes an image as an input and then finds 1,2,3, ...256 color centers of the RGB colors in the image.  It outputs a series of images. The first image is 1 color only, the second has 2 colors etc.  The number of colors in each image is shown in the upper right corner of each frame.  The script produces 28 frames.  The original image and an all black "0 clusters" image provide a total of 30 frames.  Using <a href="http://gifmaker.me/" rel="nofollow">gifmaker.me/</a> I combined the images into an animated GIF.

The python code is the most recent and implements all the features as seen in the animated gif such as the writing of the original image to the output directory, use a newer directory structure and writing the duration of each cluster loop to the console.

I used k-means++ instead of standard k-means clustering due to the number of pixels with RGB values very close to one another.  The k-means R library had a problem with convergence but k-means++ worked well.

I shot the original Newport_seafood photo in Newport Oregon in Feb 2010.

Enjoy!
