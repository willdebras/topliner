#' tl_trend
#'
#' A function for combining data that has already been tabularized with data from a survey dataset
#'
#' @param vari A variable for which you want to produce trend frequencies
#' @param tl_df A survey-object dataset
#' @param trend_df A list of tibbles produced by the tl_readexcel helper function
#' @param default Creates default net categories. Defaults to TRUE
#' @param res Number of residual categories, i.e. "skipped," "refused," "Don't know." Defaults to 3.
#' @param top Custom top net.
#' @param bot Custom bot net.
#'
#'
#' @return Returns a tibble of read in trend data and new trend data
#' @export
#'
#' @importFrom purrr pluck
#' @import dplyr
#' @import survey
#' @importFrom srvyr survey_mean
#' @import gt
#' @import tidyr
#' @importFrom stringr str_to_sentence str_to_upper
#' @importFrom stringi stri_extract_all_coll stri_sub
#' @examples
tl_trend <- function(vari, tl_df, trend_df, default = TRUE, res = 3, top = 0, bot = 0) {


  solo_tib <- trend_df[var]
  plucked_tib <- pluck(solo_tib, 1)

  tib <- tl_df %>%
    group_by_at(var) %>%
    summarise(perc = survey_mean(na.rm = TRUE)) %>%
    select(c(1, 2)) %>%
    spread(var, perc) %>%
    mutate(APNORC = "") %>%
    select(APNORC, everything())


  if(top>0|bot>0) {
    default = FALSE
  }


  if (default) {

    if ((ncol(tib)-res-1)==5) {

      tib <- tib %>%
        mutate(`TOP NET` = apply(tib[,c(2:3)], 1, sum)) %>%
        mutate(`BOT NET` = apply(tib[,c(5:6)], 1, sum)) %>%
        select(1, `TOP NET`, 2:4, `BOT NET`, everything())

    }

    else if ((ncol(tib)-res-1)==4) {

      tib <- tib %>%
        mutate(`TOP NET` = apply(tib[,c(2:3)], 1, sum)) %>%
        mutate(`BOT NET` = apply(tib[,c(4:5)], 1, sum)) %>%
        select(1, `TOP NET`, 2:3, `BOT NET`, everything())

    }

    else if ((ncol(tib)-res-1)==7) {

      tib <- tib %>%
        mutate(`TOP NET` = apply(tib[,c(2:4)], 1, sum)) %>%
        mutate(`BOT NET` = apply(tib[,c(6:8)], 1, sum)) %>%
        select(1, `TOP NET`, 2:4, 5, `BOT NET`, everything())


    }

    else {

      tib <- tib

    }
  }

  else if (top>0&bot>0) {

    tib <- tib %>%
      mutate(`TOP NET` = apply(tib[,c(2:(1+top))], 1, sum)) %>%
      select(1, `TOP NET`, everything())

    first <- ncol(tib)-bot-res+1
    last <- ncol(tib)-res

    tib <- tib %>%
      mutate(`BOT NET` = apply(tib[,c(first:last)], 1, sum))
    tib <- tib %>%
      select(1:(first-1), ncol(tib), first:(ncol(tib)-1))


  }


  else if (top>0) {
    tib <- tib %>%
      mutate(`TOP NET` = apply(tib[,c(2:(1+top))], 1, sum)) %>%
      select(1, `TOP NET`, everything())

  }

  else if (bot>0) {

    first <- ncol(tib)-bot-res+1
    last <- ncol(tib)-res

    tib <- tib %>%
      mutate(`BOT NET` = apply(tib[,c(first:last)], 1, sum))
    tib <- tib %>%
      select(1:(first-1), ncol(tib), first:(ncol(tib)-1))

  }

  else {

    tib <- tib

  }

  if (res==3|res==4) {

    tib <- tib %>%
      mutate(`Skipped/Refused` = .[[ncol(tib)]] + .[[(ncol(tib)-1)]])

    tib <- tib %>%
      subset(select = -c((ncol(tib)-2), ncol(tib)-1))

  }

  tib[-1] <- lapply(tib[-1], apnorc_round)


  colnames(tib) <- colnames(plucked_tib)

  tib <- rbind(tib, plucked_tib)

  nsize_temp <- nsize %>%
    filter(rowname == vari)

  tib[1,1] <- paste(field_dates, " ", "(N=", nsize_temp$ncount, ")", sep = "")

  return(tib)

}
