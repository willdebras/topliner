#' tl_round
#'
#' This function is a helper function that rounds a number to AP-NORC style guidelines
#'
#' @param x is a number
#'
#' @return number rounded to percentage, - for zero, * for below .5%
#'
#' @export
#'
#' @examples tl_round(.48273)
#' tib[-1] <- lapply(tib[-1], "apnorc_round")
#'
#'
#'
tl_round <- function(x){
  ifelse(x = 0.5, 1,
  ifelse(x > 0.5, round(x, digits = 0),
         ifelse(x == 0, "-",
                ifelse((x > 0 & x < 0.5), "*", NA))))
}
