
library(shiny)
library(ggplot2)
library(tidyr)
library(dplyr)
library(magrittr)# load libraries
library(grid)


## load data ------------------------------
scores = read.csv("Consenting CLA+ Data.csv")
ids = read.csv("Engineering Student Info.csv") #identification

#merge data frames together and add column with year
eng_cla <- inner_join(scores, ids, by = c("year", "studentid")) %>%
  filter(time_pt > 5 & effort_pt >1) %>%
  select(studentid, score_total, semester, plan, course) %>% 
  mutate(year = ceiling(semester/2)) 

first_year <- eng_cla %>% subset(semester <= 2) #first year scores

first_year_enph = read.csv("LOAC CLA Unpaired.csv") %>% # ENPH doesn't have 2nd year 
  filter(time_pt > 5 & effort_pt >1) %>%                # scores to match to
  filter(discipline == "ENPH-M-BSE") %>% 
  mutate(semester = 1) %>% 
  select(studentid, score_total, semester, discipline, course, project_year)
colnames(first_year_enph) <- colnames(first_year)


#separate into disciplines --------------------------------
# subset by discipline in "plan" column, then add first years with matching student numbers

#mech
mech <- eng_cla %>% subset(plan == "MECH-M-BSE") #second and fourth year mech scores
first_year_mech <- semi_join(first_year, mech, by = "studentid") #first years with matching ids
mech <- rbind(mech, first_year_mech) %>% arrange(studentid) %>% mutate(plan = "MECH")

#elec
elec <- eng_cla %>% subset(plan == "ELEC-M-BSE") #second and fourth year scores
first_year_elec <- semi_join(first_year, elec, by = "studentid") #first years with matching ids
elec <- rbind(elec, first_year_elec) %>% mutate(plan = "ELEC")

#comp
cmpe <- eng_cla %>% subset(plan == "CMPE-M-BSE") #second and fourth year scores
first_year_cmpe <- semi_join(first_year, cmpe, by = "studentid") #first years with matching ids
cmpe <- rbind(cmpe, first_year_cmpe) %>% mutate(plan = "CMPE")

#civl
civl <- eng_cla %>% subset(plan == "CIVL-M-BSE") #second and fourth year scores
first_year_civl <- semi_join(first_year, civl, by = "studentid") #first years with matching ids
civl <- rbind(civl, first_year_civl) %>% mutate(plan = "CIVL")

#chem
chem <- eng_cla %>% subset(plan == "CHEE-M-BSE") #second and fourth year scores
first_year_chem <- semi_join(first_year, chem, by = "studentid") #first years with matching ids
chem <- rbind(chem, first_year_chem) %>% mutate(plan = "CHEM")

#eng chem
ench <- eng_cla %>% subset(plan == "ENCH-M-BSE") #second and fourth year scores
first_year_ench <- semi_join(first_year, ench, by = "studentid") #first years with matching ids
ench <- rbind(ench, first_year_ench) %>% mutate(plan = "ENCH")

#mining
mine <- eng_cla %>% subset(plan == "MINE-M-BSE") #second and fourth year scores
first_year_mine <- semi_join(first_year, mine, by = "studentid") #first years with matching ids
mine <- rbind(mine, first_year_mine) %>% mutate(plan = "MINE")

#geo 
geoe <- eng_cla %>% subset(plan == "GEOE-M-BSE") #second and fourth year scores
first_year_geoe <- semi_join(first_year, geoe, by = "studentid") #first years with matching ids
geoe <- rbind(geoe, first_year_geoe) %>% mutate(plan = "GEOE")

#eng phys
enph <- eng_cla %>% subset(plan == "ENPH-M-BSE") #second and fourth year scores
enph <- rbind(enph, first_year_enph)%>% mutate(plan = "ENPH")

#apple math
mthe<- eng_cla %>% subset(plan == "MTHE-M-BSE") #second and fourth year scores
first_year_mthe <- semi_join(first_year, mthe, by = "studentid") #first years with matching ids
mthe <- rbind(mthe, first_year_mthe) %>% mutate(plan = "MTHE")

# all eng ----------------------------------------------
all_eng <- eng_cla %>% mutate(plan = "z_ENG") 

# all eng sample sizes:

n_eng_1 <-  sum(with(all_eng, year == 1 & score_total > 1), na.rm = TRUE)  
n_eng_2 <-  sum(with(all_eng, year == 2 & score_total > 1), na.rm = TRUE) 
n_eng_3 <-  sum(with(all_eng, year == 3 & score_total > 1), na.rm = TRUE) 
n_eng_4 <-  sum(with(all_eng, year == 4 & score_total > 1), na.rm = TRUE) 

# dummy data for 1st, 2nd, 4th year to fix box widths ----------------

#fix <- data.frame(c(1,2,3,4), c(10,10,10,10),c(NA,NA,NA,NA),
 #                 c(NA,NA,NA,NA),c(NA,NA,NA,NA), c(1,2,3,4))
fix <- data.frame(NA,10,NA,NA,NA,3)
colnames(fix) <- colnames(eng_cla)

dummy <- fix # default to null data if discipline has data for all years
dummy_1 <- data.frame(NA, 60, NA, NA, NA, 1)
colnames(dummy_1) <- colnames(fix)
dummy_2 <- data.frame(NA, 60, NA, NA, NA, 2)
colnames(dummy_2) <- colnames(fix)
dummy_4 <- data.frame(NA, 60, NA, NA, NA, 4)
colnames(dummy_4) <- colnames(fix)

