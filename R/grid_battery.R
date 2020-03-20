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
grid_battery <- function(var, svy_dt) {

  formula <- paste0("~", "var")
  survey_output <- as.data.table(svytable(formula = formula, svy_dt, Ntotal = 100))
  survey_output <- survey_output[, data.table(t(.SD), keep.rownames = TRUE)]

  return(survey_output)

}
