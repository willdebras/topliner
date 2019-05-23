#' tl_setup
#'
#' A function that produces several objects in the parent environment for use of the tl_tib and tl_bat functions
#'
#' @param data dataframe for making of topline
#' @param caseids caseid variable of dataframe in form of string
#' @param weights weights variable of dataframe in form of string
#' @param dates character string of dates
#' @param APNORC specifies whether the topline is for AP-NORC or another department. Defaults TRUE
#'
#' @return produces three objects in the environment: a survey object for functions to call, a character string to pipe field dates, and a dataframe of nsizes for each question to pipe into tables
#' @export
#'
#' @importFrom srvyr as_survey_design
#' @import dplyr
#' @importFrom tibble rownames_to_column
#'
#' @examples tl_setup(omnibusdata, caseids = "su_id", weights = "weight_ap", dates = "05/14-17/2019", APNORC = TRUE)
tl_setup <- function(data, caseids, weights, dates, APNORC = TRUE) {

  tl_df <<- data %>%
    as_survey_design(ids = caseids, weights = weights)

  field_dates <- dates

  if (APNORC) {
    battery_fill <<- paste("AP-NORC", "<br />", field_dates, sep = " ")
  }

  else {
    battery_fill <<- paste("NORC", "<br />", field_dates, sep = " ")

  }


  nsize <<- as.data.frame(colSums(!is.na(data))) %>%
    rownames_to_column() %>%
    rename(ncount = 2) %>%
    mutate(ncount = prettyNum(ncount, big.mark = ","))

}
