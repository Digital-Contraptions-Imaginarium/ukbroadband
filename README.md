# UKBroadband

![Creative Commons License](http://i.creativecommons.org/l/by/4.0/88x31.png "Creative Commons License") This work is licensed under a [Creative Commons Attribution 4.0 International License](http://creativecommons.org/licenses/by/4.0/).

## Introduction
See [http://www.digitalcontraptionsimaginarium.co.uk/ukbroadband/](http://www.digitalcontraptionsimaginarium.co.uk/ukbroadband/).

This repository is made of two branches:
- The **master** branch is just the R script to download from data.gov.uk and pre-process the Ofcom data.
- The **gh-pages** branch is the website referenced above, that includes simple search by postcode functionality over the Ofcom data. It does not require any server-side scripting and can be hosted on GitHub Pages.

To run the pre-processing stage, just run:

	$ rscript preprocess.R 

Then, copy the _data_ folder over the folder of the same name in the _gh-pages_ branch.

