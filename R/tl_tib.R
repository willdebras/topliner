#' tl_tib
#'
#' This function produces a table with survey weighted frequencies and proper netting.
#' It creates default net categories that one can toggle on and off, the creation of custom nets, and the specification of survey mode.
#' This is useful for the creation of toplines in R.
#'
#'
#' @param vari A variable for which you want to produce frequencies
#' @param data A survey-object dataset
#' @param default Default creates generic nets. Specifying `default = FALSE` will remove all nets. Specifying custom nets will remove default netting.
#' @param top The number of columns you want to net from the beginning. Ex: `top = 2`
#' @param bot The number of columns you want to net from the end. Ex: `bot = 3`
#' @param na `na = TRUE` specifies the question has a "Not applicable" category to be excluded from netting.
#' @param web `web = TRUE` specifies there is only one "Skipped" category
#'
#' @return Returns a table of survey weighted frequencies with net categories if specified
#'
#' @import dplyr
#' @import survey
#' @importFrom srvyr survey_mean
#' @import gt
#' @import tidyr
#' @importFrom stringr str_detect str_to_sentence str_to_upper
#' @import data.table
#'
#' @export
#'
#' @examples
#' tl_tib("q3", data = df, default = TRUE)
#' tl_tib("q2", data = df, top = 3, bot = 2, na = TRUE)
#'
tl_tib <- function(vari, data = tl_df, default = TRUE, res = 3, top = 0, bot = 0, demo = FALSE) {



  label <- data_labels %>%
    filter(name==vari)

  var_form <- as.formula(paste0("~", vari))

  tib <- as.data.table(svytable(var_form, data, Ntotal = 100)) %>%
    `colnames<-`(c(vari, "perc"))

  tib <- tib[, data.table::data.table(t(.SD))]
  colnames(tib) <- as.character(unlist(tib[1,]))
  tib <- as.data.table(sapply(tib, as.numeric))
  tib <- tib[-1,]

  tibtest <- tib

  tib <- data.table::setDF(tib)





  if (top > 0 | bot > 0) {
    default = FALSE
  }

  if (default) {
    if ((ncol(tib) - res) == 5) {
      tib <- tib %>%
        mutate(`Top NET` = apply(tib[, c(1:2)], 1, sum)) %>%
        mutate(`Bot NET` = apply(tib[, c(4:5)], 1, sum)) %>%
        select(`Top NET`, 1:3, `Bot NET`, everything())

    }

    else if ((ncol(tib) - res) == 4) {
      tib <- tib %>%
        mutate(`Top NET` = apply(tib[, c(1:2)], 1, sum)) %>%
        mutate(`Bot NET` = apply(tib[, c(3:4)], 1, sum)) %>%
        select(`Top NET`, 1:2, `Bot NET`, everything())

    }

    else if ((ncol(tib) - res) == 7) {
      tib <- tib %>%
        mutate(`Top NET` = apply(tib[, c(1:3)], 1, sum)) %>%
        mutate(`Bot NET` = apply(tib[, c(5:7)], 1, sum)) %>%
        select(`TOP NET`, 1:4, `BOT NET`, everything())


    }

    else {
      tib <- tib

    }
  }

  else if (top > 0 & bot > 0) {
    tib <- tib %>%
      mutate(`Top NET` = apply(tib[, c(1:top)], 1, sum)) %>%
      select(`Top NET`, everything())

    first <- ncol(tib) - bot - res + 1
    last <- ncol(tib) - res

    tib <- tib %>%
      mutate(`Bot NET` = apply(tib[, c(first:last)], 1, sum))
    tib <- tib %>%
      select(1:(first - 1), ncol(tib), first:(ncol(tib) - 1))


  }


  else if (top > 0) {
    tib <- tib %>%
      mutate(`Top NET` = apply(tib[, c(1:top)], 1, sum)) %>%
      select(`Top NET`, everything())

  }

  else if (bot > 0) {
    first <- ncol(tib) - bot - res + 1
    last <- ncol(tib) - res

    tib <- tib %>%
      mutate(`Bot NET` = apply(tib[, c(first:last)], 1, sum))
    tib <- tib %>%
      select(1:(first - 1), ncol(tib), first:(ncol(tib) - 1))

  }

  else {
    tib <- tib

  }


  if (res == 3 | res == 4) {
    tib <- tib %>%
      mutate(`SKIPPED/REFUSED` = .[[ncol(tib)]] + .[[(ncol(tib) - 1)]])

    tib <- tib %>%
      subset(select = -c((ncol(tib) - 2), ncol(tib) - 1))

  }


  tib <- tib %>%
    gather() %>%
    select(key, value)



  tib[-1] <- lapply(tib[-1], tl_round)


  tib <- tib %>%
    mutate(key = ifelse(
      str_detect(key, "REF") |
        str_detect(key, "SKIP") |
        str_detect(key, "DON"),
      str_to_upper(key),
      key
    ))

  nsize_temp <- nsize %>%
    filter(rowname == vari)

  tib_loc <- tib %>%
    mutate(row_num = seq.int(nrow(tib))) %>%
    filter(str_detect(key, "NET"))

  colnames(tib)[1] <- " "

  gtib <- tib %>%
    gt() %>%
    #tab_header(
    #  title = label$label
    #) %>%
    cols_align(align = "center") %>%
    tab_source_note(source_note = html(paste(
      "<i>", "N = ", nsize_temp$ncount, "<i/>", sep = ""
    ))) %>%
#    tab_source_note(source_note = "  ") %>%
#    tab_source_note(source_note = "  ") %>%
    tab_style(
      style = list(cell_text(weight = "bold")),
      locations = cells_data(rows = tib_loc$row_num)
    ) %>%
    cols_align(align = "left",
               columns = c(1)) %>%
    cols_label(value = html(paste(battery_fill)))

  if (default) {
    if ((ncol(tibtest) - res) == 5) {

      gtib <- gtib %>%
        tab_style(
          style = list(cell_text(weight = "bold")),
          locations = cells_data(rows = 4)
        )


    }

  }

  cat("<br />")
  cat("<br />")

  if (!is.na(label$skip_logic)) {
    cat("<i>")
    cat(paste(label$skip_logic))
    cat("</i>")
    cat("<br />")
  }


  cat("<b>")
  cat(paste(str_to_upper(label$name), label$label, sep = ". "))
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
