source('config.R')
source('utils.R')


cat(dot_brk, '\n MRI Radiologist classifier \n', dot_brk,
    '\n Input mriqc file:             ', basename(in.data), 
    '\n\t * Assessing:', 
    '\n\t\t * MRI scans:               ', length(unique(df.iqms$bids_name)), 
    '\n\t\t * Sequences:               ', sequences, 
    '\n\t\t * Rating types:            ', paste0(cols.ratings, collapse= ', ')
) 


out.results <- data.frame()
for (seq in sequences){
  df.subset <- df.clean %>% filter(modality == seq)

  out.seq_results <- df.subset %>% 
    select(all_of(c('bids_name', 'modality')))  
  cat('\n\n Assessing ', seq, ' scans (n=',nrow(df.subset),'):', sep ='')
  for (rate in cols.ratings){
    
    tmp_row <- df.top_models[df.top_models$rating_type == rate & df.top_models$seq == seq,]
    rating_type <- tmp_row$rating_type
    model <- tmp_row$model
    pccomps <- tmp_row$pccomps
    model.name <- paste0(toupper(tmp_row$mode), '_model-',model,'_', tmp_row$in_file, '.rds')

    # * extract model 
    set.seed(123)
    model.file <- paste('models',seq, model.name, sep ='/')
    model.lastfit <- readRDS(model.file)
    model.wf <- extract_workflow(model.lastfit)
    model.fit <- model.wf %>% 
      extract_fit_parsnip()
    
    factor_type <- ifelse(rate == 'quality', 'quality', 'artifact')
    true_label <- lst.true[[factor_type]]
    
    cat('\n\t * ', rate, ' model: ', basename(model.file), sep ='')
    predictions <- predict(model.wf, df.subset)
    out.seq_results[[rate]] <- true_label[predictions$.pred_class]

  }
  out.results <- bind_rows(out.results, out.seq_results)
}


write.csv(out.results, out_file)
cat(dot_brk, '\n All compatible scans classified! \n',
    '\n\t * Output file:             ', out_file, '\n', dot_brk) 
