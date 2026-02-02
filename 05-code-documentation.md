---
title: Code documentation
teaching: 60
exercises: 30
editor_options: 
  markdown: 
    wrap: 72
---

::: questions
-   How should we document our R code?
-   Why is documentation important?
-   What are the minimum elements of documentation needed to support
    reproducible research?
:::

::: objectives
After completing this episode, participants should be able to:

-   Use a `README` file to provide an overview of an R project including
    citation instructions
-   Describe the main types of code documentation (tutorials, how to
    guides, reference and explanation).
-   Describe the different formats available for delivering code
    documentation (Markdown files, static webpages).
-   [Supplementary Material] Use `pkgdown` to generate and manage
    comprehensive project documentation
-   [Supplementary Material] Apply a documentation framework to write
    effective documentation of any type.
:::

We have seen how writing inline comments and roxygen2 function-level
documentation within our code can help with improving its readability.
The purpose of profect-level code documentation is to communicate other
important information about our analysis (its purpose, dependencies, how
to install and run it, etc.) to the people who need it – both users and
developers.

::: instructor
At this point, the code in your local software project's directory
should be as in: TODO
:::

## Why document our code?

Code documentation is often perceived as a thankless and time-consuming
task with few tangible benefits and is often neglected in research
projects. However, like testing, documenting our code can help ourselves
and others conduct **better research** and produce **reproducible
research**:

-   Good documentation captures important methodological details ready
    for when we come to publish our research
-   Good documentation can help us return to a project seamlessly after
    time away
-   Documentation can facilitate collaborations by helping us onboard
    new project members quickly and more easily
-   Good documentation can save us time by answering frequently asked
    questions (FAQs) about our code for us
-   Code documentation improves the re-usability of our code.
    -   Good documentation can make our code more understandable and
        reusable by others, and can bring us some citations and credit
    -   How-to guides and tutorials ensure that users can install our
        code independently and make use of its basic features
    -   Reference guides and background information can help developers
        understand our code sufficiently to modify/extend/repurpose it.

## Project-level documentation

In previous episodes we encountered several different forms of in-code
documentation aspects, including in-line comments and roxygen2
function-level documentation These are an excellent way to improve the
readability of our code, but by themselves are insufficient to ensure
that our code is easy to use, understand and modify - this requires
additional project-level documentation.

Project-level documentation includes various information and metadata
about our code such as the legal terms of reusing it, describe its
functionality on a high level and how to install, run and contribute to
it.

There are many different types of project-level documentation including.

### Technical documentation

Project-level technical documentation encompasses:

-   Tutorials - lessons that guide learners through a series of
    exercises to build proficiency as using the code\
-   How-To Guides - step by step instructions on how to accomplish
    specific goals using the code.
-   Reference - a lookup manual to help users find relevant information
    about the software e.g. functions and their parameters.
-   Explanation - conceptual discussion of the code to help users
    understand implementation decisions

### Project metadata files

A common way to to provide project-level documentation is to include
various metadata files in the software repository together with code.
Many of these files can be described as "social documentation", i.e.
they indicate how users should “behave” in relation to our project. Some
common examples of repository metadata files and their role are
explained below:

| File | Description |
|-------------|-----------------------------------------------------------|
| README | Provides an overview of the project, including installation, usage instructions, dependencies and links to other metadata files and technical documentation (tutorial/how-to/explanation/reference) |
| CONTRIBUTING | Explains to developers how to contribute code to the project including processes and standards that should be followed |
| CODE_OF_CONDUCT | Defines expected standards of conduct when engaging in a software project |
| LICENSE | Defines the (legal) terms of using, modifying and distributing the code |
| CITATION | Provides instructions on how to cite the code |
| AUTHORS | Provides information on who authored the code (can also be included in CITATION) |

::: callout
### Just enough documentation

For many small projects the following three pieces of project-level
documentation may be sufficient: README, LICENSE and CITATION.
:::

Let’s look at each of these files in turn.

### README file

A README file is the first piece of documentation users are likely to
read and should provide sufficient information for users to and
developers to get started using your code.

Let's create a simple README for our repository:

``` r
rrtools::use_readme_qmd()
```

The README created by rrtools provides a good template. Lets look at its
sections.

## README sections

The README.qmd provided by rrtools is a Quarto file which generates
README.md. If you want to make changes to this file, please do not edit
README.md directly.

### CITATION information

We should add a citation instructions to our README to provide
instructions on how to cite our code. This encourages users to credit us
when they make use of our code:

``` r
### How to cite

Please cite this compendium as:

> Kopec-Harding et al, (2026). _Compendium of R code and data for an analyis of NASA extravehicular data. Accessed 02 Feb 2026. Online at <https://doi.org/xxx/xxx>
```

In this example, we assume that the code of the R Compendium will be
shared online via repository such as Zenodo (see ["Archiving code to
Zenodo and obtaining a
DOI"](%22https://carpentries-incubator.github.io/fair-research-software/10-open-collaboration.html#archiving-code-to-zenodo-and-obtaining-a-doi%22).

::: callout
### CITATION.cff

We can include citation information in our README file, but there are
certain benefits to using a a special file format called the [Citation
File Format (CFF)][cff], which provides a way to include richer metadata
about code (or datasets) we want to cite, making it easy for both humans
and machines to use this information.

Further information is available from the [Turing Way's guide to
software citation][turing-way-citation].
:::

### Contents section

The Contents section generated by `rrtools` follows a compendium structure, 
so you will need to modify this section to outline where your analysis and
function code lives now that we have adapted the structure to what is expected
for an R package.

:::: challenge
### Change the contents section to match your directory structure

Now that you have structured this as an R package, there are certain expected
locations for package functionality and documentation. Modify the README to 
match the folder structure you've created. A useful reference is this section of
Hadley Wickham's R package development [book](https://r-pkgs.org/code.html).

::: solution
- `R/` contains the functions that are part of this package
- `eva_data_analysis.R` is the script which contains all of the sourced functions
that are part of this R package.
- `man/` contains function reference documentation for each function in the
package
- `run_script.R` outlines an example use case of how you might use the
package functions
- `DESCRIPTION` defines the package name, version, authors, and dependencies on
other R packages.
:::
::::

### How to run in your browser or download and run locally

This section should be replaced by installation instructions for an R package.

:::: challenge
### Alternative ways to generate a README

For an R package, it might be more helpful to use the helper function built into
the `usethis` package called `use_readme_md()` Use this function instead to generate
a README and modify the `Installation` instructions to tell users how to install
your package.

::: solution

`usethis::use_readme_md()`

You can install the development version of `spacewalks` like so:

``` r
devtools::install_github("my_username/spacewalks")
library(spacewalks)
```
:::
::::

### LICENSE section and file

Copyright allows a creator of work (such as written text, photographs,
films, music, software code) to state that they own the work they have
created. Copyright is automatically implied - even if the creator does
not explicitly assert it, copyright of the work exists from the moment
of creation. A licence is a legal document which sets down the terms
under which the creator is releasing what they have created for others
to use, modify, extend or exploit.

Because any creative work is copyrighted the moment it is created, even
without any kind of licence agreement, it is important to state the
terms under which code can be reused. The lack of a licence for your
software implies that no one can reuse the software at all - hence it is
imperative you declare it. A common way to declare your copyright of a
piece of software and the license you are distributing it under is to
include a file called LICENSE in the root directory of your code
repository.

There is an optional extra [episode in this course on different open
source software licences](../learners/licensing.md) that you can choose
for your code and that we recommend for further reading.

::: instructor
Make sure to mention the [extra content on different open source
software licences](../learners/licensing.md), briefly cover it if there
is time, then focus on the technicalities of adding a license file to a
code project / repository (as there is likely not going to be enough
time to spend on different license types).
:::

::: callout
#### Tools to help you choose a licence

-   A [short intro](../learners/licensing.md) on different open source
    software licences included as extra content to this course.
-   [The open source guide][opensource-licence-guide] on applying,
    changing and editing licenses.
-   [choosealicense.com][choosealicense] online tool has some great
    resources to help you choose a license that is appropriate for your
    needs, and can even automate adding the LICENSE file to your GitHub
    code repository.
:::

:::: challenge
### Change the license of your code

NB: One you've shared your code outside your research group or made your
code public it isn't common to change the license and there are
complexities associated with this (see: [12.2.4 Relicensing Section in R
Packages (2e)](https://r-pkgs.org/license.html#relicensing)). This
challenge covers the situation prior to code release when you\
might change your mind about the license you'd like to use.

1.  Many R packages are licensed using GPL-2 / 3. Read the description
    of GPL-2 and GPL-3 licenses from the
    [choosealicense.com][choosealicense] website.

2.  Use usethis::use_gpl_license(version = 3, include_future = TRUE) to
    change the license of your code to GPL-3. This function will create
    a LICENSE file in the root of your repository with the text of the
    GPL-3 license.

::: solution
1.  See [choosealicense.com][choosealicense]
2.  usethis::use_gpl_license(version = 3, include_future = TRUE)
:::
::::

### Contributions

In this section, you can describe how you would like others to
contribute their suggestions to your code. Adding a contributing guide
is a good practice to make sure your software adheres to the principles
of open source. If someone finds a bug or has a good suggestion on how
your package can be improved, they will feel more comfortable sharing
their thoughts if it's clear on your README that you will welcome their
input.

This section of the README directs visitors to two files that are
present in your project folder. `CONTRIBUTING.md` tells the visitor how
they should add their thoughts/suggestions. For example, if you would
welcome someone to open a pull request with fixes to your repository,
you can add that request here. Alternatively, if you'd like contributors
to open issues instead, please describe this in your `CONTRIBUTING.md`
folder.

The `CONDUCT.md` file tells contributors what the terms of collaboration
for the project are. A good standard is the [Contributor
Covenant](https://www.contributor-covenant.org), which has been
translated into over 40 languages and is often adapted for use in open
source projects. By adding a code of conduct, you encourage anyone who
is interacting with your code to contribute to a healthy community and
values for your project.

## [Supplementary Material] Documentation tools

Once our project reaches a certain size or level of complexity we may
want to add additional documentation such as a standalone tutorial or
“background” explaining our methodological choices.

Once we move beyond using a README as our primary source of
documentation, we need to consider how we will distribute our
documentation to our users. Options include:

-   A `docs/` folder of Markdown files
-   Adding a Wiki to our repository (if sharing online)
-   Creating a set of web pages (either bundled with our project folder
    or hosted online) for our documentation using a static site
    generator for our documentation such as `pkgdown`.

Creating a static site is a popular solution as it has the key benefit
being able to automatically generate a reference manual from any
roxygen2 comment blocks we have added to our code.

### pkgdown [\^1]

You can use package pkgdown to create an online site for your
documentation. It effectively recycles the documentation you have
already created for your functions, information in your README and
DESCRIPTION file and presents it in a standardised website form.

Let’s create such a site for our package.

``` r
pkgdown::build_site()
```

This creates html documentation for our package in the docs/ folder and
presents you with a preview to the site.

::: challenge
### Explore your documentation

Explore documentation in `docs/` folder built with `pkgdown` for your
project, starting from the `index.html` file.

Open `index.html` file in a Web browser to see how it renders.

Check `Reference` page in the top menu to see how roxygen2 blocks from
your functions are provided here as a reference manual.
:::

::: callout
### Hosting documentation

We saw how `pkgdown` documentation can be distributed with our
repository and viewed "offline" using a browser.

We can also make our documentation available as a live website by
deploying our documentation to a hosting service like GitHub pages. You
can find out more about how to do this here: see [Create documentation
site](https://annakrystalli.me/rrresearchACCE20/packaging-functionality.html)
in course ["Reproducible Research Data and Project Management in
R"](https://annakrystalli.me/rrresearchACCE20/) for further details.
:::

## Documentation guides

Once we start to consider other forms of documentation beyond the
README, we can also increase reusability of our code by ensuring that
the content and style of our documentation matches its purpose.

Documentation guides such as [Write the Docs][write-the-docs], [The Good
Docs Project][the-good-docs-project] and the [Diataxis
framework][diataxis-framework] provide a range of resources including
documentation templates to help to help us do this.

:::: discussion
### Spacewalks how-to guide

a.  Review the Diataxis guidance page on writing a How-to guide.
    Identify three features of an effective how-to guide.

b.  Following the Diataxis guidelines, write a how-to guide to show
    users how to change the destination filename for the output CSV
    dataset generated by the Spacewalks software.

::: spoiler
### Discussion hints & solution

An effective how-to guide should:

-   be goal oriented and focus on action.
-   avoid teaching or explanation
-   use appropriate language e.g. conditional imperatives
-   have an informative title

An example how-to guide for our project to the file
`docs/how-to-guides.md`:

```         
# How to change the file path of Spacewalk's output dataset

This guide shows you how to set the file path for Spacewalk's output
data set to a location of your choice.

By default, the cleaned data set in CSV format, generated by the Spacewalk software, is saved to the `analysis/data/derived-data`
folder within the working directory with file name `eva-data.csv`.

If you would like to modify the name or location of the output dataset, you should edit
the run_analysis.R script in the `analysis/scripts` folder directly and modify the `output_file` variable.

The specified destination folder `data/clean/` must exist before running spacewalks analysis script.
```

Remember to rebuild your documentation:

``` r
devtools::document()
```
:::
::::

## Further reading

We recommend the following resources for some additional reading on the
topic of this episode:

-   ["The Art of Readme"][art-of-readme] article by Kira Oakley - a
    useful discussion of best practices for writing a high-quality
    README
-   [What are best practices for research software
    documentation?][ssi-blog-docs] (Software Sustainability blog post)
    by Stephan Druskat et al.

Also check the [full reference set](learners/reference.md#litref) for
the course.

::: keypoints
-   Documentation allows users to run and understand software without
    having to work things out for themselves directly from the source
    code.
-   Software documentation improves the reusability of research code.
-   A (good) README, CITATION entry/file and LICENSE file are the
    minimum documentation elements required to support reproducible and
    reusable research code.
-   Documentation can be provided to users in a variety of formats
    including a `docs` folder of Markdown files, a repository Wiki and
    static webpages.
-   A static documentation site can be created using the tool `pkgdown`
-   Documentation frameworks such as Diataxis provide content and style
    guidelines that can helps us write high quality documentation.
:::

## Attribution

This episode reuses material from [“Code
Documentation”][fair-software-course-documentation] episode of the
Software Carpentries Incubator course ["Tools and practices of FAIR
research software”][fair-software-course] under a
[CC-BY-4.0](https://creativecommons.org/licenses/by/4.0/deed.en) with
modifications, (i) adaptations have been made to make the material
suitable for an audience of R users (e.g. replacing “software” with
“code” in places and introducing R specific versions content e.g.
discussing pkgdown insteam of mkdocs) (ii) all code has been ported from
Python to R (iii) Objectives, Questions, Key Points and Further Reading
sections have been updated to reflect the remixed R focussed content.

[\^1] : Reused from [Create documentation
site](https://annakrystalli.me/rrresearchACCE20/packaging-functionality.html)
in course ["Reproducible Research Data and Project Management in
R"](https://annakrystalli.me/rrresearchACCE20/) by Anna Krystalli under
[CC-BY-4.0](https://creativecommons.org/licenses/by/4.0/deed.en).
