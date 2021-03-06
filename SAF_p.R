##### Speed Accuracy Functions #####
       ## each participant ##
  ### authored by Tony Ingram ###

rm(list=setdiff(ls(), c("all_figs","all_data","post"))) # clear all but all_figs & all_data
graphics.off() # clear figures

library(tidyverse)

load("all_data.Rda")

# REMOVE EXREME VALUES DUE TO TECHNICAL ERRORS:

all_data_sub <- dplyr::filter(
        .data = all_data
        # , shape_dtw_error_mean < 400
        # , vresp > 200
        # , scale < 2
        # , rotation < 1
        # , translation < 400
) # note: this removes all MI and CC trials, so do next two lines to see how many dropped:
aggregate(!is.na(PLresp) ~ stimulus_gt, all_data, sum)
aggregate(!is.na(PLresp) ~ stimulus_gt, all_data_sub, sum)


## SET UP PARTICIPANT ##
# what participant?
p <- 67
#fig <- dplyr::filter(all_data, participant_id == p, figure_type != "random")$figure_type[1] # can't remember why I did this... old code I guess


##### SESSION TO SESSION CHANGES #####

# ## RAW error against speed:
# ggplot(subset(all_data_sub, participant_id == p)
#        , mapping = aes(
#                 x = vresp, y = raw_error_mean
#                 , color = factor(session_num)
# )) + geom_point(na.rm = TRUE, alpha = .5) + 
#         geom_smooth(na.rm = TRUE) + 
#         theme_minimal() +
#         facet_grid(. ~ figure_type) +
#         labs(title = "Raw Error"
#              , x = "Velocity"
#              , y = "Raw Error"
#              , color = "Session")

## RAW DTW error against speed:
ggplot(subset(all_data_sub, participant_id == p)
       , mapping = aes(
               x = vresp, y = raw_dtw_error_mean
               , color = factor(session_num)
       )) + geom_point(na.rm = TRUE, alpha = .5) + 
        geom_smooth(na.rm = TRUE) + 
        theme_minimal() +
        facet_grid(. ~ figure_type) +
        labs(title = "Raw DTW Error"
             , x = "Velocity"
             , y = "Raw DTW Error"
             , color = "Session")

# ## SHAPE error against speed:
# ggplot(subset(all_data_sub, participant_id == p)
#        , mapping = aes(
#                x = vresp, y = shape_error_mean
#                , color = factor(session_num)
# )) + geom_point(na.rm = TRUE, alpha = .5) + 
#         geom_smooth(na.rm = TRUE) + 
#         theme_minimal() +
#         facet_grid(. ~ figure_type) +
#         labs(title = "Shape Error"
#              , x = "Velocity"
#              , y = "Shape Error"
#              , color = "Session")

## SHAPE DTW error against speed:
ggplot(subset(all_data_sub, participant_id == p)
       , mapping = aes(
               x = vresp, y = shape_dtw_error_mean
               , color = factor(session_num)
       )) + geom_point(na.rm = TRUE, alpha = .5) + 
        geom_smooth(na.rm = TRUE) + 
        theme_minimal() +
        facet_grid(. ~ figure_type) +
        labs(title = "Shape DTW Error"
             , x = "Velocity"
             , y = "Shape DTW Error"
             , color = "Session")

## Absolute features DTW error against speed:
ggplot(subset(all_data_sub, participant_id == p)
       , mapping = aes(
               x = vresp, y = abs_dtw_error_mean
               , color = factor(session_num)
       )) + geom_point(na.rm = TRUE, alpha = .5) + 
        geom_smooth(na.rm = TRUE) + 
        theme_minimal() +
        facet_grid(. ~ figure_type) +
        labs(title = "Absolute Features DTW Error"
             , x = "Velocity"
             , y = "Absolute DTW Error"
             , color = "Session")

# ## SCALE error against speed:
# ggplot(subset(all_data_sub, participant_id == p)
#        , mapping = aes(
#                x = vresp, y = scale
#                , color = factor(session_num)
#        )) + geom_point(na.rm = TRUE, alpha = .5) + 
#         geom_smooth(na.rm = TRUE) + 
#         theme_minimal() +
#         facet_grid(. ~ figure_type) +
#         labs(title = "Scale Error"
#              , x = "Velocity"
#              , y = "Scale Error"
#              , color = "Session")

## SCALE DTW error against speed:
ggplot(subset(all_data_sub, participant_id == p)
       , mapping = aes(
               x = vresp, y = scale_dtw
               , color = factor(session_num)
       )) + geom_point(na.rm = TRUE, alpha = .5) + 
        geom_smooth(na.rm = TRUE) + 
        theme_minimal() +
        facet_grid(. ~ figure_type) +
        labs(title = "Scale DTW Error"
             , x = "Velocity"
             , y = "Scale DTW Error"
             , color = "Session")

# ## ROTATION error against speed:
# ggplot(subset(all_data_sub, participant_id == p)
#        , mapping = aes(
#                x = vresp, y = rotation
#                , color = factor(session_num)
#        )) + geom_point(na.rm = TRUE, alpha = .5) + 
#         geom_smooth(na.rm = TRUE) + 
#         theme_minimal() +
#         facet_grid(. ~ figure_type) +
#         labs(title = "Rotation Error"
#              , x = "Velocity"
#              , y = "Rotation Error"
#              , color = "Session")

## ROTATION DTW error against speed:
ggplot(subset(all_data_sub, participant_id == p)
       , mapping = aes(
               x = vresp, y = rotation_dtw
               , color = factor(session_num)
       )) + geom_point(na.rm = TRUE, alpha = .5) + 
        geom_smooth(na.rm = TRUE) + 
        theme_minimal() +
        facet_grid(. ~ figure_type) +
        labs(title = "Rotation DTW Error"
             , x = "Velocity"
             , y = "Rotation DTW Error"
             , color = "Session")

# ## TRANSLATION error against speed:
# ggplot(subset(all_data_sub, participant_id == p)
#        , mapping = aes(
#                x = vresp, y = translation
#                , color = factor(session_num)
#        )) + geom_point(na.rm = TRUE, alpha = .5) + 
#         geom_smooth(na.rm = TRUE) + 
#         theme_minimal() +
#         facet_grid(. ~ figure_type) +
#         labs(title = "Translation Error"
#              , x = "Velocity"
#              , y = "Translation Error"
#              , color = "Session")

## TRANSLATION DTW error against speed:
ggplot(subset(all_data_sub, participant_id == p)
       , mapping = aes(
               x = vresp, y = translation_dtw
               , color = factor(session_num)
       )) + geom_point(na.rm = TRUE, alpha = .5) + 
        geom_smooth(na.rm = TRUE) + 
        theme_minimal() +
        facet_grid(. ~ figure_type) +
        labs(title = "Translation DTW Error"
             , x = "Velocity"
             , y = "Translation DTW Error"
             , color = "Session")


## 3D plots of speed-complexity-error ##
# library(rgl)


