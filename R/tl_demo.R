#' tl_demo
#'
#' Function to output demo vars with no netting, rounding, or combination of skp/ref
#'
#' @param var Variable in your survey data object
#' @param data Survey data object
#'
#' @return Tibble with weighted frequencies
#' @export
#'
#' @import dplyr
#' @import survey
#' @importFrom srvyr survey_mean
#'
#' @examples tl_demO(raceth, data = survey_data)
#'
tl_demo <- function(var, data = nk) {

  tib <- nk %>%
    group_by_at(vari) %>%
    summarise(perc = survey_mean()) %>%
    select(vari, perc) %>%
    spread(vari, perc) %>%
    gather() %>%
    mutate(Percentage = ifelse(value >= 0.005, round(100*value, digits = 0), value)) %>%
    mutate(Percentage = ifelse(value == 0, "-", Percentage)) %>%
    mutate(Percentage = ifelse(value > 0 & value < 0.005, "*", Percentage)) %>%
    select(key, Percentage)
}
