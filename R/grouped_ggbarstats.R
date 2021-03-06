#' @title Grouped bar (column) charts with statistical tests
#' @name grouped_ggbarstats
#' @description Helper function for `ggstatsplot::ggbarstats` to apply this
#'   function across multiple levels of a given factor and combining the
#'   resulting plots using `ggstatsplot::combine_plots`.
#'
#' @inheritDotParams combine_plots
#' @inheritParams ggbarstats
#' @inheritParams grouped_ggbetweenstats
#'
#' @import ggplot2
#'
#' @importFrom dplyr select bind_rows summarize mutate mutate_at mutate_if
#' @importFrom dplyr group_by n arrange
#' @importFrom rlang !! enquo quo_name ensym
#' @importFrom purrr map
#'
#' @seealso \code{\link{ggbarstats}}, \code{\link{ggpiestats}},
#'  \code{\link{grouped_ggpiestats}}
#'
#' @inherit ggbarstats return references
#' @inherit ggbarstats return details
#' @inherit ggbarstats return return
#'
#' @examples
#' \donttest{
#' # with condition and with count data
#' library(jmv)
#'
#' ggstatsplot::grouped_ggbarstats(
#'   data = as.data.frame(HairEyeColor),
#'   x = Hair,
#'   y = Eye,
#'   counts = Freq,
#'   grouping.var = Sex
#' )
#'
#' # the following will take slightly more amount of time
#' # for reproducibility
#' set.seed(123)
#'
#' # let's create a smaller dataframe
#' diamonds_short <- ggplot2::diamonds %>%
#'   dplyr::filter(.data = ., cut %in% c("Very Good", "Ideal")) %>%
#'   dplyr::filter(.data = ., clarity %in% c("SI1", "SI2", "VS1", "VS2")) %>%
#'   dplyr::sample_frac(tbl = ., size = 0.05)
#'
#' # plot
#' ggstatsplot::grouped_ggbarstats(
#'   data = diamonds_short,
#'   x = color,
#'   y = clarity,
#'   grouping.var = cut,
#'   sampling.plan = "poisson",
#'   title.prefix = "Quality",
#'   bar.label = "both",
#'   messages = FALSE,
#'   perc.k = 1,
#'   nrow = 2
#' )
#' }
#' @export

# defining the function
grouped_ggbarstats <- function(data,
                               main,
                               condition,
                               counts = NULL,
                               grouping.var,
                               title.prefix = NULL,
                               ratio = NULL,
                               paired = FALSE,
                               results.subtitle = TRUE,
                               labels.legend = NULL,
                               stat.title = NULL,
                               sample.size.label = TRUE,
                               label.separator = " ",
                               label.text.size = 4,
                               label.fill.color = "white",
                               label.fill.alpha = 1,
                               bar.outline.color = "black",
                               bf.message = TRUE,
                               sampling.plan = "indepMulti",
                               fixed.margin = "rows",
                               prior.concentration = 1,
                               subtitle = NULL,
                               caption = NULL,
                               legend.position = "right",
                               x.axis.orientation = NULL,
                               conf.level = 0.95,
                               nboot = 100,
                               simulate.p.value = FALSE,
                               B = 2000,
                               bias.correct = FALSE,
                               legend.title = NULL,
                               xlab = NULL,
                               ylab = "Percent",
                               k = 2,
                               perc.k = 0,
                               bar.label = "percentage",
                               data.label = NULL,
                               bar.proptest = TRUE,
                               ggtheme = ggplot2::theme_bw(),
                               ggstatsplot.layer = TRUE,
                               package = "RColorBrewer",
                               palette = "Dark2",
                               direction = 1,
                               ggplot.component = NULL,
                               return = "plot",
                               messages = TRUE,
                               x = NULL,
                               y = NULL,
                               ...) {

  # ======================== check user input =============================

  # check that there is a grouping.var
  if (!"grouping.var" %in% names(as.list(match.call()))) {
    stop("You must specify a grouping variable")
  }

  # ensure the grouping variable works quoted or unquoted
  grouping.var <- rlang::ensym(grouping.var)
  main <- rlang::ensym(main)
  condition <- if (!rlang::quo_is_null(rlang::enquo(condition))) rlang::ensym(condition)
  x <- if (!rlang::quo_is_null(rlang::enquo(x))) rlang::ensym(x)
  y <- if (!rlang::quo_is_null(rlang::enquo(y))) rlang::ensym(y)
  x <- x %||% main
  y <- y %||% condition
  counts <- if (!rlang::quo_is_null(rlang::enquo(counts))) rlang::ensym(counts)

  # check that conditioning and grouping.var are different
  if (rlang::as_name(y) == rlang::as_name(grouping.var)) {
    message(cat(
      crayon::red("\nError: "),
      crayon::blue(
        "Identical variable (",
        crayon::yellow(rlang::as_name(y)),
        ") was used for both grouping and conditioning, which is not allowed.\n"
      ),
      sep = ""
    ))
    return(invisible(rlang::as_name(y)))
  }

  # if `title.prefix` is not provided, use the variable `grouping.var` name
  if (is.null(title.prefix)) title.prefix <- rlang::as_name(grouping.var)

  # ======================== preparing dataframe =============================

  # creating a dataframe
  df <-
    dplyr::select(.data = data, {{ grouping.var }}, {{ x }}, {{ y }}, {{ counts }}) %>%
    tidyr::drop_na(data = .) %>% # creating a list for grouped analysis
    grouped_list(data = ., grouping.var = {{ grouping.var }})

  # ================ creating a list of return objects ========================

  # creating a list of plots using `pmap`
  plotlist_purrr <-
    purrr::pmap(
      .l = list(data = df, title = paste(title.prefix, ": ", names(df), sep = "")),
      .f = ggstatsplot::ggbarstats,
      # put common parameters here
      x = {{ x }},
      y = {{ y }},
      counts = {{ counts }},
      ratio = ratio,
      paired = paired,
      results.subtitle = results.subtitle,
      labels.legend = labels.legend,
      stat.title = stat.title,
      sample.size.label = sample.size.label,
      label.separator = label.separator,
      label.text.size = label.text.size,
      label.fill.color = label.fill.color,
      label.fill.alpha = label.fill.alpha,
      bar.outline.color = bar.outline.color,
      bf.message = bf.message,
      sampling.plan = sampling.plan,
      fixed.margin = fixed.margin,
      prior.concentration = prior.concentration,
      subtitle = subtitle,
      caption = caption,
      legend.position = legend.position,
      x.axis.orientation = x.axis.orientation,
      conf.level = conf.level,
      nboot = nboot,
      simulate.p.value = simulate.p.value,
      B = B,
      bias.correct = bias.correct,
      legend.title = legend.title,
      xlab = xlab,
      ylab = ylab,
      k = k,
      perc.k = perc.k,
      data.label = data.label,
      bar.label = bar.label,
      bar.proptest = bar.proptest,
      ggtheme = ggtheme,
      ggstatsplot.layer = ggstatsplot.layer,
      package = package,
      palette = palette,
      direction = direction,
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
