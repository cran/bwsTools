#' Walkscoring Method to Calculate Individual Best-Worst Scores
#'
#' @description 
#' Calculate best-worst scores for each respondent-item combination. This uses
#'   the walkscoring method described in White (2019).
#'
#' @details
#' This function requires data to be in a specified format. Each row must
#'   represent a respondent-block-label combination. That is, it indicates
#'   the person, the block (or trial), the item that was judged, and a column
#'   indicating whether it was chosen as best (+1), worst (-1), or wasn't 
#'   selected as either (0).
#'
#' @param data A data.frame of the type described in details.
#' @param id A string of the name of the id column.
#' @param block A string of the name of the block column.
#' @param item A string of the name of the item column.
#' @param choice A string of the name of the choice column.
#' @param walks Integer indicating how many random walks to simulate.
#' @param wide Logical of whether or not one wants the data returned in long
#'   (each row is an item-respondent combination and all best-worst scores are
#'   in the same column) format (FALSE) or in wide format (where each row is a 
#'   respondent, and the best-worst scores for the items are in their own 
#'   columns). See the `indiv` data as an example.
#' 
#' @return
#' A data.frame containing the id and item columns as well as a "walk" column
#'   that indicates the best worst score. If `wide = TRUE`, then each item
#'   has its own column and the walkscore is filled-in those columns.
#' 
#' @examples
#' \dontrun{
#' data(indiv)
#' head(indiv)
#' # use more than 100 walks; only using 100 here for speed
#' walkscoring(indiv, "id", "block", "label", "value", 100)
#' }
#' 
#' @references 
#' White, M. H., II. (2019). bwsTools: An R package for case 1 best-worst
#'   scaling. Retrieved from https://osf.io/xftvq/
#' 
#' @importFrom magrittr "%>%"
#' @importFrom rlang sym
#' @export
walkscoring <- function(data, id, block, item, choice, walks = 10000,
                        wide = FALSE) {
  
  # check data ----
  get_checks(data, id, block, item, choice, nonbibd = TRUE)
  
  # do for all ids ----
  out <- lapply(unique(data[[id]]), function(x) {
    B <- get_walkscores(
      get_M(data[data[[id]] == x, ], "b", block, item, choice),
      walks
    )
    W <- get_walkscores(
      get_M(data[data[[id]] == x, ], "w", block, item, choice),
      walks
    )
    rowMeans(cbind(scale(B), scale(W) * -1))
  })
  
  # tidy ----
  out <- do.call(rbind, out)
  out <- dplyr::as_tibble(cbind(id = unique(data[[id]]), out))
  colnames(out)[1] <- id
  
  # already wide, gather to tidy by default ----
  if (!wide) {
    out <- out %>% 
      tidyr::gather(!!sym(item), "walk", -!!sym(id)) %>% 
      dplyr::arrange(id)
  }
  
  return(out)
}
