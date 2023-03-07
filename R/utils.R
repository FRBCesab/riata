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
