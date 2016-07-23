###==============================###
### Nima Hejazi & Alan Hubbard   ###
### CRM Workshop and Conference  ###
### Montreal, Canada, July 2016  ###
### Causal Inference Competition ###
### Script #2: Exploratory Vis.  ###
###==============================###


# basic programmatic housekeeping
proj_path <- paste0(path.expand("~"), "/git_repos/CRM_CausalComp2016")
library(ggplot2); library(GGally); library(qgraph); library(corrr)
library(ProjectTemplate)
set.seed(0)
if( getwd() != proj_path) setwd(proj_path)
load.project()


# generate data frame with only genomic covariates
data_genomic <- micedata %>%
                  na.omit() %>%
                  dplyr::select(which(substr(colnames(.),1,4) %in% "IMPC"))


# examine and plot correlation structure in genomic covariates
pdf(paste0(proj_path, "/figs/genes_correlationPlot.pdf"))
corr_genomic <- data_genomic %>%
                  correlate() %>%
                    rearrange()
rplot(corr_genomic) + theme(axis.text.x = element_text(angle = 90,
                                                       hjust = 1, vjust = 0.5))
dev.off()


# generating correlation undirected acyclic graph with qgraph
pdf(paste0(proj_path, "/figs/genes_correlationGraph.pdf"))
p.corr_graph <- qgraph(cor(data_genomic), layout = "spring", node.width = 0.5,
                       labels = codebook$nam, label.scale = FALSE,
                       label.cex = 1)
dev.off()


# generating sparse graph above from Graphical Lasso using qgraph
pdf(paste0(proj_path, "/figs/genes_glassoGraph.pdf"))
p.glasso_graph <- qgraph(cor(data_genomic), layout = "spring", graph = "glasso",
                         sampleSize = nrow(micedata), labels = codebook$nam,
                         label.scale = FALSE, label.cex = 1, node.width = 0.5)
dev.off()
