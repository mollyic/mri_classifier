source('functions.R')
library(pacman)
p_load(plyr, tidyverse, tidymodels, recipes)


model.dir <- 'models/predict_models_20092024/'
model.dir <- 'models/'

df.iqms <- read.csv(in.data, sep = ifelse(grepl('.tsv', in.data), '\t', ","))
# * read in input dataframe
df.top_models <- readRDS(paste0(model.dir, "/radiolQAclassifier_modelmap.RDS"))
# * read in model mapping
if (!dir.exists(out.dir)) {dir.create(out.dir)}
#  * check if output directory exists
out_file <- paste0(out.dir, out.filestr, format(today(), "%Y%m%d"),  '.csv')
# * output results file
cols.ratings <- c("motion", "quality") 
#  * rating types 
df.clean <- func.format_df(df.iqms)
# * format df for classifier 
sequences <- unique(df.clean$modality)[unique(df.clean$modality) %in% c('T1w', 'T2w', 'FLAIR')]
# * sequences in input dataframe


lst.true <- list('artifact'=  c('bad' ='severe', 'mild'='moderate', 'ok'='mild', 
                            'good'='none', 'outside'='outside'), 
                 'quality' = c('bad' ='poor', 'mild'='suboptimal', 'ok'='acceptable',
                               'good'='above average', 'great'='excellent'))

lst.scores <- list('artifact'=  c('bad' =1, 'mild'=2, 'ok'=3, 
                                'good'=4, 'outside'=5), 
                 'quality' = c('bad' =1, 'mild'=2, 'ok'=3,'good'=4, 'outside'=5))
# * label formatting for  labels

# * terminal formatting
full_brk <- "\n__________________________________________________________\n"
dot_brk <- "\n----------------------------------------------------------\n"
dot_mid <- "----------------------------------------------------------"
full_mid <-"__________________________________________________________"

cols.subset <- c('bids_name', 'modality', 
                 'avg_quality', 'avg_motion', 'avg_susceptibility', 'avg_flow_ghosting')