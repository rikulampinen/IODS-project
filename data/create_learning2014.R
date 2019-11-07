# Script: "create_learning2014" ----

# Name: Richard E. Lamprecht
# Date: 5.11.2019

# Script for exercise 2 in the course: Introduction to Open Data Science (IODS) ----

# DATA WRANGLING ----

# Read the data file ----

learning2014 <- read.table(file = 
                "https://www.mv.helsinki.fi/home/kvehkala/JYTmooc/JYTOPKYS3-data.txt", 
                sep = "\t", header = TRUE)                          
                # read the data file and assign it to the object "learning2014"


# Explore the read data ----

View(learning2014) # see the whole dataset in a new window
str(learning2014) # check the structure of the dataset --> --> (observations = rows and variables = columns)
dim(learning2014) # check the table dimensions --> (observations = rows and variables = columns)

# Structure of the data - short explanation

library(ggplot2)
qplot(Attitude, Points, data = learning2014)
hist(learning2014$Points)


# Create an analysis dataset: "lrn14_analysis" ----

# Create an analysis dataset with the variables gender, age, attitude, deep, stra, surf and points 
# (by combining questions in the learning2014 data)

library(dplyr) # load the package for data wrangling

keep_columns <- c("gender","Age","Attitude","Points") # these are the data columns which need to be kept
lrn14_analysis <- select(learning2014, one_of(keep_columns))  # assin a new object and select kept columns
colnames(lrn14_analysis) <- c("gender", "age", "attitude", "points") # change of the kept column names

## use %>% more often!!

# e.g.
lrn14_analysis <- lrn14_analysis %>% rename(Age = age, Points = points) # pipe is a good way for data handling!!





# define questions (observations from variables) acc. instructions
deep_q <- c("D03", "D11", "D19", "D27", "D07", "D14", "D22", "D30","D06",  "D15", "D23", "D31")  # deep questions
surf_q <- c("SU02","SU10","SU18","SU26", "SU05","SU13","SU21","SU29","SU08","SU16","SU24","SU32") # surface questions
stra_q <- c("ST01","ST09","ST17","ST25","ST04","ST12","ST20","ST28") # strategic questions

# Select the combined variables (columns) & scale the observations (mean) and add it to the analysis dataframe
deep <- select(learning2014, one_of(deep_q))
lrn14_analysis$deep <- round(rowMeans(deep, na.rm = TRUE), digits = 2)

surf <- select(learning2014, one_of(surf_q))
lrn14_analysis$surf <- round(rowMeans(surf,na.rm = TRUE), digits = 2)

stra <- select(learning2014, one_of(stra_q))
lrn14_analysis$stra <- round(rowMeans(stra, na.rm = TRUE), digits = 2)

# devide the number of the attitude column by 10 (its a sum of 10 questions)
lrn14_analysis$attitude <- lrn14_analysis$attitude / 10

# Exclude observations where the exam points variable is zero. 
lrn14_analysis <- filter(lrn14_analysis, points > 0)


# write a pipe coding of the data wrangling!!!





# Check the analysis dataset
str(lrn14_analysis)
dim(lrn14_analysis)


# Set the working directory to IODS project folder ---- 

getwd() # check the current working directory

setwd("C:/Users/richla/OneDrive/1 C - R-Folder/11-IODS-course/IODS-project") # set the wd to the IODS folder


# safe the analysis dataset to the "data" folder ----

?write.table 
?write.csv    # check the help on write.table/csv

write.table(lrn14_analysis, 
            file = "C:/Users/richla/OneDrive/1 C - R-Folder/11-IODS-course/IODS-project/data/lrn14_analysis_table.txt", 
            sep = "\t", col.names = TRUE, row.names = TRUE)

write.csv(lrn14_analysis, 
          file = "C:/Users/richla/OneDrive/1 C - R-Folder/11-IODS-course/IODS-project/data/lrn14_analysis_table.csv", 
          row.names = FALSE)


# to save an excel file
library(openxlsx)
# saved as:
# write.xlsx(object, file = )


# check if the table can be read ----

read.table(file = 
             "C:/Users/richla/OneDrive/1 C - R-Folder/11-IODS-course/IODS-project/data/lrn14_analysis_table.txt") %>% head()

read.csv(file = 
           "C:/Users/richla/OneDrive/1 C - R-Folder/11-IODS-course/IODS-project/data/lrn14_analysis_table.csv") %>%head()



# DATA ANALYSIS ----

# Read the dataset & assign it to object lrn14_analysis ----

lrn14_analysis <- read.table(file = 
                  "C:/Users/richla/OneDrive/1 C - R-Folder/11-IODS-course/IODS-project/data/lrn14_analysis_table.txt", 
                  stringsAsFactors = FALSE) # check if you need strings as factors or if you want to keep the string - here F/M

str(lrn14_analysis)
dim(lrn14_analysis)

qplot(attitude, points, data = lrn14_analysis) + geom_smooth(method = lm)
hist(lrn14_analysis$points)



# Graphical overview of the data and show summaries ----

ov_lrn14 <- pairs(lrn14_analysis[-1])

# more advanced overview plot
library(ggplot2)
library(GGally)

ov_lrn14_2 <- ggpairs(lrn14_analysis, mapping = aes(col = gender), lower = list(combo = wrap("facethist", bins = 20)))

ov_lrn14_2

# Save the overview plot
ggsave("OV_plot_lrn14.png", 
       plot = ov_lrn14_2, path = "C:/Users/richla/OneDrive/1 C - R-Folder/11-IODS-course/IODS-project/data/", scale = 1,
       dpi = 300)

# Summary table of the lrn14_analysis data ----

Sum_table <- summary(lrn14_analysis)
Sum_table

getwd()

# Save the table

library(tidyr)
library(broom)

write.table(Sum_table, file = "C:/Users/richla/OneDrive/1 C - R-Folder/11-IODS-course/IODS-project/data/Sum_table.txt", 
            sep = "\t", quote = FALSE, row.names = TRUE)


# Regression models ----
# Three variables compared with exam points as dependent variabe

# Simple regressions ----
# gender

gen_lm <- lm(points ~ gender, data = lrn14_analysis)
summary(gen_lm) # not significant

# age
age_lm <- lm(points ~ age, data = lrn14_analysis)
summary(age_lm) # not significant

# attitude
att_lm <- lm(points ~ attitude, data = lrn14_analysis)
summary(att_lm)

windows()
par(mfrow = c(2,2))
plot(att_lm, which = c(1,2,5))
savePlot(filename = "C:/Users/richla/OneDrive/1 C - R-Folder/11-IODS-course/IODS-project/data/att_lm.png",
         type = "png", device = dev.cur())
?restoreConsole

savePlot("att_lm.png", plot =last_plot(), 
       path = "C:/Users/richla/OneDrive/1 C - R-Folder/11-IODS-course/IODS-project/data/", scale = 1,
       dpi = 300)



# Multiple regressions ----
# points ~ attitude + deep + surf + stra

att_de_su_st_lm <- lm(points ~ attitude + deep + surf + stra, data = lrn14_analysis)
summary(att_de_su_st_lm)

windows()
par(mfrow = c(2,2))
plot(att_de_su_st_lm, which = c(1,2,5))
savePlot(filename = "C:/Users/richla/OneDrive/1 C - R-Folder/11-IODS-course/IODS-project/data/att_de_su_st_lm.png",
         type = "png", device = dev.cur())






## attitude vs. points
## what is the summary points ~ attitude telling me

# increase of attitude by 1, the points increase by 3.5


# diagnostic plots



































