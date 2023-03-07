#' Retrieve the number of records that match a given IATI Datastore query
#' 
#' @description
#' This function sends a query to the IATI Datastore API 
#' (\url{https://iatistandard.org/en/iati-tools-and-resources/iati-datastore/})
#' and returns the total number of records that match this query.
#' 
#' To learn how to write a query, users can read the documentation 
#' available at:
#' \url{https://iatistandard.org/en/iati-tools-and-resources/iati-datastore/how-to-use-the-datastore-api/}.
#' 
#' @param query_terms a `character` of length 1. The terms to search for.
#'   Visit the API documentation at:
#'   \url{https://iatistandard.org/en/iati-tools-and-resources/iati-datastore/how-to-use-the-datastore-api/}.
#' 
#' @param collection a `character` of length 1. One among `activity`, `budget`,
#'   `transaction`.
#'
#' @return The total number of records (`integer` of length 1) that match the 
#'   query.
#'   
#' @export
#'
#' @examples
#' \dontrun{
#' ## Search NGO in projects description ----
#' query <- "description_narrative:NGO"
#' get_number_of_records(query, collection = "activity")
#' }

get_number_of_records <- function(query_terms, collection = "activity") {
  
  
  ## Check args ----
  
  if (missing(query_terms)) {
    stop("Argument 'query_terms' is required", 
         call. = FALSE)
  }
  
  if (!is.character(query_terms) || length(query_terms) != 1) {
    stop("Argument 'query_terms' must be a character of length 1", 
         call. = FALSE)
  }
  
  if (!is.character(collection) || length(collection) != 1) {
    stop("Argument 'collection' must be a character of length 1", 
         call. = FALSE)
  }
  
  collection <- tolower(collection)
  
  if (!(collection %in% valid_collections())) {
    stop("Argument 'collection' must be one of ", 
         paste0(valid_collections(), collapse = ", "),
         call. = FALSE)
  }
  
  
  ## Check token ----
  
  token <- get_token()
  
  
  ## Encode URL ----
  
  query_terms <- utils::URLencode(query_terms, reserved = TRUE)
  
  
  ## Write query ----
  
  full_url <- paste0(api_url(), collection, "/select?q=", query_terms, 
                     "&start=0", "&rows=0", "&wt=json")
  
  results <- httr::GET(full_url, 
                       httr::add_headers("Ocp-Apim-Subscription-Key" = token))
  
  
  ## Check response ----
  
  httr::stop_for_status(results)
  
  
  ## Parse response ----
  
  results <- httr::content(results, as = "text")
  results <- jsonlite::fromJSON(results)
  
  results$"response"$"numFound"
}
