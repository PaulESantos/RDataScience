---
title: "Wallace"
author: Jamie Kass, Matt Aiello-Lammens
output: html_document
---

<!-- Scroll down to the section beginning # *Wallace* below - this top stuff is just for the website  -->



<div>
<object data="3_4_assets/Wallace_Intro.pdf" type="application/pdf" width="100%" height="650px"> 
  <p>It appears you don't have a PDF plugin for this browser.
   No biggie... you can <a href="3_4_assets/Wallace_Intro.pdf">click here to
  download the PDF file.</a></p>  
 </object>
 </div>
 
 <p><a href="3_4_assets/Wallace_Intro.pdf">Download the PDF of the presentation</a></p>  

<!-- [<i class="fa fa-file-code-o fa-3x" aria-hidden="true"></i> The R Script associated with this page is available here](3_4_wallace.R).  Download this file and open it (or copy-paste into a new script) with RStudio so you can follow along.   -->

 <p><a href="3_4_wallace_Rmd">Download the Rmd of the code</a></p>  


# *Wallace*

*Wallace* is a modular platform for reproducible modeling of species niches and distributions, written in R with the web app development package `shiny`. The application guides users through a complete analysis, from the acquisition of data to visualizing model predictions on an interactive map, thus bundling complex workflows into a single, streamlined interface. Please find the *Wallace* homepage below. It has links to the development page (Github repository), the official *Wallace* email, and the *Wallace* Google Group for discussion and support for the software.

https://wallaceecomod.github.io/

*Wallace* is currently available for installation via the Github development page. You can get *Wallace* up and running with a few lines of code.


```r
# if you do not have devtools installed, install it first
install.packages("devtools", repos = "http://cran.us.r-project.org")
# install wallace from github
devtools::install_github("wallaceEcoMod/wallace")
# load wallace
library(wallace)
# run the user interface
wallace()
```

While the above will get you going, if you want to use the ***Maxent*** module in Component **Model**, you'll have to follow a few more steps, which are listed in the documentation at the bottom (i.e., the `README.md` file) of [the Github repository page](https://github.com/wallaceEcoMod/wallace).

# *Wallace* is **Modular**

Developers can (and are encouraged to) contribute new methods to *Wallace* by submitting pull requests for new modules. This feature is key to the concept of *Wallace*, which was built for community expansion.

The way developers can do this may change in future versions, but we will provide a simple example of adding a module in the current framework.

# Architecture of *Wallace*

*Wallace* currently has eight "components" that represent key steps of a niche/distributional modeling analysis. Within each component, there are a number of "modules", which represent methodological options for that particular step. For example, the sixth component **Model** has modules ***BIOCLIM*** and ***Maxent***.

For all `shiny` apps, there are two main parts: "ui" and "server". The UI part generates all the controls and displays of the user interface, while the server part runs all the functions in the background.

Within the `inst/shiny` folder, *Wallace* has a script for each part: `server.R` and `ui.R`. In addition, there are scripts that contain the modules for each component in `/modules`. These are `source()`ed in `server.R`. Adding a new module involves making edits to each of these scripts, as you'll need to add not only the functionality, but the buttons, check boxes, maps, tables, etc. that the user interacts with and views.

# Example workflow

Before getting into how to expand *Wallace*, let's work our way through an example workflow. If you have successfully installed *Wallace* then please follow along, or feel free to ignore us and try things out yourself. If you haven't been able to get the install to work, then follow us as we go through it in front, and come talk with Jamie or Matt after the workshop. We'll try to help troubleshoot your installation problems.

# **WORKFLOW DEMO**

# Using the resulting `*.Rmd` file to reproduce and customize analyses

At any point during the *Wallace* workflow, users can download a document detailing the session analysis with text and R code. There are multiple formats available, but the [RMarkdown](http://rmarkdown.rstudio.com/) format (i.e., `*.Rmd`) can be run like a script to reproduce the analysis. Users can directly edit this file to customize parts of the analysis that are outside the scope of what *Wallace* can (currently) do. The other formats (.html, .pdf, .doc) are not executable, but can be shared with colleagues or used for supplemental information for publications, etc.

# **CUSTOMIZE *.RMD DEMO**

## Using GAMs for modeling

As an example of the utility of the `*.Rmd` format, let's imagine that you want to use a **generalized addative model** as an additional SDM approach. Looking through the `*.Rmd` file, we can find the **code chunk** (in the parlance of RMarkdown, a block of code embedded within the text) where we run our SDM, and add a new code chunk to run a GAM (and preferably, some text explaining what you're doing for reference).

# Let's add GAMs to *Wallace*

Say that for your particular research needs, you'd like to use GAMs in the *Wallace* GUI, and possibly compare the results with the other models you can build and evaluate with *Wallace*.

You'll be working in `mods_comp6.R`, `server.R`, and `ui.R`. Let's start with the functionality for the UI.

## UI development

To start, you'll need to imagine what the user will need to input to *Wallace* in order to have your module work. In the case of GAMs (the simplest case), perhaps you envision users entering the variables that go into the model and specifying a smoothing parameter to apply to all variables.

Open up `ui.R` and use the navigation tab in RStudio (lower left corner of script window) to find "tab 6", which is the UI functionality for Component **Model**. We'll need to edit some parts of this code to accomodate a new modeling method.

Each component is nested in a `conditonalPanel()` block, which activates only after a conditional statement is fulfilled. In this case, the condition is whether the component tab is selected or not.

**IMPORTANT** Make sure to add commas after all `shiny` functions within a `conditionalPanel()` block. Reference the code in `ui.R` for the appropriate syntax.


```r
# First, we add "GAM" to the choices for the radio buttons use to select the modeling method (around line 260)
radioButtons("enmSel", "Modules Available:", 
             choices = list("BIOCLIM", "Maxent", "GAM"))

# Next, we'll add functionality specific to GAMs: put a set of checkboxes to specify variables
# that go into the model ("gamVars"), and numeric input for the smoothing parameter ("gamDF").
# The function uiOutput() generates ui that is defined in server.R -- we'll see this next.
# (around line 295)
conditionalPanel("input.enmSel == 'GAM'",
                 uiOutput('gamVars'),
                 numericInput('gamDF', label = "Smoothing parameter", value = 4))

# Lastly, add GAMs to the conditional statement that generates the button that runs the models
# (around line 300)
conditionalPanel("input.enmSel == 'BIOCLIM' || input.enmSel == 'Maxent' || input.enmSel == 'GAM'",
                 strong("Build and evaluate models"), br(),
                 actionButton("goEval", "Run Models"), br(), br(),
                 downloadButton('downloadEvalcsv', "Download Results CSV"))
```

Now let's add the checkbox input ui and gam module function call to `server.R`. The checkbox input is specified here because it needs the names of the variables integrated into the the workflow in Component **Obtain Environmental Data**, and the information can only be passed on the server side.


```r
# Define the uiOutput (ui side) with a renderUI() function (server side). This is executed within an observe() because it's a reactive function (see shiny documentation for more details). (around line 452)
observe({
  output$gamVars <- renderUI({
    if (is.null(values$preds)) return()
    n <- names(values$preds)
    predNameList <- setNames(as.list(n), n)
    checkboxGroupInput("gamVars", label = "Select variables",
                       choices = predNameList)
  })
})

# Then we need to add the function that runs the GAMs. This goes at the end of the observeEvent() for the goEval button specified in ui.R. (around line 492)
observeEvent(input$goEval, {
  ...
  else if (input$enmSel == 'GAM') {
    comp6_gamMod(input$gamVars, input$gamDF)
  }
}
```

Finally, we will write the function to run the GAMs and plot a results table in the "Results" tab in `mods_comp6.R`.


```r
comp6_gamMod <- function(gamVars, gamDF) {

  # take the list of variables input and turn it into a formula with all variable names
  # wrapped in s() with degrees of freedom equal to gamDF
  dfs <- unlist(lapply(gamVars, FUN = function(x) paste0("s(", x, ", ", gamDF, ")")))
  f <- as.formula(paste("pa", paste(dfs, collapse = " + "), sep = " ~ "))

  # extract the predictor variables values at occurrence and background points
  occ.x <- raster::extract(values$preds[[gamVars]], values$modParams$occ.pts)
  bg.x <- raster::extract(values$preds[[gamVars]], values$modParams$bg.pts)
  # rbind them together and make new field for identifying occurrence from background
  x <- rbind(occ.x, bg.x)
  gamData <- data.frame(pa=c(rep(1, nrow(values$modParams$occ.pts)), rep(0, nrow(values$modParams$bg.pts))), x)

  # run the GAM
  res <- gam(f, family = "binomial", data = gamData)
  # put a copy of the output in the reactiveValues list to retrieve later
  values$gamOut <- res

  # print summary table to Results tab
  output$evalTbl <- DT::renderDataTable({DT::datatable(data.frame(variable=gamVars, coefficient=res$coefficients[-1], row.names=NULL))})

  # write log
  writeLog(paste("> GAM ran successfully."))
}
```

# Congratulations

You've added a module. The module building process will likely require testing and troubleshooting, but referencing other functional modules will give you tips on how to make everything work the way you want it to.

If you've built a functional model and you think it's neat, please submit a pull request so that the *Wallace* team can consider adding it to the official version. You can also make your own versions of *Wallace* as you see fit -- it's open and free (license GPL3). Hope you enjoyed this short tutorial.





