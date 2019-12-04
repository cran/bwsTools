# bwsTools

Tools for Case 1 Best-Worst Scaling (MaxDiff) Designs

### Installation

An in-development version of this package can be installed using the `devtools` package:

```
devtools::install_github("markhwhiteii/bwsTools")
```

### Contents

- Aggregate estimates, based on: analytical estimation of the multinomial logit model using `ae_mnl()`

- Individual estimates, based on: difference scores (best minus worst) using `diffscoring()`, random walks in directed networks using `walkscoring()`, empirical Bayes using `e_bayescoring()`, Elo scores using `eloscoring()`, and page rank scores using `prscoring()`

- A data.frame of balanced incomplete block designs for creating these studies, `bibds`, and a function to generate a balanced incomplete block design from this, `make_bibd()`
