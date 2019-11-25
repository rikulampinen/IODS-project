# Script: "create_human" ----
  
# Name: Richard E. Lamprecht
# Date: 25.11.2019
  
# Set the working directory
setwd("C:/Users/richla/OneDrive/1 C - R-Folder/11-IODS-course/IODS-project/")


# CHAPTER 5: Data wrangling of human data set -----------------------------------------------------------------------

# Preparation of a data set for further analysis

# load necessary packages

library(tidyr)

# 1. Read the data files from the internet ----

# Human development data set
hu_dvlpmt <- read.csv("http://s3.amazonaws.com/assets.datacamp.com/production/course_2218/datasets/human_development.csv", stringsAsFactors = F)

#check the data
head(hu_dvlpmt) 
str(hu_dvlpmt)
dim(hu_dvlpmt)

summary(hu_dvlpmt)

# Gender inequlatity data set
ge_inequ <- read.csv("http://s3.amazonaws.com/assets.datacamp.com/production/course_2218/datasets/gender_inequality.csv", stringsAsFactors = F, na.strings = "..")

#check the data
head(ge_inequ) 
str(ge_inequ)
dim(ge_inequ)

summary(ge_inequ)

# 2. Rename the variables with shorter descriptive names ----

colnames(hu_dvlpmt)
colnames(hu_dvlpmt) <- c("HDI.r", "country", "HDI", "life.exp", "edu.expect", "edu.mean", "GNI", "diff.GNI.HDI")
colnames(hu_dvlpmt)

colnames(ge_inequ)
colnames(ge_inequ) <- c("GII.r", "country", "GII", "mat.mor.r", "adol.birth", "rep.parliament", "sec.edu.female", 
                        "sec.edu.male", "lab.force.female", "lab.force.male")
colnames(ge_inequ)


# 3. Mutation of gender inequality data ----

ge_inequ <- mutate(ge_inequ, ratio.sec.edu = (sec.edu.female/sec.edu.male)) # add variable: secondary education ratio of female and male

ge_inequ <- mutate(ge_inequ, ratio.lab.force = (lab.force.female/lab.force.male)) # add variable: labour force participation ratio of female and male

head(ge_inequ)

# 4. Join the data sets ----

# Use country as an identifier. Keep only countries from both datasets

# Join the two data sets
human <- inner_join(hu_dvlpmt, ge_inequ, by = "country",)

# check the new data set "hu_ge"
dim(human)
str(human)
glimpse(human)
colnames(human)

# there are 195 observations with 19 variables

# 5. Save the data set as a table ----

# Save the alc data frame as a .txt file 
write.table(human,
            file = "C:/Users/richla/OneDrive/1 C - R-Folder/11-IODS-course/IODS-project/data/human_table.txt",
            sep = "\t", col.names = TRUE, row.names = TRUE)


# Check if the file can be read
read.table(file = 
             "C:/Users/richla/OneDrive/1 C - R-Folder/11-IODS-course/IODS-project/data/human_table.txt") %>% head()

