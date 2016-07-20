###==============================###
### Nima Hejazi & Alan Hubbard   ###
### CRM Workshop and Conference  ###
### Montreal, Canada, July 2016  ###
### Causal Inference Competition ###
### Script #4: SL Visualizion    ###
###==============================###

library(ggplot2); library(plotly)
Sys.setenv("plotly_username" = "nhejazi")
Sys.setenv("plotly_api_key" = "73h2ov8u7o")

# make dataframes for linear model ggplots with predicted fits + observed data
covar_lm <- list()
for (i in 1:ncol(O.varsNA)) {
  true_tmp <- O.varsNA[-which(is.na(O.varsNA[, i])), i]
  fits_tmp <- yfit.pred[-which(is.na(O.varsNA[, i])), i]
  covar_lm[[i]] <- as.data.frame(cbind(fits_tmp, true_tmp))
}
rm(true_tmp, fits_tmp)

cv_r2 <- list()
for(i in 1:ncol(O.varsNA)) {
  cv_r2[[i]] <- 1 - var(covar_lm[[i]]$fits_tmp -
                        covar_lm[[i]]$true_tmp) / var(covar_lm[[i]]$true_tmp)
}
cv_r2 <- as.data.frame(unlist(cv_r2))
names(cv_r2) <- "R2"

# make ggplots + post to Plotly
for (i in 1:length(covar_lm)) {
  p <- ggplot(covar_lm[[i]], aes(fits_tmp, true_tmp))
  p <- p+ stat_smooth(method = "lm") + geom_point()
  p <- p + ggtitle(paste0(as.character(subset(codebook, ph == varsNA[i])$nam),
                          "\n fitted values vs. observed data (",
                          "R^2 = ", sprintf("%.3f", cv_r2[i, 1]), ")"))
  p <- p + xlab("Fitted Values") + ylab("Observed Values")
  ggplotly(p)
  plotly_POST(p, paste0("Analysis of SuperLearner Fits",
                        as.character(varsNA[i])))
}

#EndScript
