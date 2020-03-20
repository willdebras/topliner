#' Sample survey
#'
#' Helper function to generate survey dataset with one battery grid question, two single variable questions, and one check all that apply question.
#' Function generates caseid and weight to set as survey design using {survey}.
#'
#' @return Survey weighted dataset with 16 variables and 1000 rows.
#'
sample_survey <- function() {

  caseid <- c(1:1000)
  weight <- rnorm(1000, mean = 1, sd = 0.15)
  battery_var_a <- sample(c("Yes", "No", "Don't know", "Skipped/Refused"), 1000, replace = TRUE)
  battery_var_b <- sample(c("Yes", "No", "Don't know", "Skipped/Refused"), 1000, replace = TRUE)
  battery_var_c <- sample(c("Yes", "No", "Don't know", "Skipped/Refused"), 1000, replace = TRUE)
  battery_var_d <- sample(c("Yes", "No", "Don't know", "Skipped/Refused"), 1000, replace = TRUE)
  battery_var_e <- sample(c("Yes", "No", "Don't know", "Skipped/Refused"), 1000, replace = TRUE)
  single_var_1 <- sample(c("Extremely worried", "Very worried", "Somewhat worried", "Very not worried", "Extremely not worried", "Don't know", "Skipped/Refused"), 1000, replace = TRUE)
  single_var_2 <- sample(c("Yes", "No", "Don't know", "Skipped/Refused"), 1000, replace = TRUE)
  check_var_1 <- sample(c("Yes", "No"), 1000, replace = TRUE)
  check_var_2 <- sample(c("Yes", "No"), 1000, replace = TRUE)
  check_var_3 <- sample(c("Yes", "No"), 1000, replace = TRUE)
  check_var_4 <- sample(c("Yes", "No"), 1000, replace = TRUE)
  check_var_5 <- sample(c("Yes", "No"), 1000, replace = TRUE)
  check_var_DK <- sample(c("Yes", "No"), 1000, replace = TRUE)
  check_var_SKP <- sample(c("Yes", "No"), 1000, replace = TRUE)

  dt <- data.table(caseid = caseid,
                   weight = weight,
                   battery_var_a = battery_var_a,
                   battery_var_b = battery_var_b,
                   battery_var_c = battery_var_c,
                   battery_var_d = battery_var_d,
                   battery_var_e = battery_var_e,
                   single_var_1 = single_var_1,
                   single_var_2 = single_var_2,
                   check_var_1 = check_var_1,
                   check_var_2 = check_var_2,
                   check_var_3 = check_var_3,
                   check_var_4 = check_var_4,
                   check_var_5 = check_var_5,
                   check_var_DK = check_var_DK,
                   check_var_SKP = check_var_SKP)

  svy_dt <- svydesign(ids = ~ caseid,
                      weights = ~ weight,
                      data = dt)

  return(svy_dt)

}
