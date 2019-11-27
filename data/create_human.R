# Script: "create_human" ----
  
# Name: Richard E. Lamprecht
# Date: 25.11.2019
  
# Set the working directory
setwd("C:/Users/richla/OneDrive/1 C - R-Folder/11-IODS-course/IODS-project/")

# Exercise for chapter 4 --------------------------------------------------------------------------------------------

# CHAPTER 5: Data wrangling of human data set -----------------------------------------------------------------------

# Preparation of a data set for further analysis

# load necessary packages

library(tidyr)
library(dplyr)

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

# Join the two data sets into the new data set "human"
human_full <- inner_join(hu_dvlpmt, ge_inequ, by = "country",)

# check the new data set "human"
dim(human_full)
str(human_full)
glimpse(human_full)
colnames(human_full)

# there are 195 observations with 19 variables

# 5. Save the data set as a table ----

# Save the human data frame as a .txt file 
write.table(human_full,
            file = "C:/Users/richla/OneDrive/1 C - R-Folder/11-IODS-course/IODS-project/data/human_full.txt",
            sep = "\t", col.names = TRUE, row.names = TRUE)


# Check if the file can be read
read.table(file = 
             "C:/Users/richla/OneDrive/1 C - R-Folder/11-IODS-course/IODS-project/data/human_full.txt") %>% head()




# Exercise - chapter 5 continued -------------------------------------------------------------------------------------

# Date: 26.11.2019
# Further data wrangling and data analysis for principa component analysis

# Read and check  the data file ----

human_full <- read.table(file = 
             "C:/Users/richla/OneDrive/1 C - R-Folder/11-IODS-course/IODS-project/data/human_full.txt")

#check the human data frame
head(human_full)
str(human_full)
dim(human_full)
summary(human_full)


# 1. Change the character values of GNI to numerical values with string manipulation ----

# load stringr package
library(stringr)

# check the GNI values
str(human_full$GNI)
human_full$GNI

# remove the commas and change the values to a numeric form
human_full$GNI <- str_replace(human_full$GNI, pattern=",", replace ="") %>% as.numeric()

head(human_full)
human_full$GNI

# 2. Remove unwanted variables from the data set ----

# Keep following variables: 
# "country"         --> country name
# "ratio.sec.edu"   --> ratio of second education of female/male
# "ratio.lab.force" --> ratio of labour forced female/male
# "edu.expect"      --> expected years of schooling
# "life.exp"        --> life expectancy at birth
# "GNI"             --> Gross National Income per capita
# "mat.mor.r"       --> maternal mortality ratio
# "adol.birth"      --> adolescent birth rate
# "rep.parliament"  --> percetange of female representatives in parliament

# Define the columns to keep
human_keep <-c("country", "ratio.sec.edu", "ratio.lab.force", "edu.expect", "life.exp",
               "GNI", "mat.mor.r", "adol.birth", "rep.parliament")
human_keep

# Select the column to keep
human_analys <- select(human_full, one_of(human_keep))

# Check the completeness indicator of the 'human' data
complete.cases(human_analys)
# If the data is not complete - if "NA" are in the data set, the completeness indicator will set to "FALSE"

# Prepare a data frame with the completeness indicator as the last column
data.frame(human_analys[-1], comp = complete.cases(human_analys))


# 3. Filter out all rows with NA values
human_analys <- filter(human_analys, complete.cases(human_analys))

# Check the "human_analys" data set - there should be no "NA"
human_analys


# 4. Remove the observations which relate to regions instead of countries

# We want to remove data which was collected from regions, not from independent nations

# Check the last observations
tail(human_analys, 10) 
# starting at row 156 to row 162 there are regions

# I choose to keep the rows from 1 to 155
human_analys <- human_analys[1:155, ]

# Check if this was done correctly
tail(human_analys, 10)

# Add countries as rownames
rownames(human_analys) <- human_analys$country

head(human_analys)


# 5. Remove the country column from the data ----
human_analys <- human_analys[-1]

head(human_analys)
str(human_analys)


# 6. Save the human data frame as a .txt file ----

# I overwrite my old human table
write.table(human_analys,
            file = "C:/Users/richla/OneDrive/1 C - R-Folder/11-IODS-course/IODS-project/data/human_analys.txt",
            col.names = TRUE, row.names = TRUE)


# Check if the table can be read
read.table(file = 
             "C:/Users/richla/OneDrive/1 C - R-Folder/11-IODS-course/IODS-project/data/human_analys.txt") %>% str()

