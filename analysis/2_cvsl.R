###==============================###
### Nima Hejazi & Alan Hubbard   ###
### CRM Workshop and Conference  ###
### Montreal, Canada, July 2016  ###
### Causal Inference Competition ###
### Script #2: Imputation & SL   ###
###==============================###

library(SuperLearner); library(mice)
SL.library <- c("SL.loess", "SL.glm", "SL.bayesglm", "SL.stepAIC", "SL.gam",
                "SL.mean")
CV_folds = 10

# generate observed data and find variables with missingness
obs_O <- as.data.frame(micedata[, c(5:26), with = FALSE])
obs_O.missing <- md.pattern(obs_O)
varsNA <- names(which(is.na(colSums(obs_O, na.rm = FALSE))))

# imputation and variable scaling
obs_O.impute <- obs_O
obs_O.impute[is.na(obs_O.impute)] <- 0  #Zero replacement, try empirical Bayes
O.imputed.scaled <- scale(obs_O.impute)

yfit <- list()  #store predicted values over all folds of cross-validation

for (idx in 1:length(varsNA)) {
  set.seed(0)
  #get prediction covariate
  y <- subset(O.imputed.scaled, select = varsNA[idx])
  y <- as.vector(y[, 1])

  #get covariates for training
  X <- subset(O.imputed.scaled,
              select = colnames(O.imputed.scaled) !=varsNA[idx])
  X <- as.data.frame(X)

  #get rid of all missing values remaining in training data
  #X[is.na(X)] <- 0  #many other options for imputation, zero just to start

  #use SuperLearner with 10-fold cross-validation to predict missing gene Y
  yfit.SL <- CV.SuperLearner(y, X, V = CV_folds, family = gaussian(),
                             SL.library = SL.library, verbose = TRUE)
  yfit[[idx]] <- yfit.SL$SL.predict
}

# find indices of missing values for covariates with missingness
indNA <- list()
for (i in 1:sum(is.na(colMeans(obs_O)))) {
  indNA[[i]] <- which(is.na(obs_O[,varsNA[i]]))
}

# un-normalize predicted values from the SuperLearner
yfit_untrans <- list()
for (i in 1:length(yfit)) {
  yfit_untrans[[i]] <- (yfit[[i]]*sd(obs_O[, varsNA[i]], na.rm = TRUE)) +
                       mean(obs_O[, varsNA[i]], na.rm = TRUE)
}

# replace missing values in original data structure with predicted values
for (i in 1:length(yfit_untrans)) {
  obs_O[which(is.na(obs_O[,varsNA[i]])), varsNA[i]] <- yfit_untrans[[i]][which(is.na(obs_O[, varsNA[i]]))]
}

# clean up workspace a bit
rm("i", "idx", "O.imputed.scaled", "obs_O.impute", "obs_O.missing", "yfit.SL",
   "X", "y", "yfit_untrans")

#EndScript
