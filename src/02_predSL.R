###==============================###
### Nima Hejazi & Alan Hubbard   ###
### CRM Workshop and Conference  ###
### Montreal, Canada, July 2016  ###
### Causal Inference Competition ###
### Script #3: Imputation w/ SL  ###
###==============================###

library(SuperLearner)
SL.library <- c("SL.loess", "SL.glm", "SL.bayesglm", "SL.stepAIC", "SL.gam",
                "SL.mean")

# generate observed data and find variables with missingness
obs_O <- as.data.frame(micedata[, c(5:26), with = FALSE])
varsNA <- names(which(is.na(colSums(obs_O, na.rm = FALSE))))

# variable scaling
scaled_O <- scale(obs_O)

yfit <- list()  #store predicted values over all folds of cross-validation

for (idx in 1:length(varsNA)) {
  set.seed(0)
  #get prediction covariate
  y <- subset(scaled_O, select = varsNA[idx])
  y <- as.vector(y[, 1])

  #make missingness indicators for other covariates
  indNA <- list()
  varsNAind <- varsNA[varsNA %ni% varsNA[idx]]
  for (i in 1:length(varsNAind)) {
    indicatorNA <- as.integer(!is.na(scaled_O[, varsNAind[i]]))
    indNA[[i]] <- indicatorNA
  }

  #generate indicators and remove testing covariate from training data structure
  I <- data.frame(matrix(unlist(indNA), nrow = nrow(scaled_O), byrow = TRUE))
  X <- subset(scaled_O, select = colnames(scaled_O) !=varsNA[idx])

  #replace all missing values in training/testing data structures with zeros
  X[is.na(X)] <- 0
  y[is.na(y)] <- 0

  #add indicator variables to training data structure
  X <- cbind(X, I)

  #use SuperLearner to predict missing gene Y
  yfit.SL <- SuperLearner(y, X, family = gaussian(), SL.library = SL.library,
                          verbose = TRUE)
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

# pass SL predicted values from list to dataframe <-- SEEMS INCORRECT
yfit.pred <- data.frame(matrix(unlist(yfit_untrans), nrow = nrow(scaled_O),
                               byrow = TRUE))

# replace missing values in original data structure with predicted values
res_O <- obs_O  #make copy to avoid overwriting original observed data strucutre
for (i in 1:length(yfit_untrans)) {
  res_O[which(is.na(res_O[, varsNA[i]])),
        varsNA[i]] <- yfit_untrans[[i]][which(is.na(res_O[, varsNA[i]]))]
}

# clean up workspace a bit
rm("i", "idx", "indicatorNA", "indNA", "SL.library", "varsNAind", "yfit.SL",
   "I", "X", "y", "yfit", "scaled_O")

#EndScript
