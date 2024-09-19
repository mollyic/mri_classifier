
dir.results
#
model.lastfit <- readRDS(paste0('/models/', model.name))


#INPUT classifier results files 
csv.in_data <- 'test.csv'
#     * Metrics
df.iqms <- read.csv(csv.in_data)
