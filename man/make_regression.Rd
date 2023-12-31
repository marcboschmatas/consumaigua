% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/make_regression.R
\name{make_regression}
\alias{make_regression}
\title{make_regression}
\usage{
make_regression(x, y, model = "linear")
}
\arguments{
\item{x}{a character vector with all independent variables}

\item{y}{a character vector with the dependent variable of interest}

\item{model}{choice of model to implement, either linear or logit}
}
\value{
a list with a ```broom::glance``` table and estimates plot
}
\description{
makes a regression model from a series of independent variables and one dependent
}
\examples{
\dontrun{
make_regression(x = c("hotels_1000hab", "vab_relatiu_Agricultura", "piscines_1000hab"), y = "consum_total")
}
}
