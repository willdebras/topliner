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
grid_battery <- function(var, data) {

  formula <- as.formula(paste0("~", var))
  tib_temp <- data.table::as.data.table(survey::svytable(formula = formula, data, Ntotal = 100))
  tib_temp <- tib_temp[, data.table::data.table(t(.SD), keep.rownames = TRUE)]

  return(tib_temp)

}
