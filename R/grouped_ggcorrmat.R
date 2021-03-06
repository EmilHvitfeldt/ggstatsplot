#' @title Visualization of a correlalogram (or correlation matrix) for all
#'   levels of a grouping variable
#' @name grouped_ggcorrmat
#' @description Helper function for `ggstatsplot::ggcorrmat` to apply this
#'   function across multiple levels of a given factor and combining the
#'   resulting plots using `ggstatsplot::combine_plots`.
#'
#' @inheritParams ggcorrmat
#' @inheritParams grouped_ggbetweenstats
#' @inheritDotParams combine_plots
#'
#' @importFrom dplyr select bind_rows summarize mutate mutate_at mutate_if
#' @importFrom dplyr group_by n arrange
#' @importFrom rlang !! enquo quo_name ensym %||%
#' @importFrom purrr map
#'
#' @seealso \code{\link{ggcorrmat}}, \code{\link{ggscatterstats}},
#'   \code{\link{grouped_ggscatterstats}}
#'
#' @inherit ggcorrmat return references
#' @inherit ggcorrmat return details
#'
#' @examples
#' \donttest{
#' # for reproducibility
#' set.seed(123)
#'
#' # for plot
#' # (without specifying needed variables; all numeric variables will be used)
#' ggstatsplot::grouped_ggcorrmat(
#'   data = ggplot2::msleep,
#'   grouping.var = vore
#' )
#'
#' # for getting plot
#' ggstatsplot::grouped_ggcorrmat(
#'   data = ggplot2::msleep,
#'   grouping.var = vore,
#'   cor.vars = sleep_total:bodywt,
#'   corr.method = "r",
#'   p.adjust.method = "holm",
#'   colors = NULL,
#'   package = "wesanderson",
#'   palette = "BottleRocket2",
#'   nrow = 2
#' )
#'
#' # for getting correlations
#' ggstatsplot::grouped_ggcorrmat(
#'   data = ggplot2::msleep,
#'   grouping.var = vore,
#'   cor.vars = sleep_total:bodywt,
#'   output = "correlations"
#' )
#'
#' # for getting confidence intervals
#' # confidence intervals are not available for **robust** correlation
#' ggstatsplot::grouped_ggcorrmat(
#'   data = datasets::iris,
#'   grouping.var = Species,
#'   corr.method = "r",
#'   p.adjust.method = "holm",
#'   cor.vars = Sepal.Length:Petal.Width,
#'   output = "ci"
#' )
#' }
#' @export

# defining the function
grouped_ggcorrmat <- function(data,
                              cor.vars = NULL,
                              cor.vars.names = NULL,
                              grouping.var,
                              title.prefix = NULL,
                              output = "plot",
                              matrix.type = "full",
                              method = "square",
                              corr.method = "pearson",
                              type = NULL,
                              exact = FALSE,
                              continuity = TRUE,
                              beta = 0.1,
                              digits = 2,
                              k = NULL,
                              sig.level = 0.05,
                              conf.level = 0.95,
                              p.adjust.method = "none",
                              hc.order = FALSE,
                              hc.method = "complete",
                              lab = TRUE,
                              package = "RColorBrewer",
                              palette = "Dark2",
                              direction = 1,
                              colors = c("#E69F00", "white", "#009E73"),
                              outline.color = "black",
                              ggtheme = ggplot2::theme_bw(),
                              ggstatsplot.layer = TRUE,
                              subtitle = NULL,
                              caption = NULL,
                              caption.default = TRUE,
                              lab.col = "black",
                              lab.size = 5,
                              insig = "pch",
                              pch = 4,
                              pch.col = "black",
                              pch.cex = 11,
                              tl.cex = 12,
                              tl.col = "black",
                              tl.srt = 45,
                              messages = TRUE,
                              return = NULL,
                              ...) {

  # create a list of function call to check for label.expression
  param_list <- as.list(match.call())

  # check that there is a grouping.var
  if (!"grouping.var" %in% names(param_list)) {
    stop("You must specify a grouping variable")
  }

  # ========================= preparing dataframe =============================

  # ensure the grouping variable works quoted or unquoted
  grouping.var <- rlang::ensym(grouping.var)

  # if `title.prefix` is not provided, use the variable `grouping.var` name
  if (is.null(title.prefix)) title.prefix <- rlang::as_name(grouping.var)

  # getting the dataframe ready
  if ("cor.vars" %in% names(param_list)) {
    data %<>% dplyr::select(.data = ., {{ grouping.var }}, {{ cor.vars }})
  }

  # creating a list for grouped analysis
  df <- grouped_list(data = data, grouping.var = {{ grouping.var }})

  # ===================== grouped analysis ===================================

  # see which method was used to specify type of correlation
  corr.method <- type %||% corr.method
  digits <- k %||% digits
  output <- return %||% output

  # creating a list of results
  plotlist_purrr <-
    purrr::pmap(
      .l = list(data = df, title = paste(title.prefix, ": ", names(df), sep = "")),
      .f = ggstatsplot::ggcorrmat,
      cor.vars.names = cor.vars.names,
      output = output,
      matrix.type = matrix.type,
      method = method,
      corr.method = corr.method,
      exact = exact,
      continuity = continuity,
      beta = beta,
      digits = digits,
      sig.level = sig.level,
      conf.level = conf.level,
      p.adjust.method = p.adjust.method,
      hc.order = hc.order,
      hc.method = hc.method,
      lab = lab,
      package = package,
      palette = palette,
      direction = direction,
      colors = colors,
      outline.color = outline.color,
      ggtheme = ggtheme,
      ggstatsplot.layer = ggstatsplot.layer,
      subtitle = subtitle,
      caption = caption,
      caption.default = caption.default,
      lab.col = lab.col,
      lab.size = lab.size,
      insig = insig,
      pch = pch,
      pch.col = pch.col,
      pch.cex = pch.cex,
      tl.cex = tl.cex,
      tl.col = tl.col,
      tl.srt = tl.srt,
      messages = messages,
      return = return
    )

  # ===================== combining results ===================================

  # combining the list of plots into a single plot
  # inform user this can't be modified further with ggplot commands
  if (output == "plot") {
    if (isTRUE(messages)) grouped_message()
    return(ggstatsplot::combine_plots(plotlist = plotlist_purrr, ...))
  } else {
    return(dplyr::bind_rows(plotlist_purrr, .id = title.prefix))
  }
}
