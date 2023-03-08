#' Retrieve records that match a given IATI Datastore query
#' 
#' @description
#' This function sends a query to the IATI Datastore API 
#' (\url{https://iatistandard.org/en/iati-tools-and-resources/iati-datastore/})
#' and returns all records that match this query.
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
#' @param sleep a `numeric` of length 1. The time interval between two 
#'   consecutive requests to not stress the API.
#'
#' @return A `data.frame` with records in rows and metadata in columns.
#'   
#' @export
#'
#' @examples
#' \dontrun{
#' ## Get records for NGO in projects description ----
#' query <- "description_narrative:NGO"
#' get_records(query, collection = "activity")
#' }

get_records <- function(query_terms, collection = "activity", sleep = 1) {
  
  
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
  
  
  ## Get total number of records ----
  
  n_records <- results$"response"$"numFound"
  
  if (n_records == 0) {
    return(data.frame())
  }
  
  
  ## Define parameters for requests ----
  
  n_records_per_page <- 1000
  
  pages <- seq(0, n_records, by = n_records_per_page)
  
  for (page in pages) {
    
    
    ## Write query ----
    
    request  <- paste0(api_url(), collection, "/select?q=", query_terms, 
                       "&start=", page, "&rows=", n_records_per_page, 
                       "&wt=json")
    
    
    ## Send query ----
    
    response <- httr::GET(request, 
                          httr::add_headers("Ocp-Apim-Subscription-Key" = 
                                              token))
    
    
    ## Check response ----
    
    httr::stop_for_status(response)
    
    
    ## Extract records ----
    
    content <- httr::content(response, as = "text", encoding = "UTF-8")
    content <- jsonlite::fromJSON(content)
    
    content <- content[[2]][[4]]
    
    for (i in 1:ncol(content)) {

      if (i == 1) {
        
        df <- list_to_df(content[ , i])
      
      } else {
        
        df <- data.frame(df, list_to_df(content[ , i]))
      }
    }
    
    colnames(df) <- colnames(content)
    
    if (page == 0) {
      datas <- df
    } else {
      datas <- rows_bind(datas, df)  
    }
    
    
    ## Do not stress the API ----
    
    Sys.sleep(sleep)
  }
  
  datas
}
