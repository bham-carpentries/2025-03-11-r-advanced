---
title: Code structure
teaching: 60
exercises: 30
editor_options: 
  markdown: 
    wrap: 72
---

::: questions
-   How can we best structure our R project?
-   What are conventional places to store data, code, results and tests
    within our research project?
:::

::: objectives
After completing this episode, participants should be able to:

-   Set up and use an R "research compendium" using rrtools to organise
    a reproducible research project.
:::

In the previous episode we have seen some tools and practices that can
help up improve readability of our code - including breaking our code
into small, reusable functions that perform one specific task. 

In this episode we will expand these practices to our (research) projects as a whole.

::: instructor
At this point, the code in your local software project's directory
should be as in: TODO
:::

## Introducing Research Compendia

Ensuring that our R project is organised and well-structured is just as
important as writing well-structured code. Following conventions on
consistent and informative directory structure for our project will
ensure people will immediately know where to find things and is
especially helpful for long-term research projects or when working in
teams.

Our project is currently set up as a simple R project with all of our
files stored in the root of the project folder. We could improve on this
significantly by creating a more structured directory layout like the
one below:

``` output
project_name/
├── README.md             # overview of the project
├── data/                 # data files used in the project
│   ├── README.md         # describes where data came from
│   ├── raw/
│   └── processed/
├── manuscript/           # manuscript describing the results
├── results/              # results of the analysis (data, tables)  
│   ├── preliminary/
│   └── final/
├── figures/              # results of the analysis (figures)
│   ├── comparison_plot.png
│   └── regression_chart.pdf
├── src/                  # contains source code for the project
│   ├── LICENSE           # license for your code
│   ├── main_script.R    # main script/code entry point
│   └── ...
├── doc/                  # documentation for your project
└── ...
```

However, we are going to structure our project as an rrtools (package)
research compendium instead.

An rrtools compendium is essentially an R package containing everything required
to reproduce an analysis (data and functions). While experience
of building R packages is helpful - it isn't necessary to get started working with 
rrtools compendia - we will cover the necessary detail as we go along.  

:::: callout

# Research Compendium vs R Project

A **research compendium** offers additional benefits over a
simple R project structure, particularly for ensuring reproducibility and
long-term sustainability of the project. 

+ While a simple R project can be **well-organised**, a research
compendium follows a standardised **R package structure** that aligns with best
practices for reproducible research. This makes it far easier for
someone new to the project to understand and run the analysis.

+ rrtools compendia include
**metadata files** like `DESCRIPTION` and `NAMESPACE` that provide clear
documentation of dependencies, which helps other collaborators or future
users run your project with the correct packages and versions. 

+ The compendium setup also allows you to include automatic documentation
generation through tools like **roxygen2**, making it easier to maintain
and update as the project evolves.

+ A research compendium supports **automated testing** (using
tools like `testthat`).

:::: 

## Setting up a research compendium

In this section we are going to setup an R compendium using the rrtools package
and copy over our content from out current project to the new compendium.

The top-level of our folder structure for this course is organised as follows:
``` output
advanced_r/
├── project/                  
│   └── spacewalks1/ # contains source code for the project
└── compendium/
```

Before we start, we need to close our current `spacewalks1` project (File >> Close Project) and 
create and open a new R project `spacewalks2` in the compendium subdfolder of `advanced_r` (File >> New Project >>  New Directory >> New Project).

``` output
advanced_r/
├── project/                  
│   └── spacewalks1/
└── compendium/
│   └── spacewalks2/ 
```

We also need to install a number of packages we'll need to start working with the compendium:
```r
install.packages("rrtools")
install.packages("usethis")
install.packages("devtools")
```

Once we have created and launched the new project, we can start setting up the compendium by running the following commands in the R console:

```r
library(rrtools)
rrtools::use_compendium(simple=FALSE) 
```

```output
> library(rrtools)
✔ Git is installed on this computer, your username is abc123
```

```
New project 'spacewalks2' is nested inside an existing project '/Users/myusername/projects/astronaut-data-analysis-r/advanced_r/compendium', which is rarely a good idea.
If this is unexpected, the here package has a function, `here::dr_here()` that reveals why '/Users/myusername/projects/astronaut-data-analysis-r/advanced_r/compendium' is regarded as a project.
Do you want to create anyway?

1: I agree
2: Absolutely not
3: Not now
```

```output
Selection: 1
✔ Setting active project to '/Users/myusername/projects/astronaut-data-analysis-r/advanced_r/compendium/spacewalks2'
✔ Creating 'R/'
✔ Writing 'DESCRIPTION'
Package: spacewalks2
Title: What the Package Does (One Line, Title Case)
Version: 0.0.0.9000
Authors@R (parsed):
    * First Last <first.last@example.com> [aut, cre]
Description: What the package does (one paragraph).
License: MIT + file LICENSE
ByteCompile: true
Encoding: UTF-8
LazyData: true
Roxygen: list(markdown = TRUE)
RoxygenNote: 7.3.2
✔ Writing 'NAMESPACE'
Overwrite pre-existing file 'spacewalks2.Rproj'?

1: Yup
2: Nope
3: Not now

```

```output
Selection: 1
✔ Writing 'spacewalks2.Rproj'
✔ Adding '^spacewalks2\\.Rproj$' to '.Rbuildignore'
✔ Adding '.Rproj.user' to '.gitignore'
✔ Adding '^\\.Rproj\\.user$' to '.Rbuildignore'
✔ Opening '/Users/myusername/projects/astronaut-data-analysis-r/advanced_r/compendium/spacewalks2/' in new RStudio session
✔ Setting active project to '<no active project>'
✔ The package spacewalks2 has been created

Next, you need to:  ↓ ↓ ↓ 
• Edit the DESCRIPTION file
• Add a license file (e.g. with usethis::use_mit_license(copyright_holder = 'Your Name'))
• Use other 'rrtools' functions to add components to the compendium
```

The output of the use_compendium function provides a list of next steps to complete 
the setup of the compendium. 

We will follow these steps to complete the setup, but first let's take a look at 
the new directory structure that has been created:

``` output
.
├── DESCRIPTION <- .............................package metadata
|                                               dependency management
├── NAMESPACE <- ...............................AUTO-GENERATED on build
├── R <- .......................................folder for functions
└── spacewalks2.Rproj <- ......................rstudio project file
```
rrtools::use_compendium() creates the bare backbone of infrastructure
required for a research compendium. 

At this point it provides facilities to store general metadata about our compendium 
(eg bibliographic details to create a citation) and manage dependencies in the 
DESCRIPTION file and store and document functions in the R/ folder. 

Together these allow us to manage, install and share functionality associated with our project.

+ A `DESCRIPTION` file is a required component of an R package. This file contains 
  metadata about our package, including the name, version, author, and dependencies.
+ A `NAMESPACE` file is a required component of an R package. Its role is to defines the functions, 
  methods, and datasets that are exported from a package (i.e., made available to users) 
  and those that are kept internal (i.e., not accessible directly by users). 
  It helps manage the visibility of functions and ensures that only the intended 
  parts of the package are exposed to the outside world. This file is auto-generated when the package is built.
+ The `R/` folder contains the R scripts that contain the functions in the package.
+ RStudio Project file `spacewalks2.Rproj` - this file is used to open the project in RStudio.


### Edit the DESCRIPTION file

Let's start by editing the DESCRIPTION file. 

```text
Package: spacewalks2
Title: What the Package Does (One Line, Title Case)
Version: 0.0.0.9000
Authors@R: 
    person("First", "Last", , "first.last@example.com", role = c("aut", "cre"))
Description: What the package does (one paragraph).
License: MIT + file LICENSE
ByteCompile: true
Encoding: UTF-8
LazyData: true
Roxygen: list(markdown = TRUE)
RoxygenNote: 7.3.2
```

The following fields need to be updated:

+ `Package` - the name of the package.
+ `Title` - a short description of what the package does.
+ `Version` - the version number of the package.
+ `Authors@R` - the authors of the package.
+ `Description` - a longer description of what the package does.
+ `License` - the license under which the package code is distributed.

```
Package: spacewalks2
Title: Analysis of NASA's extravehicular activity datasets
Version: 0.0.0.9000
Authors@R: c(
    person(given   = "Kamilla",
           family  = "Kopec-Harding",
           role    = c("cre"),
           email   = "k.r.kopec-harding@bham.ac.uk",           
           comment = c(ORCID = "{{0000-0002-2960-7944}}")),
    person(given   = "Sarah",
           family  = "Jaffa",
           role    = c("aut"),
           email   = "sarah.jaffa@manchester.ac.uk",
           comment = c(ORCID = "{{0000-0002-6711-6345}}")),
    person(given   = "Aleksandra",
           family  = "Nenadic",
           role    = c("aut"),
           comment = c(ORCID = "{{0000-0002-2269-3894}}"))
    )
Description: An R research compendium for researchers to generate visualisations and statistical 
    summaries of NASA's extravehicular activity datasets.
License: MIT + file LICENSE
ByteCompile: true
Encoding: UTF-8
LazyData: true
Roxygen: list(markdown = TRUE)
RoxygenNote: 7.3.2
```

### Add a license file

Next, we need to add a license file to the compendium.  
A license file is a text file that specifies the legal terms under which the code in the package can be used.

We can add a license file using the `usethis` package:
We'll use an MIT license for this project.  We discuss how to select a license in the next episode. 

```r 
usethis::use_mit_license(copyright_holder = "Kamilla Kopec-Harding")
```

```output
✔ Writing 'LICENSE'
✔ Writing 'LICENSE.md'
✔ Adding '^LICENSE\\.md$' to '.Rbuildignore'
```

### Add components to the compendium
Once we have filled in the DESCRIPTION file and added a license file, 
we can start adding content to the compendium. We'll look a this in detail in
the next section


## Managing functionality in a package 

We mentioned previously that an R compendium is an R package. `rrtools` essentially
provides us with an R package template and in this section we will start populating this with the functionality 
from our current project `spacewalks1`.

Our first task is to copy over the code from our current project to the new compendium
and get it working within the compendium / R package structure. We'll follow these steps:

+ Create package functions 
+ Document our functions
+ Build and install our compendium package
+ Check our package for issues
+ Fix any issues that come up
+ Re-build and install our compendium package
+ Write a script to run (drive) our analysis

### Create package functions

We'll start by creating a new R script file in the `R/` folder of the compendium and 
copying over the functions we have created so far.

To create or edit .R files in the R/ directory, we can use:
```
usethis::use_r("eva_data_analysis.R")
```
This creates a file called eva_data_analysis.R in the R/ directory and opens it up for editing.
Let's populate this with the functions we created in the previous episode.

```r 
# R/eva_data_analysis.R

#' Read and Clean EVA Data from JSON
#'
#' This function reads EVA data from a JSON file, cleans it by converting
#' the 'eva' column to numeric, converting data from text to date format,
#. creating a year variable and removing rows with missing values, and sorts
#' the data by the 'date' column.
#'
#' @param input_file A character string specifying the path to the input JSON file.
#'
#' @return A cleaned and sorted data frame containing the EVA data.
#'
read_json_to_dataframe <- function(input_file) {
  print("Reading JSON file")

  eva_df <- fromJSON(input_file, flatten = TRUE) |>
    mutate(eva = as.numeric(eva)) |>
    mutate(date = ymd_hms(date)) |>
    mutate(year = year(date)) |>
    drop_na() |>
    arrange(date)

  return(eva_df)
}

#' Convert Duration from HH:MM Format to Hours
#'
#' This function converts a duration in "HH:MM" format (as a character string)
#' into the total duration in hours (as a numeric value).
#'
#' @details
#' When applied to a vector, it will only process and return the first element
#' so this function must be applied to a data frame rowwise.
#'
#' @param duration A character string representing the duration in "HH:MM" format.
#'
#' @return A numeric value representing the duration in hours.
#'
#' @examples
#' text_to_duration("03:45")  # Returns 3.75 hours
#' text_to_duration("12:30")  # Returns 12.5 hours
text_to_duration <- function(duration) {
  time_parts <- stringr::str_split(duration, ":")[[1]]
  hours <- as.numeric(time_parts[1])
  minutes <- as.numeric(time_parts[2])
  duration_hours <- hours + minutes / 60
  return(duration_hours)
}

#' Plot Cumulative Time in Space Over the Years
#'
#' This function plots the cumulative time spent in space over the years based on
#' the data in the dataframe. The cumulative time is calculated by converting the
#' "duration" column into hours, then computing the cumulative sum of the duration.
#' The plot is saved as a PNG file at the specified location.
#'
#' @param tdf A dataframe containing a "duration" column in "HH:MM" format and a "date" column.
#' @param graph_file A character string specifying the path to save the graph.
#'
#' @return NULL
plot_cumulative_time_in_space <- function(tdf, graph_file) {

  time_in_space_plot <- tdf |>
    rowwise() |>
    mutate(duration_hours = text_to_duration(duration)) |>  # Add duration_hours column
    ungroup() |>
    mutate(cumulative_time = cumsum(duration_hours)) |>     # Calculate cumulative time
    ggplot(ggplot2::aes(x = date, y = cumulative_time)) +
    geom_line(color = "black") +
    labs(
      x = "Year",
      y = "Total time spent in space to date (hours)",
      title = "Cumulative Spacewalk Time"
    )

  ggplot2::ggsave(graph_file, width = 8, height = 6, plot = time_in_space_plot)
}
```

Notice that this file **only** contains functions and we have omitted `library()` calls.
We will add the main script that calls these functions later.

### Document package functions

Now, to have our functions exported as part of the spacewalks2 package, we need to document them using Roxygen2.

As we saw earlier, Roxygen2 provides a documentation framework in R and allows us to write specially-structured comments preceding each function definition. When we document our our package, these are processed automatically to produce .Rd help files for our functions. The contents of these files controls which are exported to the package NAMESPACE. 

The @export tag tells Roxygen2 to add a function as an export in the NAMESPACE file, so that it will be accessible and available for use after package installation. This means that we need to add the @export function to each of our functions:

```r
#' Read and Clean EVA Data from JSON
#'
#' This function reads EVA data from a JSON file, cleans it by converting
#' the 'eva' column to numeric, converting data from text to date format,
#. creating a year variable and removing rows with missing values, and sorts
#' the data by the 'date' column.
#'
#' @param input_file A character string specifying the path to the input JSON file.
#'
#' @return A cleaned and sorted data frame containing the EVA data.
#' @export
read_json_to_dataframe <- function(input_file) {
  print("Reading JSON file")

  eva_df <- fromJSON(input_file, flatten = TRUE) |>
    mutate(eva = as.numeric(eva)) |>
    mutate(date = ymd_hms(date)) |>
    mutate(year = year(date)) |>
    drop_na() |>
    arrange(date)

  return(eva_df)
}

#' Convert Duration from HH:MM Format to Hours
#'
#' This function converts a duration in "HH:MM" format (as a character string)
#' into the total duration in hours (as a numeric value).
#'
#' @details
#' When applied to a vector, it will only process and return the first element
#' so this function must be applied to a data frame rowwise.
#'
#' @param duration A character string representing the duration in "HH:MM" format.
#'
#' @return A numeric value representing the duration in hours.
#'
#' @examples
#' text_to_duration("03:45")  # Returns 3.75 hours
#' text_to_duration("12:30")  # Returns 12.5 hours
#' @export
text_to_duration <- function(duration) {
  time_parts <- str_split(duration, ":")[[1]]
  hours <- as.numeric(time_parts[1])
  minutes <- as.numeric(time_parts[2])
  duration_hours <- hours + minutes / 60
  return(duration_hours)
}

#' Plot Cumulative Time in Space Over the Years
#'
#' This function plots the cumulative time spent in space over the years based on
#' the data in the dataframe. The cumulative time is calculated by converting the
#' "duration" column into hours, then computing the cumulative sum of the duration.
#' The plot is saved as a PNG file at the specified location.
#'
#' @param tdf A dataframe containing a "duration" column in "HH:MM" format and a "date" column.
#' @param graph_file A character string specifying the path to save the graph.
#'
#' @return NULL
#' @export
plot_cumulative_time_in_space <- function(tdf, graph_file) {

  time_in_space_plot <- tdf |>
    rowwise() |>
    mutate(duration_hours = text_to_duration(duration)) |>  # Add duration_hours column
    ungroup() |>
    mutate(cumulative_time = cumsum(duration_hours)) |>     # Calculate cumulative time
    ggplot(ggplot2::aes(x = date, y = cumulative_time)) +
    geom_line(color = "black") +
    labs(
      x = "Year",
      y = "Total time spent in space to date (hours)",
      title = "Cumulative Spacewalk Time"
    )

  ggplot2::ggsave(graph_file, width = 8, height = 6, plot = time_in_space_plot)
}
```

### Build and install package

#### Build Roxygen documentation
Now that we’ve annotated our source code we can build the documentation either 
by clicking on More > Document in the RStudio Build panel or from the console using:

```r
devtools::document()
```

```output
ℹ Updating spacewalks2 documentation
ℹ Loading spacewalks2
Writing NAMESPACE
Writing read_json_to_dataframe.Rd
Writing text_to_duration.Rd
Writing plot_cumulative_time_in_space.Rd
```

The man/ directory will now contain an .Rd file for recode_system_size.
```output
man
└── plot_cumulative_time_in_space.Rd
└── read_json_to_dataframe.Rd
└── text_to_duration.Rd
```
and the NAMESPACE now contains an export() entry for each of our functions:

```output
# Generated by roxygen2: do not edit by hand
export(plot_cumulative_time_in_space)
export(read_json_to_dataframe)
export(text_to_duration)
```


#### Install Package
The usual workflow for package development is to:

+	make some changes
+	build and install the package
+	unload and reload the package (often in a new R session)

The best way to install and reload a package in a fresh R session is to use the 🔨 Clean and Install cammand tab in the Build panel which performs several steps in sequence to ensure a clean and correct result:

+	Unloads any existing version of the package (including shared libraries if necessary).
+	Builds and installs the package using R CMD INSTALL.
+	Restarts the underlying R session to ensure a clean environment for re-loading the package.
+	Reloads the package in the new R session by executing the library function.

Running the 🔨 Clean and Install  command on our package results in this output in the Build panel output:

```output
==> R CMD INSTALL --preclean --no-multiarch --with-keep.source spacewalks2

* installing to library ‘/Library/Frameworks/R.framework/Versions/4.3-arm64/Resources/library’
* installing *source* package ‘spacewalks2’ ...
** using staged installation
** R
** byte-compile and prepare package for lazy loading
** help
*** installing help indices
** building package indices
** testing if installed package can be loaded from temporary location
** testing if installed package can be loaded from final location
** testing if installed package keeps a record of temporary installation path
* DONE (spacewalks2)
```

We can inspect the resulting documentation for our function using ?plot_cumulative_time_in_space

### Check package

#### Automated checking
An important part of the package development process is R CMD check. R CMD check automatically checks your code and can automatically detects many common problems that we’d otherwise discover the hard way.

To check our package, we can:

+ use devtools::check()
+ click on the ✅Check tab in the Build panel.

This:
+	Ensures that the documentation is up-to-date by running devtools::document().
+	Bundles the package before checking it.


More info on checks here.

Both these run R CMD check which return three types of messages:

+	ERRORs: Severe problems that you should fix regardless of whether or not you’re submitting to CRAN.
+	WARNINGs: Likely problems that you must fix if you’re planning to submit to CRAN (and a good idea to look into even if you’re not).
_	NOTEs: Mild problems. If you are submitting to CRAN, you should strive to eliminate all NOTEs, even if they are false positives.
Let’s Check our package:

```r
devtools::check()
```


```output
── R CMD check results ──────────────────────────────────────────────────────────── spacewalks2 0.0.0.9000 ────
Duration: 10s

❯ checking dependencies in R code ... WARNING
  '::' or ':::' imports not declared from:
    ‘ggplot2’ ‘stringr’

❯ checking R code for possible problems ... NOTE
  plot_cumulative_time_in_space: no visible global function definition
    for ‘ggplot’
  plot_cumulative_time_in_space: no visible global function definition
    for ‘mutate’
  plot_cumulative_time_in_space: no visible global function definition
    for ‘ungroup’
  plot_cumulative_time_in_space: no visible global function definition
    for ‘rowwise’
  plot_cumulative_time_in_space: no visible binding for global variable
    ‘duration’
  plot_cumulative_time_in_space: no visible binding for global variable
    ‘duration_hours’
  plot_cumulative_time_in_space: no visible binding for global variable
    ‘cumulative_time’
  plot_cumulative_time_in_space: no visible global function definition
    for ‘geom_line’
  plot_cumulative_time_in_space: no visible global function definition
    for ‘labs’
  read_json_to_dataframe: no visible global function definition for
    ‘arrange’
  read_json_to_dataframe: no visible global function definition for
    ‘drop_na’
  read_json_to_dataframe: no visible global function definition for
    ‘mutate’
  read_json_to_dataframe: no visible global function definition for
    ‘fromJSON’
  read_json_to_dataframe: no visible binding for global variable ‘eva’
  read_json_to_dataframe: no visible global function definition for
    ‘ymd_hms’
  read_json_to_dataframe: no visible global function definition for
    ‘year’
  Undefined global functions or variables:
    arrange cumulative_time drop_na duration duration_hours eva fromJSON
    geom_line ggplot labs mutate rowwise ungroup year ymd_hms

0 errors ✔ | 1 warning ✖ | 1 notes ✖
```

R CMD check succeeded
OK so there’s a couple of flags from problems and a NOTE. Let’s start troubleshooting with:

```output
our_function_name: no visible global function definition for ‘third_party_function_name’

read_json_to_dataframe: no visible global function definition for ‘mutate’
plot_cumulative_time_in_space: no visible global function definition for ‘ggplot’
```

This arises because we are using lots of functions from third party packages in our code e.g. mutate and ggplot from dplyr and ggplot2 respectively. However, we have not specified that they are imported from the dplyr and ggplot2 NAMESPACEs so the checks look for functions with those names in our package (spacewalks2) instead and obviously can’t find anything.

To fix this we need to add the namespace of every third-party function we use.

To specify the namespace of a function we use the notation <package_name>::<function_name>, so let’s update our functions with these details.

Let's start with `read_json_to_dataframe`:

```r
read_json_to_dataframe <- function(input_file) {
  print("Reading JSON file")

  eva_df <- fromJSON(input_file, flatten = TRUE) |>
    mutate(eva = as.numeric(eva)) |>
    mutate(date = ymd_hms(date)) |>
    mutate(year = year(date)) |>
    drop_na() |>
    arrange(date)

  return(eva_df)
}
```

Once we've added namespace notation to all the functions our `read_json_to_dataframe`
function looks like this:

```r
read_json_to_dataframe <- function(input_file) {
  print("Reading JSON file")

  eva_df <- jsonlite::fromJSON(input_file, flatten = TRUE) |>
    dplyr::mutate(eva = as.numeric(eva)) |>
    dplyr::mutate(date = lubridate::ymd_hms(date)) |>
    dplyr::mutate(year = lubridate::year(date)) |>
    tidyr::drop_na() |>
    dplyr::arrange(date)

  return(eva_df)
}
```

::: challenge

Add namespace notation to the `plot_cumulative_time_in_space` function
```
plot_cumulative_time_in_space <- function(tdf, graph_file) {

  time_in_space_plot <- tdf |>
    rowwise() |>
    mutate(duration_hours = text_to_duration(duration)) |>  # Add duration_hours column
    ungroup() |>
    mutate(cumulative_time = cumsum(duration_hours)) |>     # Calculate cumulative time
    ggplot(aes(x = date, y = cumulative_time)) +
    geom_line(color = "black") +
    labs(
      x = "Year",
      y = "Total time spent in space to date (hours)",
      title = "Cumulative Spacewalk Time"
    )

  ggsave(graph_file, width = 8, height = 6, plot = time_in_space_plot)
}
```

::: solution

plot_cumulative_time_in_space <- function(tdf, graph_file) {

   time_in_space_plot <- tdf |>
    dplyr::rowwise() |>
    dplyr::mutate(duration_hours = text_to_duration(duration)) |>  # Add duration_hours column
    dplyr::ungroup() |>
    dplyr::mutate(cumulative_time = cumsum(duration_hours)) |>     # Calculate cumulative time
    ggplot2::ggplot(ggplot2::aes(x = date, y = cumulative_time)) +
    ggplot2::geom_line(color = "black") +
    ggplot2::labs(
      x = "Year",
      y = "Total time spent in space to date (hours)",
      title = "Cumulative Spacewalk Time"
    )

  ggplot2::ggsave(graph_file, width = 8, height = 6, plot = time_in_space_plot)
}

:::

:::


We can update the rest of our functions as follows:

```r
#' Read and Clean EVA Data from JSON
#'
#' This function reads EVA data from a JSON file, cleans it by converting
#' the 'eva' column to numeric, converting data from text to date format,
#. creating a year variable and removing rows with missing values, and sorts
#' the data by the 'date' column.
#'
#' @param input_file A character string specifying the path to the input JSON file.
#'
#' @return A cleaned and sorted data frame containing the EVA data.
#' @export
read_json_to_dataframe <- function(input_file) {
  print("Reading JSON file")

  eva_df <- jsonlite::fromJSON(input_file, flatten = TRUE) |>
    dplyr::mutate(eva = as.numeric(eva)) |>
    dplyr::mutate(date = lubridate::ymd_hms(date)) |>
    dplyr::mutate(year = lubridate::year(date)) |>
    tidyr::drop_na() |>
    dplyr::arrange(date)

  return(eva_df)
}

#' Convert Duration from HH:MM Format to Hours
#'
#' This function converts a duration in "HH:MM" format (as a character string)
#' into the total duration in hours (as a numeric value).
#'
#' @details
#' When applied to a vector, it will only process and return the first element
#' so this function must be applied to a data frame rowwise.
#'
#' @param duration A character string representing the duration in "HH:MM" format.
#'
#' @return A numeric value representing the duration in hours.
#'
#' @examples
#' text_to_duration("03:45")  # Returns 3.75 hours
#' text_to_duration("12:30")  # Returns 12.5 hours
#' @export
text_to_duration <- function(duration) {
  time_parts <- stringr::str_split(duration, ":")[[1]]
  hours <- as.numeric(time_parts[1])
  minutes <- as.numeric(time_parts[2])
  duration_hours <- hours + minutes / 60
  return(duration_hours)
}

#' Plot Cumulative Time in Space Over the Years
#'
#' This function plots the cumulative time spent in space over the years based on
#' the data in the dataframe. The cumulative time is calculated by converting the
#' "duration" column into hours, then computing the cumulative sum of the duration.
#' The plot is saved as a PNG file at the specified location.
#'
#' @param tdf A dataframe containing a "duration" column in "HH:MM" format and a "date" column.
#' @param graph_file A character string specifying the path to save the graph.
#'
#' @return NULL
#' @export
plot_cumulative_time_in_space <- function(tdf, graph_file) {

  time_in_space_plot <- tdf |>
    dplyr::rowwise() |>
    dplyr::mutate(duration_hours = text_to_duration(duration)) |>  # Add duration_hours column
    dplyr::ungroup() |>
    dplyr::mutate(cumulative_time = cumsum(duration_hours)) |>     # Calculate cumulative time
    ggplot2::ggplot(ggplot2::aes(x = date, y = cumulative_time)) +
    ggplot2::geom_line(color = "black") +
    ggplot2::labs(
      x = "Year",
      y = "Total time spent in space to date (hours)",
      title = "Cumulative Spacewalk Time"
    )

  ggplot2::ggsave(graph_file, width = 8, height = 6, plot = time_in_space_plot)

}
```

Let’s run Check again:
```r
devtools::check()
```


```output
── R CMD check results ───────────────── spacewalks2 0.0.0.9000 ────
Duration: 1m 7.7s

❯ checking dependencies in R code ... WARNING
  '::' or ':::' imports not declared from:
    ‘dplyr’ ‘ggplot2’ ‘jsonlite’ ‘lubridate’ ‘stringr’ ‘tidyr’

❯ checking R code for possible problems ... NOTE
  plot_cumulative_time_in_space: no visible binding for global variable
    ‘duration’
  plot_cumulative_time_in_space: no visible binding for global variable
    ‘duration_hours’
  plot_cumulative_time_in_space: no visible binding for global variable
    ‘cumulative_time’
  read_json_to_dataframe: no visible binding for global variable ‘eva’
  Undefined global functions or variables:
    cumulative_time duration duration_hours eva

0 errors ✔ | 1 warning ✖ | 1 notes ✖
Error: R CMD check found WARNINGs
Execution halted

Exited with status 1.
```

####  Add dependency

In this next round of checks, the note about undefined global functions is gone but now we have a warning regarding '::' or ':::' import not declared from: ‘dplyr’, 'ggplot2' and other packages. It’s flagging the fact that we are wanting to import functions from dplyr and other packages but have not yet declared the package as a dependency in the Imports field of the DESCRIPTION file.

We can add dplyr and these other packages to Imports with:

```r
usethis::use_package("dplyr", "Imports")
usethis::use_package("ggplot2", "Imports")
usethis::use_package("jsonlite", "Imports")
usethis::use_package("lubridate", "Imports")
usethis::use_package("stringr", "Imports")
usethis::use_package("tidyr", "Imports")
```

```output
✔ Setting active project to '/Users/krharding/projects/uob/astronaut-data-analysis-not-so-fair-r/advanced_r/compendium/spacewalks2'
✔ Adding 'dplyr' to Imports field in DESCRIPTION
• Refer to functions with `dplyr::fun()`
> usethis::use_package("ggplot2", "Imports")
✔ Adding 'ggplot2' to Imports field in DESCRIPTION
• Refer to functions with `ggplot2::fun()`
> usethis::use_package("jsonlite", "Imports")
✔ Adding 'jsonlite' to Imports field in DESCRIPTION
• Refer to functions with `jsonlite::fun()`
> usethis::use_package("lubridate", "Imports")
✔ Adding 'lubridate' to Imports field in DESCRIPTION
• Refer to functions with `lubridate::fun()`
> usethis::use_package("stringr", "Imports")
✔ Adding 'stringr' to Imports field in DESCRIPTION
• Refer to functions with `stringr::fun()`
> usethis::use_package("tidyr", "Imports")
✔ Adding 'tidyr' to Imports field in DESCRIPTION
• Refer to functions with `tidyr::fun()` 
```

Our description file now looks like this:
```
Package: spacewalks2
Title: Analysis of NASA's extravehicular activity datasets
Version: 0.0.0.9000
Authors@R: c(
    person(given   = "Kamilla",
           family  = "Kopec-Harding",
           role    = c("cre"),
           email   = "k.r.kopec-harding@bham.ac.uk",           
           comment = c(ORCID = "{{0000-0002-2960-7944}}")),
    person(given   = "Sarah",
           family  = "Jaffa",
           role    = c("aut"),
           email   = "sarah.jaffa@manchester.ac.uk",
           comment = c(ORCID = "{{0000-0002-6711-6345}}")),
    person(given   = "Aleksandra",
           family  = "Nenadic",
           role    = c("aut"),
           comment = c(ORCID = "{{0000-0002-2269-3894}}"))
    )
Description: An R research compendium for researchers to generate visualisations and statistical 
    summaries of NASA's extravehicular activity datasets.
License: MIT + file LICENSE
ByteCompile: true
Encoding: UTF-8
LazyData: true
Roxygen: list(markdown = TRUE)
RoxygenNote: 7.3.2
Imports: 
    dplyr,
    ggplot2,
    jsonlite,
    lubridate,
    stringr,
    tidyr
```
Let's do one final check.

```r
devtools::check()
```

```output
── R CMD check results ───────────────── spacewalks2 0.0.0.9000 ────
Duration: 13.7s

❯ checking for future file timestamps ... NOTE
  unable to verify current time

❯ checking R code for possible problems ... NOTE
  plot_cumulative_time_in_space: no visible binding for global variable
    ‘duration’
  plot_cumulative_time_in_space: no visible binding for global variable
    ‘duration_hours’
  plot_cumulative_time_in_space: no visible binding for global variable
    ‘cumulative_time’
  read_json_to_dataframe: no visible binding for global variable ‘eva’
  Undefined global functions or variables:
    cumulative_time duration duration_hours eva

0 errors ✔ | 0 warnings ✔ | 1 notes ✖
```

We’ll ignore this note for the time being. It results from the non-standard evaluation 
used in dplyr functions. You can find out more about it in the [Programming with dplyr vignette][programming-with-dplyr-vignette].


::: challenge

# Creating a Driver Script

1. Now that we've updated our functions to include the correct namespace 
   for dplyr functions, let's build and install the package again so that are
   functions are available for use.
   
2. Setup a run script that calls the functions in the package to run the analysis
   on the EVA data. The steps below will lead you through this process.
   
   a. Create a new folder `analysis` in the root of the compendium.
   b. Create the following sub-folders in the `analysis` folder to organise
      our scripts, data and results:
      
      + `scripts` - to store our analysis scripts
      + `data` - to store raw and processed data
      + `data/raw_data` - to store our raw data    
      + `data/derived_data` - to store the output of our analysis    
      + `figures` - to store any figures generated by our analysis
      + `tables` - to store any tables generated by our analysis
    
   c. Place the file `eva-data.json` in the `analysis/data/raw_data` folder.
   
   d. Create a new R script file in the `scripts` folder called `run_analysis.R`.
      Use the `run_analysis` function from `spacewalks1` and related code to run the analysis
      
      Hint: remember to update the input and output file locations in your code.
    
   d. One final piece of housekeeping we need to do is to edit the file .Rbuildignore 
      in the root of the compendium and add the following line to it:
      
      ```
      ^analysis$
      ```
      
      This will ensure that the analysis folder is not included in the package next time it is built. 
   
::: solution


1. Build and install the package

Run "Clean and Install" from the build panel.

```output
==> R CMD INSTALL --preclean --no-multiarch --with-keep.source spacewalks2

* installing to library ‘/Library/Frameworks/R.framework/Versions/4.3-arm64/Resources/library’
* installing *source* package ‘spacewalks2’ ...
** using staged installation
** R
** byte-compile and prepare package for lazy loading
** help
*** installing help indices
** building package indices
** testing if installed package can be loaded from temporary location
** testing if installed package can be loaded from final location
** testing if installed package keeps a record of temporary installation path
* DONE (spacewalks2)
``` 

2. Your `run_analysis.R` script should look like this:


```r
library(spacewalks)
library(dplyr)
library(readr)

run_analysis <- function(input_file, output_file, graph_file) {
  print("--START--\n")

  eva_data <- read_json_to_dataframe(input_file)
  write_csv(eva_data, output_file)
  plot_cumulative_time_in_space(eva_data, graph_file)

  print("--END--\n")
}


input_file <- 'analysis/data/raw_data/eva-data.json'
output_file <- 'analysis/data/derived_data/eva-data.csv'
graph_file <- 'analysis/figures/cumulative_eva_graph.png'
run_analysis(input_file, output_file, graph_file)

```

:::
:::


## Further reading

We recommend the following resources for some additional reading on the
topic of this episode:

+ [`rrtools` package documentation][rrtools-pkg-site]
+  [The Turing Way's "Guide for Reproducible Research – Research Compendia"][ttw-guide-compendia] 
+ [A list of resources about Research Compendia  by Daniel Nust, Ben Marwich and Carl Boettinger][research-compendium-science] 


Also check the [full reference set](learners/reference.md#litref) for
the course.

::: keypoints
-   Good practices for code and project structure are essential for
    creating readable, reusable and reproducible projects.
:::

## Attribution
This episode reuses material from pages [“Create a compendium”][rrr-with-rrtools-ak-compendium] and [“Manage functionality as a package“][rrr-with-rrtools-ak-package] from [“Reproducible Research in R with rrtools”][rrr-with-rrtools-ak] by Anna Krystalli under [CC-BY-4.0](https://creativecommons.org/licenses/by/4.0/) license with modifications. Sections covering git and github have been removed. Output has been modified to reflect the spacewalks case study project used in this course.  Some original material has been added to introduce the episode and to connect sections together where needed. This is indicated with a footnote [^1] e.g. Challenge “Create a Driver Script”.  The section ”Test function” is omitted and the Document function section has been cut-down as roxygen is covered elsewhere in this course.   
Questions, Objectives and Keypoints have been re-used from the “Code Structure” episod the Software Carpentries Incubator course [‘Tools and practices of FAIR research software”][fair-software-course-code-structure] under a [CC-BY-4.0](https://creativecommons.org/licenses/by/4.0/) licence with modifications: adaptations for  R code.  


[^1]: Original Material
