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



for (i in 1:length(varsNA)) {
  p <- ggplot(obs_O, aes_string(x = varsNA[i]))
  p <- p + ggtitle(paste0("Histogram of ",
                          as.character(subset(codebook, ph == varsNA[i])$nam)))
  p <- p + geom_histogram(aes(fill = ..count..))
  p <- p + scale_fill_gradient("Count", low = "green", high = "red")
  ggplotly(p)
  plotly_POST(p, paste0("Histogram of ", as.character(varsNA[i])))
}

#EndScript
