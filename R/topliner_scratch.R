### new topliner scratch

data2 <- haven::read_dta("P:\\AP-NORC Center\\Common\\AP Special Projects\\Omnibus\\2019\\05.2019\\Data\\old\\May_completes_clean.dta")

library(dplyr)
library(survey)
library(srvyr)

data2 <- as_factor(data2)

topliner::tl_setup(data = data2, caseids = "caseid", weights = "weight_enes", dates = "05/17-20/2019")

tib <- as.data.frame(svytable(~rel3d, tl_df))
att <- as.data.frame(as.factor(attributes(data2$rel3d)$labels)) %>%
  `colnames<-`("rel3d")

tib_2 <- right_join(tib, att)
