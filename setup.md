---
title: Setup
---

## Code Setup 
We will be using an example project in the lesson. 
Download the file using the link below and extract it to your computer:
 - [zip file of example project](https://github.com/bham-carpentries/astronaut-data-analysis-for-r/archive/refs/tags/v0.0.1.zip).


## Software Setup

::::::::::::::::::::::::::::::::::::::: discussion

This lesson assumes you have R and RStudio installed on your computer.
Please follow the setup instructions below.


:::::::::::::::::::::::::::::::::::::::::::::::::::

:::::::::::::::: spoiler

### Personal Laptop

To install R and RStudio on a personal laptop

#### Windows/Mac

- R can be downloaded [here](https://www.stats.bris.ac.uk/R/). Select the precompiled binary distribution for your operating system.

- RStudio is an environment for code development using R. It can be downloaded [here](https://www.rstudio.com/products/rstudio/download/). You will need the Desktop version for your computer; scroll to the bottom of the page for links.

::::::::::::::::::::::::

:::::::::::::::: spoiler

### University of Birmingham Managed Laptop

#### Windows
To install R and RStudio on a University managed Windows machine:

- Connect your computer to the university network and open the Software Centre from the Start Menu

- Search for and install "RStudio". 

- This will also automatically install R for Windows 4.3.1 and Rtools.

#### Mac

To install R and RStudio on a University managed Mac machine:

- Connect your computer to the university network and open the Software Centre from the Start Menu

- Search for and install "R Language". 

- Search for and install "RStudio". 

::::::::::::::::::::::::
 
## Packages

The course teaches the tidyverse, which is a collection of R packages that are designed to make many common data analysis tasks easier. Please install this before the course. You can do this by starting Rstudio, and typing:

```r
install.packages("tidyverse")
```

At the > prompt in the left hand window of RStudio. You may be prompted to select a mirror to use; either select one in the UK, or the “cloud” option at the start of the list.

R will download the packages that constitute the tidyverse, and then install them. This can take some time. You may get a prompt There are binary versions available but the source versions are later and asking if you want to install from sources packages which require compilation. You should answer no to this.

If you are using a mac you may be prompted whether you wish to install binary or source versions of the packages; you should select binary.

On Linux, several of the packages will be compiled from source. This can take several minutes. You may find that you need to install additional development libraries to allow this to happen.

There will be a number of messages displayed during installation. After the installation has completed you should see a message containing:

```output
** testing if installed package can be loaded
* DONE (tidyverse)
```

Or:

```output
package ‘tidyverse’ successfully unpacked and MD5 sums checked
```

## Check Your Installation

Type the following commands at the > prompt:
```r
library(tidyverse)
ggplot(cars, aes(x=speed, y=dist)) + geom_point()
```

(any message about conflicts can be safely ignored)
This should produce a plot in the lower right hand window of RStudio.
