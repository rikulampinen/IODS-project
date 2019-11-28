# Script: "meet_and_repeat.R" ----

# Name: Richard E. Lamprecht
# Date: 27.11.2019

# Set the working directory
setwd("C:/Users/richla/OneDrive/1 C - R-Folder/11-IODS-course/IODS-project/")


# Exercise for chapter 6 - Analysis of longitudinal data -----

# Load necessary packages
library(tidyr)
library(dplyr)


# Data wrangling exercise ----

# 1. Load the data ----

bprs <- read.table("https://raw.githubusercontent.com/KimmoVehkalahti/MABS/master/Examples/data/BPRS.txt", sep = " ", header = TRUE)

rats <- read.table("https://raw.githubusercontent.com/KimmoVehkalahti/MABS/master/Examples/data/rats.txt", header = TRUE)


# Check the data files

head(bprs)
str(bprs)
summary(bprs)


head(rats)
str(rats)
summary(rats)


# 2 .Convert the categorical variables of both data sets to factors ----

# bprs data --> factor treatment & subject
bprs$treatment <- factor(bprs$treatment)
bprs$subject <- factor(bprs$subject)

str(bprs)


# rats data --> factor ID & Group
rats$ID <- factor(rats$ID)
rats$Group <- factor(rats$Group)

str(rats)


# 3. Convert the data sets to long form ----
# Add a week variable to "bprs" and a time variable to "rats"

# bprs - long form
bprs_l <-  bprs %>% gather(key = weeks, value = bprs, -treatment, -subject)
glimpse(bprs_l)

# bprs - add the week number as a variable to the long form of the data set
bprs_l <- bprs_l %>% mutate(week = as.integer(substr(weeks,5,5)))
glimpse(bprs_l)


# rats - long form
rats_l <- rats %>% gather(key = WD, value = Weight, -ID, -Group) 
glimpse(rats_l)

# rats - add the time as a variable
rats_l <- rats_l %>% mutate(Time = as.integer(substr(WD,3,4)))
glimpse(rats_l)

# 4. Take a serious look on the data ----

View(bprs_l)
str(bprs_l)

# The long form let's us analyse the data in a much better way...

# bprs_l form:
# The former wide form hat the week number as a variable and the bprs data in these variables -
# now all values of our data are transformed to the long form where each bprs value is then nicely compareable with
# treatment, subject and week number.

# So all shorter columns were put after each other relating to the week number 
# (so the values were put in a logical time order)


View(rats_l)
str(rats_l)

# same with the rats_l long form data - the weights and times are now in separate variables and not anymore in separate
# single time variables, but after each other in a time series...


# 5. Save the long form of the data ----  

write.table(bprs_l, file = "C:/Users/richla/OneDrive/1 C - R-Folder/11-IODS-course/IODS-project/data/bprs_l.txt",
            col.names = TRUE, row.names = TRUE)

write.table(rats_l, file = "C:/Users/richla/OneDrive/1 C - R-Folder/11-IODS-course/IODS-project/data/rats_l.txt",
            col.names = TRUE, row.names = TRUE)

# check if you can read the files again...

read.table("C:/Users/richla/OneDrive/1 C - R-Folder/11-IODS-course/IODS-project/data/bprs_l.txt") %>% str()

read.table("C:/Users/richla/OneDrive/1 C - R-Folder/11-IODS-course/IODS-project/data/rats_l.txt") %>% str()


