% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/ggwithinstats.R
\name{ggwithinstats}
\alias{ggwithinstats}
\title{Box/Violin plots for group or condition comparisons in
within-subjects (or repeated measures) designs.}
\usage{
ggwithinstats(
  data,
  x,
  y,
  type = "parametric",
  pairwise.comparisons = FALSE,
  pairwise.annotation = "p.value",
  pairwise.display = "significant",
  p.adjust.method = "holm",
  effsize.type = "unbiased",
  partial = TRUE,
  effsize.noncentral = TRUE,
  bf.prior = 0.707,
  bf.message = TRUE,
  sphericity.correction = TRUE,
  results.subtitle = TRUE,
  xlab = NULL,
  ylab = NULL,
  caption = NULL,
  title = NULL,
  subtitle = NULL,
  sample.size.label = TRUE,
  k = 2,
  conf.level = 0.95,
  nboot = 100,
  tr = 0.1,
  path.point = TRUE,
  path.mean = TRUE,
  sort = "none",
  sort.fun = mean,
  axes.range.restrict = FALSE,
  mean.label.size = 3,
  mean.label.fontface = "bold",
  mean.label.color = "black",
  notch = FALSE,
  notchwidth = 0.5,
  linetype = "solid",
  outlier.tagging = FALSE,
  outlier.shape = 19,
  outlier.label = NULL,
  outlier.label.color = "black",
  outlier.color = "black",
  outlier.coef = 1.5,
  mean.plotting = TRUE,
  mean.ci = FALSE,
  mean.size = 5,
  mean.color = "darkred",
  ggtheme = ggplot2::theme_bw(),
  ggstatsplot.layer = TRUE,
  package = "RColorBrewer",
  palette = "Dark2",
  direction = 1,
  ggplot.component = NULL,
  return = "plot",
  messages = TRUE
)
}
\arguments{
\item{data}{A dataframe (or a tibble) from which variables specified are to
be taken. A matrix or tables will \strong{not} be accepted.}

\item{x}{The grouping variable from the dataframe \code{data}.}

\item{y}{The response (a.k.a. outcome or dependent) variable from the
dataframe \code{data}.}

\item{type}{Type of statistic expected (\code{"parametric"} or \code{"nonparametric"}
or \code{"robust"} or \code{"bayes"}).Corresponding abbreviations are also accepted:
\code{"p"} (for parametric), \code{"np"} (nonparametric), \code{"r"} (robust), or
\code{"bf"}resp.}

\item{pairwise.comparisons}{Logical that decides whether pairwise comparisons
are to be displayed (default: \code{FALSE}). Please note that \strong{only significant
comparisons} will be shown by default. To change this behavior, select
appropriate option with \code{pairwise.display} argument.}

\item{pairwise.annotation}{Character that decides the annotations to use for
pairwise comparisons. Either \code{"p.value"} (default) or \code{"asterisk"}.}

\item{pairwise.display}{Decides which pairwise comparisons to display.
Available options are \code{"significant"} (abbreviation accepted: \code{"s"}) or
\code{"non-significant"} (abbreviation accepted: \code{"ns"}) or
\code{"everything"}/\code{"all"}. The default is \code{"significant"}. You can use this
argument to make sure that your plot is not uber-cluttered when you have
multiple groups being compared and scores of pairwise comparisons being
displayed.}

\item{p.adjust.method}{Adjustment method for \emph{p}-values for multiple
comparisons. Possible methods are: \code{"holm"} (default), \code{"hochberg"},
\code{"hommel"}, \code{"bonferroni"}, \code{"BH"}, \code{"BY"}, \code{"fdr"}, \code{"none"}.}

\item{effsize.type}{Type of effect size needed for \emph{parametric} tests. The
argument can be \code{"biased"} (equivalent to \code{"d"} for Cohen's \emph{d} for
\strong{t-test}; \code{"partial_eta"} for partial eta-squared for \strong{anova}) or
\code{"unbiased"} (equivalent to \code{"g"} Hedge's \emph{g} for \strong{t-test};
\code{"partial_omega"} for partial omega-squared for \strong{anova})).}

\item{partial}{Logical that decides if partial eta-squared or omega-squared
are returned (Default: \code{TRUE}). If \code{FALSE}, eta-squared or omega-squared
will be returned. Valid only for objects of class \code{lm}, \code{aov}, \code{anova}, or
\code{aovlist}.}

\item{effsize.noncentral}{Logical indicating whether to use non-central
\emph{t}-distributions for computing the confidence interval for Cohen's \emph{d}
or Hedge's \emph{g} (Default: \code{TRUE}).}

\item{bf.prior}{A number between \code{0.5} and \code{2} (default \code{0.707}), the prior
width to use in calculating Bayes factors.}

\item{bf.message}{Logical that decides whether to display Bayes Factor in
favor of the \emph{null} hypothesis. This argument is relevant only \strong{for
parametric test} (Default: \code{TRUE}).}

\item{sphericity.correction}{Logical that decides whether to apply correction
to account for violation of sphericity in a repeated measures design ANOVA
(Default: \code{TRUE}).}

\item{results.subtitle}{Decides whether the results of statistical tests are
to be displayed as a subtitle (Default: \code{TRUE}). If set to \code{FALSE}, only
the plot will be returned.}

\item{xlab}{Labels for \code{x} and \code{y} axis variables. If \code{NULL} (default),
variable names for \code{x} and \code{y} will be used.}

\item{ylab}{Labels for \code{x} and \code{y} axis variables. If \code{NULL} (default),
variable names for \code{x} and \code{y} will be used.}

\item{caption}{The text for the plot caption.}

\item{title}{The text for the plot title.}

\item{subtitle}{The text for the plot subtitle. Will work only if
\code{results.subtitle = FALSE}.}

\item{sample.size.label}{Logical that decides whether sample size information
should be displayed for each level of the grouping variable \code{x} (Default:
\code{TRUE}).}

\item{k}{Number of digits after decimal point (should be an integer)
(Default: \code{k = 2}).}

\item{conf.level}{Scalar between 0 and 1. If unspecified, the defaults return
\verb{95\%} lower and upper confidence intervals (\code{0.95}).}

\item{nboot}{Number of bootstrap samples for computing confidence interval
for the effect size (Default: \code{100}).}

\item{tr}{Trim level for the mean when carrying out \code{robust} tests. If you
get error stating "Standard error cannot be computed because of Winsorized
variance of 0 (e.g., due to ties). Try to decrease the trimming level.",
try to play around with the value of \code{tr}, which is by default set to
\code{0.1}. Lowering the value might help.}

\item{path.point, path.mean}{Logical that decides whether individual data
points and means, respectively, should be connected using \code{geom_path}. Both
default to \code{TRUE}. Note that \code{path.point} argument is relevant only when
there are two groups (i.e., in case of a \emph{t}-test). In case of large number
of data points, it is advisable to set \code{path.point = FALSE} as these lines
can overwhelm the plot.}

\item{sort}{If \code{"ascending"} (default), \code{x}-axis variable factor levels will
be sorted based on increasing values of \code{y}-axis variable. If
\code{"descending"}, the opposite. If \code{"none"}, no sorting will happen.}

\item{sort.fun}{The function used to sort (default: \code{mean}).}

\item{axes.range.restrict}{Logical that decides whether to restrict the axes
values ranges to \code{min} and \code{max} values of the axes variables (Default:
\code{FALSE}), only relevant for functions where axes variables are of numeric
type.}

\item{mean.label.size}{Aesthetics for
the label displaying mean. Defaults: \code{3}, \code{"bold"},\code{"black"}, respectively.}

\item{mean.label.fontface}{Aesthetics for
the label displaying mean. Defaults: \code{3}, \code{"bold"},\code{"black"}, respectively.}

\item{mean.label.color}{Aesthetics for
the label displaying mean. Defaults: \code{3}, \code{"bold"},\code{"black"}, respectively.}

\item{notch}{A logical. If \code{FALSE} (default), a standard box plot will be
displayed. If \code{TRUE}, a notched box plot will be used. Notches are used to
compare groups; if the notches of two boxes do not overlap, this suggests
that the medians are significantly different. In a notched box plot, the
notches extend \code{1.58 * IQR / sqrt(n)}. This gives a roughly \verb{95\%}
confidence interval for comparing medians. IQR: Inter-Quartile Range.}

\item{notchwidth}{For a notched box plot, width of the notch relative to the
body (default \code{0.5}).}

\item{linetype}{Character strings (\code{"blank"}, \code{"solid"}, \code{"dashed"},
\code{"dotted"}, \code{"dotdash"}, \code{"longdash"}, and \code{"twodash"}) specifying the type
of line to draw box plots (Default: \code{"solid"}). Alternatively, the numbers
\code{0} to \code{6} can be used (\code{0} for "blank", \code{1} for "solid", etc.).}

\item{outlier.tagging}{Decides whether outliers should be tagged (Default:
\code{FALSE}).}

\item{outlier.shape}{Hiding the outliers can be achieved by setting
\code{outlier.shape = NA}. Importantly, this does not remove the outliers,
it only hides them, so the range calculated for the \code{y}-axis will be
the same with outliers shown and outliers hidden.}

\item{outlier.label}{Label to put on the outliers that have been tagged. This
\strong{can't} be the same as \code{x} argument.}

\item{outlier.label.color}{Color for the label to to put on the outliers that
have been tagged (Default: \code{"black"}).}

\item{outlier.color}{Default aesthetics for outliers (Default: \code{"black"}).}

\item{outlier.coef}{Coefficient for outlier detection using Tukey's method.
With Tukey's method, outliers are below (1st Quartile) or above (3rd
Quartile) \code{outlier.coef} times the Inter-Quartile Range (IQR) (Default:
\code{1.5}).}

\item{mean.plotting}{Logical that decides whether mean is to be highlighted
and its value to be displayed (Default: \code{TRUE}).}

\item{mean.ci}{Logical that decides whether \verb{95\%} confidence interval for
mean is to be displayed (Default: \code{FALSE}).}

\item{mean.size}{Point size for the data point corresponding to mean
(Default: \code{5}).}

\item{mean.color}{Color for the data point corresponding to mean (Default:
\code{"darkred"}).}

\item{ggtheme}{A function, \code{ggplot2} theme name. Default value is
\code{ggplot2::theme_bw()}. Any of the \code{ggplot2} themes, or themes from
extension packages are allowed (e.g., \code{ggthemes::theme_fivethirtyeight()},
\code{hrbrthemes::theme_ipsum_ps()}, etc.).}

\item{ggstatsplot.layer}{Logical that decides whether \code{theme_ggstatsplot}
theme elements are to be displayed along with the selected \code{ggtheme}
(Default: \code{TRUE}). \code{theme_ggstatsplot} is an opinionated theme layer that
override some aspects of the selected \code{ggtheme}.}

\item{package}{Name of package from which the palette is desired as string
or symbol.}

\item{palette}{If a character string (e.g., \code{"Set1"}), will use that named
palette. If a number, will index into the list of palettes of appropriate
type. Default palette is \code{"Dark2"}.}

\item{direction}{Either \code{1} or \code{-1}. If \code{-1} the palette will be reversed.}

\item{ggplot.component}{A \code{ggplot} component to be added to the plot prepared
by \code{ggstatsplot}. This argument is primarily helpful for \code{grouped_} variant
of the current function. Default is \code{NULL}. The argument should be entered
as a function. If the given function has an argument \code{axes.range.restrict}
and if it has been set to \code{TRUE}, the added \code{ggplot} component \emph{might} not
work as expected.}

\item{return}{Character that describes what is to be returned: can be
\code{"plot"} (default) or \code{"subtitle"} or \code{"caption"}. Setting this to
\code{"subtitle"} will return the expression containing statistical results. If
you have set \code{results.subtitle = FALSE}, then this will return a \code{NULL}.
Setting this to \code{"caption"} will return the expression containing details
about Bayes Factor analysis, but valid only when \code{type = "parametric"} and
\code{bf.message = TRUE}, otherwise this will return a \code{NULL}.}

\item{messages}{Decides whether messages references, notes, and warnings are
to be displayed (Default: \code{TRUE}).}
}
\description{
A combination of box and violin plots along with raw
(unjittered) data points for within-subjects designs with statistical
details included in the plot as a subtitle.
}
\details{
For more about how the effect size measures (for nonparametric tests) and
their confidence intervals are computed, see \code{?rcompanion::wilcoxonPairedR}.

For independent measures designs, use \code{ggbetweenstats}.
}
\examples{
\donttest{
# setup
set.seed(123)
library(ggstatsplot)

# two groups (*t*-test)
ggstatsplot::ggwithinstats(
  data = VR_dilemma,
  x = modality,
  y = score,
  xlab = "Presentation modality",
  ylab = "Proportion of utilitarian decisions"
)

# more than two groups (anova)
library(WRS2)

ggstatsplot::ggwithinstats(
  data = tibble::as_tibble(WineTasting),
  x = Wine,
  y = Taste,
  type = "np",
  conf.level = 0.99,
  pairwise.comparisons = TRUE,
  outlier.tagging = TRUE,
  outlier.label = Taster
)
}
}
\seealso{
\code{\link{grouped_ggbetweenstats}}, \code{\link{ggbetweenstats}},
\code{\link{grouped_ggwithinstats}}
}
