library(foreign)
library(sp)
library(biomod2)
library(randomForest)
library(gbm)
library(mda)
library(mgcv)
library(rpart)
#=====================================================================
#====== Ideas
#===================================================================== 
# Just step through each method and aim to implement an off the shelf
# fit to only one environmental variable
setwd('/Users/ctg/Dropbox/Projects/Workshops/RDataScience/4_1_assets/')
data<-read.csv("punc10train.csv")
evaldata<-read.csv("punc10eval.csv")
max01=raster('max01.asc')
source('SetOptions.r')

v1='MAX01'
v2='RAIN_CONCE'


#== plot denisites
pres=subset(data,species==1)
bg=subset(data,species==0)

pres.d=density(pres[,v1],from=19,to=34,n=512)
bg.d=density(bg[,v1],from=19,to=34,n=512)

pdf('max01.pdf',h=4,w=6)
  plot(max01)
dev.off()
system('open max01.pdf')

pdf('bg_only.pdf',h=4,w=6)
  plot(bg.d,bty='n',las=1,main='',xlab='Max. Jan. Temp.',col='grey50',lwd=5,xlim=c(18,35))
  legend('topleft',legend=c('background'),col=c('grey50'),lwd=c(5),bty='n',cex=.7)
dev.off()
system('open bg_only.pdf')

pdf('bg_pres_only.pdf',h=4,w=6)
  plot(bg.d,bty='n',las=1,main='',xlab='Max. Jan. Temp.',col='grey50',lwd=5,xlim=c(18,35))
  lines(pres.d,bty='n',las=1,main='',xlab='Max. Jan. Temp.',col='red3',lwd=5)
  legend('topleft',legend=c('background','presences'),col=c('grey50','red3'),lwd=c(5,5,2),bty='n',cex=.7)
dev.off()
system('open bg_pres_only.pdf')

pdf('bg_pres_ratio.pdf',h=4,w=6)
  plot(bg.d,bty='n',las=1,main='',xlab='Max. Jan. Temp.',col='grey50',lwd=5,xlim=c(18,35))
  lines(pres.d,bty='n',las=1,main='',xlab='Max. Jan. Temp.',col='red3',lwd=5)
  lines(pres.d$x,pres.d$y/bg.d$y/25,col='black',lwd=2)
  legend('topleft',legend=c('background','presences','ratio: pres/back'),col=c('grey50','red3','black'),lwd=c(5,5,2),bty='n',cex=.7)
dev.off()
system('open bg_pres_ratio.pdf')
  






# == from Merow et al 2014 Ecography
data.best6 <- BIOMOD_FormatingData(
  resp.var = as.numeric(data[,'species']),
  #expl.var = data[,c('PH1','MIN07','MEAN_AN_PR','RAIN_CONCE')],
  expl.var = data[,c(v1,v2)],
  resp.xy = data[,c('lon','lat')],
  resp.name = 'PPunc',
  eval.resp.var = as.numeric(evaldata[,'species']),
  # eval.expl.var = evaldata[,c('PH1','MIN07','MEAN_AN_PR','RAIN_CONCE')],
  eval.expl.var = evaldata[,c(v1,v2)],
  eval.resp.xy = evaldata[,c('lon','lat')])


models.to.run=c('GLM','GAM','MARS','ANN','RF','GBM','CTA', 'MAXENT','SRE')

#models.to.run=c('GAM')
myBiomodOption.1=BIOMOD_ModelingOptions(
						CTA = list( method = 'class',
								parms = 'default',
								#cost = NULL,
								cost=c(.1,1),
								control = list(xval = 5, minbucket = 5, minsplit = 5, cp = 0.001, maxdepth = 25) ),
            ANN = list( NbCV = 5,
								#rang = 0.1,
								rang=.5,
								maxit = 100),
            GAM = list( myFormula = #formula("PPunc~s(MIN07,k=16,fx=TRUE)+s(PH1,k=5,fx=TRUE)+s(MEAN_AN_PR,k=5,fx=TRUE)+s(RAIN_CONCE,k=5,fx=TRUE)")
  					as.formula(paste0('PPunc~s(',v1,',k=11,fx=TRUE)+s(',v2,',k=6,fx=TRUE)')), family = 'binomial'),
						GBM = list( distribution = 'bernoulli',
								n.trees = 2500,
								interaction.depth = 7,
								n.minobsinnode = 5,
								shrinkage = 0.005,
								bag.fraction = 0.5,
								train.fraction = 1,
								cv.folds = 3,
								keep.data = FALSE,
								verbose = FALSE,
								perf.method = 'cv')
            )
            #SetGBMOptions(1000,49,0.01)#NTREES, INTERACTIONDEPTH, SHRINKAGE)
m1 <-SetBIOMOD2Options(data.best6,models.to.run,myBiomodOption.1,0) 
m2<-BIOMOD_LoadModels(m1, models=models.to.run)

resp.plot.1 <- response.plot2(models = m2, Data = getModelsInputData(m1,'expl.var'), show.variables= getModelsInputData(m1,'expl.var.names'))

#to plot just one curve
response.plot2(models = BIOMOD_LoadModels(m1, models='CTA'), Data = getModelsInputData(m1,'expl.var'), show.variables= getModelsInputData(m1,'expl.var.names'))
#dev.off()


#source('PlotFig.r')
#PlotFig(1)
#PlotFig(2)
#PlotFig(3)
#PlotFig(4)
#PlotFig(5)
#PlotFig(6)
#PlotFig(7)
#PlotFig(8)
#PlotFig(9)

#dev.off()

source('SetOptions.r')
source('PlotFig3.r')
# Do a GLM analysis
##USE CORE GLM LIBRARY
myRespPlotData<-array(data = NA, dim = c(3,100,6), dimnames = NULL)
myBiomodOption.GLM<-SetGLMOptions('simple',0,'AIC',NULL)
m1.GLM <-SetBIOMOD2Options(data.best6,'GLM',myBiomodOption.GLM,0) 
m2.GLM<-BIOMOD_LoadModels(m1.GLM, models='GLM')
resp.plot.GLM <- response.plot2(models = m2.GLM, Data = getModelsInputData(m1.GLM,'expl.var'), show.variables= getModelsInputData(m1.GLM,'expl.var.names'))
myBiomodOption.GLM<-BIOMOD_ModelingOptions(GLM = list(
  myFormula = #formula("PPunc~ns(MIN07,13)+ns(PH1,3)+MEAN_AN_PR+RAIN_CONCE"),
  as.formula(paste0('PPunc~ns(',v1,',13)+ns(',v2,',13)')),
  test='none',
  family = 'binomial',
  control = glm.control(epsilon = 1e-08, maxit = 1000, trace = FALSE)))
m3.GLM <-SetBIOMOD2Options(data.best6,'GLM',myBiomodOption.GLM,0) 
m4.GLM<-BIOMOD_LoadModels(m3.GLM, models='GLM')
resp.plot.GLM2 <- response.plot2(models = m4.GLM, Data = getModelsInputData(m3.GLM,'expl.var'), show.variables= getModelsInputData(m3.GLM,'expl.var.names'))
#dev.off()
pdf('Output/GLMcm.pdf',h=3,w=3)
PlotFig3(1,resp.plot.GLM,resp.plot.GLM2,1,2)
dev.off()
system('open Output/GLMcm.pdf')

# Do a GAM analysis
myRespPlotData<-array(data = NA, dim = c(3,100,6), dimnames = NULL)
myBiomodOption.GAM<-SetGAMOptions(0,5)
m1.GAM <-SetBIOMOD2Options(data.best6,'GAM',myBiomodOption.GAM,0) 
m2.GAM<-BIOMOD_LoadModels(m1.GAM, models='GAM')
resp.plot.GAM <- response.plot2(models = m2.GAM, Data = getModelsInputData(m1.GAM,'expl.var'), show.variables= getModelsInputData(m1.GAM,'expl.var.names'))
#myBiomodOption.GAM<-SetGAMOptions('polynomial',1,5)
myBiomodOption.GAM<-BIOMOD_ModelingOptions(GAM = list(
  myFormula = #formula("PPunc~s(MIN07,k=16,fx=TRUE)+s(PH1,k=5,fx=TRUE)+s(MEAN_AN_PR,k=5,fx=TRUE)+s(RAIN_CONCE,k=5,fx=TRUE)")
  as.formula(paste0('PPunc~s(',v1,',k=15,fx=TRUE)+s(',v2,',k=11,fx=TRUE)')), family = 'binomial'))
m3.GAM <-SetBIOMOD2Options(data.best6,'GAM',myBiomodOption.GAM,0) 
m4.GAM<-BIOMOD_LoadModels(m3.GAM, models='GAM')
resp.plot.GAM2 <- response.plot2(models = m4.GAM, Data = getModelsInputData(m3.GAM,'expl.var'), show.variables= getModelsInputData(m3.GAM,'expl.var.names'))
#dev.off()
pdf('Output/GAMcm.pdf',h=3,w=3)
PlotFig3(1,resp.plot.GAM,resp.plot.GAM2,1,2)
dev.off()
system('open Output/GAMcm.pdf')

## Now do MARS
#(DEGREE, PENALTY, THRESH, NK, PRUNEBOOL)
myRespPlotData<-array(data = NA, dim = c(3,100,6), dimnames = NULL)
cont<-rpart.control(cp = 0.01)
#myBiomodOption.MARS<-SetMARSOptions(1,3, 0.1, 3, TRUE)
# MARS = list( degree = 2,
#              penalty = 2,
#              thresh = 0.001,
#              prune = TRUE),
#myBiomodOption.MARS<-SetMARSOptions(1, 10,0.01, 10, TRUE)
myBiomodOption.MARS<-SetMARSOptions(1, 10,0.01, 10, TRUE)
m1.MARS <-SetBIOMOD2Options(data.best6,'MARS',myBiomodOption.MARS,0) 
m2.MARS<-BIOMOD_LoadModels(m1.MARS, models='MARS')
resp.plot.MARS <- response.plot2(models = m2.MARS, Data = getModelsInputData(m1.MARS,'expl.var'), show.variables= getModelsInputData(m1.MARS,'expl.var.names'))
#cont2<-rpart.control(cp = 0,minsplit=2,penalty=0.00001)
cont2<-rpart.control(cp = 0,minsplit=2,penalty=0.00001,xval=2)

myBiomodOption.MARS<-SetMARSOptions(4, 0,0.0000000000001, 100, FALSE)
m3.MARS <-SetBIOMOD2Options(data.best6,'MARS',myBiomodOption.MARS,0) 
m4.MARS<-BIOMOD_LoadModels(m3.MARS, models='MARS')
resp.plot.MARS2 <- response.plot2(models = m4.MARS, Data = getModelsInputData(m3.MARS,'expl.var'), show.variables= getModelsInputData(m3.MARS,'expl.var.names'))
#dev.off()
pdf('Output/MARScm.pdf',h=3,w=3)
PlotFig3(3,resp.plot.MARS,resp.plot.MARS2,1,2)
dev.off()
system('open Output/MARScm.pdf')


#spp<-data[,1]
#vars<-data[,c(10,11,12,14)]
#aa<-mars(vars,spp,degree=2,penalty=0,trace.mars=TRUE,nk=80,prune=FALSE)
#aa<-earth(vars,spp,degree=2,penalty=0,nk=20,glm=list(family=binomial))
#bb<-vars
#gg<-colMeans(bb[,1:4])
#bb[,1]=gg[1]
#bb[,3]=gg[3]
#bb[,4]=gg[4]
#kk<-predict(aa,bb)
#mx<-max(kk)
#mn<-min(kk)
#r=(mx-mn)
#kk2<-((kk-mn)/r)
#plot(vars[,2],exp(kk2))



## now do ANN
#(NITER, NBCV, SIZE, DECAY)
myRespPlotData<-array(data = NA, dim = c(3,100,6), dimnames = NULL)
#complex (REVERSED ORDER)
#myBiomodOption.ANN<-SetANNOptions(10000,0,10,1)
#myBiomodOption.ANN<-SetANNOptions(70,0,1,1)
myBiomodOption.ANN <- BIOMOD_ModelingOptions(ANN = list(maxit=200, NbCV=5,rang=.5))
m1.ANN <-SetBIOMOD2Options(data.best6,'ANN',myBiomodOption.ANN,0) 
m2.ANN<-BIOMOD_LoadModels(m1.ANN, models='ANN')
resp.plot.ANN <- response.plot2(models = m2.ANN, Data = getModelsInputData(m1.ANN,'expl.var'), show.variables= getModelsInputData(m1.ANN,'expl.var.names'))
#simple
#myBiomodOption.ANN<-SetANNOptions(50,0,1,1)
myBiomodOption.ANN <- BIOMOD_ModelingOptions(ANN = list(maxit=200, NbCV=5,rang=.7)) #.7 for default
#myBiomodOption.ANN<-SetANNOptions(10000,0,18,0.001) 
#myBiomodOption.ANN<-SetANNOptions(10000,0,10,NULL) # nice bump
#myBiomodOption.ANN<-SetANNOptions(10000,0,8,NULL) # little bump
#myBiomodOption.ANN<-SetANNOptions(10000,0,20,NULL) #wierd shoulder
m3.ANN <-SetBIOMOD2Options(data.best6,'ANN',myBiomodOption.ANN,0) 
m4.ANN<-BIOMOD_LoadModels(m3.ANN, models='ANN')
resp.plot.ANN2 <- response.plot2(models = m4.ANN, Data = getModelsInputData(m3.ANN,'expl.var'), show.variables= getModelsInputData(m3.ANN,'expl.var.names'))
pdf('Output/ANNcm.pdf',h=3,w=3)
PlotFig3(4,resp.plot.ANN2,resp.plot.ANN,1,2) 
dev.off()
system('open Output/ANNcm.pdf')

## Now do RF
myRespPlotData<-array(data = NA, dim = c(3,100,6), dimnames = NULL)
#myBiomodOption.RF<-SetRFOptions(1,100000)
myBiomodOption.RF <- BIOMOD_ModelingOptions(RF = list(mtry=2,ntree=5000,nodesize=30))
m1.RF <-SetBIOMOD2Options(data.best6,'RF',myBiomodOption.RF,0) 
m2.RF<-BIOMOD_LoadModels(m1.RF, models='RF')
resp.plot.RF <- response.plot2(models = m2.RF, Data = getModelsInputData(m1.RF,'expl.var'), show.variables= getModelsInputData(m1.RF,'expl.var.names'))
#myBiomodOption.RF<-SetRFOptions(1,10000)
myBiomodOption.RF <- BIOMOD_ModelingOptions(RF = list(mtry=2,ntree=1000,nodesize=2))
m3.RF <-SetBIOMOD2Options(data.best6,'RF',myBiomodOption.RF,0) 
m4.RF<-BIOMOD_LoadModels(m3.RF, models='RF')
resp.plot.RF2 <- response.plot2(models = m4.RF, Data = getModelsInputData(m3.RF,'expl.var'), show.variables= getModelsInputData(m3.RF,'expl.var.names'))
pdf('Output/RFcm.pdf',h=3,w=3)
PlotFig3(5,resp.plot.RF,resp.plot.RF2,1,2)
dev.off()
system('open Output/RFcm.pdf')

#Now do GBM
myRespPlotData<-array(data = NA, dim = c(3,100,6), dimnames = NULL)
myBiomodOption.GBM<-SetGBMOptions(50,1,1)#NTREES, INTERACTIONDEPTH, SHRINKAGE)
m1.GBM <-SetBIOMOD2Options(data.best6,'GBM',myBiomodOption.GBM,0) 
m2.GBM<-BIOMOD_LoadModels(m1.GBM, models='GBM')
resp.plot.GBM <- response.plot2(models = m2.GBM, Data = getModelsInputData(m1.GBM,'expl.var'), show.variables= getModelsInputData(m1.GBM,'expl.var.names'))
myBiomodOption.GBM<-SetGBMOptions(1000,49,0.01)#NTREES, INTERACTIONDEPTH, SHRINKAGE)
m3.GBM <-SetBIOMOD2Options(data.best6,'GBM',myBiomodOption.GBM,0) 
m4.GBM<-BIOMOD_LoadModels(m3.GBM, models='GBM')
resp.plot.GBM2 <- response.plot2(models = m4.GBM, Data = getModelsInputData(m3.GBM,'expl.var'), show.variables= getModelsInputData(m3.GBM,'expl.var.names'))
pdf('Output/GBMcm.pdf',h=3,w=3)
PlotFig3(6,resp.plot.GBM,resp.plot.GBM2,1,2)
dev.off()
system('open Output/GBMcm.pdf')

#Now do CTA
myRespPlotData<-array(data = NA, dim = c(3,100,6), dimnames = NULL)
#simple
#myBiomodOption.CTA<-SetCTAOptions(rpart.control(minsplit=10,cp=0.05,xval=10))
#myBiomodOption.CTA<-SetCTAOptions(rpart.control(minsplit=20,cp=0.01,xval=5))
myBiomodOption.CTA=BIOMOD_ModelingOptions(CTA = list( method = 'class',parms = 'default',cost = c(3,1),control = list(xval = 5, minbucket = 2, minsplit = 10, cp = 0.01, maxdepth = 3) ))

m1.CTA <-SetBIOMOD2Options(data.best6,'CTA',myBiomodOption.CTA) 
m2.CTA<-BIOMOD_LoadModels(m1.CTA, models='CTA')
resp.plot.CTA <- response.plot2(models = m2.CTA, Data = getModelsInputData(m1.CTA,'expl.var'), show.variables= getModelsInputData(m1.CTA,'expl.var.names'))
#complex
#myBiomodOption.CTA<-SetCTAOptions(rpart.control(minsplit=2,cp=0,xval=2))
myBiomodOption.CTA=BIOMOD_ModelingOptions(CTA = list( method = 'class',parms = 'default',cost = c(.01,1),control = list(xval = 3, minbucket = 2, minsplit = 3, cp = 0, maxdepth = 25) ))
m3.CTA <-SetBIOMOD2Options(data.best6,'CTA',myBiomodOption.CTA) 
m4.CTA<-BIOMOD_LoadModels(m3.CTA, models='CTA')
resp.plot.CTA2 <- response.plot2(models = m4.CTA, Data = getModelsInputData(m3.CTA,'expl.var'), show.variables= getModelsInputData(m3.CTA,'expl.var.names'))
pdf('Output/CTAcm.pdf',h=3,w=3)
PlotFig3(7,resp.plot.CTA,resp.plot.CTA2,1,2)
dev.off()
system('open Output/CTAcm.pdf')

#Now do MAXENT
myRespPlotData<-array(data = NA, dim = c(3,100,6), dimnames = NULL)
myBiomodOption.MAXENT<-SetMAXENTOptions(TRUE,TRUE,TRUE,FALSE,FALSE,1)
m1.MAXENT <-SetBIOMOD2Options(data.best6,'MAXENT',myBiomodOption.MAXENT,0) 
m2.MAXENT<-BIOMOD_LoadModels(m1.MAXENT, models='MAXENT')
resp.plot.MAXENT <- response.plot2(models = m2.MAXENT, Data = getModelsInputData(m1.MAXENT,'expl.var'), show.variables= getModelsInputData(m1.MAXENT,'expl.var.names'))
myBiomodOption.MAXENT<-SetMAXENTOptions(TRUE,TRUE,TRUE,TRUE,TRUE,1)
m3.MAXENT <-SetBIOMOD2Options(data.best6,'MAXENT',myBiomodOption.MAXENT,0) 
m4.MAXENT<-BIOMOD_LoadModels(m3.MAXENT, models='MAXENT')
resp.plot.MAXENT2 <- response.plot2(models = m4.MAXENT, Data = getModelsInputData(m3.MAXENT,'expl.var'), show.variables= getModelsInputData(m3.MAXENT,'expl.var.names'))
pdf('Output/MAXENTcm.pdf',h=3,w=3)
PlotFig3(8,resp.plot.MAXENT,resp.plot.MAXENT2,1,2)
dev.off()
system('open Output/MAXENTcm.pdf')

## Now do SRE
myRespPlotData<-array(data = NA, dim = c(3,100,6), dimnames = NULL)
myBiomodOption.SRE<-SetSREOptions(0)
m1.SRE <-SetBIOMOD2Options(data.best6,'SRE',myBiomodOption.SRE,0) 
m2.SRE<-BIOMOD_LoadModels(m1.SRE, models='SRE')
resp.plot.SRE <- response.plot2(models = m2.SRE, Data = getModelsInputData(m1.SRE,'expl.var'), show.variables= getModelsInputData(m1.SRE,'expl.var.names'))
myBiomodOption.SRE<-SetSREOptions(0.2)
m3.SRE <-SetBIOMOD2Options(data.best6,'SRE',myBiomodOption.SRE,0) 
m4.SRE<-BIOMOD_LoadModels(m3.SRE, models='SRE')
resp.plot.SRE2 <- response.plot2(models = m4.SRE, Data = getModelsInputData(m3.SRE,'expl.var'), show.variables= getModelsInputData(m3.SRE,'expl.var.names'))
pdf('Output/SREcm.pdf',h=3,w=3)
PlotFig3(9,resp.plot.SRE,resp.plot.SRE2,1,2)
dev.off()
system('open Output/SREcm.pdf')

