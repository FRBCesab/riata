api_url <- function() "https://api.iatistandard.org/datastore/"

get_token <- function(key = "IATA_KEY") {
  
  iata_token <- Sys.getenv(key)
  
  if (iata_token == "") {
    stop("Missing IATA API Token. ",
         "Please make sure you:\n",
         " 1. have obtained you own token\n",
         " 2. have stored this token in the `~/.Renviron` file\n",
         "For further detail: https://github.com/frbcesab/riata", call. = FALSE)
  }
  
  iata_token
}
