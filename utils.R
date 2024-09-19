#DF VARIABLES
cols.ratings<- c(names(df.iqms)[grep('avg_', names(df.iqms))], 
                 names(df.iqms)[grep('factor_', names(df.iqms))])
in.metrics <- names(df.iqms)[!(names(df.iqms) %in% c(cols.ids, cols.ratings, exclude))]

cols.ratings<- c('motion|quality|flow_ghosting|susceptibility')

names(df.iqms)[grep(cols.ratings, names(df.iqms))]


func.format_colnames <- function(df){
  # ----------------------------------------------------------
  #   -  Format dataframe for inputting to  classifier 
  # ----------------------------------------------------------
  
    df.pyqa <- df.pyqa %>%
      mutate(bids_name = gsub('.nii.gz', '',scan), .before=scan)%>%
      #mutate(modality = str_extract(bids_name, "(T1w|FLAIR|T2w)$", group = NULL), .before=scan)%>%
      rename(quality = rating) %>%
      mutate(avg_quality = quality,
             avg_susceptibility = susceptibility,
             avg_motion = motion,
             avg_flow_ghosting = flow_ghosting) %>%
      mutate(across(c("avg_motion", "avg_susceptibility", "avg_flow_ghosting"), ~ifelse(. == 5, NA, .)))
    
    cols.keep <- names(df.pyqa)[names(df.pyqa) %in% names(merged.avg)]
    df.pyqa_out <- df.pyqa[cols.keep]
    df.pyqa_out <- func.format_factors(df.pyqa_out)
    
    df.qc_pyqa <- left_join(df.pyqa_out, df_mriqc, by='bids_name')
    
    write.csv(df.qc_pyqa, csv.out_pyqa_mriqc, row.names = F)
  }else{
    cat('\n File exists: \n\t * File: ', basename(csv.out_pyqa_mriqc), 
        '\n\t * Directory: ', dirname(csv.out_pyqa_mriqc), sep = '')
    df.qc_pyqa <- read.csv(csv.out_pyqa_mriqc, row.names = 1)
  }
  return(df.qc_pyqa)
}