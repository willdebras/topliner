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
grid_check <- function(var, data) {

  formula <- as.formula(paste0("~", var))
  survey_output <- data.table::as.data.table(survey::svytable(formula = formula, svy_dt, Ntotal = 100))
  survey_output <- survey_output[, data.table::data.table(t(.SD), keep.rownames = TRUE)]

  colnames(tib_temp) <- as.character(unlist(tib_temp[1,]))
  tib_temp <- as.data.table(sapply(tib_temp, as.numeric))
  tib_temp <- tib_temp[-1,-1]


  return(survey_output)

}
