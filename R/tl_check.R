#' tl_check
#'
#' Creates a table of weight frequencies for check all that apply questions
#'
#' @param vars Vectors of variables from survey data object
#' @param data Survey data object
#'
#' @return Returns a tibble of weighted frequencies for given variables.
#'
#' @import tibble
#' @import dplyr
#' @import survey
#' @importFrom srvyr survey_mean
#' @import gt
#' @import tidyr
#' @importFrom stringr str_to_sentence str_to_upper
#' @importFrom stringi stri_extract_all_coll stri_sub
#'
#' @export
#'
#' @examples
#' tl_check(vars = c("var1_1", "var1_2", "var1_3", "var1_4"), data = df)


tl_check <- function(vars, data = tl_df)

  {

    tib_list <- lapply(vars, topliner::check, data)

    tib <- do.call(rbind, tib_list) %>%
      select(battery_labels, everything())

    tib[-1] <- lapply(tib[,-1], tl_round)

    tib <- tib[-c(2)]

    colnames(tib)[1] <- "col1"

    colnames(tib)[2] <- "Yes"

    tib <- tib %>%
      select(1, 2)

    nsize_temp <- nsize %>%
      filter(rowname == vars[1])

    sub_first <- stri_sub(vars[2], 1, 1:nchar(vars[2]))

    sstr <- na.omit(stri_extract_all_coll(vars[1], sub_first, simplify=TRUE))

    q_name <- sstr[which.max(nchar(sstr))]

    q_name <- gsub("_", "", q_name)

    gtib <- tib %>%
      gt() %>%
      cols_align(align = "center") %>%
      tab_source_note(source_note = html(paste("<i>", "N = ", nsize_temp$ncount, "<i/>", sep = ""))) %>%
#      tab_source_note(source_note = "  ") %>%
      cols_align(align = "left",
                 columns = c(1)) %>%
      cols_label(col1 = html(paste(battery_fill)))

    label <- data_labels %>%
      filter(name==vars[1])

    cat("<br />")
    cat("<br />")

    if (!is.na(label$skip_logic)) {
      cat("<i>")
      cat(paste(label$skip_logic))
      cat("</i>")
      cat("<br />")

    }

    cat("<b>")
    cat(paste(str_to_upper(q_name), label$question_labels, sep = ". "))
    cat("</b>")
    cat("<br />")
    cat("<br />")

    if (!is.na(label$question_logic)) {
      cat("<b>")
      cat(paste(label$question_logic))
      cat("</b>")
      cat("<br />")
      cat("<br />")
    }

    return(gtib)

  }
