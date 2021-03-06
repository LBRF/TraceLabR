##### CME-MI Statistics #####
     ## Bayesian Model ##
     ## by Tony Ingram ##

library(tidyverse)
library(ez)
library(rstan)
rstan_options(auto_write = TRUE)

rm(list=setdiff(ls(), c("df"))) # clear all
# rm(list=setdiff(ls(), c("all_figs","all_data"))) # clear all but some
# graphics.off() # clear figures
# cat("\014") # clear console


#load useful functions & options ----
source('helpers.R')

#define a useful contrasts function
best_contrasts_ever = function(n, contrasts = TRUE, sparse = FALSE){
        contr.sum(n,contrasts,sparse)*.5
}

#set options to use the above contrasts by default
options(
        contrasts = c('best_contrasts_ever','contr.poly')
)


# load and check out data ----

# load("all_data.Rda")
# # #filter unfinished participant
# dat <- dplyr::filter(
#         .data = all_data
# )
# plot visualization of "learning" (space between random and repeat):
# ggplot(dat, mapping = aes(
#         x = vresp, y = shape_dtw_error_mean
#         , color = factor(figure_type)
# )) + geom_point(na.rm = TRUE, alpha = .5) + 
#         geom_smooth(na.rm = TRUE) + 
#         theme_minimal() +
#         facet_grid(session_num ~ condition) +
#         labs(title = "SAF"
#              , x = "Velocity"
#              , y = "Error"
#              , color = "Session")
# 
# # plot all data:
# ggplot(dat, mapping = aes(
#         x = vresp, y = shape_dtw_error_mean
# )) + geom_point(na.rm = TRUE, alpha = .5) +
#         geom_smooth(na.rm = TRUE) +
#         theme_minimal() +
#         labs(title = "SAF"
#              , x = "Velocity"
#              , y = "Error"
#              , color = "Session")


#confirm model using fake data:
dat <- dplyr::filter(
        .data = df
)
colnames(dat)[3] <- "session_num"
colnames(dat)[5] <- "vresp"
colnames(dat)[6] <- "shape_dtw_error_mean"

# note: data already ordered by participant, 
# then session, then block, then trial

# str(dat)
# summary(dat)
# ezPrecis(dat)
# ezDesign(
#         data = dat
#         , x = figure_type
#         , y = participant_id
#         , row = session_num
#         , col = condition
# )


# Prep the data for Stan ----

dat$session_num_as_fac = factor(dat$session_num)
dat = dat[!is.na(dat$shape_dtw_error_mean),]
dat = dat[!is.na(dat$vresp),]

# initial guesses:
a_mean <- mean(subset(dat, dat$vresp > quantile(dat$vresp,3/4, na.rm=TRUE))$shape_dtw_error_mean, na.rm = TRUE)
a_sd <- sd(subset(dat, dat$vresp > quantile(dat$vresp,3/4, na.rm=TRUE))$shape_dtw_error_mean, na.rm=TRUE)
b_mean <- mean(subset(dat, dat$vresp < quantile(dat$vresp,1/4, na.rm=TRUE))$shape_dtw_error_mean, na.rm=TRUE)
b_sd <- sd(subset(dat, dat$vresp < quantile(dat$vresp,1/4, na.rm=TRUE))$shape_dtw_error_mean, na.rm=TRUE)
c_mean <- (a_mean - b_mean) / (max(dat$vresp, na.rm=TRUE) - min(dat$vresp, na.rm=TRUE)) #(quantile(dat$vresp,7/8, na.rm=TRUE) - quantile(dat$vresp,1/8, na.rm=TRUE))
d_mean <- mean(subset(dat, (dat$shape_dtw_error_mean < mean(dat$shape_dtw_error_mean, na.rm=TRUE)*1.1) & (dat$shape_dtw_error_mean > mean(dat$shape_dtw_error_mean, na.rm=TRUE)*0.9))$vresp)
inits = c(a_mean,b_mean,c_mean,d_mean,mean(a_sd, b_sd))

#generate within-subjects matrix

W = get_contrast_matrix(
        data = dat
        , formula = ~ session_num_as_fac*figure_type
)
#head(W)

#for the between-subjects contrast matrix, first reduce data to just the subject
# and between-subject predictors
dat %>%
        group_by(participant_id,condition) %>%
        summarize(n=n()) -> dat_between

#generate between-subjects contrast matrix
B0 = get_contrast_matrix(
        data = dat_between
        , formula = ~ condition
)
B = cbind(B0,B0,B0,B0)
#head(B)

# # #package in list for simple model
# data_for_stan1 = list(
# 	nY = nrow(dat) # num trials total
# 	, error = dat$shape_dtw_error_mean
# 	, speed = dat$vresp
# )
# # Compile & sample the simple model
# mod1 = rstan::stan_model('CME-MI_stats_I.stan')
# post1 = rstan::sampling(
# 	object = mod1
# 	, data = data_for_stan1
# 	, seed = 1
# 	, chains = 4
# 	, cores = 4
# 	, iter = 2000
# )
# print(
# 	post1
# 	, probs = c(.025,.975)
# 	, digits = 4
# )

#package in list for full model
data_for_stan = list(
        nY = nrow(dat) # num trials total
        , nW = ncol(W) # num within-subject effects
        , nB = ncol(B) # num between-subject effects
        , W = W #within-subject contrast matrix
        , B = B #between-subject contrast matrix
        , nS = length(unique(dat$participant_id)) # num subjects
        , S = as.numeric(factor(dat$participant_id)) #trick to turn ids into 1:nS
        , error = dat$shape_dtw_error_mean
        , speed = dat$vresp
        , ninits = length(inits)
        , inits = inits
)

# Compile & sample the full model ----
mod = rstan::stan_model('CME-MI_stats.stan')
post = rstan::sampling(
        object = mod
        , data = data_for_stan
        , seed = 1
        , chains = 4
        , cores = 4
        , iter = 200
)
# this saves object to load in R quickly: load("post.Rda")
save(post, file = "post.Rda")

# Check the posterior ----
stan_summary(post,'Znoise')

stan_ess(post, 'Zbetas')
nW = ncol(W)
nB = ncol(B0)
#datSD = sd(dat$shape_dtw_error_mean)
Zbetas = rstan::extract(post, 'Zbetas')[[1]]
a = Zbetas[,(nB*0+1):(nB*1),(nW*0+1):(nW*1)]#*datSD
b = Zbetas[,(nB*1+1):(nB*2),(nW*1+1):(nW*2)]#*datSD
c = Zbetas[,(nB*2+1):(nB*3),(nW*2+1):(nW*3)]#*datSD
d = Zbetas[,(nB*3+1):(nB*4),(nW*3+1):(nW*4)]#*datSD

a_cond = get_condition_post(
        post = post
        , par = a
        , W = W
        , B = B0
        , data = dat
        , numeric_res = 0
)

a_cond %>%
        dplyr::group_by(session_num_as_fac,figure_type,condition) %>%
        dplyr::summarize(
               med = median(value)
               , lo = quantile(value,.025)
               , hi = quantile(value,.975)
        ) %>%
        ggplot(
                mapping = aes(
                        x = session_num_as_fac
                        , y = med
                        , ymin = lo
                        , ymax = hi
                        , group = figure_type
                        , colour = figure_type
                )
        ) +
        geom_point()+
        geom_line()+
        geom_errorbar()+
        facet_wrap(~condition)+
        labs(title = "Upper Asymptote"
             , x = "Session"
             , y = "Error (pixels)"
             , color = "Condition")

b_cond = get_condition_post(
        post = post
        , par = b
        , W = W
        , B = B0
        , data = dat
        , numeric_res = 0
)

b_cond %>%
        dplyr::group_by(session_num_as_fac,figure_type,condition) %>%
        dplyr::summarize(
                med = median(value)
                , lo = quantile(value,.025)
                , hi = quantile(value,.975)
        ) %>%
        ggplot(
                mapping = aes(
                        x = session_num_as_fac
                        , y = med
                        , ymin = lo
                        , ymax = hi
                        , group = figure_type
                        , colour = figure_type
                )
        ) +
        geom_point()+
        geom_line()+
        geom_errorbar()+
        facet_wrap(~condition)+
        labs(title = "Lower Asymptote"
             , x = "Session"
             , y = "Error (pixels)"
             , color = "Condition")

c_cond = get_condition_post(
        post = post
        , par = c
        , W = W
        , B = B0
        , data = dat
        , numeric_res = 0
)

c_cond %>%
        dplyr::group_by(session_num_as_fac,figure_type,condition) %>%
        dplyr::summarize(
                med = median(value)
                , lo = quantile(value,.025)
                , hi = quantile(value,.975)
        ) %>%
        ggplot(
                mapping = aes(
                        x = session_num_as_fac
                        , y = med
                        , ymin = lo
                        , ymax = hi
                        , group = figure_type
                        , colour = figure_type
                )
        ) +
        geom_point()+
        geom_line()+
        geom_errorbar()+
        facet_wrap(~condition)+
        labs(title = "Growth Rate"
             , x = "Session"
             , y = "Max Slope of Error w.r.t. Speed (pixels per second)"
             , color = "Condition")

d_cond = get_condition_post(
        post = post
        , par = d
        , W = W
        , B = B0
        , data = dat
        , numeric_res = 0
)

d_cond %>%
        dplyr::group_by(session_num_as_fac,figure_type,condition) %>%
        dplyr::summarize(
                med = median(value)
                , lo = quantile(value,.025)
                , hi = quantile(value,.975)
        ) %>%
        ggplot(
                mapping = aes(
                        x = session_num_as_fac
                        , y = med
                        , ymin = lo
                        , ymax = hi
                        , group = figure_type
                        , colour = figure_type
                )
        ) +
        geom_point()+
        geom_line()+
        geom_errorbar()+
        facet_wrap(~condition)+
        labs(title = "Shift"
             , x = "Session"
             , y = "Speed at Max Slope (pixels per second)"
             , color = "Condition")
