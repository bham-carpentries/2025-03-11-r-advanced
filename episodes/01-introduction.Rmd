---
title: "Course introduction"
teaching: 30
exercises: 0
---

:::::::::::::::::::::::::::::::::::::: questions 

- What is reproducible research?
- Why is it important?

::::::::::::::::::::::::::::::::::::::::::::::::

::::::::::::::::::::::::::::::::::::: objectives

After completing this episode, participants should be able to:

- Understand the concept of reproducible research

::::::::::::::::::::::::::::::::::::::::::::::::


## Jargon busting
Before we start with the course, below we cover the terminology and explain terms, phrases, and 
concepts associated with software development in reproducible research that we will use in this course.

* **Reproducibility** - the ability to be reproduced or copied; the extent to which consistent results are obtained
when an experiment is repeated (definition from [Google’s English dictionary is provided by Oxford Languages][google-oxford-dict])
* **Computational reproducibility** - obtaining consistent results using the same input data, computational methods (code),
and conditions of analysis; work that can be independently recreated from the same data and the same code 
([definition][ttw-reproducibility-def] 
by the [Turing Way's "Guide to Reproducible Research"][ttw-guide-reproducible-research])
* **Reproducible research** - the idea that scientific results should be documented in such a way that their deduction
is fully transparent ([definition][wiki-reproducibility-def] from Wikipedia)
* **Open research** - research that is openly accessible by others; concerned with making research more transparent, 
more collaborative, more wide-reaching, and more efficient 
([definition][wiki-open-research-def] from Wikipedia)
* **FAIR** - an acronym that stands for Findable, Accessible, Interoperable, and Reusable
* **Sustainable software development** - software development practice that takes into account longevity and 
maintainability of code (e.g. beyond the lifetime of the project), environmental impact, societal responsibility and ethics in 
our software practices. 

::: callout
## Computational reproducibility

In this course, we use the term "reproducibility" as a synonym for "computational reproducibility".
:::


## What is reproducible research?

[The Turing Way's "Guide to Reproducible Research"][ttw-guide-reproducible-research]
provides an [excellent overview of definitions of "reproducibility" and "replicability"][ttw-reproducibility-def] found in literature, 
and their different aspects and levels. 

In this course, we adopt the Turing Way's definitions: 

* **Reproducible research**: a result is reproducible when the same analysis steps performed on the same data 
consistently produce the same answer.
  * For example, two different people drop a pen 10 times each and every time it falls to the floor. Or, we run the same code multiple times on different machines and each time it produces the same result.
* **Replicable research**: a result is replicable when the same analysis performed on different data produces 
qualitatively similar answers.
  * For example, instead of a pen, we drop a pencil, and it also falls to the floor. Or, we collect two different datasets as part of two different studies and run the same code over these datasets with the same result each time.
* **Robust research**: a result is robust when the same data is subjected to different analysis workflows to answer the 
same research question and a qualitatively similar or identical answer is produced.
  * For example, I lend you my pen and you drop it out the window, and it still falls to the floor. Or we run the same analysis implemented in both Python and R over the same data and it produces the same result.
* **Generalisable research**: combining replicable and robust findings allow us to form generalisable results 
that are broadly applicable to different types of data or contexts.
  * For example, everything we drop - falls, therefore gravity exists.

![*The Turing Way project illustration of aspects of reproducible research by Scriberia, used under a CC-BY 4.0 licence, [DOI: 10.5281/zenodo.3332807][ttw-illustrations]*](https://book.the-turing-way.org/build/reproducible-definit-dfbe86f062a65a8e4f5249be8529e953.svg){alt='Four cartoon images depicting two researchers at two machines which take in data and output the same landscape image in 4 different ways. These visually describe the four scenarios listed above.'}

In this course we mainly address the aspect of reproducibility - i.e. enabling others to run our code to obtain the same results.

:::::: callout

## The reproducibility spectrum 

As with most things, reproducibility is non-binary. Having access to code and data sometimes is good, but how about describing the specific version of each software and packaged used? Do you need to describe the operating system? How about the architecture of the CPU?

How exact should results be to be considered successfully reproduced? Do we expect identical result bit by bit? Or do we allow for small changes in non-significant digits, cosmetic variation in figures such as fonts or colours?

For these reasons instead of saying that a research project is reproducible or not, is often more helpful to say that a research project is more or less reproducible and harder or easier to reproduce. A project that publishes code and data but not software versions is probably harder to reproduce than one that provides the virtual machine in which the code was run.

::::::

## Why do reproducible research?

Scientific transparency and rigor are key factors in research. Scientific methodology and 
results need to be published openly and replicated and confirmed by several independent parties.
However, research papers often lack the full details required for independent reproduction or replication. 
Many attempts at reproducing or replicating the results of scientific studies have failed in a variety of disciplines 
ranging from psychology ([The Open Science Collaboration (2015)][replication-crisis-osc]) to 
cancer sciences ([Errington et al (2021)][replication-crisis-errington]).
These are called [**the reproducibility and replicability crises**][reproducibility-crisis] - ongoing
methodological crises in which the results of many scientific studies are difficult or impossible to repeat.

Reproducible research is a practice that ensures that researchers can repeat the same analysis multiple times with the 
same results. It offers many benefits to those who practice it:

* Reproducible research helps researchers remember how and why they performed specific tasks and analyses; 
this enables easier explanation of work to collaborators and reviewers. 
* Reproducible research enables researchers to quickly modify analyses and figures - this is often 
required at all stages of research and automating this process saves loads of time. 
* Reproducible research enables reusability of previously conducted tasks so that new projects 
that require the same or similar tasks become much easier and efficient by reusing or reconfiguring previous work. 
* Reproducible research supports researchers' career development by facilitating the reuse and citation of all research outputs - including both code and data.
* Reproducible research is a strong indicator of rigor, trustworthiness, and 
transparency in scientific research. This can increase the quality and speed of peer review, because reviewers can 
directly access the analytical process described in a manuscript. It increases the probability that errors are caught 
early on - by collaborators or during the peer-review process, helping alleviate the reproducibility crisis.  

## Other Considerations

An important consideration is that reproducible results are not necessarily scientifically, statistically or computationally correct -  incorrect results can be perfectly reproducible.[^2] 

As researchers, we often also want our work to be "computationally correct" and "reusable"- that is, the code we write should do what we think it does and we want to be able to use our code in future projects or related tasks without having to rewrite it from scratch.[^1]

## Tools and Practices
Developing high quality, reusable and reproducible research code often requires that 
researchers new practices.

This course teaches good practices and reproducible working methods for those working with R and aims to provide 
researchers with the tools and knowledge to feel confident when writing good quality and sustainable 
code to support their research. 

## Further reading

We recommend the following resources for some additional reading on the topic of this episode:

- [The Turing Way's "Guide for Reproducible Research"][ttw-guide-reproducible-research]
- [A Beginner's Guide to Conducting Reproducible Research][beginner-guide-reproducible-research],
  Jesse M. Alston, Jessica A. Rick, Bulletin of The Ecological Society of America 102 (2) (2021), https://doi.org/10.1002/bes2.1801
- ["Ten reproducible research things" tutorial][10-reproducible-research-things]
- [FORCE11's FAIR 4 Research Software (FAIR4RS) Working Group][fair4rs-working-group]
- ["Good Enough Practices in Scientific Computing" course][good-enough-practices]
- [Reproducibility for Everyone's (R4E) resources][repro4everyone], community-led education initiative to increase 
adoption of open research practices at scale
- [Curated resources][forrt-resources] by the [Framework for Open and Reproducible Research Training](https://forrt.org/) (FORRT)

## Acknowledgements and references
The content of this course borrows from or references [various work](learners/reference.md#litref).

## Attribution
This episode reuses material from the [“Introduction”][fair-software-course-intro] episode of Software Carpentries Incubator course ["Tools and practices of FAIR research software”][fair-software-course] under a [CC-BY-4.0](https://creativecommons.org/licenses/by/4.0/legalcode) licence with modifications: (i) minor edits have been made to make the material suitable for an audience of  R users (e.g. replacing “software” with “code” in places)  (ii) section  “Software in research and research software” from the original source has been renamed “Tools and Practices” and is shortened.  (iii) objectives, questions, keypoints and further reading have been edited to focus the material on reproducibility rather than FAIR (iv) Some original material has been introduced to maintain flow and is indicated by a footnoted reference. (v) The callout  “The reproducibility spectrum” has been added  verbatim from  the lesson [“What is reproducibility anyway”]repro-rocks-what] under [CC-BY-4.0](https://creativecommons.org/licenses/by/4.0/legalcode) from [“An R reproducibility toolkit for the practical researcher”][repro-rocks] by Elio Campitelli and Paola Corrales.  

[^1]: Original material.
[^2]: From “An R reproducibility toolkit for the practical researcher” by Elio Campitelli and Paola Corrales.  

