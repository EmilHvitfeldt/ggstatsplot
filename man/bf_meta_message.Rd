% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/helpers_ggcoefstats_metaanalysis.R
\name{bf_meta_message}
\alias{bf_meta_message}
\title{Bayes factor message for random-effects meta-analysis}
\usage{
bf_meta_message(
  data,
  k = 2,
  d = "norm",
  d.par = c(mean = 0, sd = 0.3),
  tau = "halfcauchy",
  tau.par = c(scale = 0.5),
  iter = 10000,
  summarize = "stan",
  caption = NULL,
  messages = TRUE,
  ...
)
}
\arguments{
\item{data}{data frame containing the variables for effect size \code{y},
standard error \code{SE}, \code{labels}, and moderators per study.}

\item{k}{Number of digits after decimal point (should be an integer)
(Default: \code{k = 2}).}

\item{d}{the prior distribution of the average effect size \eqn{d} specified
either as the type of family (e.g., \code{"norm"}) or via
\code{\link[metaBMA]{prior}}.}

\item{d.par}{prior parameters for \eqn{d} (only used if \code{d} specifies
the type of family).}

\item{tau}{the prior distribution of the between-study heterogeneity
\eqn{\tau} specified either as a character value (e.g.,
\code{"halfcauchy"}) or via \code{\link[metaBMA]{prior}}.}

\item{tau.par}{prior parameters for \eqn{\tau}  (only used if \code{tau}
specifies the type of family).}

\item{iter}{number of MCMC iterations using Stan.}

\item{summarize}{how to estimate parameter summaries (mean, median, SD,
etc.): Either by numerical integration (\code{summarize = "integrate"}) or
based on MCMC/Stan samples (\code{summarize = "stan"}).}

\item{caption}{The text for the plot caption.}

\item{messages}{Decides whether messages references, notes, and warnings are
to be displayed (Default: \code{TRUE}).}

\item{...}{further arguments passed to \code{rstan::sampling} (see
\code{\link[rstan]{stanmodel-method-sampling}}). Relevant MCMC settings
concern the number of warmup samples that are discarded
(\code{warmup=500}), the total number of iterations per chain
(\code{iter=2000}), the number of MCMC chains (\code{chains=4}), whether
multiple cores should be used (\code{cores=4}), and control arguments that
make the sampling in Stan more robust, for instance:
\code{control=list(adapt_delta=.97)}.}
}
\description{
Bayes factor message for random-effects meta-analysis
}
\examples{

\donttest{
# setup
set.seed(123)
library(metaBMA)

# creating a dataframe
(df <-
  structure(
    .Data = list(
      study = c("1", "2", "3", "4", "5"),
      estimate = c(
        0.382047603321706,
        0.780783111514665,
        0.425607573765058,
        0.558365541235078,
        0.956473848429961
      ),
      std.error = c(
        0.0465576338644502,
        0.0330218199731529,
        0.0362834986178494,
        0.0480571500648261,
        0.062215818388157
      )
    ),
    row.names = c(NA, -5L),
    class = c("tbl_df", "tbl", "data.frame")
  ))

# getting Bayes factor in favor of null hypothesis
ggstatsplot::bf_meta_message(
  data = df,
  k = 3,
  iter = 1500,
  messages = TRUE
)
}

}
