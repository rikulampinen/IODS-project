# Script: "create_alc" ----

# Name: Richard E. Lamprecht
# Date: 11.11.2019

# CHAPTER 3: Logistic regression -----------------------------------------------------------------------------------

# The Analysis exercise focuses on exploring your data and performing and interpreting logistic regression analysis.
# For completing the Analysis exercises, include all the codes, your interpretations and explanations in the 
# RMarkdown file chapter3.Rmd. 


# 3.1. DATA WRANGLING ----

# Read the data from the csv files

mat <- read.csv(file = "C:/Users/richla/OneDrive/1 C - R-Folder/11-IODS-course/IODS-project/data/student-mat.csv", 
                sep = ";", header = TRUE)

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



d1=read.table("student-mat.csv",sep=";",header=TRUE)
d2=read.table("student-por.csv",sep=";",header=TRUE)

d3=merge(d1,d2,by=c("school","sex","age","address","famsize","Pstatus","Medu","Fedu","Mjob","Fjob","reason","nursery","internet"))
print(nrow(d3)) # 382 students





















