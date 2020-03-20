#' grid_battery
#'
#' This is a helper function to create grid battery question table.
#'
#' @param var A variable of interest from survey design.
#'
#' @return A data.table output of survey proportions for provided variable.
#'
#' @import data.table
#' @import survey
#'
bat <- function(var, data) {

  labels_temp <- data_labels %>%
    filter(name == var) %>%
    select(battery_labels)

  tib_temp <- data %>%
    group_by_at(var) %>%
    summarise(perc = survey_mean(na.rm = TRUE)) %>%
    select(c(1, 2)) %>%
    spread(var, perc)

  tib <- cbind(tib_temp, labels_temp)

}

grid_battery <- function(var, svy_dt) {

  survey_output <- as.data.table(svytable(~var, svy_dt, Ntotal = 100))
  survey_output <- survey_output[, data.table(t(.SD), keep.rownames = TRUE)]

  return(survey_output)

}

