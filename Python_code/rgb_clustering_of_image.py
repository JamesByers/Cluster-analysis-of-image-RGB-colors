# -*- coding: utf-8 -*-
"""
Created on Tue Feb 23 16:32:34 2016

@author: jim_byers

Tested with python 2.7
"""

import Image
import ImageFont
import ImageDraw
import textwrap
import pandas as pd
from sklearn.cluster import KMeans
from datetime import datetime

font = ImageFont.truetype('/Library/Fonts/Arial.ttf', 35)
def placeText (image,a_str,font): # place center justified text on image
    font_color = (255,165,0)
    para = textwrap.wrap(a_str, width=8)   
    draw = ImageDraw.Draw(image)
    current_h, pad = 5, 0
    for line in para:
        w, h = draw.textsize(line, font=font)
        draw.text((imageW - 65 - (w / 2), current_h), line, font_color, font=font)
        current_h += h + pad


output_path = "../Output_Newport_seafood_image_and_Animated_GIF/"
input_path = "../Image_input_files/"
img_filename = "Newport_seafood.png"
im = Image.open(input_path + img_filename)
imageW = im.size[0]
imageH = im.size[1]

## create a dataframe of the image data
imageW = im.size[0]
imageH = im.size[1]
im_list = []
xrange = range(0,imageW)
yrange = range(0,imageH)
for y in yrange:
    for x in xrange:
        r, g, b = im.getpixel((x, y))
        im_list.append([x,y,r,g,b])

## write out original image
temp_im = im
placeText(temp_im,'''Original image''',font)
temp_im.save(output_path + "cluster_out_original_image" + ".png")

## Generate posterized images with increasing number of colors      
df_columns = ['x','y','r','g','b']

#num_clusters = [1,2,3,4,5,6,7,8,9,10,11,12,13,14,16,25,36,49,64,81,100,121,128,144,169,196,256]
num_clusters = [2,4]
print('Starting RBG cluster calculations and posterizing images')
for num in num_clusters:
    print("starting on calc of " + str(num) + " clusters")
    # K-means with 3 clusters
    dt_loop_start = datetime.now()
#     print(num + ' cluster start time: ' + str(datetime.now()))
    temp_imdf = pd.DataFrame(im_list, columns=df_columns)
    X = temp_imdf[['r','g','b']]
    km = KMeans(n_clusters=num, random_state=30)
    km.fit(X)
    temp_imdf['cluster'] = km.labels_
    cluster_r = {}
    cluster_g = {}
    cluster_b = {}
    for i in range(0,num):
        cluster_r[i], cluster_g[i], cluster_b[i] = km.cluster_centers_[i].round().astype(int) # Python 2.7x round() returns a float but 3.3x returns and int    

    clust_r = []
    clust_g = []
    clust_b = []
    for row in temp_imdf.iterrows():
        cluster_num = row[1][5]
        clust_r.append(cluster_r[cluster_num])
        clust_g.append(cluster_g[cluster_num])
        clust_b.append(cluster_b[cluster_num])
    temp_imdf['cluster_r'] = clust_r
    temp_imdf['cluster_g'] = clust_g
    temp_imdf['cluster_b'] = clust_b

## Generate posterize image    
    subset = temp_imdf[['cluster_r', 'cluster_g', 'cluster_b']]
    rgb_tuples = [tuple(x) for x in subset.values]
    temp_image = Image.new("RGB",[imageW,imageH])
    temp_image.putdata(rgb_tuples)
#    font = ImageFont.truetype('/Library/Fonts/Arial.ttf', 35)
    draw = ImageDraw.Draw(temp_image)
    placeText(temp_image,str(num),font)
    dt_loop_end = datetime.now()
    loop_duration = dt_loop_end - dt_loop_start
    print(str(num) + " cluster loop completed in: " + str(loop_duration))
    temp_image.save(output_path + "cluster_out_" + str(num) + ".png")
#    print(str(num) + ' cluster end time: ' + str(datetime.now()))     
