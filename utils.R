source('functions.R')
library(pacman)
p_load(plyr, tidyverse, tidymodels, recipes)

df.iqms <- read.csv(in.data, sep = ifelse(grepl('.tsv', in.data), '\t', ","))
# * read in input dataframe
df.top_models <- readRDS("models/radiolQAclassifier_modelmap.RDS")
# * read in model mapping
if (!dir.exists(out.dir)) {dir.create(out.dir)}
#  * check if output directory exists
out_file <- paste0(out.dir, 'results_radiolQA_',format(today(), "%Y%m%d"),  '.csv')
# * output results file
cols.ratings <- c("motion", "flow_ghosting", "quality")
#  * rating types 
df.clean <- func.format_df(df.iqms)
# * format df for classifier 
sequences <- unique(df.clean$modality)[unique(df.clean$modality) %in% c('T1w', 'T2w', 'FLAIR')]
# * sequences in input dataframe


lst.true <- list('artifact'=  c('bad' ='severe', 'mild'='moderate', 'ok'='mild', 
                            'good'='none', 'outside'='outside'), 
                 'quality' = c('bad' ='poor', 'mild'='suboptimal', 'ok'='acceptable',
                               'good'='above average', 'great'='excellent'))
# * label formatting for  labels

# * terminal formatting
full_brk <- "\n__________________________________________________________\n"
dot_brk <- "\n----------------------------------------------------------\n"
dot_mid <- "----------------------------------------------------------"
full_mid <-"__________________________________________________________"