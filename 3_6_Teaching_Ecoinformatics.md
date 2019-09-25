---
title: "Ecology Lab: SDM using Maxent"
author: "Drew Kerkhoff"
---
 


<div>
<object data="3_6_assets/BIENWorkshopEducation.pdf" type="application/pdf" width="100%" height="670px"> 
  <p>It appears you don't have a PDF plugin for this browser.
   No biggie... you can <a href="3_6_assets/BIENWorkshopEducation.pdf">click here to
  download the PDF file.</a></p>  
 </object>
 </div>
 
 <p><a href="3_6_assets/BIENWorkshopEducation.pdf">Download the PDF of the presentation</a></p>  

<!-- [<i class="fa fa-file-code-o fa-3x" aria-hidden="true"></i> The R Script associated with this page is available here](3_6_Teaching_Ecoinformatics.R).  Download this file and open it (or copy-paste into a new script) with RStudio so you can follow along. -->

Note that Drew's course website, with R output is available [here](http://www.rpubs.com/kerkhoffa/SDMMaxent)

# Setup

```r
library(raster)
library(rgdal)
library(maps)
library(mapdata)
library(dismo)  
#library(rJava)  
library(maptools)
library(jsonlite)
```
## Data Access
Current environment from worldclim

```r
currentEnv=getData("worldclim", var="bio", res=2.5)
```
Future environment based on the 8.5 concentration scenario for 2070 from HADGEM2-ES model


```r
futureEnv=getData('CMIP5', var='bio', res=2.5, rcp=85, model='HE', year=70)
names(futureEnv)=names(currentEnv)
```

Species locations from gbif - for example, the timber rattlesnake

```r
rattler=gbif('crotalus','horridus')
```
## Data Processing

```r
# limit number of predictors just a bit
currentEnv=dropLayer(currentEnv, c("bio2", "bio3", "bio4", "bio10", "bio11", "bio13", "bio14", "bio15"))
futureEnv=dropLayer(futureEnv, c("bio2", "bio3", "bio4", "bio10", "bio11", "bio13", "bio14", "bio15"))

# get rid of occurences without location information
rattler=subset(rattler, !is.na(lon) & !is.na(lat))

# find and eliminate duplicate locations
rattlerdups=duplicated(rattler[, c("lon", "lat")])
rattler <-rattler[!rattlerdups, ]

# make initial plot for diagnostic purposes
plot(wrld_simpl, xlim=c(min(rattler$lon)-1,max(rattler$lon)+1), ylim=c(min(rattler$lat)-1,max(rattler$lat)+1), axes=TRUE, col="light yellow")
points(rattler$lon, rattler$lat, col="orange", pch=20, cex=0.75)

# eliminate questionable points likely outside the native range
rattler <- rattler[rattler$lon < -40 & rattler$lat > 25 , ]

# make another plot, with higher resolution background
map('worldHires', xlim=c(min(rattler$lon)-1,max(rattler$lon)+1), ylim=c(min(rattler$lat)-1,max(rattler$lat)+1), fill=TRUE, col="light yellow")
points(rattler$lon, rattler$lat, col="orange", pch=20, cex=0.75)

# map mean annual temperature
plot(modelEnv[["bio1"]]/10, main="Annual Mean Temperature", col=brewer.pal(50,"RdYlBu"))
map('worldHires',xlim=c(min(rattler$lon)-10,max(rattler$lon)+10), ylim=c(min(rattler$lat)-10,max(rattler$lat)+10), fill=FALSE, add=TRUE)
points(rattler$lon, rattler$lat, pch="+", cex=0.2)

# map future mean annual temperature
plot(modelFutureEnv[["bio1"]]/10, main="Future Annual Mean Temperature")
map('worldHires',xlim=c(min(rattler$lon)-10,max(rattler$lon)+10), ylim=c(min(rattler$lat)-10,max(rattler$lat)+10), fill=FALSE, add=TRUE)
points(rattler$lon, rattler$lat, pch="+", cex=0.2)
```
 
## Species Distribution Modeling


```r
# first crop environment to the local species range +/- 10 degrees
model.extent<-extent(min(rattler$lon)-10,max(rattler$lon)+10,min(rattler$lat)-10,max(rattler$lat)+10)
modelEnv=crop(currentEnv,model.extent)
modelFutureEnv=crop(futureEnv, model.extent)
modelMitigatedEnv=crop(mitigatedEnv, model.extent)

# withold 20% of the data for testing the model
rattlerocc=cbind.data.frame(rattler$lon,rattler$lat)
fold <- kfold(rattlerocc, k=5)
rattlertest <- rattlerocc[fold == 1, ]
rattlertrain <- rattlerocc[fold != 1, ]

#fit the maxent model
rattler.me <- maxent(modelEnv, rattlertrain)

# plot showing importance of each variable
plot(rattler.me)

# response curves
response(rattler.me)
# predict to entire dataset
rattler.pred <- predict(rattler.me, modelEnv)

#plot predictions
plot(rattler.pred, main="Predicted Suitability")
map('worldHires', fill=FALSE, add=TRUE)
points(rattler$lon, rattler$lat, pch="+", cex=0.2)
```


```r
# make predictions with the future environment data
rattler.2070 = predict(rattler.me, modelFutureEnv)
rattler.mitigated = predict(rattler.me, modelMitigatedEnv)

#plot predictions
plot(rattler.2070, main="Predicted Future Suitability")
map('worldHires', fill=FALSE, add=TRUE)
points(rattler$lon, rattler$lat, pch="+", cex=0.2)

rattler.change=rattler.2070-rattler.pred
rattler.mit.change=rattler.mitigated-rattler.pred
plot(rattler.change, main="Predicted Change in Suitability")
map('worldHires', fill=FALSE, add=TRUE)
points(rattler$lon, rattler$lat, pch="+", cex=0.2)
```


```r
#testing the model
# background data
bg <- randomPoints(modelEnv, 1000) #background "pseudoabsences"

#simplest way to use 'evaluate'
e1 <- evaluate(rattler.me, p=occtest, a=bg, x=modelEnv)

plot(e1, 'ROC')
rattlerChangePoints = extract(rattler.change, rattlerocc)
hist(rattlerChangePoints, main="", xlab="Change in habitat suitability")
abline(v=0, col="red")

rattlerMitChangePoints = extract(rattler.mit.change, rattlerocc)
hist(rattlerChangePoints, main="", x)
abline(v=0, col="red")
```
Note: Code largely adapted from:
http://spatialecology.weebly.com/r-code--data/category/sdm-maxent
and Fiona Spooner's series of RPubs, which were adapted
from examples in Hijmans and Elith 2011
