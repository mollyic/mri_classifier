

func.format_df <- function(df){
  # ----------------------------------------------------------
  #   -  Format dataframe for inputting to  classifier 
  # ----------------------------------------------------------
  
  df <- df %>%
    mutate(modality = str_extract(df$bids_name, "(T1w|T2w|FLAIR)$")) %>%
    relocate(modality, .after = bids_name)
}


func.format_colnames <- function(df){
  # ----------------------------------------------------------
  #   -  Format dataframe for inputting to  classifier 
  # ----------------------------------------------------------
  factorfacts <- unlist(lapply('factor_', paste0, lst.artifacts))
  
  df <- df %>%
    mutate(across(all_of(cols.ratings[cols.ratings != 'quality']), 
                  ~ recode(round(.), '1' = 'bad','2' = 'mild','3' = 'ok','4' = 'good','5' = 'outside'),
                  .names = "factor_{.col}"),
           .after = cols.ratings[length(cols.ratings)]) %>%
    mutate(factor_quality = recode(round(quality), '1' = 'bad','2' = 'mild','3' = 'ok','4' = 'good','5' = 'great'),
           .after = cols.ratings[length(cols.ratings)]) %>%
    rename_with(~ paste0("avg_", .), .cols = all_of(cols.ratings))
  return(df)
}
