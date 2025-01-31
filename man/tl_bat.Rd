% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/tl_bat.R
\name{tl_bat}
\alias{tl_bat}
\title{tl_bat}
\usage{
tl_bat(vars, data = tl_df, default = TRUE, res = 3, top = 0, bot = 0)
}
\arguments{
\item{vars}{Vector of variables from survey data object}

\item{data}{Survey data object}

\item{default}{Creates default net categories. Defaults to TRUE}

\item{res}{Number of residual categories, i.e. "skipped," "refused," "Don't know." Defaults to 3.}

\item{top}{Custom top net.}

\item{bot}{Custom bot net.}
}
\value{
Returns a tibble of weighted frequencies
}
\description{
Creates a table of weighted frequencies for a battery of questions
}
\examples{
tl_bat(vars = c("q1", "q2", "q3"), data = df, top = 3, bot = 2)
}
