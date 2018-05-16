Posterize an image using K-means clustering of RGB values
====================================

This repository contains Python and R scripts for reducing the number of colors in images using K-Means++ clustering.  The code operates on jpeg file.

You can view the animated GIF [here](image_output_files/Newport_seafood_k_means++_cluster_animated.gif).  To see a larger image click "raw" there to download the image in it's 1024x768 size.  Open the file in a browser or other tool that will run an animated gif.

The code in this repository takes an image as an input and then finds 1,2,3, ...256 color centers of the RGB colors in the image.  It outputs a series of images. The first image is 1 color only, the second has 2 colors etc.  The number of colors in each image is shown in the upper right corner of each frame.  The script produces 28 frames.  The original image and an all black "0 clusters" image provide a total of 30 frames.  I combined the images into an animated GIF using <a href="http://gifmaker.me/" rel="nofollow">gifmaker.me/</a> .

The python code is the most recent and implements all the features as seen in the animated gif such as the writing of the original image to the output directory, adding a newer directory structure and writing the duration of each cluster loop to the console.

I shot the Newport_seafood photo taken in Newport Oregon in February 2010.

Enjoy!
