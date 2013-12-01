# UKBroadband

## Introduction
See [http://www.digitalcontraptionsimaginarium.co.uk/ukbroadband/](http://www.digitalcontraptionsimaginarium.co.uk/ukbroadband/).

This repository is made of two branches:
- The **master** branch is just the R script to download from data.gov.uk and pre-process the Ofcom data.
- The **gh-pages** branch is the website referenced above, that includes simple search by postcode functionality over the Ofcom data. It does not require any server-side scripting and can be hosted on GitHub Pages.

To run the pre-processing stage, just run:

	$ rscript preprocess.R 

Then, copy the _data_ folder over the folder of the same name in the gh-pages branch.

## MIT License
Copyright (c) 2013 Gianfranco Cecconi

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

Please take into account that bbsub is a wrapper to get_iplayer, and when using bbsub you should consider the implications of using get_iplayer in the first place and respect the content providers’ wishes and fair-use legislation in your jurisdiction.