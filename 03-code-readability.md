---
title: Code readability
teaching: 60
exercises: 30
---

::: questions

-   Why does code readability matter?
-   How can I organise my code to be more readable?
-   What types of documentation can I include to improve the readability of my code?

:::

::: objectives

After completing this episode, participants should be able to:

-   Organise R code into reusable functions that achieve a singular purpose
-   Choose function and variable names that help explain the purpose of the function or variable
-   Write informative comments and to provide more detail about what the code is doing

:::

In this episode, we will introduce the concept of readable code and consider how it can help create reusable 
scientific software and empower collaboration between researchers.

When someone writes code, they do so based on requirements that are likely to change in the future.
Requirements change because code interacts with the real world, which is dynamic.
When these requirements change, the developer (who is not necessarily the same person who wrote the original code) 
must implement the new requirements.
They do this by reading the original code to understand how it currently works and identify what needs to change.
Readable code facilitates this process and saves future you and developers' time and effort.

In order to develop readable code, we should ask ourselves: "If I re-read this piece of code in fifteen days or one 
year, will I be able to understand what I have done and why?" 
Or even better: "If a new person who just joined the project reads my software, will they be able to understand 
what I have written here?"

We will now learn about a few best practices we can follow to help create more readable code. 

::: instructor

At this point, the code in your local software project's directory should be as in:

TODO
:::

## Remove unused files and folders
Let's start by removing any files or folders that are not needed in our project directory.

```bash
rm -r astronaut-data-analyses-old
```

## Use meaningful file names
Let's give our analysis script a meaningful name that reflects what it does and do the same
for our input and output files.

```bash
mv my_analysis_v2.R eva_data_analysis.R 
mv data.json eva_data.json
```

## Place `library` statements at the top

Let's have a look at our code again - the first thing we may notice is that our script currently places `library()` statements 
throughout the code.
Conventionally, all `library()` statements are placed at the top of the script so that dependent libraries
are clearly visible and not buried inside the code 
This will help readability (accessibility) and reusability of our code.

Our code after the modification should look like the following.

```r
library(jsonlite)
library(ggplot2)

# https://data.nasa.gov/resource/eva.json (with modifications)
# File paths
data_f <- "eva-data.json"
data_t <- "eva-data.csv"
g_file <- "cumulative_eva_graph.png"

fieldnames <- c("eva", "country", "crew", "vehicle", "date", "duration", "purpose")

data <- list()
data_raw <- readLines(data_f, warn = FALSE)

# 374
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
      time <- c(time, ttt)

      if (("date" %in% names(data[[j]]) & ("eva" %in% names(data[[j]])))) {
        date <- as.Date(substr(data[[j]]$date, 1, 10), format = "%Y-%m-%d")
        year <- as.numeric(format(date,"%Y"))
        dates <- c(dates, date)
        years <- c(years, year)
        row_data <- as.data.frame(data[[j]])
      } else {
        time <- time[-1]
      }
    }
  }

  ## Comment out this bit if you don't want the spreadsheet
  if (exists("row_data")) {
    print(row_data)
    if (w==0) {
      write.table(row_data, data_t, sep = ",", row.names = FALSE, col.names = TRUE, append = FALSE)
    } else {
      write.table(row_data, data_t, sep = ",", row.names = FALSE, col.names = FALSE, append = TRUE)
    }
    w <- w+1
    rm(row_data)
  }

  j <- j + 1
}

if (!exists("ct")) {ct <- c(0)}

for (k in time) {
  ct <- c(ct, ct[length(ct)] + k)
}

sorted_indices <- order(dates)
years <- years[sorted_indices]
time <- time[sorted_indices]

# Print total time in space
print(ct[length(ct)])

tdf <- data.frame(
  years = years,
  ct = ct[-1]
)


# Plot the data
ggplot(tdf, aes(x = years, y = ct)) + geom_line(color = "black") + geom_point(color = "black") +
  labs( x = "Year", y = "Total time spent in space to date (hours)", title = "Cumulative Spacewalk Time" ) + theme_minimal()

# Correction for repeatability
ct <- c(0)

# Save plot
ggsave(g_file, width = 8, height = 6)
```


## Use meaningful variable names

Variables are the most common thing you will assign when coding, and it's really important that it is clear what each variable means in order to understand what the code is doing.
If you return to your code after a long time doing something else, or share your code with a colleague, it should be easy enough to understand what variables are involved in your code from their names.
Therefore we need to give them clear names, but we also want to keep them concise so the code stays readable.
There are no "hard and fast rules" here, and it's often a case of using your best judgment.

Some useful tips for naming variables are:

- Short words are better than single character names. For example, if we were creating a variable to store the speed 
to read a file, `s` (for 'speed') is not descriptive enough but `MBReadPerSecondAverageAfterLastFlushToLog` is too long 
to read and prone to misspellings. `ReadSpeed` (or `read_speed`) would suffice.
- If you are finding it difficult to come up with a variable name that is both short and descriptive, 
go with the short version and use an inline comment to describe it further (more on those in the next section). 
This guidance does not necessarily apply if your variable is a well-known constant in your domain - 
for example, *c* represents the speed of light in physics.
- Try to be descriptive where possible and avoid meaningless or funny names like `foo`, `bar`, `var`, `thing`, etc.

Remember there are  some restrictions to consider when naming variables in R - variable names can only contain letters, numbers, underscores and full-stops. They cannot start with a number or contain spaces. 

:::::: challenge

### Give a descriptive name to a variable

Below we have a variable called `var` being set the value of 9.81.
`var` is not a very descriptive name here as it doesn't tell us what 9.81 means, yet it is a very common constant in physics!
Go online and find out which constant 9.81 relates to and suggest a new name for this variable.

Hint: the units are *metres per second squared*!

``` r
var <- 9.81
```

::: solution
### Solution

$$ 9.81 m/s^2 $$ is the [gravitational force exerted by the Earth](https://en.wikipedia.org/wiki/Gravity_of_Earth).
It is often referred to as "little g" to distinguish it from "big G" which is the [Gravitational Constant](https://en.wikipedia.org/wiki/Gravitational_constant).
A more descriptive name for this variable therefore might be:

```r
g_earth <- 9.81
```
:::
::::::


:::::: challenge

### Rename our variables to be more descriptive

Let's apply this to `eva_data_analysis.R`.

a. Edit the code as follows to use descriptive variable names:

    - Change data_f to input_file
    - Change data_t to output_file
    - Change g_file to graph_file
    
b. What other variable names in our code would benefit from renaming? 


::: solution

a. Updated code:
```r
library(jsonlite)
library(ggplot2)

# https://data.nasa.gov/resource/eva.json (with modifications)
# File paths
input_file <- "eva-data.json"
output_file <- "eva-data.csv"
graph_file <- "cumulative_eva_graph.png"

fieldnames <- c("eva", "country", "crew", "vehicle", "date", "duration", "purpose")

data <- list()
data_raw <- readLines(input_file, warn = FALSE)

# 374
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
rownno <- 0
for (i in data) {  # Iterate manually

  if ("duration" %in% names(data[[j]])) {
    time_text <- data[[j]]$duration

    if (time_text == "") {
      # Do nothing if empty
    } else {
      t_parts <- strsplit(time_text, ":")[[1]]
      t_hours <- as.numeric(t_parts[1]) + as.numeric(t_parts[2]) / 60  # Convert to hours
      print(t_hours)
      time <- c(time, t_hours)

      if (("date" %in% names(data[[j]]) & ("eva" %in% names(data[[j]])))) {
        date <- as.Date(substr(data[[j]]$date, 1, 10), format = "%Y-%m-%d")
        year <- as.numeric(format(date,"%Y"))
        dates <- c(dates, date)
        years <- c(years, year)
        row_data <- as.data.frame(data[[j]])
      } else {
        time <- time[-1]
      }
    }
  }

  ## Comment out this bit if you don't want the spreadsheet
  if (exists("row_data")) {
    print(row_data)
    if (rownno==0) {
      write.table(row_data, output_file, sep = ",", row.names = FALSE, col.names = TRUE, append = FALSE)
    } else {
      write.table(row_data, output_file, sep = ",", row.names = FALSE, col.names = FALSE, append = TRUE)
    }
    rownno <- rowno+1
    rm(row_data)
  }

  j <- j + 1
}

if (!exists("cumulative_time")) {cumulative_time <- c(0)}

for (k in time) {
  cumulative_time <- c(cumulative_time, cumulative_time[length(cumulative_time)] + k)
}

sorted_indices <- order(dates)
years <- years[sorted_indices]
time <- time[sorted_indices]

# Print total time in space
print(cumulative_time[length(cumulative_time)])

tdf <- data.frame(
  years = years,
  cumulative_time = cumulative_time[-1]
)


# Plot the data
ggplot(tdf, aes(x = years, y = cumulative_time)) + geom_line(color = "black") + geom_point(color = "black") +
  labs( x = "Year", y = "Total time spent in space to date (hours)", title = "Cumulative Spacewalk Time" ) + theme_minimal()

# Correction for repeatability
cumulative_time <- c(0)

# Save plot
ggsave(graph_file, width = 8, height = 6)
```

b. We should also rename variables `w`, `tt`, `ttt`, `ct` to be more descriptive.
   In the solution above, these have been renamed to rownno, time_text, t_hours and cumulative_time respectively.


:::
::::::

## Use standard libraries

Our script currently reads the data line-by-line from the JSON data file and uses custom code to manipulate
the data.
Variables of interest are stored in lists but there are more suitable data structures (e.g. data frames)
to store data in our case.
By choosing custom code over standard and well-tested libraries, we are making our code less readable and understandable
and more error-prone.

The main functionality of our code can be rewritten as follows using the `dplyr` library to load and manipulate the 
data in data frames.


The code should now look like:

```r
library(jsonlite)
library(ggplot2)
library(dplyr)
library(tidyr)
library(lubridate)
library(readr)
library(stringr)

input_file <- "eva-data.json"
output_file <- "eva-data.csv"
graph_file <- "cumulative_eva_graph.png"

eva_data <- fromJSON(input_file, flatten = TRUE) |>
 mutate(eva = as.numeric(eva)) |>
 mutate(date = ymd_hms(date)) |>
 mutate(year = year(date)) |>
 drop_na() |>
 arrange(date) |>


write_csv(eva_data, output_file)

time_in_space_plot <- eva_data |>
  rowwise()  |>
  mutate(duration_hours =
                  sum(as.numeric(str_split_1(duration, "\\:"))/c(1, 60))
  ) |>
  ungroup() |>
  mutate(cumulative_time = cumsum(duration_hours)) |>
  ggplot(aes(x = year, y = cumulative_time)) +
  geom_line(color = "black") +
  labs(
    x = "Year",
    y = "Total time spent in space to date (hours)",
    title = "Cumulative Spacewalk Time" ) +
  theme_minimal()

ggsave(graph_file, width = 8, height = 6, plot = time_in_space_plot)

```


We should replace the existing code in our R script `eva_data_analysis.R` with the above code.


## Use comments to explain functionality

Commenting is a very useful practice to help convey the context of the code.
It can be helpful as a reminder for your future self or your collaborators as to why code is written in a certain way, 
how it is achieving a specific task, or the real-world implications of your code.

There are several ways to add comments to code: 

- An **inline comment** is a comment on the same line as a code statement. 
Typically, it comes after the code statement and finishes when the line ends and 
is useful when you want to explain the code line in short. 
Inline comments in R should be separated by at least two spaces from the statement; they start with a # followed
by a single space, and have no end delimiter.

``` r
x <- 5  # In R, inline comments begin with the `#` symbol and a single space.
```

- A **multi-line** or **block comment** spans multiple lines. R doesn’t have a specific 
  multiline comment syntax, a common practice is to use a single # for each line but 
  make it look like a block comment for readability. You could also align the # symbol 
  vertically to create a visually consistent block of comments.

```r
# ==========================================
# This is a block comment.
# You can write a detailed explanation here.
# It can span multiple lines as needed.
# ==========================================
```

Here are a few things to keep in mind when commenting your code:

- Focus on the **why** and the **how** of your code - avoid using comments to explain **what** your code does. 
If your code is too complex for other programmers to understand, consider rewriting it for clarity rather than adding 
comments to explain it.
- Make sure you are not reiterating something that your code already conveys on its own. Comments should not echo your 
code.
- Keep comments short and concise. Large blocks of text quickly become unreadable and difficult to maintain.
- Comments that contradict the code are worse than no comments. Always make a priority of keeping comments up-to-date 
when code changes.

### Examples of unhelpful comments

``` r
statetax <- 1.0625  # Assigns the float 1.0625 to the variable 'statetax'
citytax <- 1.01  # Assigns the float 1.01 to the variable 'citytax'
specialtax <- 1.01  # Assigns the float 1.01 to the variable 'specialtax'
```

The comments in this code simply tell us what the code does, which is easy enough to figure out without the inline comments.

### Examples of helpful comments

``` r
statetax = 1.0625  # State sales tax rate is 6.25% through Jan. 1
citytax = 1.01  # City sales tax rate is 1% through Jan. 1
specialtax = 1.01  # Special sales tax rate is 1% through Jan. 1
```

In this case, it might not be immediately obvious what each variable represents, so the comments offer helpful, 
real-world context.
The date in the comment also indicates when the code might need to be updated.

::: challenge

### Add comments to our code

a. Examine `eva_data_analysis.R`.
Add as many comments as you think is required to help yourself and others understand what that code is doing.

b. Add as many print statements as you think is required to keep the user informed about what the code is doing as it runs.


::: solution

### Solution

Some good comments and print statements may look like the example below.

``` r
ibrary(jsonlite)
library(ggplot2)
library(dplyr)
library(tidyr)
library(lubridate)
library(readr)
library(stringr)

# https://data.nasa.gov/resource/eva.json (with modifications)
input_file <- "eva-data.json"
output_file <- "eva-data.csv"
graph_file <- "cumulative_eva_graph.png"

print("--START--")
print("Reading JSON file")

# Read the data from a JSON file into a dataframe
eva_data <- fromJSON(input_file, flatten = TRUE) |>
 mutate(eva = as.numeric(eva)) |>
 mutate(date = ymd_hms(date)) |>
 mutate(year = year(date)) |>
 drop_na() |>
 arrange(date) |>


print("Saving to CSV file")
# Save dataframe to CSV file for later analysis
write_csv(eva_data, output_file)

print("Plotting cumulative spacewalk duration and saving to file")
# Plot cumulative time spent in space over years
time_in_space_plot <- eva_data |>
  rowwise() |>
  mutate(duration_hours =
                  sum(as.numeric(str_split_1(duration, "\\:"))/c(1, 60))
  ) |>
  ungroup() |>
  # Calculate cumulative time
  mutate(cumulative_time = cumsum(duration_hours)) |>
  ggplot(aes(x = year, y = cumulative_time)) +
  geom_line(color = "black") +
  labs(
    x = "Year",
    y = "Total time spent in space to date (hours)",
    title = "Cumulative Spacewalk Time" ) +
  theme_minimal()

ggsave(graph_file, width = 8, height = 6, plot = time_in_space_plot)
print("--END--")
```
:::
:::

## Separate units of functionality

Functions are a fundamental concept in writing software and are one of the core ways you can organise your code to 
improve its readability.
A function is an isolated section of code that performs a single, *specific* task that can be simple or complex.
It can then be called multiple times with different inputs throughout a codebase, but its definition only needs to 
appear once.

Breaking up code into functions in this manner benefits readability since the smaller sections are easier to read 
and understand.
Since functions can be reused, codebases naturally begin to follow the [Don't Repeat Yourself principle][dry-principle] 
which prevents software from becoming overly long and confusing.
The software also becomes easier to maintain because, if the code encapsulated in a function needs to change, 
it only needs updating in one place instead of many.
As we will learn in a future episode, testing code also becomes simpler when code is written in functions.
Each function can be individually checked to ensure it is doing what is intended, which improves confidence in 
the software as a whole.

::: callout
Decomposing code into functions helps with reusability of blocks of code and eliminating repetition, 
but, equally importantly, it helps with code readability and testing.
:::

Looking at our code, you may notice it contains different pieces of functionality:

1. reading the data from a JSON file
2. converting and saving the data in the CSV format
3. processing/cleaning the data and preparing it for analysis 
4. data analysis and visualising the results

Let's refactor our code so that reading the data in JSON format into a dataframe (step 1.) and converting it and saving 
to the CSV format (step 2.) is extracted into a separate function.
Let's name this function `read_json_to_dataframe`. 
The main part of the script should then be simplified to invoke these new functions, while the function itself 
contain the complexity of this step. We will continue to work on steps 3. and 4. above later on.

After the initial refactoring, our code may look something like the following.

``` r
library(jsonlite)
library(ggplot2)
library(dplyr)
library(tidyr)
library(lubridate)
library(readr)
library(stringr)

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


# https://data.nasa.gov/resource/eva.json (with modifications)
input_file <- "eva-data.json"
output_file <- "eva-data.csv"
graph_file <- "cumulative_eva_graph.png"

print("--START--")


# Read the data from a JSON file into a dataframe
eva_data <- read_json_to_dataframe(input_file)

# Save dataframe to CSV file for later analysis
write_csv(eva_data, output_file)

print("Plotting cumulative spacewalk duration and saving to file")
# Plot cumulative time spent in space over years
time_in_space_plot <- eva_data |>
  rowwise() |>
  mutate(duration_hours =
                  sum(as.numeric(str_split_1(duration, "\\:"))/c(1, 60))
  ) |>
  ungroup() |>
  # Calculate cumulative time
  mutate(cumulative_time = cumsum(duration_hours)) |>
  ggplot(aes(x = year, y = cumulative_time)) +
  geom_line(color = "black") +
  labs(
    x = "Year",
    y = "Total time spent in space to date (hours)",
    title = "Cumulative Spacewalk Time" ) +
  theme_minimal()

ggsave(graph_file, width = 8, height = 6, plot = time_in_space_plot)
print("--END--")

```

We have chosen to create functions for reading in our data files since this is a very common task within 
research software.
While this function does not contain that many lines of code due to using the `tidyverse` functions  that do all the 
complex data reading and data preparation operations, 
it can be useful to package these steps together into reusable functions if you need to read in or write out a lot of 
similarly structured files and process them in the same way.


## Function Documentation

Now that we have written some functions, it is time to document them so that we can quickly recall 
(and others looking at our code in the future can understand) what the functions do without having to read
the code.

*Roxygen comments* are a specific type of function-level documentation that are provided within R functions and classes.
Function level documentation should explain what that particular code is doing, what parameters the function needs (inputs)
and what form they should take, what the function outputs (you may see words like 'return' here), 
and errors (if any) that might be raised.

Providing Roxygen comments helps improve code readability since it makes the function code more transparent and aids 
understanding.
Particularly, roxygen comments that provide information on the input and output of functions makes it easier to reuse them 
in other parts of the code, without having to read the full function to understand what needs to be provided and 
what will be returned.

Roxygen comment lines in R start with #' to indicate that they are documentation 
and are written directly above the function definition.  The tag @param is used to document function parameters, 
while @return describes what the function returns, and you can also use 
@details to give additional information such as errors.

``` r
#' Divide number x by number y.
#' 
#' @param x A number to be divided.
#' @param y A number to divide by.
#' @return The result of dividing x by y.
#' 
#' @details
#' If y is zero, this will result in an error (division by zero).
divide <- function(x, y) {
    return(x / y)
}
```

We'll see later in the course
how the `roxygen2` package can be used to automatically generate formal documentation for the function.
while the package `pkgdown` can be used to generate a documentation website for our whole project.

Let's write a roxygen comment for the function `read_json_to_dataframe` we introduced in the previous exercise. 
Remember, questions we want to answer when writing the function-level documentation include:

- What the function does?
- What kind of inputs does the function take? Are they required or optional? Do they have default values?
- What output will the function produce?
- What exceptions/errors, if any, it can produce?

Our `read_json_to_dataframe` function fully described by a roxygen comment block may look like: 

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

```

:::::: challenge

### Writing roxygen comments

Write a roxygen comment for this function `text_to_duration`:.

```r
text_to_duration <- function(duration) {
  time_parts <- stringr::str_split(duration, ":")[[1]]
  hours <- as.numeric(time_parts[1])
  minutes <- as.numeric(time_parts[2])
  duration_hours <- hours + minutes / 60
  return(duration_hours)
}
```

::: solution

### Solution 

Our `text_to_duration` function fully described by roxygen comments may look like:
```r
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

```
:::

::::::

## Functions for modular and reusable code revisited.

As we have already seen earlier in this episode - functions play a key
role in creating modular and reusable code. We are going to carry on
improving our code following these principles:

-   Each function should have a single, clear responsibility. This makes
    functions easier to understand, test, and reuse.
-   Write functions that can be easily combined or reused with other
    functions to build more complex functionality.
-   Functions should accept parameters to allow flexibility and
    reusability in different contexts; avoid hard-coding values inside
    functions/code (e.g. data files to read from/write to) and pass them
    as arguments instead.

Bearing in mind the above principles, we can further simplify the main
part of our code by extracting the code to process, analyse our data and
plot a graph into a separate function `plot_cumulative_time_in_space`.

We can further extract the code to convert the spacewalk duration text
into a number to allow for arithmetic calculations (into a separate
function `text_to_duration`).

```r
library(jsonlite)
library(ggplot2)
library(dplyr)
library(tidyr)
library(lubridate)
library(readr)
library(stringr)

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

The main part of our code then becomes much simpler and more readable,
only containing the invocation of the following three functions:

```r
# https://data.nasa.gov/resource/eva.json (with modifications)
input_file <- "eva-data.json"
output_file <- "eva-data.csv"
graph_file <- "cumulative_eva_graph.png"

print("--START--")

# Read the data from a JSON file into a dataframe
eva_data <- read_json_to_dataframe(input_file)

print("Writing CSV File")
# Save dataframe to CSV file for later analysis
write_csv(eva_data, output_file)

print("Plotting cumulative spacewalk duration and saving to file")
# Plot cumulative time spent in space over years
plot_cumulative_time_in_space(eva_data, graph_file)

print("--END--")
...
```

:::::: challenge

## Using the styler package [^1]

a. Look up the stylr package. How can it help you make your code more readable? 
b. Install `stylr` and apply it to this poorly formatted version of the `plot_cumulative_time_in_space` functions we  created.

```r
plot_cumulative_time_in_space <- function(tdf, graph_file) {
  time_in_space_plot <- tdf |>
    rowwise() |>
       mutate(duration_hours = text_to_duration(duration)) |> # Add duration_hours column
    ungroup() |>
    mutate(cumulative_time = cumsum(duration_hours)) |> # Calculate cumulative time
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
:::: solution

a. See [R for Data Science](https://r4ds.hadley.nz/workflow-style.html) for 
   a discussion of `stylr` and how it can help you make your code more readable.

b. `plot_cumulative_time_in_space` after applying `stylr`

```r
plot_cumulative_time_in_space <- function(tdf, graph_file) {
  time_in_space_plot <- tdf |>
    rowwise() |>
    mutate(duration_hours = text_to_duration(duration)) |> # Add duration_hours column
    ungroup() |>
    mutate(cumulative_time = cumsum(duration_hours)) |> # Calculate cumulative time
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

::::

:::::::


## Further reading

We recommend the following resources for some additional reading on the topic of this episode:

- [7 tell-tale signs of unreadable code](https://www.index.dev/blog/7-tell-tale-signs-of-unreadable-code-how-to-identify-and-fix-the-problem)
- ['Code Readability Matters' from the Guardian's engineering blog][guardian-code-readability]


Also check the [full reference set](learners/reference.md#litref) for the course.

::: keypoints
- Readable code is easier to understand, maintain, debug and extend (reuse) - saving time and effort.
- Choosing descriptive variable and function names will communicate their purpose more effectively.
- Using comments and function-level documentation (roxygen) to describe parts of the code will help transmit understanding and context.
- Use libraries or packages for common functionality to avoid duplication.
- Creating functions from the smallest, reusable units of code will make the code more readable and help. 
compartmentalise which parts of the code are doing what actions and isolate specific code sections for re-use.
:::

## Attribution

This episode reuses material from the [“Code Readability”][fair-software-course-readability] episode of the Software Carpentries Incubator course ["Tools and practices of FAIR research software”][fair-software-course] under a [CC-BY-4.0](https://creativecommons.org/licenses/by/4.0/deed.en) licence with modifications: (i) adaptations  have been made to make the material suitable for an audience of  R users (e.g. replacing “software” with “code” in places, docstrings with roxygen2), (ii) all code has been ported from Python to  R (iii) the example code has been deliberately modified to be non-repeatable  for teaching purposes. (iv) Objectives, Questions, Key Points and Further Reading sections have been updated to reflect the remixed R focussed content. Some original material has been added – this is marked with a footnote.   

[^1]: Original Material
