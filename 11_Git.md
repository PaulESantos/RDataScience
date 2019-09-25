---
title: "Version Control (with Git)"
author: "Cory Merow & Adam Wilson"
date: "9/19/2017"
output:
  html_document:
    code_folding: show
---

> This tutorial is a quick start guide to sharing your code on github using Rstudio. Command line is optional.


# Git to manage 'versions' of files

Similar to 'track-changes' in Microsoft Word, Git keeps track of any edits and makes it possible to track who made the change and when.  Git is most commonly used to manage collaboratively edited code, but it can keep track of any file. 

# Version Control

## Tracking changes with version control 

**Payoffs**

- Eases collaboration
- Can track changes in any file type (ideally plain text)
- Can revert file to any point in its tracked history

**Costs**

- Learning curve


<!-- <img src="07_assets/git.png" alt="alt text" width="25%"> -->
<!-- <img src="07_assets/github.png" alt="alt text" width="25%"> -->
<!-- <img src="07_assets/bitbucket.png" alt="alt text" width="25%"> -->

<!-- ## Environment for reproducible research   {.columns-2} -->

<img src="07_assets/rstudio.png" alt="alt text" width="10%">

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


<!-- ## A hierarchy of reproducibility  -->

<!-- - **Good**: Use code with an integrated development environment (IDE). Minimize pointing and clicking (RStudio) -->
<!-- - **Better**: Use version control. Help yourself keep track of changes, fix bugs and improve project management (RStudio & Git & GitHub or BitBucket) -->
<!-- - **Best**: Use embedded narrative and code to explicitly link code, text and data, save yourself time, save reviewers time, improve your code. (RStudio & Git & GitHub or BitBucket & rmarkdown & knitr & data repository) -->

## To share

<img src="07_assets/VictoriaStoddenIASSISTJune2010-reasons-to.png" alt="alt text" width="800">
<small>Stodden (IASSIST 2010) sampled American academics registered at the Machine Learning conference NIPS (134 responses from 593 requests (23%). Red = communitarian norms, Blue = private incentives</small>

## Or not to share

<img src="07_assets/VictoriaStoddenIASSISTJune2010-reasons.png" alt="alt text" width="800">
<small>Stodden (IASSIST 2010) sampled American academics registered at the Machine Learning conference NIPS (134 responses from 593 requests (23%). Red = communitarian norms, Blue = private incentives</small>


<br>

***

<br>
#  Git Tutorial: let's get started
<!-- <img src="11_assets/git.png" alt="alt text" width="30%"> -->

## Github

You can think of GitHub as part:

* Server to back up your files
* Website to share your files
* Method to track changes to your files
* Platform to collaboratively develop code (or other files)

### Example: this course website is managed using Git & GitHub

<a href=https://github.com/adammwilson/RDataScience/tree/gh-pages> <img src="11_assets/githubcoursewebsite.png" alt="alt text" width="100%"></a>


## Install Git on your computer

### Windows and OSX
http://git-scm.com/downloads

### Linux
` sudo apt-get install git `
or similar


## Creating an account on [GitHub](github.com)

1. Create a GitHub account at [https://github.com/](https://github.com/)
    * This will be a public account associated with your name
    * Choose a username wisely for future use
    * Don't worry about details, you can fill them in later
2. Create a repository called _demo.YourName_

<br> 
<img src="11_assets/github_new_repo.png" alt="alt text" width="600">

<br> 
    * Add a brief and informative description
    * Choose "Public"
    * Check the box for "Initialize this repository with a README"
3. Click "Create Repository"   

<br>    
<img src="11_assets/github_create_repo.png" alt="alt text" width="600">


## In RStudio: `clone` the repository

1. Go to RStudio

    * File -> New Project
    * Version Control: Checkout a project from a version control repository
    * Git: Clone a project from a repository

2. Fill in the info:

    * URL: use HTTPS address
    * Create as a subdirectory of: Browse and create a new folder, usually with the same name as your repo (demo_YourName)

<img src="11_assets/Rstudio_clone.png" alt="alt text" width="600">

<!-- this link is dead -->
<!-- To set up a connection that doesn't require you to type in your password every time, [see here](GitSSHNotes.html)     -->

## Commit (save) to GitHub from within RStudio

### Steps:

1. Edit: make changes to a file in the repository you cloned above
2. Stage: tell git which changes you want to commit (save)
3. Commit (with a message saying what you did - you can't skip this!)
4. Push: send the updated files to GitHub

 The 3 states of files: Staged, Modified, Committed
<img src="11_assets/staging.png" alt="alt text" width="75%">

The important stuff is hidden in the `.git` folder (which might be hidden on your computer)


## Staging
<img src="11_assets/Stage.png" alt="alt text" width="75%">

Select which changed  files (added, deleted, or edited) you want to commit. Staging allows you to choose just a certain subset of modified files to associate with a commit. (If you always save all your changes in the same commit, this maybe isn't intuitive...) 

## Committing
<img src="11_assets/Commit.png" alt="alt text" width="100%">

Add a _commit message_ and click commit.

## Syncing (`push`)
<img src="11_assets/Push.png" alt="alt text" width="100%">

Click the green arrow to sync with GitHub.

## Add your Rmd
Try adding the Rmd (and associated .md, R, files) you created in the last tutorial (or any other Rmd) to your working folder and push it to github.  

In case you don't have one handy, use this [<i class="fa fa-file-code-o fa-3x" aria-hidden="true"></i> the R Script associated with this page is available here](07_assets/demo/Demo.Rmd). 


<!-- ## Git and RMarkdown -->

<!-- ### Visualize .md on GitHub -->

<!-- Make sure you compiled the Rmd in the previous step before pushing, because we want to view the .md on the github website. -->

<!-- In case you haven't already, update the YAML header to keep the markdown file -->

<!-- From this: -->
<!-- ```{r, eval=F} -->
<!-- title: "Untitled" -->
<!-- author: "Adam M. Wilson" -->
<!-- output: html_document -->
<!-- ``` -->

<!-- To this: -->
<!-- ```{r, eval=F} -->
<!-- title: "Demo" -->
<!-- author: "Adam M. Wilson" -->
<!-- output:  -->
<!--   html_document: -->
<!--       keep_md: true -->
<!-- ``` -->

<!-- And click `knit HTML` to generate the output -->

<!-- Go to your github webpage and select the md. It should display as a report, as below. Don't see the .md? Did you push your code to github? -->

<!-- <img src="11_assets/ghmd.png" alt="alt text" width="50%"> -->


<!-- <br> -->

## Invite a collaborator

Now add another github user to your repo (e.g. the person sitting next to you). 

<img src="11_assets/github_settings.png" alt="alt text" width="80%">

Practice modifying a file and pushing it to one another's repos.

## Conflicts
A conflict can occur if two people simultaneously edit the same file and haven't pushed it. This can be resolved by merging if the bits of code don't overlap, but requires someone to choose which version of the code to keep if they do overlap. **Either avoid working on the same bits of code simultaneously, or read on to learn more advanced git functions.**

## Tips

* reference a specific line of code in a link by adding (e.g.) #L18 to the html address to go to line 18
* track 'issues' such as bugs or to-dos and track a discussion on them using github's Issues tab

<img src="11_assets/github_issues.png" alt="alt text" width="90%">

<br>

***

<br>

# More git, if you're bored

<!-- ## Git Jargon -->
<!-- <img src="11_assets/git.png" alt="alt text" width="30%"> -->

<!-- * **Strong support for non-linear development:** Rapid branching and merging,  specific tools for visualizing and navigating a non-linear development history.  -->
<!-- * **Distributed development:** No central server needed, each user has a full copy -->
<!-- * **Efficient handling of large projects:** Designed to manage the Linux OS -->
<!-- * **Cryptographic authentication of history:** The ID of a particular version depends upon the complete history. Once published, it is not possible to change the old versions without it being noticed.  -->

<!-- ## Git File Lifecycle -->

<!-- <img src="11_assets/Lifecycle.png" alt="alt text" width="100%"> -->


## Git command line from RStudio

RStudio has limited functionality.  

<img src="11_assets/CommandLine.png" alt="alt text" width="75%">


## Git help

```{}
$ git help <verb>
$ git <verb> --help
$ man git-<verb>
```
For example, you can get the manpage help for the config command by running `git help config`

## Git status
<img src="11_assets/GitCL.png" alt="alt text" width="75%">

Similar to info in git tab in RStudio

## Git config
`git config` shows you all the git configuration settings:

* `user.email`
* `remote.origin.url`  (e.g. to connect to GitHub)

## Branching
Branches used to develop features isolated from each other. 
<img src="11_assets/merge.png" alt="alt text" width="100%">

Default: _master_ branch. Use other branches for development/collaboration and merge them back upon completion.

## Basic Branching

```{}
$ git checkout -b devel   # create new branch and switch to it


$ git checkout master  #switch back to master
$ git merge devel  #merge in changes from devel branch
```
But we won't do much with branching in this course...

<div class="well">
## Command line git
Take 15 minutes or so at [this site to walk through some basic git commands](https://try.github.io/levels/1/challenges/1)<br>
<a href=https://try.github.io/levels/1/challenges/1> <img src="11_assets/trygit.png" alt="alt text" width="75%"></a>

</div>
</div>

## Git can do far more!

Check out the (free) book [ProGIT](https://git-scm.com/book/en/v2)

<img src="11_assets/progit2.png" alt="alt text" width="30%">


Or the [cheatsheet](https://training.github.com/kit/downloads/github-git-cheat-sheet.pdf).

## Philosphy  
Remember, the data and code are _real_, the products (tables, figures) are ephemeral...  

## Colophon

* [Slides based on Ben Marwick's presentation to the UW Center for Statistics and Social Sciences (12 March 2014)](https://github.com/benmarwick/CSSS-Primer-Reproducible-Research) ([OrcID](http://orcid.org/0000-0001-7879-4531))
* Git Slides based on materials from Dr. Çetinkaya-Rundel
