#' battery
#'
#' This is a backend helper function to be used in the greater battery function
#'
#' @param var A variable
#'
#' @return A tibble
#' @export
#'
#'@import dplyr
#'
#'
#' @examples
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
