### new topliner scratch

data2 <- haven::read_dta("P:\\AP-NORC Center\\Common\\AP Special Projects\\Omnibus\\2019\\05.2019\\Data\\old\\May_completes_clean.dta")

library(magrittr)
library(survey)
library(srvyr)
library(data.table)
library(haven)

data2 <- as_factor(data2)

topliner::tl_setup(data = data2, caseids = "caseid", weights = "weight_enes", dates = "05/17-20/2019")

var_form <- as.formula(paste0("~", vari))

tib <- as.data.table(svytable(var_form, data, Ntotal = 100))
att <- as.data.table(as.factor(attributes(data2$rel3d)$labels), keep.rownames = TRUE) %>%
  `colnames<-`(c("label", "rel3d"))

att$labels <- rownames(att)

tib_2 <- right_join(tib, att)

tib_2$N[is.na(tib_2$N)] <- 0

tl_tib <- function(vari, data = tl_df, default = TRUE, res = 3, top = 0, bot = 0, demo = FALSE) {

  var_form <- as.formula(paste0("~", vari))

  tib <- as.data.table(svytable(var_form, data, Ntotal = 100)) %>%
    `colnames<-`(c(vari, "perc"))


  tib_2 <- tib[, data.table::data.table(t(.SD))]
  colnames(tib_2) <- as.character(unlist(tib_2[1,]))
  tib_2 <- tib_2[-1,]
  tib_2 <- as.data.table(sapply(tib_2, as.numeric))


  tibtest <- tib_2

  return(tibtest)


}

tib_att <- tl_tib("rel3d")

tib_att <- tib_att %>%
  mutate(`Top NET` = apply(tib_att[, c(1:3)], 1, sum)) %>%
  select(`Top NET`, everything())
