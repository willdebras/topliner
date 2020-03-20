### new topliner scratch

data2 <- haven::read_dta("P:\\AP-NORC Center\\Common\\AP Special Projects\\Omnibus\\2019\\05.2019\\Data\\old\\May_completes_clean.dta")

library(magrittr)
library(survey)
library(srvyr)
library(data.table)

data2 <- as_factor(data2)

topliner::tl_setup(data = data2, caseids = "caseid", weights = "weight_enes", dates = "05/17-20/2019")

tib <- as.data.table(svytable(~rel3d, tl_df, Ntotal = 100))
att <- as.data.table(as.factor(attributes(data2$rel3d)$labels), keep.rownames = TRUE) %>%
  `colnames<-`(c("label", "rel3d"))

att$labels <- rownames(att)

tib_2 <- right_join(tib, att)

tib_2$N[is.na(tib_2$N)] <- 0

