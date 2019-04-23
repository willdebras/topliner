#' tl_bat
#'
#' @param vars
#' @param data
#' @param default
#' @param res
#' @param top
#' @param bot
#'
#' @return
#' @export
#'
#' @examples

tl_bat <- function(vars, data, default = TRUE, res = 3, top = 0, bot = 0) {

  tib.list <- lapply(vars, bat, data)
  tib <- do.call(rbind, tib.list) %>%
    select (battery_labels, everything())

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
        select(1, `TOP NET`, 2:4, `BOT NET`, everything())


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

  return(tib)


}
