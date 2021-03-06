##### SAF CURVE FITTING #####
## authored by TONY INGRAM ##

## TO DO ##
# 1. look at looping fitting, so I can do other error outcomes (raw, shape, scale, rot, trans)
# 2. add "lower bound" to fitting function
# 3. create matrix of fit parameters
# 4. maybe, to make "shape error" the y-axis, take absolute value away from 1? direction matters though... 

#rm(list=setdiff(ls(), c("all_figs","all_data"))) # clear all but all_figs & all_data
graphics.off() # clear figures

library(tidyverse)

##### FITTING LOGISTIC FUNCTION #####
## adapted from: https://gist.github.com/kyrcha/74ec4894994e6a8a6d89#file-sigmoid-r 

library(minpack.lm) # better algorithm for nonlinear least squares

## SHAPE ##

# create matrices which orders x and y (speed and error) by x:

fit_ran1 <- data.frame(matrix(c(V_ran_1,PP_random_1$shape_error_mean), ncol=2))
fit_ran1 <- fit_ran1[order(fit_ran1$X1),]
fit_ran2 <- data.frame(matrix(c(V_ran_2,PP_random_2$shape_error_mean), ncol=2))
fit_ran2 <- fit_ran2[order(fit_ran2$X1),]
fit_ran3 <- data.frame(matrix(c(V_ran_3,PP_random_3$shape_error_mean), ncol=2))
fit_ran3 <- fit_ran3[order(fit_ran3$X1),]
fit_ran4 <- data.frame(matrix(c(V_ran_4,PP_random_4$shape_error_mean), ncol=2))
fit_ran4 <- fit_ran4[order(fit_ran4$X1),]
fit_ran5 <- data.frame(matrix(c(V_ran_5,PP_random_5$shape_error_mean), ncol=2))
fit_ran5 <- fit_ran5[order(fit_ran5$X1),]

fit_rep1 <- data.frame(matrix(c(V_rep_1,PP_repeat_1$shape_error_mean), ncol=2))
fit_rep1 <- fit_rep1[order(fit_rep1$X1),]
fit_rep2 <- data.frame(matrix(c(V_rep_2,PP_repeat_2$shape_error_mean), ncol=2))
fit_rep2 <- fit_rep2[order(fit_rep2$X1),]
fit_rep3 <- data.frame(matrix(c(V_rep_3,PP_repeat_3$shape_error_mean), ncol=2))
fit_rep3 <- fit_rep3[order(fit_rep3$X1),]
fit_rep4 <- data.frame(matrix(c(V_rep_4,PP_repeat_4$shape_error_mean), ncol=2))
fit_rep4 <- fit_rep4[order(fit_rep4$X1),]
fit_rep5 <- data.frame(matrix(c(V_rep_5,PP_repeat_5$shape_error_mean), ncol=2))
fit_rep5 <- fit_rep5[order(fit_rep5$X1),]

# function needed for visualization purposes
logistic = function(params, x) {
        params[1] / (1 + exp(-params[2] * (x - params[3])))
}

# function for fitting logistic function
logfit = function(x, y){
        ymax = max(y, na.rm = TRUE)
        xmed = median(x, na.rm = TRUE)
        slope = (y[which.max(y)] - y[1]) / (x[which.max(x)] - x[1])
        # fitting code:
        fit <- nlsLM(y ~ a/(1 + exp(-(b * (x-c)))), start=list(a=ymax,b=slope,c=xmed))
        return(fit)
}

## RANDOM TRAJECTORY FITS ##

# RANDOM DAY 1

fitmodel <- logfit(fit_ran1$X1,fit_ran1$X2) # fit data to equation
summary(fitmodel) # see fit summary
ran1_params=coef(fitmodel) # get parameter coefficients 
ran1 <- logistic(ran1_params,fit_ran1$X1) # get fit for plots

# RANDOM DAY 2

fitmodel <- logfit(fit_ran2$X1,fit_ran2$X2)
summary(fitmodel)
ran2_params=coef(fitmodel)
ran2 <- logistic(ran2_params,fit_ran2$X1)

# RANDOM DAY 3

fitmodel <- logfit(fit_ran3$X1,fit_ran3$X2)
summary(fitmodel)
ran3_params=coef(fitmodel)
ran3 <- logistic(ran3_params,fit_ran3$X1)

# RANDOM DAY 4

fitmodel <- logfit(fit_ran4$X1,fit_ran4$X2)
summary(fitmodel)
ran4_params=coef(fitmodel)
ran4 <- logistic(ran4_params,fit_ran4$X1)

# RANDOM DAY 5

fitmodel <- logfit(fit_ran5$X1,fit_ran5$X2)
summary(fitmodel)
ran5_params=coef(fitmodel)
ran5 <- logistic(ran5_params,fit_ran5$X1)


## REPEATED TRAJECTORY FITS ##

# REPEAT DAY 1

fitmodel <- logfit(fit_rep1$X1,fit_rep1$X2)
summary(fitmodel)
rep1_params=coef(fitmodel)
rep1 <- logistic(rep1_params,fit_rep1$X1)

# REPEAT DAY 2

fitmodel <- logfit(fit_rep2$X1,fit_rep2$X2)
summary(fitmodel)
rep2_params=coef(fitmodel)
rep2 <- logistic(rep2_params,fit_rep2$X1)

# REPEAT DAY 3

fitmodel <- logfit(fit_rep3$X1,fit_rep3$X2)
summary(fitmodel)
rep3_params=coef(fitmodel)
rep3 <- logistic(rep3_params,fit_rep3$X1)

# REPEAT DAY 4

fitmodel <- logfit(fit_rep4$X1,fit_rep4$X2)
summary(fitmodel)
rep4_params=coef(fitmodel)
rep4 <- logistic(rep4_params,fit_rep4$X1)

# REPEAT DAY 5

fitmodel <- logfit(fit_rep5$X1,fit_rep5$X2)
summary(fitmodel)
rep5_params=coef(fitmodel)
rep5 <- logistic(rep5_params,fit_rep5$X1)

# end loop here! make matrix of parameters! 

# Proc_params <- 


# PLOT DAY 1 to DAY 5 CHANGE, RANDOM and REPEAT

plot(fit_ran1$X1, ran1, type="l", col="grey", xlim=c(0,6000), ylim=c(0,600))
lines(fit_ran5$X1, ran5, col="black")
lines(fit_rep1$X1, rep1, col="cyan")
lines(fit_rep5$X1, rep5, col="blue")
points(fit_ran1$X1, fit_ran1$X2, col="grey")
points(fit_ran5$X1, fit_ran5$X2, col="black")
points(fit_rep1$X1, fit_rep1$X2, col="cyan")
points(fit_rep5$X1, fit_rep5$X2, col="blue")
title(main="Shape (ProcSD) SAF")

## PLOT RANDOM, DAY 1, 2, 3, 4, 5 — colour gradient? 

plot(fit_ran1$X1, ran1, type="l", col="gray80", xlim=c(0,6000), ylim=c(0,600))
lines(fit_ran2$X1, ran2, col="gray60")
lines(fit_ran3$X1, ran3, col="gray40")
lines(fit_ran4$X1, ran4, col="gray20")
lines(fit_ran5$X1, ran5, col="gray0")
points(fit_ran1$X1, fit_ran1$X2, col="gray80")
points(fit_ran2$X1, fit_ran2$X2, col="gray60")
points(fit_ran3$X1, fit_ran3$X2, col="gray40")
points(fit_ran4$X1, fit_ran4$X2, col="gray20")
points(fit_ran5$X1, fit_ran5$X2, col="gray0")
title(main="Random Shape (ProcSD) SAF")


## PLOT REPEAT, DAY 1, 2, 3, 4, 5 — colour gradient?

plot(fit_rep1$X1, rep1, type="l", col="gray80", xlim=c(0,6000), ylim=c(0,600))
lines(fit_rep2$X1, rep2, col="gray60")
lines(fit_rep3$X1, rep3, col="gray40")
lines(fit_rep4$X1, rep4, col="gray20")
lines(fit_rep5$X1, rep5, col="gray0")
points(fit_rep1$X1, fit_rep1$X2, col="gray80")
points(fit_rep2$X1, fit_rep2$X2, col="gray60")
points(fit_rep3$X1, fit_rep3$X2, col="gray40")
points(fit_rep4$X1, fit_rep4$X2, col="gray20")
points(fit_rep5$X1, fit_rep5$X2, col="gray0")
title(main="Repeated Shape (ProcSD) SAF")

##### first block against last block, within single session #####

# to do... however probably not worth it — unlikely to get good fits with such little data

