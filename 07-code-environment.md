---
title: Reproducible development environment
teaching: 30
exercises: 0
---

:::::::::::::::::::::::::::::::::::::: questions

- How can we manage R dependencies in our analysis projects?

::::::::::::::::::::::::::::::::::::::::::::::::

::::::::::::::::::::::::::::::::::::: objectives

After completing this episode, participants should be able to:

- Set up a local package library for an R project using `renv`.

::::::::::::::::::::::::::::::::::::::::::::::::

::: instructor

At this point, the code in your local software project's directory should be as in:
TODO

:::

## Our code has dependencies [^1]

Now that we've finished developing out project, let's take a look back at our code.

If we have a look at `analysis/scripts.R`, we can see a number of library() calls at the top of the file:
```r
library(spacewalks2)
library(dplyr)
etc.
```

Similarly, if we have a look at our script `R/eva_data_analysis.R`, we can see a number of 
functions from external packages being used including `dplyr::mutate` and `ggplot2::ggplot`:

```r
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
```

This means that our code requires several **external libraries** (also called third-party packages or dependencies) -
`jsonlite`, `readr`, `dplyr`, `stringr`, `tidyr` etc.

## Managing dependencies [^2]

One of the most important aspects of reproducible research is managing dependencies.

For your analysis to run, it interacts with:

- **Operating system:** The operating system of your computer.

- **System configurations**: such as locations of libraries and the search path your computer uses to find files and libraries

- **System Level libraries**. These are non-R libraries that R or packages in R you might be using depend on. (for example libraries such as `GEOS`, `GDAL` and `PROJ4` that geospatial R packages like `sf` and `rgeos` depend on). Such external dependencies to R are listed as `System Requirements` in R package `DESCRIPTION` files (e.g have a look at the [relevant line](https://github.com/r-spatial/sf/blob/adf7410a5c55695b4c8db97a5258ec87c931320a/DESCRIPTION#L110) in the `sf` package `DESCRIPTION`.


- **R and the R packages your analysis depends on**. For example, the version of R we've been using as well as packages `ggplot2` and `dplyr`.

When someone else tries to reproduce your analysis on a different computer, if any of these elements differ from what existed on your own system when you last ran your analysis, e.g some of the dependencies are missing, different versions are available or code behaves differently on a different operating system, they may not be able to reproduce your work.

::: callout
It is essential to document the specific package versions used in a project and to offer a way for others to install those exact versions on their own machines. The renv package addresses both of these needs effectively.
:::

## Managing R dependencies with `renv` [^2]

The `renv` package is a recent effort to bring project-local R dependency
management to R projects.

Underlying the philosophy of `renv` is that any of your existing workflows
should just work as they did before -- `renv` helps manage library paths (and
other project-specific state) to help isolate your project's R dependencies.

### `renv` Workflow

The general workflow when working with `renv` is:

1. Call `renv::init()` to initialize a new project-local environment with a
   **private R library**,

2. Work in the project as normal, installing and removing new R packages as
   they are needed in the project,

3. Call `renv::snapshot()` to save the state of the project library to the
   lockfile (called `renv.lock`),

4. Continue working on your project, installing and updating R packages as
   needed.

5. Call `renv::snapshot()` again to save the state of your project library if
   your attempts to update R packages were successful, or call `renv::restore()`
   to revert to the previous state as encoded in the lockfile if your attempts
   to update packages introduced some new problems.

The `renv::init()` function attempts to ensure the newly-created project
library includes all R packages currently used by the project. It does this
by crawling R files within the project for dependencies with the
`renv::dependencies()` function. The discovered packages are then installed
into the project library with the `renv::hydrate()` function, which will also
attempt to save time by copying packages from your user library (rather than
re-installing from CRAN) as appropriate.

Calling `renv::init()` will also write out the infrastructure necessary to
automatically load and use the private library for new R sessions launched
from the project root directory. This is accomplished by creating (or amending)
a project-local `.Rprofile` with the necessary code to load the project when
the R session is started.

The following files are written to and used by projects using `renv`:

| **File**          | **Usage**                                                                           |
| ----------------- | ----------------------------------------------------------------------------------- |
| `.Rprofile`       | Used to activate `renv` for new R sessions launched in the project.                 |
| `renv.lock`       | The lockfile, describing the state of your project's library at some point in time. |
| `renv/activate.R` | The activation script run by the project `.Rprofile`.                               |
| `renv/library`    | The private project library.                                                        |


### Reproducibility with `renv`

Using `renv`, it's possible to "save" and "load" the state of your project
library. More specifically, you can use:

- `renv::snapshot()` to save the state of your project to `renv.lock`; and
- `renv::restore()` to restore the state of your project from `renv.lock`.

For each package used in your project, `renv` will record the package version,
and (if known) the external source from which that package can be retrieved.
`renv::restore()` uses that information to retrieve and re-install those
packages in your project.

:::::::::::::::::::::::::::::::::::::::::: callout

### Beyond the DESCRIPTION file [^3]

So far we have been using the `DESCRIPTION` file to record the dependencies of our research compendium. 
This file contains a list of all of the direct dependencies of our research compendium. 
If we were to share our research compendium with someone else, they could install these dependencies by running
devtools_install().

However, this approach has some limitations:

+ We've had to manually track the dependencies of our analysis scripts and their versions.
+ By default devtools_install() will install the dependencies into the users global R library, not into a project-specific library.
  This makes it challenging to work with multiple research compendia that may require different versions of the same package
+ `DESCRIPTION` file only records the direct dependencies of our code - not the transitive dependencies (the dependencies of
our dependencies) .

renv helps to ensure that our R project can be reproduced by:

+ providing tools to automatically identify the dependencies of our compendium.
+ logging the exact versions of our both direct AND transitive dependencies.


::::::::::::::::::::::::::::::::::::::::::::::::::

### Using `renv` in our `spacewalks` project

Let's go back into our `spacewalks` compendium and capture our dependencies into a project level R package library. 

First, let's configure the install location that renv will use to `renv/library` using a .REnviron file.

```txt
# .REnviron
RENV_PATHS_LIBRARY = renv/library
```   

Then, we can initialise `renv`


```r
renv::init()
```

```output
> renv::init()
This project contains a DESCRIPTION file.
Which files should renv use for dependency discovery in this project? 

1: Use only the DESCRIPTION file. (explicit mode)
2: Use all files in this project. (implicit mode)

Selection: 2

```
We are presented with two options for automatic discover of our compendium's 
dependencies. "explicit mode" uses only the DESCRIPTION file, while "implicit mode"
scans all the files in our project for dependencies.

We are Choose "2" to use all files in the project for dependency discovery.

```output

- Using 'implicit' snapshot type. Please see `?renv::snapshot` for more details.

- Linking packages into the project library ... Done!
- Resolving missing dependencies ... 
# Installing packages --------------------------------------------------------
- Installing magrittr ...                       OK [linked from cache]
- Installing dplyr ...                          OK [linked from cache]
- Installing ggplot2 ...                        OK [linked from cache]
- Installing here ...                           OK [linked from cache]
- Installing jsonlite ...                       OK [linked from cache]
- Installing xfun ...                           OK [linked from cache]
- Installing highr ...                          OK [linked from cache]
- Installing knitr ...                          OK [linked from cache]
- Installing purrr ...                          OK [linked from cache]
- Installing readr ...                          OK [linked from cache]
- Installing rmarkdown ...                      OK [linked from cache]
- Installing stringr ...                        OK [linked from cache]
- Installing evaluate ...                       OK [linked from cache]
- Installing withr ...                          OK [linked from cache]
- Installing waldo ...                          OK [linked from cache]
- Installing testthat ...                       OK [linked from cache]
- Installing tidyr ...                          OK [linked from cache]
- Installing roxygen2 ...                       OK [linked from cache]
- Installing devtools ...                       OK [linked from cache]
The following package(s) will be updated in the lockfile:

# CRAN -----------------------------------------------------------------------
- askpass        [* -> 1.2.0]
- base64enc      [* -> 0.1-3]
- bit            [* -> 4.0.5]
- bit64          [* -> 4.0.5]
- brew           [* -> 1.0-10]
- brio           [* -> 1.1.4]
- bslib          [* -> 0.7.0]
- cachem         [* -> 1.0.8]
- callr          [* -> 3.7.6]
- cli            [* -> 3.6.2]
- clipr          [* -> 0.8.0]
- colorspace     [* -> 2.1-0]
- commonmark     [* -> 1.9.1]
- conflicted     [* -> 1.2.0]
- cpp11          [* -> 0.4.7]
- crayon         [* -> 1.5.2]
- credentials    [* -> 2.0.1]
- desc           [* -> 1.4.3]
- devtools       [* -> 2.4.5]
- diffobj        [* -> 0.3.5]
- digest         [* -> 0.6.35]
- downlit        [* -> 0.4.3]
- dplyr          [* -> 1.1.4]
- ellipsis       [* -> 0.3.2]
- evaluate       [* -> 1.0.3]
- fansi          [* -> 1.0.6]
- farver         [* -> 2.1.1]
- fastmap        [* -> 1.1.1]
- fontawesome    [* -> 0.5.2]
- fs             [* -> 1.6.3]
- generics       [* -> 0.1.3]
- gert           [* -> 2.0.1]
- ggplot2        [* -> 3.5.1]
- gh             [* -> 1.4.1]
- git2r          [* -> 0.35.0]
- gitcreds       [* -> 0.1.2]
- glue           [* -> 1.7.0]
- gtable         [* -> 0.3.4]
- here           [* -> 1.0.1]
- highr          [* -> 0.11]
- hms            [* -> 1.1.3]
- htmltools      [* -> 0.5.8.1]
- htmlwidgets    [* -> 1.6.4]
- httpuv         [* -> 1.6.15]
- httr           [* -> 1.4.7]
- httr2          [* -> 1.0.1]
- ini            [* -> 0.3.1]
- isoband        [* -> 0.2.7]
- jquerylib      [* -> 0.1.4]
- jsonlite       [* -> 1.9.0]
- knitr          [* -> 1.49]
- labeling       [* -> 0.4.3]
- later          [* -> 1.3.2]
- lattice        [* -> 0.22-5]
- lifecycle      [* -> 1.0.4]
- magrittr       [* -> 2.0.3]
- MASS           [* -> 7.3-60.0.1]
- Matrix         [* -> 1.6-5]
- memoise        [* -> 2.0.1]
- mgcv           [* -> 1.9-1]
- mime           [* -> 0.12]
- miniUI         [* -> 0.1.1.1]
- munsell        [* -> 0.5.1]
- nlme           [* -> 3.1-164]
- pillar         [* -> 1.9.0]
- pkgbuild       [* -> 1.4.4]
- pkgconfig      [* -> 2.0.3]
- pkgdown        [* -> 2.0.7]
- pkgload        [* -> 1.3.4]
- praise         [* -> 1.0.0]
- prettyunits    [* -> 1.2.0]
- processx       [* -> 3.8.4]
- profvis        [* -> 0.3.8]
- progress       [* -> 1.2.3]
- promises       [* -> 1.2.1]
- ps             [* -> 1.7.6]
- purrr          [* -> 1.0.4]
- R6             [* -> 2.5.1]
- rappdirs       [* -> 0.3.3]
- rcmdcheck      [* -> 1.4.0]
- RColorBrewer   [* -> 1.1-3]
- Rcpp           [* -> 1.0.12]
- readr          [* -> 2.1.5]
- remotes        [* -> 2.5.0]
- renv           [* -> 1.0.5]
- rlang          [* -> 1.1.3]
- rmarkdown      [* -> 2.29]
- roxygen2       [* -> 7.3.2]
- rprojroot      [* -> 2.0.4]
- rstudioapi     [* -> 0.16.0]
- rversions      [* -> 2.1.2]
- sass           [* -> 0.4.9]
- scales         [* -> 1.3.0]
- sessioninfo    [* -> 1.2.2]
- shiny          [* -> 1.8.1.1]
- sourcetools    [* -> 0.1.7-1]
- stringi        [* -> 1.8.3]
- stringr        [* -> 1.5.1]
- sys            [* -> 3.4.2]
- testthat       [* -> 3.2.3]
- tibble         [* -> 3.2.1]
- tidyr          [* -> 1.3.1]
- tidyselect     [* -> 1.2.1]
- tinytex        [* -> 0.50]
- tzdb           [* -> 0.4.0]
- urlchecker     [* -> 1.0.1]
- usethis        [* -> 2.2.3]
- utf8           [* -> 1.2.4]
- vctrs          [* -> 0.6.5]
- viridisLite    [* -> 0.4.2]
- vroom          [* -> 1.6.5]
- waldo          [* -> 0.6.1]
- whisker        [* -> 0.4.1]
- withr          [* -> 3.0.2]
- xfun           [* -> 0.51]
- xopen          [* -> 1.0.1]
- xtable         [* -> 1.8-4]
- yaml           [* -> 2.3.8]
- zip            [* -> 2.3.1]

# https://carpentries.r-universe.dev -----------------------------------------
- curl           [* -> 5.2.1]
- openssl        [* -> 2.1.1]
- ragg           [* -> 1.3.0]
- systemfonts    [* -> 1.0.6]
- textshaping    [* -> 0.3.7]
- xml2           [* -> 1.3.6]

The version of R recorded in the lockfile will be updated:
- R              [* -> 4.3.3]

- Lockfile written to "~/projects/uob/astronaut-data-analysis-fair-r/spacewalks/renv.lock".

Restarting R session...

- Project '~/projects/uob/astronaut-data-analysis-fair-r/spacewalks' loaded. [renv 1.0.5]
```

Alongside our existing content, our compendium now also contains the infrastructure that powers `renv` dependency management:
```
.
├── .Rprofile
├── renv
│   ├── .gitignore
│   ├── activate.R
│   ├── settings.json
│   └── library
│       └── R-4.3
└── renv.lock
```

The `renv.lock` contains a list of names and versions of packages used in our project. 

The folder `renv/library/R-4.3` contains the project specific library of installed packages for the R version the analysis is currently being performed on. This is never shared with recipients of our compendium. Rather, we share the rest of the files (`renv.lock` file, the `.Rprofile` file and the `renv/activate.R`). Making these available means others users of your code will have the appropriate packages installed in their own local library when the download and use your code.

Once we have run `renv::init()`, we should run renv::status() to check the status of our project library.


```r
renv::status()
```

```{.output}
No issues found -- the project is in a consistent state.
```

```output
No issues found -- the project is in a consistent state.
```
## Restoring an Environment [^4]

Anyone who wants to install the same packages that we use with their exact versions can download our code, open the compendium and use `renv::restore()`.

This will install everything in their local project library so they can be up an running in no time.


::: challenge
Restore an environment [^4]

1. Download this [reproducible project](https://reproducibility.rocks/reproducible_project.zip). 

1. (Due to a recent issue with RStudio, you might need to press Enter before continuing). 

2. Open the project and run `renv::status()` in the R console. What's the status of the packages?

3. Run `renv::restore()` in the R console and proceed. 

4. Run `renv::status()` again to check that the project is in a consistent state. 

3. Render `analysis/report.Rmd` to make sure that it worked.

:::

## Updating an Environment 

If we continue working on our project and add some new functionality that
uses a new dependency we will need to update out DESCRIPTION file,
our renv.lock file and our project library renv/library.

Let's add a new function to R/eva_data_analysis.R that tabulates crew sizes
in our spacewalks data.

```r
generate_summary_table <- function(data, column_name, output_file) {

  # Check if the column exists in the data
  if (!(column_name %in% colnames(data))) {
    stop("Column not found in the data frame")
  }

  # Create summary statistics table using gtsummary
  summary_table <- data |>
    select(all_of(column_name)) |>
    gtsummary::tbl_summary()

  # Save the summary table to the specified output file
  gtsummary::as_gt(summary_table) |>
    gt::gtsave(output_file)

  cat("Summary table saved to", output_file, "\n")
}
```

This uses the tabulate package `gtsummary`. 

Let's add the new function to `R/eva_data_analysis.R` and add the following lines 
to analysis/scripts/run_analysis.R to call the function and save the result:
   
```r
generate_summary_table(eva_data, "crew_size", "summary_table.html")
```

::: checklist

Remember to "Clean and Install" (Build panel) to make sure that our changes have been installed.

:::

   
When we run `analysis/scripts/run_analysis.R` we see an error because `gtsummary`
is not installed in out local project library.

```error
- The project is out-of-sync -- use `renv::status()` for details.
[conflicted] Will prefer dplyr::filter over any other package.
[conflicted] Will prefer dplyr::lag over any other package.
Error in library(package, pos = pos, lib.loc = lib.loc, character.only = TRUE,  : 
  there is no package called ‘spacewalks’
Calls: library -> library
Execution halted
```

```output
```
Before we install gtsummary let's run `renv::status()` to check the status of our current project dependencies.

```r
renv::status()
```

```output
No issues found -- the project is in a consistent state.
```

Now let's install out missing dependency in the console and rerun `analysis/scripts/run_analysis.R`  to check that everything is running correctly.

```r
> install.packages("gtsummary")
```

```output
# Downloading packages -------------------------------------------------------
- Downloading gtsummary from CRAN ...           OK [1.6 Mb in 1.5s]
- Downloading cards from CRAN ...               OK [523.8 Kb in 1.3s]
- Downloading gt from CRAN ...                  OK [5.7 Mb in 1.8s]
- Downloading bigD from CRAN ...                OK [1.1 Mb in 1.3s]
- Downloading bitops from CRAN ...              OK [24.8 Kb in 0.81s]
- Downloading juicyjuice from CRAN ...          OK [1.1 Mb in 1.3s]
- Downloading V8 from CRAN ...                  OK [8.4 Mb in 2.2s]
- Downloading markdown from CRAN ...            OK [142.2 Kb in 0.82s]
- Downloading reactable from CRAN ...           OK [1 Mb in 1.0s]
- Downloading reactR from CRAN ...              OK [594.8 Kb in 0.89s]
Successfully downloaded 10 packages in 17 seconds.

The following package(s) will be installed:
- bigD       [0.3.0]
- bitops     [1.0-9]
- cards      [0.5.0]
- gt         [0.11.1]
- gtsummary  [2.1.0]
- juicyjuice [0.1.0]
- markdown   [1.13]
- reactable  [0.4.4]
- reactR     [0.6.1]
- V8         [6.0.1]
These packages will be installed into "~/projects/uob/astronaut-data-analysis-fair-r/spacewalks/renv/library/R-4.3/aarch64-apple-darwin20".
Would you like to proceed? [Y/n]: Y
```

```output
# Installing packages --------------------------------------------------------
- Installing cards ...                          OK [installed binary and cached in 0.29s]
- Installing bigD ...                           OK [installed binary and cached in 0.29s]
- Installing bitops ...                         OK [installed binary and cached in 0.23s]
- Installing V8 ...                             OK [installed binary and cached in 0.5s]
- Installing juicyjuice ...                     OK [installed binary and cached in 0.28s]
- Installing markdown ...                       OK [installed binary and cached in 0.31s]
- Installing reactR ...                         OK [installed binary and cached in 0.32s]
- Installing reactable ...                      OK [installed binary and cached in 0.29s]
- Installing gt ...                             OK [installed binary and cached in 0.32s]
- Installing gtsummary ...                      OK [installed binary and cached in 0.28s]
Successfully installed 10 packages in 3.5 seconds.
```

Now let's run renv::status() in the console:
```r
> renv::status()
```
The following package(s) are in an inconsistent state:

 package    installed recorded used
 bigD       y         n        y   
 bitops     y         n        y   
 cards      y         n        y   
 gt         y         n        y   
 gtsummary  y         n        y   
 juicyjuice y         n        y   
 markdown   y         n        y   
 reactable  y         n        y   
 reactR     y         n        y   
 V8         y         n        y   

See ?renv::status() for advice on resolving these issues.

```

Now let's run renv::snapshot() in the console.
```r
renv::snapshot()
```

```output
The following package(s) will be updated in the lockfile:

# CRAN ----------------------------------------------------------------------
- bigD         [* -> 0.3.0]
- bitops       [* -> 1.0-9]
- cards        [* -> 0.5.0]
- gt           [* -> 0.11.1]
- gtsummary    [* -> 2.1.0]
- juicyjuice   [* -> 0.1.0]
- markdown     [* -> 1.13]
- reactable    [* -> 0.4.4]
- reactR       [* -> 0.6.1]
- V8           [* -> 6.0.1]

Do you want to proceed? [Y/n]: Y
```

```output
- Lockfile written to "~/projects/uob/astronaut-data-analysis-fair-r/spacewalks/renv.lock".
```
Finally, let's run renv::status() in the console:

```r
renv::status()
```

```output
No issues found -- the project is in a consistent state.
```


## Caveats [^4]

### The lockfile

The lockfile holds a snapshot of the project library at a moment in time, but it doesn't guarantee that this corresponds to the rendered result.
The lockfile could be out of date when the code is run, or the code might have been run with a previous version of the lockfile.
It's up to you to always render your file when the project is in a consistent state.

### Dependency discovery

The automatic dependency discovery is really cool, but somewhat limited.
It understand the most common and obvious ways a package can be loaded in a script, but it can fail if you use some more indirect methods.
As we saw, it fails to detect the markdown dependency.
It also fails if you use functionality in a package that depends on Suggested packages (e.g. `ggplot2::geom_hex()` requires the hexbin package, so you need to add an explicit `library(hexbin)` somewhere in your project).

### Package installation

Sometimes package installation fails.
One common case would be if you installed a CRAN-compiled package in Windows but the person trying to `restore()` the environment is running Linux.
Since CRAN doesn't offer compiled packages for Linux, renv will try to install from source, which can fail if compilation requires missing system dependencies.
There's nothing renv can do in this case, but the problem can be resolved by installing the relevant system dependencies.

Package installation will fail if the remote repository that hosts a package is unreachable either due to local connection issues or it being down, or deleted.
Again, there's nothing renv can do in that situation.

Package installation can fail if the package requires compilation but the machine doesn't have enough RAM to compile.
This is the case with the sf package, which cannot be compiled in the free-tier RStudio Cloud machine.

### System dependencies

Furthermore, some R packages require certain system dependences to be installed to run.
renv does not handle these cases yet, so if you are using a package that needs system dependencies, installation could fail if these are not met.
Even if installation goes well, a package might not work if it has unmet runtime dependencies.

Even in the case in which system dependencies are fulfilled, renv offers no guarantee that these are the same versions used to run the analysis.
This means that if results depend on the version of some system dependency, renv will not be able to ensure reproducibility.
This includes the version of R itself!

## Further reading

We recommend the following resources for some additional reading on the topic of this episode:

- [renv package official documentation][renv_man]

Also check the [full reference set](learners/reference.md#litref) for the course.

:::::: keypoints
- renv environments keep different R package versions and dependencies required by different projects separate.
- An renv environment is essentially a project-specific directory structure that isolates the packages and their versions used within that project/compendium.
- You can use renv to create and manage R project environments, and use renv::restore() to install and manage external (third-party) libraries (packages) in your project.
- By convention, you can save and export your R environment in a set of files (renv.lock), located in your project's root directory. This file can then be shared with collaborators/users and used to replicate your environment elsewhere using renv::restore().
::::::

## Attribution

This episode reuses material from the [“Reproducible Development Environment”][fair-software-course-correctn] episode of the Software Carpentries Incubator course ["Tools and practices of FAIR research software”][fair-software-course] under a [CC-BY-4.0](https://creativecommons.org/licenses/by/4.0/deed.en) with modifications
(i) adaptations  have been made to make the material suitable for an audience of  R users (e.g. replacing “software” with “code” in places, pytest with testthat), (ii) all code has been ported from Python to  R  (iii) Objectives, Questions, Key Points and Further Reading sections have been updated to reflect the remixed R focussed content. 
 

[^1]: Material re-used from  [“Reproducible Development Environment”](https://carpentries-incubator.github.io/fair-research-software/05-code-environment.html) under [CC-BY-4.0](https://creativecommons.org/licenses/by/4.0/deed.en) with modifications detailed above.  
[^2]: Reused from [Managing Dependences](https://annakrystalli.me/rrresearchACCE20/managing-dependencies.htm) in course ["Reproducible Research Data and Project Management in R"](https://annakrystalli.me/rrresearchACCE20/) by Anna Krystalli under [CC-BY-4.0](https://creativecommons.org/licenses/by/4.0/deed.en) with modifications to update R output for our case-study.
[^3]: Original material.
[^4]: Re-used from  the lesson [“Managing R dependencies with renv
”](https://reproducibility.rocks/materials/day3/01-renv/) under [CC-BY-4.0](https://creativecommons.org/licenses/by/4.0/legalcode) from [“An R reproducibility toolkit for the practical researcher”][repro-rocks] by Elio Campitelli and Paola Corrales. 
