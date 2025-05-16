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
       select(any_of(cols.subset)) 

  cat('\n\n Assessing ', seq, ' scans (n=',nrow(df.subset),'):', sep ='')
  for (rate in cols.ratings){
    
    tmp_row <- df.top_models[df.top_models$rating_type == rate & df.top_models$seq == seq,]
    model.name <- paste0(toupper(tmp_row$mode), '_model-',tmp_row$model,'_', tmp_row$in_file, '.rds')
    model.name <- tmp_row$model_name
    #model.name <- paste0(model.dir, basename(tmp_row$model_file))
    
    # * extract model 
    set.seed(123)
    model.file <- paste(model.dir, seq, model.name, sep ='/')
    model.lastfit <- readRDS(model.file)
    #model.wf <- extract_workflow(model.lastfit)
    #model.recipe <- extract_recipe(model.wf)

    model.info <- model.recipe$var_info
    pred_cols <- model.info[model.info$role == 'predictor', ]$variable
    cat('\n\t * ', rate, ' model: ', basename(model.file), sep ='')
    predictions <- predict(model.lastfit, new_data = df.subset)
    
    factor_type <- ifelse(rate == 'quality', 'quality', 'artifact')
    true_label <- lst.true[[factor_type]]
    true_score <- lst.scores[[factor_type]]
    
    out.seq_results[[rate]] <- true_label[predictions$.pred_class]
    out.seq_results[[paste0(rate, '_score')]] <- true_score[predictions$.pred_class]
  }
  out.results <- bind_rows(out.results, out.seq_results)
}

# out.results <-out.results %>% 
#   rename(true_motion = avg_motion) %>%
#   rename(true_quality = avg_quality) %>%
#   rename(true_suscep = avg_susceptibility) %>%
#   rename(true_flowghost = avg_flow_ghosting)
write.csv(out.results, out_file)
cat(dot_brk, '\n All compatible scans classified! \n',
    '\n\t * Output file:             ', out_file, '\n', dot_brk) 


# library(pROC)
# test <- out.results[out.results$modality == 'T1w', ]
# roc_curve <- multiclass.roc(test$true_quality, test$quality_score)
