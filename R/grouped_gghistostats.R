#' @title Grouped histograms for distribution of a numeric variable
#' @name grouped_gghistostats
#' @description Helper function for `ggstatsplot::gghistostats` to apply this
#'   function across multiple levels of a given factor and combining the
#'   resulting plots using `ggstatsplot::combine_plots`.
#'
#' @inheritParams gghistostats
#' @inheritParams grouped_ggbetweenstats
#' @inheritDotParams combine_plots
#'
#' @importFrom dplyr select bind_rows summarize mutate mutate_at mutate_if
#' @importFrom dplyr group_by n arrange
#' @importFrom rlang !! enquo quo_name ensym
#' @importFrom purrr pmap
#' @importFrom tidyr drop_na
#'
#' @seealso \code{\link{gghistostats}}, \code{\link{ggdotplotstats}},
#'  \code{\link{grouped_ggdotplotstats}}
#'
#' @inherit gghistostats return references
#' @inherit gghistostats return details
#'
#' @examples
#' \donttest{
#' # for reproducibility
#' set.seed(123)
#'
#' # plot
#' ggstatsplot::grouped_gghistostats(
#'   data = iris,
#'   x = Sepal.Length,
#'   test.value = 5,
#'   grouping.var = Species,
#'   bar.fill = "orange",
#'   nrow = 1,
#'   ggplot.component = list(
#'     ggplot2::scale_x_continuous(breaks = seq(3, 9, 1), limits = (c(3, 9))),
#'     ggplot2::scale_y_continuous(breaks = seq(0, 25, 5), limits = (c(0, 25)))
#'   ),
#'   messages = FALSE
#' )
#' }
#' @export
#'

# defining the function
grouped_gghistostats <- function(data,
                                 x,
                                 grouping.var,
                                 title.prefix = NULL,
                                 binwidth = NULL,
                                 bar.measure = "count",
                                 xlab = NULL,
                                 stat.title = NULL,
                                 subtitle = NULL,
                                 caption = NULL,
                                 type = "parametric",
                                 test.value = 0,
                                 bf.prior = 0.707,
                                 bf.message = TRUE,
                                 robust.estimator = "onestep",
                                 effsize.type = "g",
                                 effsize.noncentral = TRUE,
                                 conf.level = 0.95,
                                 nboot = 100,
                                 k = 2,
                                 ggtheme = ggplot2::theme_bw(),
                                 ggstatsplot.layer = TRUE,
                                 fill.gradient = FALSE,
                                 low.color = "#0072B2",
                                 high.color = "#D55E00",
                                 bar.fill = "grey50",
                                 results.subtitle = TRUE,
                                 centrality.para = "mean",
                                 centrality.color = "blue",
                                 centrality.size = 1.0,
                                 centrality.linetype = "dashed",
                                 centrality.line.labeller = TRUE,
                                 centrality.k = 2,
                                 test.value.line = FALSE,
                                 test.value.color = "black",
                                 test.value.size = 1.0,
                                 test.value.linetype = "dashed",
                                 test.line.labeller = TRUE,
                                 test.k = 0,
                                 normal.curve = FALSE,
                                 normal.curve.color = "black",
                                 normal.curve.linetype = "solid",
                                 normal.curve.size = 1.0,
                                 ggplot.component = NULL,
                                 return = "plot",
                                 messages = TRUE,
                                 ...) {

  # ======================== computing binwidth ============================

  # ensure the grouping variable works quoted or unquoted
  grouping.var <- rlang::ensym(grouping.var)

  # if `title.prefix` is not provided, use the variable `grouping.var` name
  if (is.null(title.prefix)) title.prefix <- rlang::as_name(grouping.var)

  # maximum value for x
  binmax <-
    dplyr::select(.data = data, {{ x }}) %>%
    max(x = ., na.rm = TRUE)

  # minimum value for x
  binmin <-
    dplyr::select(.data = data, {{ x }}) %>%
    min(x = ., na.rm = TRUE)

  # number of datapoints
  bincount <- as.integer(data %>% dplyr::count(.))

  # adding some binwidth sanity checking
  if (is.null(binwidth)) {
    binwidth <- (binmax - binmin) / sqrt(bincount)
  }

  # ======================== preparing dataframe ============================

  # getting the dataframe ready
  # creating a dataframe
  df <-
    dplyr::select(.data = data, {{ grouping.var }}, {{ x }}) %>%
    tidyr::drop_na(data = .) %>% # creating a list for grouped analysis
    grouped_list(data = ., grouping.var = {{ grouping.var }})

  # creating a list of plots
  plotlist_purrr <-
    purrr::pmap(
      .l = list(data = df, title = paste(title.prefix, ": ", names(df), sep = "")),
      .f = ggstatsplot::gghistostats,
      # put common parameters here
      x = {{ x }},
      bar.measure = bar.measure,
      xlab = xlab,
      stat.title = stat.title,
      subtitle = subtitle,
      caption = caption,
      type = type,
      test.value = test.value,
      bf.prior = bf.prior,
      bf.message = bf.message,
      robust.estimator = robust.estimator,
      effsize.type = effsize.type,
      effsize.noncentral = effsize.noncentral,
      conf.level = conf.level,
      nboot = nboot,
      low.color = low.color,
      high.color = high.color,
      bar.fill = bar.fill,
      k = k,
      results.subtitle = results.subtitle,
      centrality.para = centrality.para,
      centrality.color = centrality.color,
      centrality.size = centrality.size,
      centrality.linetype = centrality.linetype,
      centrality.line.labeller = centrality.line.labeller,
      centrality.k = centrality.k,
      test.value.line = test.value.line,
      test.value.color = test.value.color,
      test.value.size = test.value.size,
      test.value.linetype = test.value.linetype,
      test.line.labeller = test.line.labeller,
      test.k = test.k,
      normal.curve = normal.curve,
      normal.curve.color = normal.curve.color,
      normal.curve.linetype = normal.curve.linetype,
      normal.curve.size = normal.curve.size,
      binwidth = binwidth,
      ggtheme = ggtheme,
      ggstatsplot.layer = ggstatsplot.layer,
      fill.gradient = fill.gradient,
      ggplot.component = ggplot.component,
      return = return,
      messages = messages
    )

  # combining the list of plots into a single plot
  # inform user this can't be modified further with ggplot commands
  if (return == "plot") {
    if (isTRUE(messages)) grouped_message()
    return(ggstatsplot::combine_plots(plotlist = plotlist_purrr, ...))
  } else {
    return(plotlist_purrr)
  }
}
