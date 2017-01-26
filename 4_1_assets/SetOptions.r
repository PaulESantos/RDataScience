#=====================================================================
#====== General BIOMOD Options
#=====================================================================
SetBIOMOD2Options<-function(DATA,METHOD, MODELOPTIONS,VARIMPORT=0)
{
	#Summary of BIOMOD2 options chosen
	#models.options = MODELOPTIONS,	# Method specific options
	#NbRunEval=1, 				# Only want one evaluation run
	#DataSplit=100, 			# Don't want to split the data
	#Yweights=NULL,				# Don't want weights
	#Prevalence=NULL,			# No accounting for prevalence
	#VarImport=0, 				# No investigation of variable importance
	#models.eval.meth = c('KAPPA','TSS','ROC'),  #Pick 3 basic evaluation methods
	#SaveObj = TRUE,				# Save the object
	#rescal.all.models = FALSE,		# Don't rescale the outputs - keep the raw probabilities
	#do.full.models = FALSE		# Don't evaluate with the full dataset		

	myBiomodModelOut1 <-BIOMOD_Modeling(DATA,models = c(METHOD),
		models.options = MODELOPTIONS,
		NbRunEval=1, 
		DataSplit=100, 
		Yweights=NULL,
		Prevalence=NULL,
		VarImport=VARIMPORT, 
		models.eval.meth = c('KAPPA','TSS','ROC'), 
		SaveObj = TRUE,
		rescal.all.models = FALSE,
		do.full.models = FALSE)
	return(myBiomodModelOut1)
}

#=====================================================================
#====== GLM
#=====================================================================
SetGLMOptions<-function(TYPE, INTERACTIONLEVEL, AICSET,FORMULA)
{
	#Summary of GLM options chosen
	#test = 'AIC', 	# Use the classic AIC test to choose model variables
	#family = 'binomial', #choose binomial family, so data are probabilities of 1 or 0
	#control = glm.control(epsilon = 1e-08, maxit = 1000, trace = FALSE)		#Choosing default settings


	myBiomodOption <- BIOMOD_ModelingOptions(GLM = list(
	 type = TYPE,
	 interaction.level = INTERACTIONLEVEL,
	 myFormula = FORMULA,
	 test = AICSET,
	 family = 'binomial',
	 control = glm.control(epsilon = 1e-08, maxit = 1000, trace = FALSE)))

 return(myBiomodOption)
}

#=====================================================================
#====== GAM
#=====================================================================
SetGAMOptions<-function(INTERACTIONLEVEL, KNOTS)
{
  #Summary of major GAM options considered
  #algo = 'GAM_mgcv', 	# This one was recommended but not sure
  #myFormula = NULL,	# Not using a formula
  #family = 'binomial',	# use binomial family
  #type=TYPE,		# Specify the type
  #interaction.level = INTERACTIONLEVEL, #Specify the interaction level
  #control = glm.control(epsilon = 1e-08, maxit = 1000, trace = FALSE)))	# Adopt the standard control
  
  #method #The smoothing parameter estimation method - don't specify. 
  #optimizer #An array specifying the numerical optimization method - dont specify
  #scale I #dont specify
  #select If this is TRUE then gam can add an extra penalty to each term so that it can be penalized to zero.  - dont specify
  
  #knots this is an optional list containing user specified knot values to be used for basis construction. For most bases the user simply supplies the knots to be used, which must match up with the k value supplied (note that the number of knots is not always just k). See tprs for what happens in the "tp"/"ts" case. Different terms can use different numbers of knots, unless they share a covariate. 
  
  #sp A vector of smoothing parameters can be provided here. - dont specify
  #min.sp Lower bounds can be supplied for the smoothing parameters. - dont specify
  #H  A user supplied fixed quadratic penalty on the parameters of the GAM can be supplied, with this as its coefficient matrix. - dont specify
  #gamma It is sometimes useful to inflate the model degrees of freedom in the GCV or UBRE/AIC score by a constant multiplier. - dont specify
  #paraPen optional list specifying any penalties to be applied to parametric model terms. gam.models explains more.- dont specify
  #G Usually NULL, but may contain the object returned by a previous call to gam with fit=FALSE, in which case all other arguments are ignored except for gamma, in.out, scale, control, method optimizer and fit.- dont specify
  # in.out optional list for initializing outer iteration. - dont specify
  
  myBiomodOption <- BIOMOD_ModelingOptions(GAM = list(
    algo = 'GAM_mgcv',
    myFormula = NULL,
    family = 'binomial',
    interaction.level = INTERACTIONLEVEL,
    knots = KNOTS,
    control = glm.control(epsilon = 1e-08, maxit = 1000, trace = FALSE)))

 return(myBiomodOption)
}

#=====================================================================
#====== MARS
#=====================================================================
SetMARSOptions<-function(DEGREE, PENALTY, THRESH, NK, PRUNEBOOL)
{
	# degree an optional integer specifying maximum interaction degree (default is 1).
	# nk an optional integer specifying the maximum number of model terms.
	# penalty an optional value specifying the cost per degree of freedom charge (default is 2).
	# thresh an optional value specifying forward stepwise stopping threshold (default is 0.001).
	#prune an optional logical value specifying whether the model should be pruned in a backward stepwise fashion (default is TRUE).

	myBiomodOption <- BIOMOD_ModelingOptions(
	MARS = list(degree=DEGREE,
	penalty=PENALTY,
	thresh=THRESH,
	nk=NK,
	prune=PRUNEBOOL))

	return(myBiomodOption)

}


#=====================================================================
#====== RF
#=====================================================================
SetRFOptions<-function(MTRY, NTREE)
{
	#do.classif #do default
	#ntree # Number of trees to grow. change this
	#mtry (?default) # Number of variables randomly sampled as candidates at each split. change this

	myBiomodOption <- BIOMOD_ModelingOptions(RF = list(mtry=MTRY,ntree=NTREE))

	return(myBiomodOption)
}

SetANNOptions<-function(NITER, NBCV, SIZE, DECAY)
{
  #do.classif #do default
  #ntree # Number of trees to grow. change this
  #mtry (?default) # Number of variables randomly sampled as candidates at each split. change this
  
  myBiomodOption <- BIOMOD_ModelingOptions(ANN = list(maxit=NITER, NbCV=NBCV,size=SIZE,decay=DECAY))
  
  return(myBiomodOption)
}
#myBiomodOption.ANN<-SetANNOptions(70,5,10)
#myBiomodOption.ANN<-SetANNOptions(1000,1,5)
#default settings: size=c(2,4,6, 8) et decay=c(0.001, 0.01, 0.05, 0.1)
#myBiomodOption <- BIOMOD_ModelingOptions(ANN = list(decay=NULL, size=NULL, NbCV=5))

#You can fix one variable and then the second will be optimized. 
#myBiomodOption <- BIOMOD_ModelingOptions(ANN = list(decay=NULL, size=5, NbCV=5))

#You can fix the two variables => no cross-validation. 
#myBiomodOption <- BIOMOD_ModelingOptions(ANN = list(decay=0.1, size=5, NbCV=0))
#You can also give the range of values you would like to make the optimisation: 
#  myBiomodOption <- BIOMOD_ModelingOptions(ANN = list(decay=0.1, size=c(2,5,10), NbCV=5))


SetCTAOptions<-function(CONTROL)
{
  #do.classif #do default
  #ntree # Number of trees to grow. change this
  #mtry (?default) # Number of variables randomly sampled as candidates at each split. change this
  
  myBiomodOption <- BIOMOD_ModelingOptions(CTA = list(control=CONTROL))

  return(myBiomodOption)
}

#=====================================================================
#====== BRT
#=====================================================================
SetGBMOptions<-function(NTREES, INTERACTIONDEPTH, SHRINKAGE)
{
	#Summary of major GBM options considered
	#n.trees = NTREES #the total number of trees to fit. This is equivalent to the number of iterations and the number of basis functions in the additive expansion. # vary this
	#cv.folds = 5 #The number of cross validation folds - keep constant
	#distribution = 'bernoulli'
	#interaction.depth = INTERACTIONDEPTH # very this
	#shrinkage=SHRINKAGE #a shrinkage parameter applied to each tree in the expansion. Also known as the learning rate or step-size reduction. # vary this
	#bag.fraction = the fraction of the training set observations randomly selected to propose the next tree in the expansion. This introduces randomnesses into the model fit.
	#train.fraction = The first train.fraction * nrows(data) observations are used to fit the gbm and the remainder are used for computing out-of-sample estimates of the loss function.
	myBiomodOption <- BIOMOD_ModelingOptions(
		GBM = list(distribution='bernoulli',
		n.trees=NTREES,
		cv.folds=5,
		shrinkage=SHRINKAGE,
		bag.fraction=1,
		train.fraction=1,
		interaction.depth=INTERACTIONDEPTH))
	
	return(myBiomodOption)
}

#=====================================================================
#====== MAXENT
#=====================================================================
SetMAXENTOptions<-function(L,Q,P,T,H,MasterBeta)
{
	# maximumiterations # adopt default
	# linear # play with this
	# quadratic # play with this
	# product # play with this
	# threshold # play with this
	# hinge # play with this
	# lq2lqptthreshold #default
	# l2lqthreshold #default
	# hingethreshold #default
	# beta_threshold : numeric (default -1.0) # play? - set as same beta for all features
	# beta_categorical : numeric (default -1.0) # play?
	# beta_lqp # play with?
	# beta_hinge # play with?
	# defaultprevalence : numeric (default 0.5), # default

	myBiomodOption <- BIOMOD_ModelingOptions(
		MAXENT = list( path_to_maxent.jar = getwd(),
		linear=L,
		quadratic=Q,
		product=P,
		threshold=T,
		hinge=H,
		lq2lqptthreshold=MasterBeta,
		l2lqthreshold=MasterBeta,
		hingethreshold=MasterBeta,
		beta_threshold=MasterBeta,
		beta_lqp=MasterBeta,
		beta_hinge=MasterBeta))

	return(myBiomodOption)

}

SetSREOptions<-function(QUANT)
{
  #do.classif #do default
  #ntree # Number of trees to grow. change this
  #mtry (?default) # Number of variables randomly sampled as candidates at each split. change this
  
  myBiomodOption <- BIOMOD_ModelingOptions(SRE = list(quant=QUANT))
  
  return(myBiomodOption)
}


#=====================================================================
#====== 
#=====================================================================

#=====================================================================
#====== 
#=====================================================================

