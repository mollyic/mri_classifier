

#check dataframe for column names matching types 

# Using for loop to iterate through rows
for (i in 1:nrow(df.iqms)) {
  print(df.iqms[i, ]$mo)
  
}
