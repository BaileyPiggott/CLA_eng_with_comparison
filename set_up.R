
library(shiny)
library(ggplot2)
library(tidyr)
library(dplyr)
library(magrittr)# load libraries
library(grid)

## data
scores = read.csv("Engineering CLA+ data.csv") # scores
ids = read.csv("Engineering Student Info.csv") #identification

#merge data frames together
cla <- merge(scores, ids, by = c("year", "studentid")) # year and student id are the only common variables between dataframes
cla <- cla[c("studentid", "score_total", "semester", "plan", "course")] #keep only important columns
cla <- cla %>% mutate(year = ceiling(semester/2)) #add column with year calculated from semester
first_year <- cla %>% subset(semester <= 2) #first year scores

#separate into disciplines
# subset by dicsipline in "plan" column, then add first years with matching student numbers

#some discplines do not have data in some years
#need to add null scores for each year so graph plots properly
fix <- data.frame(c(1,2,3,4),  c(NA,NA,NA,NA),c(NA,NA,NA,NA),c(NA,NA,NA,NA),c(NA,NA,NA,NA), c(1,2,3,4))
colnames(fix) <- colnames(cla)

cla <- rbind(cla, fix)

#all engineering
all_eng <-  cla  %>% rbind(fix)%>% mutate(plan = "Z_ENG") # start with z so all eng is on the right of disicpline
n_eng_1 <-  sum(with(all_eng, year ==1 & score_total > 1), na.rm = TRUE)  # all eng sample sizes
n_eng_2 <-  sum(with(all_eng, year ==2 & score_total > 1), na.rm = TRUE)
n_eng_3 <-  sum(with(all_eng, year ==3 & score_total > 1), na.rm = TRUE)
n_eng_4 <-  sum(with(all_eng, year ==4 & score_total > 1), na.rm = TRUE)

#mech
mech <- cla %>% subset(plan == "MECH-M-BSE") #second and fourth year mech scores
first_year_mech <- semi_join(first_year, mech, by = "studentid") #first years with matching ids to mech
mech <- rbind(mech, first_year_mech, fix) %>% arrange(studentid) %>% mutate(plan = "MECH")

#elec
elec <- cla %>% subset(plan == "ELEC-M-BSE") #second and fourth year scores
first_year_elec <- semi_join(first_year, elec, by = "studentid") #first years with matching ids
elec <- rbind(elec, first_year_elec, fix) %>% arrange(studentid)%>% mutate(plan = "ELEC")

#comp
cmpe <- cla %>% subset(plan == "CMPE-M-BSE") #second and fourth year scores
first_year_cmpe <- semi_join(first_year, cmpe, by = "studentid") #first years with matching ids
cmpe <- rbind(cmpe, first_year_cmpe, fix) %>% arrange(studentid) %>% mutate(plan = "CMPE")

#civl
civl <- cla %>% subset(plan == "CIVL-M-BSE") #second and fourth year scores
first_year_civl <- semi_join(first_year, civl, by = "studentid") #first years with matching ids
civl <- rbind(civl, first_year_civl, fix) %>% arrange(studentid) %>% mutate(plan = "CIVL")

#chem
chem <- cla %>% subset(plan == "CHEE-M-BSE") #second and fourth year scores
first_year_chem <- semi_join(first_year, chem, by = "studentid") #first years with matching ids
chem <- rbind(chem, first_year_chem, fix) %>% arrange(studentid) %>% mutate(plan = "CHEM")

#eng chem
ench <- cla %>% subset(plan == "ENCH-M-BSE") #second and fourth year scores
first_year_ench <- semi_join(first_year, ench, by = "studentid") #first years with matching ids
ench <- rbind(ench, first_year_ench, fix) %>% arrange(studentid) %>% mutate(plan = "ENCH")

#mining
mine <- cla %>% subset(plan == "MINE-M-BSE") #second and fourth year scores
first_year_mine <- semi_join(first_year, mine, by = "studentid") #first years with matching ids
mine <- rbind(mine, first_year_mine, fix) %>% arrange(studentid) %>% mutate(plan = "MINE")

#geo 
geoe <- cla %>% subset(plan == "GEOE-M-BSE") #second and fourth year scores
first_year_geoe <- semi_join(first_year, geoe, by = "studentid") #first years with matching ids
geoe <- rbind(geoe, first_year_geoe, fix) %>% arrange(studentid) %>% mutate(plan = "GEOE")

#eng phys
enph <- cla %>% subset(plan == "ENPH-M-BSE") #second and fourth year scores
first_year_enph <- semi_join(first_year, enph, by = "studentid") #first years with matching ids
enph <- rbind(enph, first_year_enph, fix) %>% arrange(studentid) %>% mutate(plan = "ENPH")

#apple math
mthe<- cla %>% subset(plan == "MTHE-M-BSE") #second and fourth year scores
first_year_mthe <- semi_join(first_year, mthe, by = "studentid") #first years with matching ids
mthe <- rbind(mthe, first_year_mthe, fix) %>% arrange(studentid) %>% mutate(plan = "MTHE")


# dummy data for 1st, 2nd, 4th year to fix box widths
dummy <- fix # default to null data if discipline has data for all years
dummy_1 <- data.frame(NA, 60, NA, NA, NA, 1)
colnames(dummy_1) <- colnames(fix)
dummy_2 <- data.frame(NA, 60, NA, NA, NA, 2)
colnames(dummy_2) <- colnames(fix)
dummy_4 <- data.frame(NA, 60, NA, NA, NA, 4)
colnames(dummy_4) <- colnames(fix)
