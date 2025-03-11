---
title: "Good Practices"
teaching: 60
exercises: 30
---

:::::::::::::::::::::::::::::::::::::: questions

- What good practices can to help us develop reproducible, reusable and computationally correct R code?

::::::::::::::::::::::::::::::::::::::::::::::::

::::::::::::::::::::::::::::::::::::: objectives
After completing this episode, participants should be able to:

- Identify some good practices the help us develop reproducible, reusable and computationally correct R code
- Explain how can these practices support reproducibility

::::::::::::::::::::::::::::::::::::::::::::::::

## Tools and good practices

There are various tools and practices that support the development of reproducible, reusable and computationally correct R code  In later episodes we will describe these tools and practices in more detail.


### Coding conventions

Following coding conventions and guides for your R code that are agreed upon by the community and other programmers
are important practices to ensure that others find it easy to read your code, reuse or extend it in their own examples and applications.

For R, some key resources include:

+ The [tidyverse style guide][tidyverse-style-guide], for consistent naming conventions, indentation, and code structure.     This guide  is especially useful if you're working with packages like ggplot2, dplyr, and tidyr.
+ [styler][stylr-package] - An R package that helps you automatically format your code according to a style guide.
+ [lintr][lintr-package] - An R package that checks your code for style issues and syntax errors.


### Project Structure (`rrtools` Research compendia)

A well-structured project is essential for ensuring that your R code is 
reproducible, maintainable, and easy to share when you are ready to do so. 

Using a research compendium  provides an organized directory structure that makes it easy to manage your R code, data, 
documentation, and results.

A typical R research compendium structure might look like this:

```
.
├── CONDUCT.md
├── CONTRIBUTING.md
├── DESCRIPTION
├── LICENSE
├── LICENSE.md
├── NAMESPACE
├── R
│   └── process-data.R
├── README.Rmd
├── README.md
├── analysis
│   ├── data
│   │   ├── DO-NOT-EDIT-ANY-FILES-IN-HERE-BY-HAND
│   │   ├── derived_data
│   │   └── raw_data
│   │       └── gillespie.csv
│   ├── figures
│   ├── paper
│   │   ├── elsarticle.cls
│   │   ├── mybibfile.bib
│   │   ├── numcompress.sty
│   │   ├── paper.Rmd
│   │   ├── paper.fff
│   │   ├── paper.pdf
│   │   ├── paper.spl
│   │   ├── paper.tex
│   │   ├── paper_files
│   │   │   └── figure-latex
│   │   │       └── figure1-1.pdf
│   │   └── refs.bib
│   └── templates
│       ├── journal-of-archaeological-science.csl
│       ├── template.Rmd
│       └── template.docx
├── inst
│   └── testdata
│       └── gillespie.csv
├── man
│   └── recode_system_size.Rd
├── rrcompendium.Rproj
└── tests
    ├── testthat
    │   └── test-process-data.R
    └── testthat.R
```
Reproduced from "Reproducible Research with rrtools" by Anna Krystalli, licensed under [CC BY 4.0](https://creativecommons.org/licenses/by/4.0/deed.en).

Using rrtools or similar packages helps you to automatically set up this structure, 
which makes it easier for others to navigate your project.

### Code testing (`testthat`)

Testing ensures that your code is correct and does what it is set out to do.
When you write code you often feel very confident that it is perfect, but when writing bigger codes or code that is meant to do complex operations
it is very hard to consider all possible edge cases or notice every single typing mistake.
Testing also gives other people confidence in your code as they can see an example of how it is meant to run and be assured that it does work
correctly on their machine - helping with code understanding and reusability.


### Code- and project- level documentation (`roxygen2`, `pkgdown`)

Documentation comes in many forms - from **code-level documentation** including descriptive names of variables and functions and
additional comments that explain lines of your code, to **project-level documentation** (including README, LICENCE, CITATION, etc. files)
that help explain the legal terms of reusing it, describe its functionality and how to install and run  it,
to whole websites full of documentation with function definitions, usage examples, tutorials and guides.
You many not need as much documentation as a large commercial software product, but making your code reusable relies on other people being able to understand what your code does and how to use it.

#### Code licensing

A licence is a legal document which sets down the terms under which the creator of work (such as written text,
photographs, films, music, software code) is releasing what they have created for others to use, modify, extend or exploit.
It is important to state the terms under which software can be reused - the lack of a licence for your code
implies that no one can reuse the software at all.

A common way to declare your copyright of a piece of software and the license you are distributing it under is to
include a file called **LICENSE** in the root directory of your code project folder / repository.

#### Code citation

We should add citation instructions to our project README or a **CITATION** file to our project to provide instructions on how and when to cite our code.
A citation file can be a plain text (CITATION.txt) or a Markdown file (CITATION.md), but there are certain benefits
to using use a special file format called the [Citation File Format (CFF)][cff], which provides a way to include richer
metadata about code (or datasets) we want to cite, making it easy for both humans and machines to use this information.


###  Managing dependencies (`renv`)

Managing dependencies is essential for ensuring that your R code runs consistently 
across different environments. renv is a powerful R package that helps you manage 
the libraries your project relies on, ensuring that the exact versions of packages 
are used when your project is shared or run in the future.


## Code and data used in this course

We are going to follow a fairly typical experience of a new PhD or postdoc joining a research group. 
They were emailed some data and analysis code bundled in a `.zip` archive and written by another group member 
who worked on similar things but has since left the group. 
They need to be able to install and run this code on their machine, check they can understand it and then adapt it to 
their own project.

As part of the [setup for this course](./index.html#astronaut-data-and-analysis-code), you should have downloaded a `.zip` archive containing the software project
the new research team member was given. 
Let's unzip this archive and inspect its content in R Studio. 
The software project contains:

(1) a JSON file (`data.json`) - a snippet of which is shown below - with data on extra-vehicular activities 
(EVAs or spacewalks) undertaken by astronauts and cosmonauts from 1965 to 2013 (data provided by NASA 
via its [Open Data Portal](https://data.nasa.gov/Raw-Data/Extra-vehicular-Activity-EVA-US-and-Russia/9kcy-zwvn/about_data)). The first few lines are:

```json
[{"eva": "1", "country": "USA", "crew": "Ed White;", "vehicle": "Gemini IV", "date": "1965-06-03T00:00:00.000", "duration": "0:36", "purpose": "First U.S. EVA. Used HHMU and took  photos.  Gas flow cooling of 25ft umbilical overwhelmed by vehicle ingress work and helmet fogged.  Lost overglove.  Jettisoned thermal gloves and helmet sun visor"}
,{"eva": "2", "country": "USA", "crew": "David Scott;", "vehicle": "Gemini VIII", "duration": "0:00", "purpose": "HHMU EVA cancelled before starting by stuck on vehicle thruster that ended mission early"}
,{"eva": "3", "country": "USA", "crew": "Eugene Cernan;", "vehicle": "Gemini IX-A", "date": "1966-06-05T00:00:00.000", "duration": "2:07", "purpose": "Inadequate restraints, stiff 25ft umbilical and high workloads exceeded suit vent loop cooling capacity and caused fogging.  Demo called off of tethered astronaut maneuvering unit"}
]
```

Let's have a closer look at one line of to understand the dataset a little better:

```json
[
...
{
  "eva": "13",
  "country": "USA",
  "crew": "Neil Armstrong;Buzz Aldrin;",
  "vehicle": "Apollo 11",
  "date": "1969-07-20T00:00:00.000",
  "duration": "2:32",
  "purpose": "First to walk on the moon.  Some trouble getting out small hatch.  46.3 lb of geologic material collected.  EASEP seismograph and laser reflector exp deployed.  Solar wind exp deployed & retrieved.  400 ft (120m) circuit on foot.  Dust issue post EVA"
}
...
]
```

(2) an R script (`my_code_v2.R`) containing some analysis. The first few lines are:
```r
# https://data.nasa.gov/resource/eva.json (with modifications)

# File paths
data_f <- "/home/sarah/Projects/ssi-ukrn-fair-course/data.json"
data_t <- "/home/sarah/Projects/ssi-ukrn-fair-course/data.csv"
g_file <- "myplot.png"

fieldnames <- c("eva", "country", "crew", "vehicle", "date", "duration", "purpose")

data <- list()
data_raw <- readLines(data_f, warn = FALSE)

# 374
library(jsonlite)
for (i in 1:374) {
  line <- data_raw[i]
  print(line)
  data[[i]] <- fromJSON(substr(line, 2, nchar(line)))
}

# Initialize empty vectors
time <- c()
dates <- c()
years <- c()

j <- 1
w <- 0
for (i in data) {  # Iterate manually

  if ("duration" %in% names(data[[j]])) {
    tt <- data[[j]]$duration

    if (tt == "") {
      # Do nothing if empty
    } else {
      t_parts <- strsplit(tt, ":")[[1]]
      ttt <- as.numeric(t_parts[1]) + as.numeric(t_parts[2]) / 60  # Convert to hours
      print(ttt)

...
```

The code in the R script does some common research tasks:

* Read in the data from the JSON file
* Change the data from one data format to another and save to a file in the new format (CSV)
* Make a plot to visualise the data

Let's have a critical look at this code and think about how easy it is to reproduce the outputs of this project.

::::::::::::::::::::::::::::::::::::: discussion

### Barriers to Reproducibility [^1]

Look at the code in RStudio: 

a. Can you rerun the code in R? 

(Hint: what changes do you need to make to get the code to run?)

b. Are the results of the analysis repeatable?
c. Are there any barriers that would 
prevent the results generated by the code from being reproduced by someone else in the future?

::::::::::::::::::::::::::::::::::::::::::::::::

::::::::::::::::::::::::::::::::::::: hint


Here are some questions to help you identify barriers to reproducibilty in the code:

- Code readability - Is the code easy to understand?  Are there clear comments explaining what each part of the code does?
- Reusability - Can you easily modify the code to run on different data or compute a different result?
- Environment & dependencies - Does the code specify what tools or packages (e.g., R libraries, specific versions) need to be installed to run it? Is it clear which version of the code was used in the analysis?

::::::::::::::::::::::::::::::::::::::::::::::::

:::  solution

a. The code fails with errors because the file paths to the input and output data are specific to the
author's computer and not available on our computers:

```error
Error in file(con, "r") : cannot open the connection
In addition: Warning message:
In file(con, "r") :
  cannot open file '/home/sarah/Projects/ssi-ukrn-fair-course/data.json': No such file or directory
```

You need to change the data input/ output file paths to get the code to run:
```
data_f <- "data.json"
data_t <- "data.csv"
```

b . The results of the analysis are not repeatable because the code produces different output 
    depending on whether it is run for the first time in our RStudio session or not.

    In the RStudio menus, select Session > Restart R and run the code once using "Source with Echo":
    ```output
    > print(ct[length(ct)])
    [1] 1840.2

    ```
    
    Now run the code again:
    ```output
    > print(ct[length(ct)])
    [1] 1951.2
    ```
    
    Notice how `ct` is incorrectly reset to `c(111)` here:
    ```r
    ggplot(tdf, aes(x = years, y = ct)) + geom_line(color = "black") + geom_point(color = "black") + 
        labs( x = "Year", y = "Total time spent in space to date (hours)", title = "Cumulative Spacewalk Time" ) + 
        + theme_minimal() ; ct <- c(111)

    ```
    Let's correct this as follows:
    ```r
    ggplot(tdf, aes(x = years, y = ct)) + geom_line(color = "black") + geom_point(color = "black") + 
        labs( x = "Year", y = "Total time spent in space to date (hours)", title = "Cumulative Spacewalk Time" ) + 
        + theme_minimal() 
    
    ct <- c(0)

    ```
    The code should now be repeatable.

b. Barriers to reproducibility include:
   - The code lacks clear comments, and the variable names and file names are not descriptive.
     It is hard to determine the purpose of the code or how it works. This may hinder 
     another researcher's ability to get the code running.
   - The code does not explicitly specify what third party packages need to be installed to
     run the code. There are library() statements in the code but these are positioned through
     out the code and not in a single place where they can be easily identified. We don't know 
     which version of the packages were used in the analysis.
   - It is really difficult to understand what the code does and how it does it. 
     This makes it hard to modify the code to run on different dataset or plot another facet of the data.

::::::::::::::::::::::::::::::::::::::::::::::::

## Further reading

We recommend the following resources for some additional reading on the topic of this episode:

- [Primer on Reproducible Research in R: Enhancing Transparency and Scientific Rigor.][ rrr-primer] Siraji MA, Rahman M. Clocks Sleep. 2023 Dec 20;6(1):1-10. doi: 10.3390/clockssleep6010001. PMID: 38534796; PMCID: PMC10969410.
- [Reproducible Research in R: A Tutorial on How to Do the Same Thing More Than Once.] [rrr-intro] Peikert, A., van Lissa, C. J., & Brandmaier, A. M. (2021) Psych, 3(4), 836-867. https://doi.org/10.3390/psych3040053


Also check the [full reference set](learners/reference.md#litref) for the course.

:::::::::::::::::::::::::::::::::::::::: keypoints
- Coding conventions ensure your R code is easy to read, reuse, and extend.
- Research compendia provide an organized directory for your code, data, documentation, and results.
- Testing helps you check that your code is behaving as expected and will continue to do so in the future or when used by someone else.
- Documentation is essential for explaining what your code does, how to use it, and the legal terms for reuse. 
- Dependency management helps making your code reproducible across different computational environments.
::::::::::::::::::::::::::::::::::::::::::::::::::

## Attribution
This episode is a remix of  episodes [“FAIR research software”][fair-software-course-fair] (Section: Software and data used in this course) and [“Tools and Practices for FAIR research software development”][fair-software-course-tools] from  the Software Carpentries Incubator course ["Tools and practices of FAIR research software”][fair-software-course]] under a [CC-BY-4.0](https://creativecommons.org/licenses/by/4.0/deed.en) licence with modifications. 

The material has been edited to target a audience of R users and to focus on reproducibility, correctness and reuse as end goals rather than FAIR (findability, accessibility, interoperability and reusability) . Consequently, several tools considered in the original course  e.g. persistent identifiers have been omitted.  The section  Code and data used in this course has been adapted to reflect the R version of the spacewalks repository used in this course. 

Objectives, Questions, Key Points and Further Reading sections have been updated to reflect the remixed R focussed content. Some original material has been added – this is marked with a footnote [^1].

[^1]: Original material.
