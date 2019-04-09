#' tl_labels
#'
#' Create a dataframe of variables and labels to print in tables
#'
#' @param data Dataframe from which you want to draw labels
#' @param spss Whether the dataset is from SPSS or not. Defaults to FALSE.
#'
#' @return Returns a dataframe of variable names and associated labels assigned to attributes
#' @export
#' @importFrom tibble tibble
#' @examples labels <- tl_labels(omnibus0319, SPSS = TRUE)
#'
#'
tl_labels <- function(data, spss = FALSE) {
  if (spss) {
    labels <- attr(data, "variable.labels")
    tibble(name = tolower(names(labels)),
           label = labels)
  }
  else {
    labels <- sapply(data, function(x) attr(x, "label"))
    tibble(name = names(labels),
           label = labels)
  }
}
