#### Rough Descriptive Stats ####

library(tidyverse)
load("all_data.Rda")

dat <- dplyr::filter(
        .data = all_data
        #, participant_id != 18
)
vmed <- median(dat$vresp, na.rm = TRUE)
vSD <- sd(dat$vresp, na.rm = TRUE)
# vIQR <- IQR(all_data_sub$vresp, na.rm = TRUE)
dat <- dplyr::filter(
        .data = dat
        , vresp > vmed - (.25*vSD)
        , vresp < vmed + (.25*vSD)
)

## PPVR 
PPVRmean_rep1 <- mean((subset(dat, (condition == "PP-VR-5") & (figure_type == "repeated") & (session_num == 1)))$shape_dtw_error_mean)
#PPVRsd_rep1 <- sd((subset(dat, (condition == "PP-VR-5") & (figure_type == "repeated") & (session_num == 1)))$shape_dtw_error_mean)
PPVRmean_ran1 <- mean((subset(dat, (condition == "PP-VR-5") & (figure_type == "random") & (session_num == 1)))$shape_dtw_error_mean)
#PPVRsd_ran1 <- sd((subset(dat, (condition == "PP-VR-5") & (figure_type == "random") & (session_num == 1)))$shape_dtw_error_mean)

PPVRsd1 <- sd((subset(dat, (condition == "PP-VR-5") & (session_num == 1)))$shape_dtw_error_mean)
PPVRlearn1 <- (PPVRmean_ran1 - PPVRmean_rep1)/PPVRsd1
print(PPVRlearn1)

PPVRmean_rep5 <- mean((subset(dat, (condition == "PP-VR-5") & (figure_type == "repeated") & (session_num == 5)))$shape_dtw_error_mean)
#PPVRsd_rep5 <- sd((subset(dat, (condition == "PP-VR-5") & (figure_type == "repeated") & (session_num == 5)))$shape_dtw_error_mean)
PPVRmean_ran5 <- mean((subset(dat, (condition == "PP-VR-5") & (figure_type == "random") & (session_num == 5)))$shape_dtw_error_mean)
#PPVRsd_ran5 <- sd((subset(dat, (condition == "PP-VR-5") & (figure_type == "random") & (session_num == 5)))$shape_dtw_error_mean)

PPVRsd5 <- sd((subset(dat, (condition == "PP-VR-5") & (session_num == 5)))$shape_dtw_error_mean)
PPVRlearn5 <- (PPVRmean_ran5 - PPVRmean_rep5)/PPVRsd5
print(PPVRlearn5)


## PP
PPmean_rep1 <- mean((subset(dat, (condition == "PP-VV-5") & (figure_type == "repeated") & (session_num == 1)))$shape_dtw_error_mean)
#PPsd_rep1 <- sd((subset(dat, (condition == "PP-VV-5") & (figure_type == "repeated") & (session_num == 1)))$shape_dtw_error_mean)
PPmean_ran1 <- mean((subset(dat, (condition == "PP-VV-5") & (figure_type == "random") & (session_num == 1)))$shape_dtw_error_mean)
#PPsd_ran1 <- sd((subset(dat, (condition == "PP-VV-5") & (figure_type == "random") & (session_num == 1)))$shape_dtw_error_mean)

PPsd1 <- sd((subset(dat, (condition == "PP-VV-5") & (session_num == 1)))$shape_dtw_error_mean)
PPlearn1 <- (PPmean_ran1 - PPmean_rep1)/PPsd1
print(PPlearn1)

PPmean_rep5 <- mean((subset(dat, (condition == "PP-VV-5") & (figure_type == "repeated") & (session_num == 5)))$shape_dtw_error_mean)
#PPsd_rep5 <- sd((subset(dat, (condition == "PP-VV-5") & (figure_type == "repeated") & (session_num == 5)))$shape_dtw_error_mean)
PPmean_ran5 <- mean((subset(dat, (condition == "PP-VV-5") & (figure_type == "random") & (session_num == 5)))$shape_dtw_error_mean)
#PPsd_ran5 <- sd((subset(dat, (condition == "PP-VV-5") & (figure_type == "random") & (session_num == 5)))$shape_dtw_error_mean)

PPsd5 <- sd((subset(dat, (condition == "PP-VV-5") & (session_num == 5)))$shape_dtw_error_mean)
PPlearn5 <- (PPmean_ran5 - PPmean_rep5)/PPsd5
print(PPlearn5)


## MI

MImean_rep5 <- mean((subset(dat, (condition == "MI-00-5") & (figure_type == "repeated") & (session_num == 5)))$shape_dtw_error_mean)
#MIsd_rep5 <- sd((subset(dat, (condition == "MI-00-5") & (figure_type == "repeated") & (session_num == 5)))$shape_dtw_error_mean)
MImean_ran5 <- mean((subset(dat, (condition == "MI-00-5") & (figure_type == "random") & (session_num == 5)))$shape_dtw_error_mean)
#MIsd_ran5 <- sd((subset(dat, (condition == "MI-00-5") & (figure_type == "random") & (session_num == 5)))$shape_dtw_error_mean)

MIsd5 <- sd((subset(dat, (condition == "MI-00-5") & (session_num == 5)))$shape_dtw_error_mean)
MIlearn5 <- (MImean_ran5 - MImean_rep5)/MIsd5
print(MIlearn5)

## CC

CCmean_rep5 <- mean((subset(dat, (condition == "CC-00-5") & (figure_type == "repeated") & (session_num == 5)))$shape_dtw_error_mean)
#CCsd_rep5 <- sd((subset(dat, (condition == "CC-00-5") & (figure_type == "repeated") & (session_num == 5)))$shape_dtw_error_mean)
CCmean_ran5 <- mean((subset(dat, (condition == "CC-00-5") & (figure_type == "random") & (session_num == 5)))$shape_dtw_error_mean)
#CCsd_ran5 <- sd((subset(dat, (condition == "CC-00-5") & (figure_type == "random") & (session_num == 5)))$shape_dtw_error_mean)

CCsd5 <- sd((subset(dat, (condition == "CC-00-5") & (session_num == 5)))$shape_dtw_error_mean)
CClearn5 <- (CCmean_ran5 - CCmean_rep5)/CCsd5
print(CClearn5)

#### EFFECT SIZES:

# Day 1 PPVR
length(unique(subset(dat, (condition == "PP-VR-5") & (session_num == 1))$participant_id))
print(PPVRlearn1)

# Day 1 PP
length(unique(subset(dat, (condition == "PP-VV-5") & (session_num == 1))$participant_id))
print(PPlearn1)

# Day 5 PPVR
length(unique(subset(dat, (condition == "PP-VR-5") & (session_num == 5))$participant_id))
print(PPVRlearn5)

# Day 5 PP
length(unique(subset(dat, (condition == "PP-VV-5") & (session_num == 5))$participant_id))
print(PPlearn5)

# Day 5 MI
length(unique(subset(dat, (condition == "MI-00-5") & (session_num == 5))$participant_id))
print(MIlearn5)

# Day 5 CC
length(unique(subset(dat, (condition == "CC-00-5") & (session_num == 5))$participant_id))
print(CClearn5)
