% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/tl_labels.R
\name{tl_labels}
\alias{tl_labels}
\title{tl_labels}
\usage{
tl_labels(data, spss = FALSE)
}
\arguments{
\item{data}{Dataframe from which you want to draw labels}

\item{spss}{Whether the dataset is from SPSS or not. Defaults to FALSE.}
}
\value{
Returns a data object of variable names and associated labels to the environment for other functions to use
}
\description{
Create a dataframe of variables and labels to print in tables
}
\examples{
tl_labels(omnibus0319, SPSS = TRUE)


}
