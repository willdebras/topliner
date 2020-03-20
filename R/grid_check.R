#' grid_check
#'
#' This is a helper function to create grid check all that apply question table.
#'
#' @param var A variable of interest from survey design.
#'
#' @return A data.table output of survey proportions for provided variable.
#'
#' @import data.table
#' @import survey
#'
grid_check <- function(var, svy_dt) {

  formula <- as.formula(paste0("~", var))
  survey_output <- data.table::as.data.table(survey::svytable(formula = formula, svy_dt, Ntotal = 100))
  survey_output <- survey_output[, data.table::data.table(t(.SD), keep.rownames = TRUE)]

  return(survey_output)

}
