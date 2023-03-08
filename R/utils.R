#' 
#' @noRd

api_url <- function() "https://api.iatistandard.org/datastore/"



#' 
#' @noRd

get_token <- function(key = "IATI_KEY") {
  
  iati_token <- Sys.getenv(key)
  
  if (iati_token == "") {
    stop("Missing IATI API Token. ",
         "Please make sure you:\n",
         " 1. have obtained you own token\n",
         " 2. have stored this token in the `~/.Renviron` file\n",
         "For further detail: https://github.com/frbcesab/riati", call. = FALSE)
  }
  
  iati_token
}



#'
#' @noRd

valid_collections <- function() c("activity", "budget", "transaction")



#'
#' @noRd

list_to_df <- function(x) {
  
  if (is.null(x)) {
    
    NA
    
  } else {
    
    x <- unlist(lapply(x, function(y) paste0(y, collapse = " | ")))
    pos <- which(x == "")
    
    if (length(pos)) x[pos] <- NA
    
    x
  }
}



#' Bind rows of multiple data.frame with different columns (case sensitive)
#' @noRd

rows_bind <- function(...) {
  
  datas <- list(...)
  
  if (length(datas) < 2) {
    stop("Please provide at least two data.frame", call. = FALSE)
  }
  
  lapply(datas, function(x) {
    if (!is.data.frame(x)) {
      stop("Please provide only data.frame", call. = FALSE)
    }
    invisible(NULL)
  })
  
  
  for (i in 2:length(datas)) {
    
    common_cols <- colnames(datas[[1]])[colnames(datas[[1]]) %in% 
                                          colnames(datas[[i]])]
    
    cols_only_1 <- colnames(datas[[1]])[!(colnames(datas[[1]]) %in% 
                                          colnames(datas[[i]]))]
    
    cols_only_i <- colnames(datas[[i]])[!(colnames(datas[[i]]) %in% 
                                            colnames(datas[[1]]))]
    
    if (length(cols_only_1) > 0) {
      for (j in 1:length(cols_only_1)) {
        datas[[i]] <- data.frame(datas[[i]], rep(NA, nrow(datas[[i]])))
        colnames(datas[[i]])[ncol(datas[[i]])] <- cols_only_1[j]
      }
    }
    
    if (length(cols_only_i) > 0) {
      for (j in 1:length(cols_only_i)) {
        datas[[1]] <- data.frame(datas[[1]], rep(NA, nrow(datas[[1]])))
        colnames(datas[[1]])[ncol(datas[[1]])] <- cols_only_i[j]
      }
    }
    
    cols <- sort(unique(c(common_cols, cols_only_1, cols_only_i)))
    
    datas[[1]] <- rbind(datas[[1]][ , cols, drop = FALSE], 
                        datas[[i]][ , cols, drop = FALSE])
  }
  
  datas[[1]]
}
