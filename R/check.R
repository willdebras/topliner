#' check
#'
#' This is a backend helper function to be used in the greater check all that apply function
#'
#' @param var is a variable
#'
#' @return A row with survey weighted frequency of yes, no, and grid item text.
#'
#' @export
#'
#' @import dplyr
#'
check <- function(var, data)

  {

    label_temp <- data_labels %>%
      filter(name == var) %>%
      select(battery_labels)

    tib_temp <- data %>%
      group_by_at(var) %>%
      summarise(perc = survey_mean(na.rm = TRUE)) %>%
      select(c(1, 2)) %>%
      spread(var, perc)

    tib <- cbind(tib_temp, label_temp)

}
