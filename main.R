library(RGoogleAnalytics)
library(FactoMineR)
library(plyr)

client.id <- "CLIENTID"
client.secret <- "CLIENT_SECRET"
token <- Auth(client.id, client.secret)

save(token, file="./token_acp_ga")

ValidateToken(token)

start_date <- "2015-12-15"
end_date <- "2016-01-04"
max_results <- 10000
dimension <- "experimentVariant"
table_id <- "ga:94275425"

query.list <- list(
  Init(start.date = start_date,
        end.date = end_date,
        dimensions= paste("ga:",dimension,""),
        metrics="ga:users, ga:newUsers, ga:sessionsPerUser, ga:sessions, ga:bounces, ga:sessionDuration, ga:organicSearches",
        max.results = max_results,
        sort="-ga:users",
        table.id=table_id)
  ,
  Init(start.date = start_date,
                      end.date = end_date,
                      dimensions = paste("ga:",dimension,""),
                      metrics="ga:entrances,ga:pageviews, ga:uniquePageviews,ga:timeOnPage, ga:exits",
                      max.results = max_results,
                      sort="-ga:entrances",
                      table.id=table_id)
  ,
  Init(start.date = start_date,
       end.date = end_date,
       dimensions = paste("ga:",dimension,""),
       metrics="ga:pageLoadTime,ga:pageLoadSample, ga:domainLookupTime, ga:redirectionTime",
       max.results = max_results,
       sort="-ga:pageLoadTime",
       table.id=table_id)
)


ga.query <- lapply(query.list, QueryBuilder)
ga.data_reporting <- lapply(ga.query, GetReportData, token=token)
ga.data <- join_all(ga.data, by=dimension)


