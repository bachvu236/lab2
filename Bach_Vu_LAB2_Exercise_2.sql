--Exercise 2
SELECT  visitId,
        visitStartTime,
        hits.page.pageTitle,
        hits.page.pagePath,

FROM `bigquery-public-data.google_analytics_sample.ga_sessions_20170801`,
UNNEST(hits) AS hits
WHERE date = "20170801"
 LIMIT 1000