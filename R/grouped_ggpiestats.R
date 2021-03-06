#' @title Grouped pie charts with statistical tests
#' @name grouped_ggpiestats
#' @description Helper function for `ggstatsplot::ggpiestats` to apply this
#'   function across multiple levels of a given factor and combining the
#'   resulting plots using `ggstatsplot::combine_plots`.
#'
#' @inheritParams ggpiestats
#' @inheritParams grouped_ggbetweenstats
#' @inheritDotParams combine_plots
#'
#' @importFrom dplyr select bind_rows summarize mutate mutate_at mutate_if
#' @importFrom dplyr group_by n arrange
#' @importFrom rlang !! enquo quo_name ensym
#'
#' @seealso \code{\link{ggbarstats}}, \code{\link{ggpiestats}},
#'  \code{\link{grouped_ggbarstats}}
#'
#' @inherit ggpiestats return references
#' @inherit ggpiestats return details
#' @inherit ggpiestats return return
#'
#' @examples
#' \donttest{
#' # grouped one-sample proportion tests
#' ggstatsplot::grouped_ggpiestats(
#'   data = mtcars,
#'   grouping.var = am,
#'   x = cyl
#' )
#'
#' # without condition and with count data
#' library(jmv)
#'
#' ggstatsplot::grouped_ggpiestats(
#'   data = as.data.frame(HairEyeColor),
#'   x = Hair,
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
#'   dplyr::filter(.data = ., cut %in% c("Fair", "Very Good", "Ideal")) %>%
#'   dplyr::sample_frac(tbl = ., size = 0.10)
#'
#' # plot
#' ggstatsplot::grouped_ggpiestats(
#'   data = diamonds_short,
#'   x = color,
#'   y = clarity,
#'   grouping.var = cut,
#'   nboot = 20,
#'   sampling.plan = "poisson",
#'   title.prefix = "Quality",
#'   slice.label = "both",
#'   messages = FALSE,
#'   perc.k = 1,
#'   nrow = 3
#' )
#' }
#' @export

# defining the function
grouped_ggpiestats <- function(data,
                               main,
                               condition = NULL,
                               counts = NULL,
                               grouping.var,
                               title.prefix = NULL,
                               ratio = NULL,
                               paired = FALSE,
                               results.subtitle = TRUE,
                               factor.levels = NULL,
                               stat.title = NULL,
                               sample.size.label = TRUE,
                               label.separator = "\n",
                               label.text.size = 4,
                               label.fill.color = "white",
                               label.fill.alpha = 1,
                               bf.message = TRUE,
                               sampling.plan = "indepMulti",
                               fixed.margin = "rows",
                               prior.concentration = 1,
                               subtitle = NULL,
                               caption = NULL,
                               conf.level = 0.95,
                               bf.prior = 0.707,
                               nboot = 100,
                               simulate.p.value = FALSE,
                               B = 2000,
                               bias.correct = FALSE,
                               legend.title = NULL,
                               facet.wrap.name = NULL,
                               k = 2,
                               perc.k = 0,
                               slice.label = "percentage",
                               facet.proptest = TRUE,
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

  # create a list of function call to check
  param_list <- as.list(match.call())

  # check that there is a grouping.var
  if (!"grouping.var" %in% names(param_list)) {
    stop("You must specify a grouping variable")
  }

  # check that conditioning and grouping.var are different
  if ("condition" %in% names(param_list)) {
    if (as.character(param_list$condition) == as.character(param_list$grouping.var)) {
      message(cat(
        crayon::red("\nError: "),
        crayon::blue(
          "Identical variable (",
          crayon::yellow(param_list$condition),
          ") was used for both grouping and conditioning, which is not allowed.\n"
        ),
        sep = ""
      ))
      return(invisible(param_list$condition))
    }
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

  # if `title.prefix` is not provided, use the variable `grouping.var` name
  if (is.null(title.prefix)) title.prefix <- rlang::as_name(grouping.var)

  # ======================== preparing dataframe =============================

  # creating a dataframe
  df <-
    dplyr::select(.data = data, {{ grouping.var }}, {{ x }}, {{ y }}, {{ counts }}) %>%
    tidyr::drop_na(data = .) %>% # creating a list for grouped analysis
    grouped_list(data = ., grouping.var = {{ grouping.var }})

  # ==================== creating a list of return objects ===================

  # creating a list of plots using `pmap`
  plotlist_purrr <-
    purrr::pmap(
      .l = list(data = df, title = paste(title.prefix, ": ", names(df), sep = "")),
      .f = ggstatsplot::ggpiestats,
      # put common parameters here
      x = {{ x }},
      y = {{ y }},
      counts = {{ counts }},
      ratio = ratio,
      paired = paired,
      results.subtitle = results.subtitle,
      factor.levels = factor.levels,
      stat.title = stat.title,
      sample.size.label = sample.size.label,
      label.separator = label.separator,
      label.text.size = label.text.size,
      label.fill.color = label.fill.color,
      label.fill.alpha = label.fill.alpha,
      bf.message = bf.message,
      sampling.plan = sampling.plan,
      fixed.margin = fixed.margin,
      prior.concentration = prior.concentration,
      subtitle = subtitle,
      caption = caption,
      bf.prior = bf.prior,
      conf.level = conf.level,
      nboot = nboot,
      simulate.p.value = simulate.p.value,
      B = B,
      bias.correct = bias.correct,
      legend.title = legend.title,
      facet.wrap.name = facet.wrap.name,
      k = k,
      perc.k = perc.k,
      slice.label = slice.label,
      facet.proptest = facet.proptest,
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
