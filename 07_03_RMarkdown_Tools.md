# RMarkdown Tools: Interactive Presentations, Apps, Websites
Cory Merow  
9/19/2017  

> This tutorial is a quick start guide extending the basic R Markdown skills from __ to getting started with interactive presentations, apps that can be hosted online or run locally, and R-based websites. The RStudio team has excellent complete tutorials on each of these (); this tutorial is meant to show how easy it is to get started with some key features.

# Interactive presentations (with ioSlides)

## Motivation

Interactive Slides ...

  * allow you or students to tinker with inputs and see the results on the fly
  * are completely reproducible and sharable
  * update presentation automatically if code changes 
  * maintain simplicity in presentations

## Getting Started
To create an ioslides presentation from R Markdown you specify the ioslides_presentation output format in the front-matter of your document. 

```r
---
title: "Demo with ioslides"
author: Cory Merow
date: Sept, 20, 2017
output: ioslides_presentation
runtime: shiny
---

## Example Heading 

  Headings are specified by #, ##, or ----  
  
## Text formatting

**bold**

`code`

equations: $H=-\sum_{i=1}^S p_i \log_b  p_i$

## Lists

* list element 1
    + subelement (this line needs to start with a tab, not a space)
* list element 2
    + subelement
```

* Download the extended version of this demo to see interactive components [<i class="fa fa-file-code-o fa-3x" aria-hidden="true"></i> here](07_03assets/Demo_ioslides.Rmd). 

More on [basic authoring](http://rmarkdown.rstudio.com/authoring_basics.html)

## Display Modes

The following single character keyboard shortcuts enable alternate display modes:

  * 'f' enable fullscreen mode
  * 'w' toggle widescreen mode
  * 'o' enable overview mode
  * 'h' enable code highlight mode
  * 'p' show presenter notes

# Applications (with Shiny)

# Websites (like this)

<!-- ## Colophon -->

