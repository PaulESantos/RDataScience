# Reproducible and Interactive Research
Cory Merow & Adam Wilson  
9/19/2017  

# Overview

- 3.1 Research Reports with R markdown
- 3.2 Version control with Github
- 3.3 Interactive presentations
- 3.4 Developing Web Applications with Shiny
- 3.5 Developing R websites (like this)

The same set of R Markdown tools is used for all these!

## Benefits are straightforward

- **Verification & Reliability**: Find and fix bugs. 
- **Transparency**: Increased citation count, broader impact, institutional memory
- **Efficiency**: Reduces duplication of effort, Colleagues like you and ask for advice
- **Flexibility**: When you don’t 'point-and-click' you gain many new analytic options.

## But limitations are substantial

- Classified/sensitive/big data
- Nondisclosure agreements & intellectual property 
- Competition
- Few expect reproducibility 
- No uniform standards
- Inertia & embarassment


## Our work exists on a spectrum of reproducibility
<img src="07_assets/peng-spectrum.jpg" alt="alt text" width="800">

<small>Peng 2011, Science 334(6060) pp. 1226-1227</small>

## Click trails are ephemeral & dangerous {.columns-2}

- Lots of human effort for tedious & time-wasting tasks
- Error-prone due to manual & ad hoc data handling
- Difficult to record -  hard to reconstruct a 'click history'
- Tiny changes in data or method require extensive reworking

<br><br><br><br>

<img src="07_assets/contrails.jpg" alt="alt text" width="400">


## Scripted analyses are superior  {.columns-2}

  <img src="07_assets/open-science.png" alt="alt text" width="250px">


  - Plain text files readable for a _long_ time
  - Improved transparency, automation, maintanability, accessibility, standardisation, modularity, portability, efficiency, communicability of process (what more could we want?)
  - Steeper learning curve  

## Literate programming: for and against   {.columns-2}

**For**

- Text & code in one place, in logical order
- Tables and figures automatically updated
- Automatic test when building document


**Against**

- Text and code in one place; can be hard to read
- Can slow down the processing of documents (use caching!)

# Reproducible Research in R

## Need a programming language  {.columns-2}

The machine-readable part: R

* R: Free, open source, cross-platform, highly interactive, huge user community in academica and private sector
* R packages an ideal 'Compendium'?
* Scriptability → R
* Literate programming → R Markdown
* Version control → Git / GitHub

<img src="07_assets/r-project.jpg" alt="alt text" width="100">


## Need a document formatting language  {.columns-2}

<img src="07_assets/markdown.png" alt="alt text" width="100">

Markdown: lightweight document formatting syntax. Easy to write, read and publish as-is.

The human-readable part

`rmarkdown`: 
- minor extensions to allow R code display and execution
- embed images in html files (convenient for sharing)
- equations

e.g.

 * `*` for bullet
 * `_` for underline

## Dynamic documents in R  {.columns-2}

`knitr` - descendant of Sweave  

Engine for dynamic report generation in R

<img src="07_assets/knitr.png" alt="alt text" width="200">

<br> 

- Narrative and code in the same file or explicitly linked
- When data or narrative are updated, the document is automatically updated
- Data treated as 'read only'
- Output treated as disposable

## Pandoc: document converter  {.columns-2}


<img src="07_assets/pandoc-workflow-rmd-md.png" alt="alt text" width="100%">
<small><small><small>http://kieranhealy.org/blog/archives/2014/01/23/plain-text/ </small></small></small>

A universal document converter, open source, cross-platform

* Write code and narrative in rmarkdown   
* knitr->markdown (with computation)   
* use pandoc to get HTML/PDF/DOCX

# Version Control

## Tracking changes with version control 

**Payoffs**

- Eases collaboration
- Can track changes in any file type (ideally plain text)
- Can revert file to any point in its tracked history

**Costs**
- Learning curve


<img src="07_assets/git.png" alt="alt text" width="25%">
<img src="07_assets/github.png" alt="alt text" width="25%">
<img src="07_assets/bitbucket.png" alt="alt text" width="25%">

## Environment for reproducible research   {.columns-2}

<img src="07_assets/rstudio.png" alt="alt text" width="10%">

* integrated R console
* deep support for markdown and git
* package development tools, etc. etc.

> RStudio 'projects' make version control & document preparation simple


## Depositing code and data

**Payoffs**
- Free space for hosting (and paid options)
- Assignment of persistent DOIs
- Tracking citation metrics 

**Costs**
- Sometimes license restrictions (CC-BY & CC0)
- Limited or no private storage space


<img src="07_assets/figshare.png" alt="alt text" width="30%">
<img src="07_assets/dryad.png" alt="alt text" width="30%">
<img src="07_assets/zenodo.png" alt="alt text" width="30%">


## A hierarchy of reproducibility 

- **Good**: Use code with an integrated development environment (IDE). Minimize pointing and clicking (RStudio)
- **Better**: Use version control. Help yourself keep track of changes, fix bugs and improve project management (RStudio & Git & GitHub or BitBucket)
- **Best**: Use embedded narrative and code to explicitly link code, text and data, save yourself time, save reviewers time, improve your code. (RStudio & Git & GitHub or BitBucket & rmarkdown & knitr & data repository)

##

<img src="07_assets/VictoriaStoddenIASSISTJune2010-reasons-to.png" alt="alt text" width="800">
<small>Stodden (IASSIST 2010) sampled American academics registered at the Machine Learning conference NIPS (134 responses from 593 requests (23%). Red = communitarian norms, Blue = private incentives</small>

##

<img src="07_assets/VictoriaStoddenIASSISTJune2010-reasons.png" alt="alt text" width="800">
<small>Stodden (IASSIST 2010) sampled American academics registered at the Machine Learning conference NIPS (134 responses from 593 requests (23%). Red = communitarian norms, Blue = private incentives</small>



#  Demo: let's get started

[<i class="fa fa-file-code-o fa-3x" aria-hidden="true"></i> The R Script associated with this page is available here](07_assets/demo/Demo.Rmd).  Download this file and open it (or copy-paste into a new script) with RStudio so you can follow along.  

## R Markdown

Cheatsheet:

<a href="https://www.rstudio.com/wp-content/uploads/2015/02/rmarkdown-cheatsheet.pdf"> <img src="07_assets/rmarkdown.png" alt="alt text" width="400"></a>

<small><small><small>[https://www.rstudio.com/wp-content/uploads/2015/02/rmarkdown-cheatsheet.pdf](https://www.rstudio.com/wp-content/uploads/2015/02/rmarkdown-cheatsheet.pdf)</small></small></small>


## Create new file
**File -> New File -> RMarkdown -> Document -> HTML**

<img src="07_assets/rmarkdownwindow.png" alt="alt text" width="500">

## Step 1: Load packages

All R code to be run must be in a _code chunk_ like this:

```r
#```{r,eval=F}
CODE HERE
#```
```

Load these packages in a code chunk (you may need to install some packages):


```r
library(dplyr)
library(ggplot2)
library(maps)
library(spocc)
```

> Do you think you should put `install.packages()` calls in your script?


## Step 2: Load data

Now use the `occ()` function to download all the _occurrence_ records for the American robin (_Turdus migratorius_) from the [Global Biodiversity Information Facility](gbif.org).

<img src="07_assets/Turdus-migratorius-002.jpg" alt="alt text" width="200">

<small><small><small>Licensed under CC BY-SA 3.0 via [Wikimedia Commons](https://commons.wikimedia.org/wiki/File:Turdus-migratorius-002.jpg#/media/File:Turdus-migratorius-002.jpg)</small></small></small>


```r
## define which species to query
sp='Turdus migratorius'

## run the query and convert to data.frame()
d = occ(query=sp, from='ebird',limit = 1000) %>% occ2df()
```
This can take a few seconds.

## Step 3: Map it


```r
# Load coastline
map=map_data("world")

ggplot(d,aes(x=longitude,y=latitude))+
  geom_polygon(aes(x=long,y=lat,group=group,order=order),data=map)+
  geom_point(col="red")+
  coord_equal()
```

```
## Warning: Ignoring unknown aesthetics: order
```

![](07_Reproducibile_files/figure-html/unnamed-chunk-4-1.png)<!-- -->

## Step 4:
Update the YAML header to keep the markdown file

From this:

```r
title: "Untitled"
author: "Adam M. Wilson"
date: "October 31, 2016"
output: html_document
```

To this:

```r
title: "Demo"
author: "Adam M. Wilson"
date: "October 31, 2016"
output: 
  html_document:
      keep_md: true
```

And click `knit HTML` to generate the output

## Step 5:  Explore markdown functions

1. Use the Cheatsheet to add sections and some example narrative.  
2. Try changing changing the species name to your favorite species and re-run the report. 
3. Add more figures or different versions of a figure
4. Check out the `kable()` function for tables (e.g. `kable(head(d))`)

<a href="https://www.rstudio.com/wp-content/uploads/2015/02/rmarkdown-cheatsheet.pdf"> <img src="07_assets/rmarkdown.png" alt="alt text" width="400"></a>


## Colophon

* [Slides based on Ben Marwick's presentation to the UW Center for Statistics and Social Sciences (12 March 2014)](https://github.com/benmarwick/CSSS-Primer-Reproducible-Research) ([OrcID](http://orcid.org/0000-0001-7879-4531))

## References

See Rmd file for full references and sources



