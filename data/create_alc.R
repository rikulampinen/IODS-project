# Script: "create_alc" ----

# Name: Richard E. Lamprecht
# Date: 11.11.2019

# CHAPTER 3: Logistic regression -------------------------------------------------------------------------------------

# The Analysis exercise focuses on exploring your data and performing and interpreting logistic regression analysis.
# For completing the Analysis exercises, include all the codes, your interpretations and explanations in the 
# RMarkdown file chapter3.Rmd. 


# 3.1. DATA WRANGLING ------------------------------------------------------------------------------------------------

# Check and set the working directory
getwd()
setwd("C:/Users/richla/OneDrive/1 C - R-Folder/11-IODS-course/IODS-project/")


# 3.1.1. Read the data from the csv files downloaded from the webpage ----


# read the mat data set
mat <- read.csv(file = "C:/Users/richla/OneDrive/1 C - R-Folder/11-IODS-course/IODS-project/data/student-mat.csv", 
                sep = ";", header = TRUE)

# read the por data set
por <- read.csv(file = "C:/Users/richla/OneDrive/1 C - R-Folder/11-IODS-course/IODS-project/data/student-por.csv", 
                sep = ";", header = TRUE)


# check the data sets

# mat data set
head(mat)
dim(mat)
str(mat)

# por data set
head(por)
dim(por)
str(por)


# 3.1.2. Join the two data sets mat & por using different variables as identifiers ----


library(dplyr) # load dplyr package

?inner_join # check the data join options of the dplyr package

# Variables as student identifiers:
# "school", "sex", "age", "address", "famsize", "Pstatus", "Medu", "Fedu", "Mjob", "Fjob", "reason", "nursery","internet" 
# students present in both data sets shall be kept


# The two data sets "mat" and "por" are merged by the common columns ("comcol") given

# define the common columns of the data set ("comcol")
comcol <- c("school","sex","age","address","famsize","Pstatus","Medu","Fedu","Mjob","Fjob","reason","nursery","internet")

comcol # check the input

# Join the two data sets
mat_por <- inner_join(mat, por, by = comcol, suffix = c(".mat", ".por"))

# check the new data set "mat_por"
dim(mat_por)
str(mat_por)
glimpse(mat_por)
colnames(mat_por)

# there are 53 variables with 382 observations (students)


# 3.1.3. Join the duplicates answers in the joined data ----


# Create a new data frame "alc" with only the common columns
alc <- select(mat_por, one_of(comcol))
dim(alc)
head(alc)

# Define the columns("no_com_col") that were not used for joining the data sets mat and por
no_com_col <- colnames(mat)[!colnames(mat) %in% comcol]

# Check the columns not used for joining
no_com_col

# For loop: 
# --> for every column name not used for joining we check if there are two similar named columns
# --> if the observation in the first column of the two similar named columns is numeric the mean of the two observations
#     is calculated and put in a new column in the "alc" data frame
# --> if the first column value is not numeric this value will be added in a new column in the "alc" data frame

for(col_name in no_com_col) {
  # select two columns from 'mat_por' with the same original name
  two_columns <- select(mat_por, starts_with(col_name))
  # select the first column vector of those two columns
  first_column <- select(two_columns, 1)[[1]]
  
  # if that first column vector is numeric...
  if(is.numeric(first_column)) {
    # take a rounded average of each row of the two columns and
    # add the resulting vector to the alc data frame
    alc[col_name] <- round(rowMeans(two_columns))
  } else { # else if it's not numeric...
    # add the first column vector to the alc data frame
    alc[col_name] <- first_column
  }
}

# glimpse at the new combined data and check dimensions and first six rows
glimpse(alc)
dim(alc)
head(alc)


# 3.1.4. Take an average of weekday and weekend alcohol consumption ----
#        and create a new column "alc_use" in the alc dataframe

# Create a new column alc_use with the mean of weekday and weekend alcohol comsuption

alc <- mutate(alc, alc_use = (Dalc + Walc) / 2)

head(alc) # check the new column

# Define a new column "high_use" for students with an alc_use greater than 2

alc <- mutate(alc, high_use = alc_use > 2)

head(alc)

# 3.1.5. Check the joined data frame and save it as a table or csv file ----

glimpse(alc)
dim(alc)

# Save the alc data frame as a .txt file 
write.table(alc,
            file = "C:/Users/richla/OneDrive/1 C - R-Folder/11-IODS-course/IODS-project/data/alc_table.txt",
            sep = "\t", col.names = TRUE, row.names = TRUE)

# Check if the file can be read
read.table(file = 
           "C:/Users/richla/OneDrive/1 C - R-Folder/11-IODS-course/IODS-project/data/alc_table.txt") %>% head()


