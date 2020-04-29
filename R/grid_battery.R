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
#' @importFrom dplyr filter select
#'
grid_battery <- function(var, data) {

  labels_temp <- data_labels %>%
    filter(name == var) %>%
    select(battery_labels)

  formula <- as.formula(paste0("~", var))
  tib_temp <- data.table::as.data.table(survey::svytable(formula = formula, data, Ntotal = 100))
  tib_temp <- tib_temp[, data.table::data.table(t(.SD), keep.rownames = TRUE)]

  colnames(tib_temp) <- as.character(unlist(tib_temp[1,]))
  tib_temp <- as.data.table(sapply(tib_temp, as.numeric))
  tib_temp <- tib_temp[-1,-1]

  tib <- cbind(tib_temp, labels_temp)

  return(tib)

}
