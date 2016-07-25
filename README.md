# CRM Causal Inference Challenge, 2016 July

This repository contains materials for an entry into the [causal inference
challenge](http://www.crm.umontreal.ca/2016/Genetics16/competition_e.php) held
at the [Centre de Recherches Mathématiques (CRM)
workshop](http://www.crm.umontreal.ca/2016/Genetics16/index_e.php) for the short
thematic program on "Statistical Causal Inference and Applications to Genetics,"
25-29 July 2016 in Montreal, Canada.

For details about the competition objectives and the data set, consult [this
link](http://www.crm.umontreal.ca/2016/Genetics16/competition_e.php).

__N.B.__, a link to the competition data set is included with this repository as
a git submodule. To clone this repo, use:

```bash
git clone --recursive https://github.com/nhejazi/CRM_CausalComp2016.git
```

...and, to properly update the data set via the git submodule link, simply use:

```bash
git submodule foreach git pull origin master
```

---

## Directions/Roadmap

The workflow for running the preprocessing and analysis scripts for this project
is described below:

* `munge/` - contains preprocessing scripts for wrangling the data into a form
    suitable for downstream analyses.
* `src/` - contains analysis scripts for using the SuperLearner method for
    prediction and creating visualizations.
* `poster/` - contains the TeX source file (and supplementary files) for the
    poster presented in the competition.
* This project uses [R/ProjectTemplate](http://projecttemplate.net/index.html)
    for organizational purposes. See `ProjectTemplate.md` for detailed info.

---

## Reference

* [Mark J. van der Laan, Eric C. Polley, and Alan E. Hubbard. "Super Learner".
  _Statistical applications in genetics and molecular biology_, 6(1),
  2007.](http://biostats.bepress.com/ucbbiostat/paper222/)

---

## License

&copy; 2016 [Nima Hejazi](http://www.nimahejazi.org) & [Alan
Hubbard](http://hubbard.berkeley.edu)

This repository is licensed under the MIT license. See `LICENSE` for details.
