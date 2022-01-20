--Exercise 3
SELECT  PARSE_DATE("%Y%m%d", date) as parsed,
        hits.page.pagePath,
COUNT ( DISTINCT
CONCAT( fullvisitorid,"-",CAST(visitNumber AS string),"-",CAST(visitStartTime AS string),"-",hits.page.pagePath)
)
as counters
FROM
`bigquery-public-data.google_analytics_sample.ga_sessions_20170801` , UNNEST(hits) AS hits
GROUP BY  hits.page.pagePath,date
ORDER BY counters
DESC
LIMIT 1000