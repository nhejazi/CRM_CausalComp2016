###==============================###
### Nima Hejazi & Alan Hubbard   ###
### CRM Workshop and Conference  ###
### Montreal, Canada, July 2016  ###
### Causal Inference Competition ###
### Script #2: Impute using SL   ###
###==============================###

library(SuperLearner)
SL.library <- c("SL.mean", "SL.glm", "SL.bayesglm", "SL.stepAIC", "SL.gam",
                "SL.randomForest", "SL.nnet")
CV_folds = 10

obs_O <- as.data.frame(micedata[, c(5:26), with = FALSE])

yfit <- list()

for (idx in 1:length(missvars)) {
  set.seed(0)
  #organize data into learning matrix and prediction set
  y_idx <- which(colnames(obs_O) == missvars[idx])
  y <- as.vector(subset(obs_O, select = y_idx)[, 1])
  X <- subset(obs_O, select = -y_idx)

  #get rid of all missing values remaining in training data
  X[is.na(X)] <- 0  #many other options for imputation, zero just to start

  #use SuperLearner with 10-fold cross-validation to predict missing gene Y
  yfit.SL <- CV.SuperLearner(y, X, V = CV_folds, family = gaussian(),
                             SL.library = SL.library, verbose = TRUE)
  yfit[[idx]] <- yfit.SL$SL.predict
}

# to be continued...
# need to test whether this actually does what it seems to
