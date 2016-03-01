

# Load the package
library(jpeg)
url <- "http://www.wall321.com/thumbnails/detail/20120304/colorful%20birds%20tropical%20head%203888x2558%20wallpaper_www.wall321.com_40.jpg"

## Download the file and save it as "Image.jpg" in the directory
#dFile <- download.file(url, "Image.jpg")
#img <- readJPEG("Image.jpg") # Read the image
img <- readJPEG("/Users/jim_byers/Documents/R examples/Clustering/Newport_seafood/Newport_seafood.jpg") # Read the image


##Cleaning the Data
# Extract the necessary information from the image and organize this for our computation:
# Obtain the dimension
imgDm <- dim(img)

# Assign RGB channels to data frame
imgRGB <- data.frame(
  x = rep(1:imgDm[2], each = imgDm[1]),
  y = rep(imgDm[1]:1, imgDm[2]),
  R = as.vector(img[,,1]),
  G = as.vector(img[,,2]),
  B = as.vector(img[,,3])
)

# The image is represented by large array of pixels with dimension rows by columns by channels -- red, green, and blue or RGB. 

##Plotting
## Plot the original image using the following codes:
library(ggplot2)
# ggplot theme twith boarders is needed
plotTheme2 <- function() {
  theme(
    panel.background = element_rect(
      size = 3,
      colour = "black",
      fill = "white"),
    axis.ticks = element_line(
      size = 2),
    panel.grid.major = element_line(
      colour = "gray80",
      linetype = "dotted"),
    panel.grid.minor = element_line(
      colour = "gray90",
      linetype = "dashed"),
    axis.title.x = element_text(
      size = rel(1.2),
      face = "bold"),
    axis.title.y = element_text(
      size = rel(1.2),
      face = "bold"),
    plot.title = element_text(
      size = 20,
      face = "bold",
      vjust = 1.5)
  )
}

# ggplot theme to be used

plotTheme <- function() {
  theme(axis.line=element_blank(),
        axis.text.x=element_blank(),
        axis.text.y=element_blank(),
        axis.ticks=element_blank(),
        axis.title.x=element_blank(),
        axis.title.y=element_blank(),
        legend.position="none",
        panel.background=element_blank(),
        panel.border=element_blank(),
        panel.grid.major=element_blank(),
        panel.grid.minor=element_blank(),
        plot.background=element_blank(),
        line = element_blank(),
        text = element_blank(),
        line = element_blank(),
        title = element_blank())
}


library(scatterplot3d)

cubedraw <- function(res3d, min = 0, max = 300, cex = 2) 
{
  cube01 <- rbind(0,c(1,0,0),c(1,1,0),1,c(0,1,1),c(0,0,1),c(1,0,1),
                  c(1,0,0),c(1,0,1),1,c(1,1,0),
                  c(0,1,0),c(0,1,1), c(0,1,0),0)
  corners <- 300*rbind(c(0,0,0),c(0,0,1),c(0,1,0), c(0,1,1), c(1,0,0), c(1,0,1),c(1,1,0),c(1,1,1))
  corners_colors <- rgb(corners/300)
  cub <- min + (max-min)* cube01 
  res3d$points3d(cub[ 1:11,], cex = NULL, type = 'b', lty = 3)
  res3d$points3d(cub[11:15,], cex = NULL, type = 'b', lty = 3)
  res3d$points3d(corners, col = corners_colors, pch=17, cex=.75)
}   
# Clustering Apply k-Means clustering on the image:
#kClusters <- 1
library(LICORS)
library(grid)
library(gridExtra)
for (i in 5:16)
{
  kClusters <- i^2
  #kMeans <- kmeans(imgRGB[, c("R", "G", "B")], centers = kClusters)
  #kMeans <- kmeans(imgRGB[, c("R", "G", "B")], centers = kClusters, algorithm = "Forgy")
  kMeans <- kmeanspp(imgRGB[, c("R", "G", "B")], k = kClusters, algorithm = "Lloyd",start = "random", iter.max = 10, nstart = 10)
  kColours <- rgb(kMeans$centers[kMeans$cluster,])

#  p <- ggplot(data = imgRGB, aes(x = x, y = y), width = 350, height = 233, units = "px") +
  p <- ggplot(data = imgRGB, aes(x = x, y = y), width = 1024, height = 768, units = "px") + 
  geom_point(colour = kColours) + plotTheme() + scale_x_continuous(expand = c(0,0)) + scale_y_continuous(expand = c(0,0))
  q <- p + annotate("text", x = 975, y = 750, label = kClusters, colour = "orange", size = 9)
  gt <- ggplot_gtable(ggplot_build(q))
  ge <- subset(gt$layout, name == "panel")
#  vp <- viewport(.25,.25,1,1)
#  grid.draw(gt[ge$t:ge$b, ge$l:ge$r])
  
ggsave <- ggplot2::ggsave; body(ggsave) <- body(ggplot2::ggsave)[-2]
##  print(arrangeGrob(gt[ge$t:ge$b, ge$l:ge$r]))
  ggsave(paste("/Users/jim_byers/Downloads/cluster_out_",kClusters,".png", sep=""), 
         arrangeGrob(gt[ge$t:ge$b, ge$l:ge$r]),
         width = 10.24, height = 7.68, dpi = 100)


# Assign RGB channels to data frame
uniqkColoursHEX <- unique(kColours)
uniqkColoursRGB <- col2rgb(unique(kColours))
red <- uniqkColoursRGB["red",]
green <- uniqkColoursRGB["green",]
blue <- uniqkColoursRGB["blue",]
title_text <- paste("The cluster centers of the ",kClusters,".png", sep="")

                  
par(bg="darkblue", col.lab= "grey")
rr <- scatterplot3d(red, green, blue, angle = 45, highlight.3d=FALSE, xlim = c(0,255),ylim = c(0,255), zlim = c(0,255), bg = "black", col.axis="grey", col.grid="darkgrey", main= paste("The ",kClusters," cluster centers in RGB space", sep=""), col.main= "white", pch=20, cex.symbols= 2, color = uniqkColoursHEX)
cubedraw(rr)

}

# Reference: http://www.r-bloggers.com/r-k-means-clustering-on-an-image/
