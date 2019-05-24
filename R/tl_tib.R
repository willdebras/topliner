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
#'
#' @export
#'
#' @examples
#' tl_tib("q3", data = df, default = TRUE)
#' tl_tib("q2", data = df, top = 3, bot = 2, na = TRUE)
#'
tl_tib <- function(vari, data = tl_df, default = TRUE, top = 0, bot = 0, na = FALSE, web = FALSE) {

  label <- data_labels %>%
    filter(name==vari)


  tib <- data %>%
    group_by_at(vari) %>%
    summarise(perc = survey_mean(na.rm = TRUE)) %>%
    select(vari, perc) %>%
    spread(vari, perc)

  if (web) {

    if(na) {


      if(top>0) {
        default = FALSE
      }

      if(bot>0) {
        default = FALSE
      }

      if(default) {


        if ((ncol(tib)==7)) {

          tib <- tib %>%
            mutate(`Top NET` = .[[1]] + .[[2]]) %>%
            mutate(`Bottom NET` = .[[4]] + .[[5]]) %>%
            select(8, 1, 2, 3, 9, 4, 5, 6, 7)

        }


        else if ((ncol(tib)==9)) {

          tib <- tib %>%
            mutate(`Top NET` = .[[1]] + .[[2]] + .[[3]]) %>%
            mutate(`Bottom NET` = .[[5]] + .[[6]] + .[[7]]) %>%
            select(10, 1, 2, 3, 4, 11, 5, 6, 7, 8, 9)

        }


        else if ((ncol(tib)==6)) {

          tib <- tib %>%
            mutate(`Top NET` = .[[1]] + .[[2]]) %>%
            mutate(`Bottom NET` = .[[3]] + .[[4]]) %>%
            select(7, 1, 2, 8, 3, 4, 5, 6)

        }

        else {
          tib <- tib

        }

        tib <- tib %>%
          gather() %>%
          mutate(Percentage = ifelse(value >= 0.005, round(100*value, digits = 0), value)) %>%
          mutate(Percentage = ifelse(value == 0, "-", Percentage)) %>%
          mutate(Percentage = ifelse(value > 0 & value < 0.005, "*", Percentage)) %>%
          select(key, Percentage)
      }


      else {

        if (top>0&bot>0) {
          tib <- tib %>%
            mutate(`TOP NET` = apply(tib[,c(1:top)], 1, sum)) %>%
            select(`TOP NET`, everything())

          first <- ncol(tib)-bot-1
          last <- ncol(tib)-2

          tib <- tib %>%
            mutate(`BOT NET` = apply(tib[,c(first:last)], 1, sum))
          tib <- tib %>%
            select(1:(first-1), ncol(tib), first:(ncol(tib)-1))


          tib <- tib %>%
            gather() %>%
            mutate(Percentage = ifelse(value >= 0.005, round(100*value, digits = 0), value)) %>%
            mutate(Percentage = ifelse(value == 0, "-", Percentage)) %>%
            mutate(Percentage = ifelse(value > 0 & value < 0.005, "*", Percentage)) %>%
            select(key, Percentage)

        }


        else if (top>0) {
          tib <- tib %>%
            mutate(`TOP NET` = apply(tib[,c(1:top)], 1, sum)) %>%
            select(`TOP NET`, everything())

          tib <- tib %>%
            gather() %>%
            mutate(Percentage = ifelse(value >= 0.005, round(100*value, digits = 0), value)) %>%
            mutate(Percentage = ifelse(value == 0, "-", Percentage)) %>%
            mutate(Percentage = ifelse(value > 0 & value < 0.005, "*", Percentage)) %>%
            select(key, Percentage)

        }

        else if (bot>0) {

          first <- ncol(tib)-bot-1
          last <- ncol(tib)-2

          tib <- tib %>%
            mutate(`BOT NET` = apply(tib[,c(first:last)], 1, sum))
          tib <- tib %>%
            select(1:(first-1), ncol(tib), first:(ncol(tib)-1))

          tib <- tib %>%
            gather() %>%
            mutate(Percentage = ifelse(value >= 0.005, round(100*value, digits = 0), value)) %>%
            mutate(Percentage = ifelse(value == 0, "-", Percentage)) %>%
            mutate(Percentage = ifelse(value > 0 & value < 0.005, "*", Percentage)) %>%
            select(key, Percentage)

        }



        else {
          tib <- tib %>%
            gather() %>%
            mutate(Percentage = ifelse(value >= 0.005, round(100*value, digits = 0), value)) %>%
            mutate(Percentage = ifelse(value == 0, "-", Percentage)) %>%
            mutate(Percentage = ifelse(value > 0 & value < 0.005, "*", Percentage)) %>%
            select(key, Percentage)
        }
      }

      tib <- tib %>%
        mutate(key = ifelse(str_detect(key, "REF")|str_detect(key, "SKIP")|str_detect(key, "DON"), str_to_sentence(key), key))

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
        tab_source_note(source_note = html(paste("<i>", "N = ", nsize_temp$ncount, "<i/>", sep = ""))) %>%
        tab_source_note(source_note = "  ") %>%
        tab_source_note(source_note = "  ") %>%
        tab_style(
          style = cells_styles(
            text_weight = "bold"),
          locations = cells_data(rows = tib_loc$row_num)) %>%
        cols_align(align = "left",
                   columns = c(1)) %>%
        cols_label(Percentage = html(paste(battery_fill)))

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

      return(gtib)


    }

    else {

      if(top>0) {
        default = FALSE
      }

      if(bot>0) {
        default = FALSE
      }

      if(default) {


        if ((ncol(tib)==6)) {

          tib <- tib %>%
            mutate(`Top NET` = .[[1]] + .[[2]]) %>%
            mutate(`Bottom NET` = .[[4]] + .[[5]])
          select(7, 1, 2, 3, 8, 4, 5, 6)

        }


        else if ((ncol(tib)==8)) {

          tib <- tib %>%
            mutate(`Top NET` = .[[1]] + .[[2]] + .[[3]]) %>%
            mutate(`Bottom NET` = .[[5]] + .[[6]] + .[[7]]) %>%
            select(9, 1, 2, 3, 4, 10, 5, 6, 7, 8)

        }


        else if ((ncol(tib)==5)) {

          tib <- tib %>%
            mutate(`Top NET` = .[[1]] + .[[2]]) %>%
            mutate(`Bottom NET` = .[[3]] + .[[4]]) %>%
            select(6, 1, 2, 7, 3, 4, 5)

        }

        else {
          tib <- tib

        }

        tib <- tib %>%
          gather() %>%
          mutate(Percentage = ifelse(value >= 0.005, round(100*value, digits = 0), value)) %>%
          mutate(Percentage = ifelse(value == 0, "-", Percentage)) %>%
          mutate(Percentage = ifelse(value > 0 & value < 0.005, "*", Percentage)) %>%
          select(key, Percentage)
      }


      else {

        if (top>0&bot>0) {
          tib <- tib %>%
            mutate(`TOP NET` = apply(tib[,c(1:top)], 1, sum)) %>%
            select(`TOP NET`, everything())


          first <- ncol(tib)-bot
          last <- ncol(tib)-1

          tib <- tib %>%
            mutate(`BOT NET` = apply(tib[,c(first:last)], 1, sum))
          tib <- tib %>%
            select(1:(first-1), ncol(tib), first:(ncol(tib)-1))


          tib <- tib %>%
            gather() %>%
            mutate(Percentage = ifelse(value >= 0.005, round(100*value, digits = 0), value)) %>%
            mutate(Percentage = ifelse(value == 0, "-", Percentage)) %>%
            mutate(Percentage = ifelse(value > 0 & value < 0.005, "*", Percentage)) %>%
            select(key, Percentage)

        }


        else if (top>0) {
          tib <- tib %>%
            mutate(`TOP NET` = apply(tib[,c(1:top)], 1, sum)) %>%
            select(`TOP NET`, everything())



          tib <- tib %>%
            gather() %>%
            mutate(Percentage = ifelse(value >= 0.005, round(100*value, digits = 0), value)) %>%
            mutate(Percentage = ifelse(value == 0, "-", Percentage)) %>%
            mutate(Percentage = ifelse(value > 0 & value < 0.005, "*", Percentage)) %>%
            select(key, Percentage)

        }

        else if (bot>0) {

          first <- ncol(tib)-bot
          last <- ncol(tib)-1

          tib <- tib %>%
            mutate(`BOT NET` = apply(tib[,c(first:last)], 1, sum))
          tib <- tib %>%
            select(1:(first-1), ncol(tib), first:(ncol(tib)-1))

          tib <- tib %>%
            gather() %>%
            mutate(Percentage = ifelse(value >= 0.005, round(100*value, digits = 0), value)) %>%
            mutate(Percentage = ifelse(value == 0, "-", Percentage)) %>%
            mutate(Percentage = ifelse(value > 0 & value < 0.005, "*", Percentage)) %>%
            select(key, Percentage)

        }



        else {
          tib <- tib %>%
            gather() %>%
            mutate(Percentage = ifelse(value >= 0.005, round(100*value, digits = 0), value)) %>%
            mutate(Percentage = ifelse(value == 0, "-", Percentage)) %>%
            mutate(Percentage = ifelse(value > 0 & value < 0.005, "*", Percentage)) %>%
            select(key, Percentage)
        }
      }

      tib <- tib %>%
        mutate(key = ifelse(str_detect(key, "REF")|str_detect(key, "SKIP")|str_detect(key, "DON"), str_to_sentence(key), key))

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
        tab_source_note(source_note = html(paste("<i>", "N = ", nsize_temp$ncount, "<i/>", sep = ""))) %>%
        tab_source_note(source_note = "  ") %>%
        tab_source_note(source_note = "  ") %>%
        tab_style(
          style = cells_styles(
            text_weight = "bold"),
          locations = cells_data(rows = tib_loc$row_num)) %>%
        cols_align(align = "left",
                   columns = c(1)) %>%
        cols_label(Percentage = html(paste(battery_fill)))

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

      return(gtib)
    }

  }

  else {

    if(na) {


      if(top>0) {
        default = FALSE
      }

      if(bot>0) {
        default = FALSE
      }

      if(default) {


        if ((ncol(tib)==9)) {

          tib <- tib %>%
            mutate(`Top NET` = .[[1]] + .[[2]]) %>%
            mutate(`Bottom NET` = .[[4]] + .[[5]]) %>%
            mutate(`Skipped/Refused` = .[[8]] + .[[9]]) %>%
            select(10, 1, 2, 3, 11, 4, 5, 6, 7, 12)

        }


        else if ((ncol(tib)==11)) {

          tib <- tib %>%
            mutate(`Top NET` = .[[1]] + .[[2]] + .[[3]]) %>%
            mutate(`Bottom NET` = .[[5]] + .[[6]] + .[[7]]) %>%
            mutate(`Skipped/Refused` = .[[10]] + .[[11]]) %>%
            select(12, 1, 2, 3, 4, 13, 5, 6, 7, 8, 9, 14)

        }


        else if ((ncol(tib)==8)) {

          tib <- tib %>%
            mutate(`Top NET` = .[[1]] + .[[2]]) %>%
            mutate(`Bottom NET` = .[[3]] + .[[4]]) %>%
            mutate(`Skipped/Refused` = .[[7]] + .[[8]]) %>%
            select(9, 1, 2, 10, 3, 4, 5, 6, 11)

        }

        else {
          tib <- tib %>%
            mutate(`Skipped/Refused` = .[[ncol(tib)]] + .[[(ncol(tib)-1)]]) %>%
            subset(select = -c((ncol(tib)-1), ncol(tib)))

        }

        tib <- tib %>%
          gather() %>%
          mutate(Percentage = ifelse(value >= 0.005, round(100*value, digits = 0), value)) %>%
          mutate(Percentage = ifelse(value == 0, "-", Percentage)) %>%
          mutate(Percentage = ifelse(value > 0 & value < 0.005, "*", Percentage)) %>%
          select(key, Percentage)
      }


      else {

        if (top>0&bot>0) {
          tib <- tib %>%
            mutate(`TOP NET` = apply(tib[,c(1:top)], 1, sum)) %>%
            select(`TOP NET`, everything()) %>%
            mutate(`Skipped/Refused` = .[[ncol(tib)]] + .[[(ncol(tib)-1)]])
          tib <- tib %>%
            subset(select = -c((ncol(tib)-2), ncol(tib)-1))



          first <- ncol(tib)-bot-1-1
          last <- ncol(tib)-2-1

          tib <- tib %>%
            mutate(`BOT NET` = apply(tib[,c(first:last)], 1, sum))
          tib <- tib %>%
            select(1:(first-1), ncol(tib), first:(ncol(tib)-1))


          tib <- tib %>%
            gather() %>%
            mutate(Percentage = ifelse(value >= 0.005, round(100*value, digits = 0), value)) %>%
            mutate(Percentage = ifelse(value == 0, "-", Percentage)) %>%
            mutate(Percentage = ifelse(value > 0 & value < 0.005, "*", Percentage)) %>%
            select(key, Percentage)

        }


        else if (top>0) {
          tib <- tib %>%
            mutate(`TOP NET` = apply(tib[,c(1:top)], 1, sum)) %>%
            select(`TOP NET`, everything()) %>%
            mutate(`Skipped/Refused` = .[[ncol(tib)]] + .[[(ncol(tib)-1)]])
          tib <- tib %>%
            subset(select = -c((ncol(tib)-2), ncol(tib)-1))



          tib <- tib %>%
            gather() %>%
            mutate(Percentage = ifelse(value >= 0.005, round(100*value, digits = 0), value)) %>%
            mutate(Percentage = ifelse(value == 0, "-", Percentage)) %>%
            mutate(Percentage = ifelse(value > 0 & value < 0.005, "*", Percentage)) %>%
            select(key, Percentage)

        }

        else if (bot>0) {

          first <- ncol(tib)-bot-2-1
          last <- ncol(tib)-3-1

          tib <- tib %>%
            mutate(`BOT NET` = apply(tib[,c(first:last)], 1, sum))
          tib <- tib %>%
            select(1:(first-1), ncol(tib), first:(ncol(tib)-1))

          tib <- tib %>%
            mutate(`Skipped/Refused` = .[[ncol(tib)]] + .[[(ncol(tib)-1)]]) %>%
            subset(select = -c((ncol(tib)-1), ncol(tib)))


          tib <- tib %>%
            gather() %>%
            mutate(Percentage = ifelse(value >= 0.005, round(100*value, digits = 0), value)) %>%
            mutate(Percentage = ifelse(value == 0, "-", Percentage)) %>%
            mutate(Percentage = ifelse(value > 0 & value < 0.005, "*", Percentage)) %>%
            select(key, Percentage)

        }



        else {
          tib <- tib %>%
            gather() %>%
            mutate(Percentage = ifelse(value >= 0.005, round(100*value, digits = 0), value)) %>%
            mutate(Percentage = ifelse(value == 0, "-", Percentage)) %>%
            mutate(Percentage = ifelse(value > 0 & value < 0.005, "*", Percentage)) %>%
            select(key, Percentage)
        }
      }

      tib <- tib %>%
        mutate(key = ifelse(str_detect(key, "REF")|str_detect(key, "SKIP")|str_detect(key, "DON"), str_to_sentence(key), key))

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
        tab_source_note(source_note = html(paste("<i>", "N = ", nsize_temp$ncount, "<i/>", sep = ""))) %>%
        tab_source_note(source_note = "  ") %>%
        tab_source_note(source_note = "  ") %>%
        tab_style(
          style = cells_styles(
            text_weight = "bold"),
          locations = cells_data(rows = tib_loc$row_num)) %>%
        cols_align(align = "left",
                   columns = c(1)) %>%
        cols_label(Percentage = html(paste(battery_fill)))

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

      return(gtib)


    }

    else {

      if(top>0) {
        default = FALSE
      }

      if(bot>0) {
        default = FALSE
      }

      if(default) {


        if ((ncol(tib)==8)) {

          tib <- tib %>%
            mutate(`Top NET` = .[[1]] + .[[2]]) %>%
            mutate(`Bottom NET` = .[[4]] + .[[5]]) %>%
            mutate(`Skipped/Refused` = .[[7]] + .[[8]]) %>%
            select(9, 1, 2, 3, 10, 4, 5, 6, 11)

        }


        else if ((ncol(tib)==10)) {

          tib <- tib %>%
            mutate(`Top NET` = .[[1]] + .[[2]] + .[[3]]) %>%
            mutate(`Bottom NET` = .[[5]] + .[[6]] + .[[7]]) %>%
            mutate(`Skipped/Refused` = .[[9]] + .[[10]]) %>%
            select(11, 1, 2, 3, 4, 12, 5, 6, 7, 8, 13)

        }


        else if ((ncol(tib)==7)) {

          tib <- tib %>%
            mutate(`Top NET` = .[[1]] + .[[2]]) %>%
            mutate(`Bottom NET` = .[[3]] + .[[4]]) %>%
            mutate(`Skipped/Refused` = .[[6]] + .[[7]]) %>%
            select(8, 1, 2, 9, 3, 4, 5, 10)

        }

        else {
          tib <- tib %>%
            mutate(`Skipped/Refused` = .[[ncol(tib)]] + .[[(ncol(tib)-1)]]) %>%
            subset(select = -c((ncol(tib)-1), ncol(tib)))

        }

        tib <- tib %>%
          gather() %>%
          mutate(Percentage = ifelse(value >= 0.005, round(100*value, digits = 0), value)) %>%
          mutate(Percentage = ifelse(value == 0, "-", Percentage)) %>%
          mutate(Percentage = ifelse(value > 0 & value < 0.005, "*", Percentage)) %>%
          select(key, Percentage)
      }


      else {

        if (top>0&bot>0) {
          tib <- tib %>%
            mutate(`TOP NET` = apply(tib[,c(1:top)], 1, sum)) %>%
            select(`TOP NET`, everything()) %>%
            mutate(`Skipped/Refused` = .[[ncol(tib)]] + .[[(ncol(tib)-1)]])
          tib <- tib %>%
            subset(select = -c((ncol(tib)-2), ncol(tib)-1))



          first <- ncol(tib)-bot-1
          last <- ncol(tib)-2

          tib <- tib %>%
            mutate(`BOT NET` = apply(tib[,c(first:last)], 1, sum))
          tib <- tib %>%
            select(1:(first-1), ncol(tib), first:(ncol(tib)-1))


          tib <- tib %>%
            gather() %>%
            mutate(Percentage = ifelse(value >= 0.005, round(100*value, digits = 0), value)) %>%
            mutate(Percentage = ifelse(value == 0, "-", Percentage)) %>%
            mutate(Percentage = ifelse(value > 0 & value < 0.005, "*", Percentage)) %>%
            select(key, Percentage)

        }


        else if (top>0) {
          tib <- tib %>%
            mutate(`TOP NET` = apply(tib[,c(1:top)], 1, sum)) %>%
            select(`TOP NET`, everything()) %>%
            mutate(`Skipped/Refused` = .[[ncol(tib)]] + .[[(ncol(tib)-1)]])
          tib <- tib %>%
            subset(select = -c((ncol(tib)-2), ncol(tib)-1))



          tib <- tib %>%
            gather() %>%
            mutate(Percentage = ifelse(value >= 0.005, round(100*value, digits = 0), value)) %>%
            mutate(Percentage = ifelse(value == 0, "-", Percentage)) %>%
            mutate(Percentage = ifelse(value > 0 & value < 0.005, "*", Percentage)) %>%
            select(key, Percentage)

        }

        else if (bot>0) {

          first <- ncol(tib)-bot-2
          last <- ncol(tib)-3

          tib <- tib %>%
            mutate(`BOT NET` = apply(tib[,c(first:last)], 1, sum))
          tib <- tib %>%
            select(1:(first-1), ncol(tib), first:(ncol(tib)-1))

          tib <- tib %>%
            mutate(`Skipped/Refused` = .[[ncol(tib)]] + .[[(ncol(tib)-1)]]) %>%
            subset(select = -c((ncol(tib)-1), ncol(tib)))


          tib <- tib %>%
            gather() %>%
            mutate(Percentage = ifelse(value >= 0.005, round(100*value, digits = 0), value)) %>%
            mutate(Percentage = ifelse(value == 0, "-", Percentage)) %>%
            mutate(Percentage = ifelse(value > 0 & value < 0.005, "*", Percentage)) %>%
            select(key, Percentage)

        }



        else {
          tib <- tib %>%
            gather() %>%
            mutate(Percentage = ifelse(value >= 0.005, round(100*value, digits = 0), value)) %>%
            mutate(Percentage = ifelse(value == 0, "-", Percentage)) %>%
            mutate(Percentage = ifelse(value > 0 & value < 0.005, "*", Percentage)) %>%
            select(key, Percentage)
        }
      }

      tib <- tib %>%
        mutate(key = ifelse(str_detect(key, "REF")|str_detect(key, "SKIP")|str_detect(key, "DON"), str_to_sentence(key), key))

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
        tab_source_note(source_note = html(paste("<i>", "N = ", nsize_temp$ncount, "<i/>", sep = ""))) %>%
        tab_source_note(source_note = "  ") %>%
        tab_source_note(source_note = "  ") %>%
        tab_style(
          style = cells_styles(
            text_weight = "bold"),
          locations = cells_data(rows = tib_loc$row_num)) %>%
        cols_align(align = "left",
                   columns = c(1)) %>%
        cols_label(Percentage = html(paste(battery_fill)))

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

      return(gtib)

    }

  }

}
