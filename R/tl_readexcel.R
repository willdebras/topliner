#' tl_readexcel
#'
#' @param filename A reference to an excel workbook
#' @param tibble Binary parameter to specify type of file. Defaults to list of tibbles, otherwise produces list of dataframes
#'
#' @return A list of tibbles or dataframes to for reference by trend data
#' @export
#'
#' @examples trends <- tl_readexcel("C:\\documents\\file.xlsx")
#'
#' @importFrom readxl excel_sheets read_excel
#'
tl_readexcel <- function(filename, tibble = TRUE) {
  sheets <- readxl::excel_sheets(filename)
  x <- lapply(sheets, function(X) readxl::read_excel(filename, sheet = X))
  if(!tibble) x <- lapply(x, as.data.frame)
  names(x) <- sheets
  x
}
