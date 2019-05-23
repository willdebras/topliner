#' tl_labels
#'
#' Create a dataframe of variables and labels to print in tables
#'
#' @param data Dataframe from which you want to draw labels
#' @param spss Whether the dataset is from SPSS or not. Defaults to FALSE.
#'
#' @return Returns a data object of variable names and associated labels to the environment for other functions to use
#' @export
#' @importFrom tibble tibble
#' @examples tl_labels(omnibus0319, SPSS = TRUE)
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

  labels$skip_logic <- NA

  data_labels <<- labels
  #assign("labels", labels, envir = .GlobalEnv)

  data_labels$label <- vapply(data_labels$label, paste, collapse = ", ", character(1L))

  temp <<- tempfile("data_labels", fileext = ".csv")
  write.csv(data_labels, file = temp, row.names=FALSE)
  shell.exec(temp)

}
