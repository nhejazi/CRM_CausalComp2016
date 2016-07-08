__Meeting - 6 July 2016__
* make CV predictions measure for a subset of the covariates
* with CV residuals, 1 - (Var(residuals)/Var(outcome)) gives CV R^2
* plots of observed vs. predicted for all covariates with missingness
  * just ignore those measurements with no missingness
* use Alan's shiny app, feeding in the matrix as is (no indicators)
* for potential causal DAG:
  * estimate variable importance for each covariate, adjusting based on
      relatedness by some metric
  * connect nodes (covariates), after adjustment based on some cutoff for the
      chosen variable importance metric
  * using conditional independence, no need for assumption of multivariate
      Gaussian.
