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
  require(stringr)
  if (spss) {
    labels <- attr(data, "variable.labels")
    labels <- tibble(name = tolower(names(labels)),
                     label = labels)
  }
  else {
    labels <- sapply(data, function(x) attr(x, "label"))
    labels <- tibble(name = names(labels),
                     label = labels)
  }

  battery_labels <- str_extract(labels$label, "(?<=\\[)(.*?)(?=\\])")
  question_labels <- str_replace(labels$label, "(?<=\\[)(.*?)(?=\\])", "")
  question_labels <- gsub("\\[", "", question_labels)
  question_labels <- gsub("\\]", "", question_labels)
  question_labels <- str_trim(question_labels)

  labels <- labels %>%
    cbind(battery_labels) %>%
    cbind(question_labels)

  data_labels <<- labels
  #assign("labels", labels, envir = .GlobalEnv)

}
