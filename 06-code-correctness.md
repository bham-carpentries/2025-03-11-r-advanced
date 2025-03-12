---
title: "Code correctness"
teaching: 60
exercises: 30
---

::: questions

-   How can we verify that our code is correct?
-   How can we automate testing in R?
-   What makes a "good" test?
-   Which parts of our code should we prioritise for testing?

:::

::: objectives

After completing this episode, participants should be able to:

-   Explain why code testing is important and how this supports reproducibility.
-   Describe the different types of software tests (unit tests, integration tests, regression tests).
-   Implement unit tests to verify that functions behave as expected using the R testing framework `testthat`.
-   Interpret the output from `testthat` to identify which functions are not behaving as expected.
-   Write tests using typical values, edge cases and invalid inputs to ensure that the code can handle extreme 
values and invalid inputs appropriately.
-   Evaluate code coverage to identify how much of the code is being tested and identify areas that need further 
tests.

:::

Now that we have improved the structure and readability of our code - it is much easier to 
test its functionality and improve it further. 
The goal of software testing is to check that the actual results
produced by a piece of code meet our expectations, i.e. are correct.

::: callout

Open your research compendium in R Studio and clear your environment:

+ Double-click on spacwalks2.rproj to open your project in RStudio.
+ Clear your environment using the built-in GUI:
  + Go to the Environment pane (usually on the top right).
  + Click on the ** broom icon** (Clear All) to remove all objects in the environment.
  
:::

:::::: instructor

At this point, the code in your local software project's directory should be as in:
TODO

::::::

## Why use software testing?

Adopting software testing as part of our research workflow helps us to
conduct **better research** and produce reproducible software:

- Software testing can help us be more productive as it helps us to identify and fix problems with our code early and
  quickly and allows us to demonstrate to ourselves and others that our
  code does what we claim. More importantly, we can share our tests
  alongside our code, allowing others to verify our software for themselves.
- The act of writing tests encourages to structure our code as individual functions and often results in a more
  **readable**, modular and maintainable codebase that is easier to extend or repurpose.
- Software testing improves the **accessibility** and **reusability** of our code - well-written software tests
  capture the expected behaviour of our code and can be used alongside documentation to help other developers
  quickly make sense of our code. In addition, a well tested codebase allows developers to experiment with new
  features safe in the knowledge that tests will reveal if their changes have broken any existing functionality.
- Software testing also gives us the confidence to engage in open research practices - if we are not sure that our code works as intended and produces accurate results, we are unlikely to feel confident about sharing our code with
  others. Software testing brings piece of mind by providing a
  step-by-step approach that we can apply to verify that our code is
  correct.


## Types of software tests

There are many different types of software tests, including:

-   **Unit tests** focus on testing individual functions in
    isolation. They ensure that each small part of the software performs
    as intended. By verifying the correctness of these individual units,
    we can catch errors early in the development process.

-   **Integration tests** check how different parts
    of the code e.g. functions work together.

-   **Regression tests** are used to ensure that new
    changes or updates to the codebase do not adversely affect the
    existing functionality. They involve checking whether a program or
    part of a program still generates the same results after changes
    have been made.

-   **End-to-end** tests are a special type of integration testing which
    checks that a program as a whole behaves as expected.

In this course, our primary focus will be on unit testing. However, the
concepts and techniques we cover will provide a solid foundation
applicable to other types of testing.

::: challenge
### Types of software tests

Fill in the blanks in the sentences below:

-   \_\_\_\_\_\_\_\_\_\_ tests compare the \_\_\_\_\_\_ output of a
    program to its \_\_\_\_\_\_\_\_ output to demonstrate correctness.
-   Unit tests compare the actual output of a \_\_\_\_\_\_
    \_\_\_\_\_\_\_\_ to the expected output to demonstrate correctness.
-   \_\_\_\_\_\_\_\_\_\_ tests check that results have not changed since
    the previous test run.
-   \_\_\_\_\_\_\_\_\_\_ tests check that two or more parts of a program
    are working together correctly.

::: solution
-   End-to-end tests compare the actual output of a program to the
    expected output to demonstrate correctness.
-   Unit tests compare the actual output of a single function to the
    expected output to demonstrate correctness.
-   Regression tests check that results have not changed since the
    previous test run.
-   Integration tests check that two or more parts of a program are
    working together correctly.
:::
:::

## Informal testing

How should we test our code? 

One approach is to load the code or a function into our R environment. 
 
From the R console, we can then run one function or a piece of code at a time and check that it behaves as 
expected. To do this, we can observe how the function behaves using input values for which we know what the correct 
return value should be.

Let's do this for our `text_to_duration` function.


::: callout

Before we do so, let's deliberately introduce a bug into our code:

1. Open `R/eva_data_analysis.R`
2. Let's modify `text_to_duration` so that the `minutes` component 
   is divided by `6` instead of `60` (an easy typo to make!).

```r
#' Convert Duration from HH:MM Format to Hours
#'
#' This function converts a duration in "HH:MM" format (as a character string)
#' into the total duration in hours (as a numeric value).
#'
#' @param duration A character string representing the duration in "HH:MM" format.
#'
#' @return A numeric value representing the duration in hours.
#' @export
#'
#' @examples
#' text_to_duration("03:45")  # Returns 3.75 hours
#' text_to_duration("12:30")  # Returns 12.5 hours
text_to_duration <- function(duration) {
  time_parts <- stringr::str_split(duration, ":")[[1]]
  hours <- as.numeric(time_parts[1])
  minutes <- as.numeric(time_parts[2])
  duration_hours <- hours + minutes / 6
  return(duration_hours)
}
3. Once we've done this we must rebuild and install our compendium using 
   "Clean and Install" from the Build panel.
```

:::


Recall that the `text_to_duration` function converts a spacewalk duration stored as a string
in format "HH:MM" to a duration in hours - e.g. duration `01:15` (1 hour and 15 minutes) should return a numerical 
value of `1.25`.

Open `R/eva_data_analysis.R` in RStudio and click "Source" to load all of the functions
into the R environment.

On the R console, let's invoke our function with the value "10:00":

```r
> text_to_duration("10:00")
10.0
```

So, we have invoked our function with the value "10:00" and it returned the floating point value "10" as expected.

We can then further explore the behaviour of our function by running:

```r
> text_to_duration("00:00")
0.0
```

This all seems correct so far.

Testing code in this "informal" way in an important process to go through as we draft our code for the first time.
However, there are some serious drawbacks to this approach if used as our only form of testing.

:::::: challenge

### What are the limitations of informally testing code? (5 minutes)

Think about the questions below. Your instructors may ask you to share
your answers in a shared notes document and/or discuss them with other
participants.

-   Why might we choose to test our code informally?
-   What are the limitations of relying solely on informal tests to
    verify that a piece of code is behaving as expected?

::: solution
### 

It can be tempting to test our code informally because this approach:

- is quick and easy
- provides immediate feedback

However, there are limitations to this approach:

- Working interactively is error prone
- We must reload our function in R each time we change our code
- We must repeat our tests every time we update our code which is time consuming
- We must rely on memory to keep track of how we have tested our code, e.g. what input values we tried
- We must rely on memory to keep track of which functions have been tested and which have not 
(informal testing may work well on smaller pieces of code but it becomes unpractical for a large codebase)
- Once we close the R console, we lose all the test scenarios we have tried
:::
::::::

## Formal testing

::: caution

The way we setup and store tests in this section is not conventional for R
and is used for teaching purposes to introduce the concept of testing.

In section "Testing Frameworks", we cover the conventional way to write tests in R.

:::



We can overcome some of these limitations by formalising our testing process. 
A formal approach to testing our code is to write dedicated test functions to check it. 
These test functions:

-   Run the function we want to test - the target function with known inputs
-   Compare the output to known, valid results
-   Raise an error if the function’s actual output does not match the expected output
-   Are recorded in a test script that can be re-run on demand.

Let’s explore this process by writing some formal tests for our `text_to_duration` function. 

In RStudio, let's create a new R file `test_code.R` in `analysis/scripts` to store our tests.

We need to load  spacewalks using a `library()` call so that we can access text_to_duration` in our test script. 

Then, we define our first test function and run it:

```r
library(spacewalks)
test_text_to_duration_integer <- function() {
  input_value <- "10:00"
  test_result <- text_to_duration(input_value) == 10
  print(paste("text_to_duration('10:00') == 10?", test_result))
}

test_text_to_duration_integer()
```

We can run this code with RStudio using the "Source" button or by running the code in the R console:
```r
> test_text_to_duration_integer()
[1] "text_to_duration('10:00') == 10? TRUE"
```

This test checks that when we apply `text_to_duration` to input value `10:00`, the output matches the expected value
of `10`.

In this example, we use a print statement to report whether the actual output from `text_to_duration` meets our 
expectations.

However, this does not meet our requirement to “Raise an error if the function’s output does not match the expected 
output” and means that we must carefully read our test function’s output to identify whether it has failed.

To ensure that our code raises an error if the function’s output does not match the expected output, we using  
the `expect_true` function from the `testthat` package.

The `expect_true` function checks whether a statement is `True`. 
If the statement is `True`, `expect_true` does not return a value and the code continues to run. 
However, if the statement is `False`, `expect_true` raises an `Error`.

Let's rewrite our test with an `expect_true` statement:

```r

library(spacewalks)
library(testthat)

test_text_to_duration_integer <- function() {
  input_value <- "10:00"
  test_result <- text_to_duration(input_value) == 10
  expect_true(test_result)
}

test_text_to_duration_integer()
```

Notice that when we run `test_text_to_duration_integer()`, nothing
happens - there is no output. That is because our function is working
correctly and returning the expected value of 10.

Let's add another test to check what happens when duration is not an integer number and if our function can handle 
durations with a non-zero minute component, and rerun our test code.

```r
library(spacewalks)
library(testthat)

test_text_to_duration_integer <- function() {
  input_value <- "10:00"
  test_result <- text_to_duration(input_value) == 10
  expect_true(test_result)
}

test_text_to_duration_float <- function() {
  input_value <- "10:15"
  test_result <- all.equal(text_to_duration(input_value), 10.25) #
  expect_true(test_result)
}

test_text_to_duration_float()
test_text_to_duration_integer()
```

```error
> test_text_to_duration_float()
Error: `test_result` is not TRUE

`actual`:   FALSE
`expected`: TRUE
```

Notice that this time, our test `test_text_to_duration_float` fails.
Our `expect_true` statement has raised an `Error` - a clear signal that there is a problem in our code that we
need to fix. 

We know that duration `10:15` should be converted to number `10.25`. 
What is wrong with our code?
If we look at our `text_to_duration` function, we may identify the following line of our code as problematic:

```r
text_to_duration <- function(duration) {
  ...
  duration_hours <- hours + minutes / 6
  ...
}
```

Recall that our conversion code contains a bug - the minutes component should have been divided by 60 and not 6.
We were able to spot this tiny bug **only by testing our code** (note that just by looking at the result graph there 
is not way to spot incorrect results).

Let's fix the problematic line and rerun out tests. To do this we need to:

+ Navigate to R/eva_data_analysis.R in RStudio
+ Correct the affected line of code 
```r

duration_hours = int(hours) + int(minutes)/60 

```

::: checklist

Remember to "Clean and Install" (Build panel) to make sure that our changes have been installed.

:::


This time our tests run without problem. 

You may have noticed that we have to repeat a lot of code to add each individual test for each test case. 
You may also have noticed that our test script stopped after the first test failure and none of the tests after that 
were run. 

To run our remaining tests we would have to manually comment out our failing test and re-run the test script. 
As our code base grows, testing in this way becomes cumbersome and error-prone. 
These limitations can be overcome by automating our tests using a **testing framework**.

## Testing frameworks

Testing frameworks can automatically find all the tests in our code base, run all of them (so we do not have to invoke 
them explicitly or, even worse, forget to invoke them), and present the test results as a readable summary.

We will use the R testing framework `testthat` with the code coverage package `covr`. 

Let's install these packages and add them to our DESCRIPTION file. 

```r
install.packages("testthat")
install.packages("covr)
```

DESCRIPTION file
```r
Suggests: 
  testthat (>= 3.0.0),
  covr,
  ...
```

Let’s make sure that our tests are ready to work with `testthat`.

-   `testthat` automatically discovers tests based on specific naming
    patterns. It looks for files that start with "test\_" or "test\-" and end with
    ".r" or ".R". Then, within these files, `testthat` looks for function
    calls to "test_that()".
    Our test file already meets these requirements, so there is nothing
    to do here. However, our script does contain lines to run each of
    our test functions. These are no-longer required as `testthat` will run
    our tests so we can remove them:

    ```r
    # Delete these 2 lines
    test_text_to_duration_float()
    test_text_to_duration_integer()
    ```

-   It is also conventional when working with `testthat` to
    place test files in a `tests\testthat` directory at the root of our project and
    to name each test file after the code file that it targets. This
    helps in maintaining a clean structure and makes it easier for
    others to understand where the tests are located.
  
-   Finally, a standard setup file `testthat.R` is placed in the tests folder:

    ```r
    # This file is part of the standard setup for testthat.
    # It is recommended that you do not modify it.
    #
    # Where should you do additional test configuration?
    # Learn more about the roles of various files in:
    # * https://r-pkgs.org/testing-design.html#sec-tests-files-overview
    # * https://testthat.r-lib.org/articles/special-files.html
    
    library(testthat)
    library(spacewalks)
    
    test_check("spacewalks")
    ```

We can setup the folder structure and setup file manually or by running the following commands in the R console:
```
usethis::use_testthat()
```

A set of tests for a given piece of code is called a test suite. 
Our test suite is currently located in `analysis/scripts`. 
Let’s move it to a conventional test folder `tests/testthat` and rename our `test-code.R` file to
`test-eva_data_analysis.R`.

You can do this using the file panel in RStudio or by typing the following commands in the command line terminal:

``` bash
mv test-code.R tests/testthat/test-eva_data_analysis.R
```

Before we re-run our tests using `testthat`, let's convert out test functions to `test_that()` calls 
and  add some inline  comments to clarify what each test is doing.  We will also expand our syntax to highlight 
the logic behind our approach:

```r
test_that("text_to_duration returns expected ground truth values
    for typical durations with a non-zero minute component", {
  actual_result <- text_to_duration("10:15")
  expected_result <- 10.25
  expect_true(isTRUE(all.equal(actual_result), expected_result))
})

test_that("text_to_duration returns expected ground truth values
    for typical whole hour durations", {
  actual_result <- text_to_duration("10:00")
  expected_result <- 10
  expect_true(actual_result==expected_result)
})
```

Writing our tests this way highlights the key idea that each test should compare the actual results returned by our 
function with expected values.

Similarly, writing inline comments for our tests that complete the sentence "Test that ..." helps us to understand 
what each test is doing and why it is needed.

Before running out tests with `testthat`, let's reintroduce our old bug in function `text_to_duration` that affects 
the durations with a non-zero minute component like "10:25" but not those that are whole hours, e.g. "10:00":

```r
text_to_duration <- function(duration) {
  ...
  duration_hours <- hours + minutes / 6 # 6 instead of 60
  ...
}
```

Finally, let's run our tests. We can do this by running the following command in the R console:

```r
testthat::test_dir("tests/testthat")
```

This runs all of the tests in the `tests/testthat` directory and provides a summary of the results.


```error
> testthat::test_dir("tests/testthat")
✔ | F W  S  OK | Context
✖ | 1        1 | eva_data_analysis                                              
────────────────────────────────────────────────────────────────────────────────
Error (test-eva_data_analysis.R:5:3): text_to_duration returns expected ground truth values
    for typical durations with a non-zero minute component
Error in `isTRUE(all.equal(actual_result), expected_result)`: unused argument (expected_result)
Backtrace:
    ▆
 1. └─testthat::expect_true(isTRUE(all.equal(actual_result), expected_result)) at test-eva_data_analysis.R:5:3
 2.   └─testthat::quasi_label(enquo(object), label, arg = "object")
 3.     └─rlang::eval_bare(expr, quo_get_env(quo))
────────────────────────────────────────────────────────────────────────────────

══ Results ═════════════════════════════════════════════════════════════════════
── Failed tests ────────────────────────────────────────────────────────────────
Error (test-eva_data_analysis.R:5:3): text_to_duration returns expected ground truth values
    for typical durations with a non-zero minute component
Error in `isTRUE(all.equal(actual_result), expected_result)`: unused argument (expected_result)
Backtrace:
    ▆
 1. └─testthat::expect_true(isTRUE(all.equal(actual_result), expected_result)) at test-eva_data_analysis.R:5:3
 2.   └─testthat::quasi_label(enquo(object), label, arg = "object")
 3.     └─rlang::eval_bare(expr, quo_get_env(quo))

[ FAIL 1 | WARN 0 | SKIP 0 | PASS 1 ]
Error: Test failures
```

From the above output from `testthats`'s execution of out tests, we notice that: 

- If a test finishes without triggering an error, the test is considered "OK" and is included in the total count of
  of successful tests under the "OK" column.
- If a test raises an error, the test is considered a failure with an `F` and is included in the total count of
  of successful tests under the "OK" column
- The output includes details about the error to help identify what went wrong.

Let's fix our bug once again, reload our compendium (devtools::load_all()) and rerun our tests using `testthat`.


```r
text_to_duration <- function(duration) {
  ...
  duration_hours <- hours + minutes / 60 
  ...
}
```


::: checklist

Remember to "Clean and Install" (Build panel) to make sure that our changes have been installed.

:::


```r
testthat::test_dir("tests/testthat")
````


::: challenge

# Interpreting `testhat` output

A colleague has asked you to conduct a pre-publication review of their code which analyses time spent in space by various individual astronauts.

You tested their code using `testhat`, and got the following output. Inspect it and answer the questions below.


```output
> testthat::test_dir("tests/testthat")
✔ | F W  S  OK | Context
✖ | 2        4 | analyse                                                                                      
──────────────────────────────────────────────────────────────────────────────────────────────────────────────
Failure (test-analyse.R:7:3): test_total_duration
`actual` (`actual`) not equal to `expected` (`expected`).

  `actual`: 100
`expected`:  10

Error (test-analyse.R:14:3): test_mean_duration
Error in `len(durations)`: could not find function "len"
Backtrace:
    ▆
 1. └─spacetravel:::calculate_mean_duration(durations) at test-analyse.R:14:3
──────────────────────────────────────────────────────────────────────────────────────────────────────────────
✔ |      1    2 | prepare                                                                            

══ Results ═══════════════════════════════════════════════════════════════════════════════════════════════════
── Failed tests ──────────────────────────────────────────────────────────────────────────────────────────────
Failure (test-analyse.R:7:3): test_total_duration
`actual` (`actual`) not equal to `expected` (`expected`).

  `actual`: 100
`expected`:  10

Error (test-analyse.R:14:3): test_mean_duration
Error in `len(durations)`: could not find function "len"
Backtrace:
    ▆
 1. └─spacetravel:::calculate_mean_duration(durations) at test-analyse.R:14:3

[ FAIL 2 | WARN 0 | SKIP 1 | PASS 6 ]
Error: Test failures
```

a.  How many tests has our colleague included in the test suite?
c.  How many tests failed?
d.  Why did "test_total_duration" fail?
e.  Why did "test_mean_duration" fail?

::: solution
a.  9 tests were detected in the test suite
b.  s - stands for "skipped",
c.  2 tests failed in in test file `test_analyse.py`
d.  `test_total_duration` failed because the calculated total duration
    differs from the expected value by a factor of 10.
e.  `test_mean_duration` failed because there is a syntax error in
    `calculate_mean_duration`. Our colleague has used the command
    `len` (not an R command) instead of `length`. As a result,
    running the function returns a `could not find function` error rather than a calculated
    value and the test fails.
:::

:::

## Test suite design

We now have the tools in place to automatically run tests. 
However, that alone is not enough to properly test code.
We will now look into what makes a good test suite and good practices for testing code.

Let’s start by considering the following scenario. 
A collaborator on our project has sent us the following function which can be used to add a
new column called `crew_size`  to our data containing the number of astronauts participating in any given spacewalk. 
How do we know that it works as intended and that it will not break the rest of our code?
For this, we need to write a test suite with a comprehensive coverage of the new code.
 
```r

#' Calculate the Size of the Crew
#'
#' This function calculates the number of crew members from a string containing
#' their names, separated by semicolons. The crew size is determined by counting
#' the number of crew members listed and subtracting 1 to account for an empty string
#' at the end of the list.  This function should be applied to a dataframe.
#'
#' @param crew A character string containing the names of crew members, separated by semicolons.
#'
#' @return An integer representing the size of the crew (the number of crew members).
#' @export
#'
#' @examples
#' calculate_crew_size("John Doe;Jane Doe;")  # Returns 2
#' calculate_crew_size("John Doe;")  # Returns 1
calculate_crew_size <- function(crew) {
  # Use purrr::map_int to iterate over each crew element and return an integer vector
  purrr::map_int(crew, function(c) {
    trimmed_crew <- stringr::str_trim(c)
    if (trimmed_crew == "") {
      return(NA_integer_)  # Return NA as an integer (NA_integer_)
    } else {
      crew_list <- stringr::str_split(c, ";")[[1]]
      return(length(crew_list) - 1)  # Return the number of crew members (excluding the last empty string)
    }
  })
}
    
```

Let's add this function to
`R/eva_data_analysis.R` and update `analysis/run_data_analysis.R` to include it.

```r
run_analysis <- function(input_file, output_file, graph_file) {
  cat("--START--\n")

  eva_data <- read_json_to_dataframe(input_file)
  
  eva_data <- eva_data |> # Add this line
    mutate(crew_size = calculate_crew_size(crew)) # Add this line

  write_dataframe_to_csv(eva_data, output_file) # Add this line

  plot_cumulative_time_in_space(eva_data, graph_file)
  generate_summary_table(eva_data, "crew_size", "analysis/tables/summary_table.html")
  cat("--END--\n")
}


::: checklist

Remember to "Clean and Install" (Build panel) to make sure that our changes have been installed.

:::


```

### Writing good tests

The aim of writing good tests is to verify that each of our functions behaves as expected with the full range of inputs 
that it might encounter.
It is helpful to consider each argument of a function in turn and identify the range of typical values it can take.
Once we have identified this typical range or ranges (where a function takes more than one argument), we should:

-   Test all values at the edge of the range
-   Test at least one interior point
-   Test invalid values

Let's have a look at the `calculate_crew_size` function from our colleague's new code and write some tests for it.

:::::: challenge

### Unit tests for calculate_crew_size

Implement unit tests for the `calculate_crew_size` function. 
Cover typical cases and edge cases.

Hint - use the following template when writing tests:
```         
test_that("MYFUNCTION ...", {
    """
    Test that ...   #FIXME
    """
    
    # Typical value 1
    actual_result <-  _______________ #FIXME
    expected_result <- ______________ #FIXME
    expect_equal(actual_result == expected_result, tolerance = 1e-6)
    
    # Typical value 2
    actual_result <-  _______________ #FIXME
    expected_result <- ______________ #FIXME
    expect_equal(actual_result == expected_result, tolerance = 1e-6)
}
```

::: solution

We can add the following test functions to out test suite.

```r

test_that("calculate_crew_size returns correct values for typical crew inputs", {
  
  # First test case
  actual_result_1 <- calculate_crew_size("Valentina Tereshkova;")
  expected_result_1 <- 1
  expect_equal(actual_result_1, expected_result_1)
  
  # Second test case
  actual_result_2 <- calculate_crew_size("Judith Resnik; Sally Ride;")
  expected_result_2 <- 2
  expect_equal(actual_result_2, expected_result_2)
  
})


# Edge cases
test_that("calculate_crew_size returns expected value for an empty crew string", {
  actual_result <- calculate_crew_size("")
  expect_true(is.na(actual_result))
})

```

Let's run out tests:

```r
testthat::test_dir("tests/testthat")
```

```output
> testthat::test_dir("tests/testthat")
✔ | F W  S  OK | Context
✔ |          5 | eva_data_analysis                                                                            

══ Results ═══════════════════════════════════════════════════════════════════════════════════════════════════
[ FAIL 0 | WARN 0 | SKIP 0 | PASS 5 ]
```
:::
::::::


### Just enough tests

In this episode, so far we have (only) written tests for two individual functions: `text_to_duration` and 
`calculate_crew_size`.

We can quantify the proportion of our code base that is run (also referred to as "exercised") by a given test suite 
using a metric called code coverage:

$$ \text{Line Coverage} = \left( \frac{\text{Number of Executed Lines}}{\text{Total Number of Executable Lines}} \right) \times 100 $$

We can calculate our test coverage using the `covr` package as follows.

```r
install.packages("covr")
install.packages("DT")
install.packages("htmltools")

library(covr)
coverage <- package_coverage()
```

``` output
> coverage
spacewalks Coverage: 40.00%
R/eva_data_analysis.R: 40.00%
```

To get an in-depth report about which parts of our code are tested and
which are not , we can run:

```r
 covr::report(coverage)
```

This option generates a report in the RStudio viewer. 
This provides structured information about our test coverage including: 

- a table showing the proportion of lines in each file that are currently tested, and 
- an annotated copy of our code where untested lines are highlighted in red.

Ideally, all the lines of code in our code base should be exercised by at least one test. 
However, if we lack the time and resources to test every line of our code we should:

- avoid testing R's built-in functions or functions imported from well-known and well-tested libraries like 
`dplyr` or `ggplot2`.
- focus on the the parts of our code that carry the greatest "reputational risk", i.e. that could affect the accuracy 
of our reported results.

::: callout

Test coverage of less than 100% indicates that more testing may be helpful.

Test coverage of 100% does not mean that our code is bug-free.

:::

::: challenge

### Evaluating code coverage

Generate the code coverage report for your compendium using the ` covr::report(coverage)` command.

Inspect the report generated and extract the following information:

a.  What proportion of the code base is currently "not" exercised by the test suite?
b.  Which functions in our code base are currently untested?

::: solution

a.   The proportion of the code base NOT covered by our tests is ~60% (100% - 40%) - this may differ for your 
version of the code.
b.  You can find this information by checking which functions in the annotated source code
section of the report contain red (untested) lines. 
The following functions in our code base are currently untested:
    -   read_json_to_dataframe
    -   write_dataframe_to_csv
    -   add_duration_hours_variable
    -   plot_cumulative_time_in_space
    -   add_crew_size_variable

:::

:::

## Summary

During this episode, we have covered how to use tests to verify
the correctness of our code. We have seen how to write a unit test, how
to manage and run our tests using the `testthat` framework and how to identify
which parts of our code require additional testing using test coverage
reports.

These skills reduce the probability that there will be a mistake in our
code and support reproducible research by giving us the confidence to
engage in open research practices. 
Tests also document the intended behaviour of our code for other developers and mean that we can
experiment with changes to our code knowing that our tests will let us
know if we break any existing functionality. 


## Further reading

We recommend the following resources for some additional reading on the
topic of this episode:

- [Testing basics][r-pkg-testing] from Wickham, H., & Bryan, J. (2023). R Packages. O’Reilly
- [Testthat package documentation][test-that-pkg]

Also check the [full reference set](learners/reference.md#litref) for
the course.

::: keypoints
 1 . Code testing supports reproducibility by demonstrating that your code behaves as
    you expect and consistently generates the same output with a given set of inputs.
2.  Unit testing is crucial as it ensures each functions works
    correctly.
3.  Using the `testthat` package  you can write basic unit tests for R functions 
    to verify their correctness.
4.  Identifying and handling edge cases in unit tests is essential to
    ensure your code performs correctly under a variety of conditions.
5.  Test coverage can help you to identify parts of your code that
    require additional testing.
:::

## Attribution
This episode reuses material from the [“Code Correctness”][fair-software-course-documentation] episode of the Software Carpentries Incubator course ["Tools and practices of FAIR research software”][fair-software-course] under a [CC-BY-4.0](https://creativecommons.org/licenses/by/4.0/deed.en) with modifications
(i) adaptations  have been made to make the material suitable for an audience of  R users (e.g. replacing “software” with “code” in places, pytest with testthat), (ii) all code has been ported from Python to  R  (iii) Objectives, Questions, Key Points and Further Reading sections have been updated to reflect the remixed R focussed content.   
