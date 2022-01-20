--Exercise 4
CREATE OR REPLACE TABLE `nttdata-c4e-bde.uc1_8.exercise_4`
AS
SELECT
  country,
  ARRAY_AGG(STRUCT(operatingSystem,
      browser,
      rank)
  ORDER BY
    rank) AS country_rank
FROM (
  SELECT
    geoNetwork.country AS country,
    device.operatingSystem AS operatingSystem,
    device.browser AS browser,
    RANK() OVER (PARTITION BY geoNetwork.country ORDER BY COUNT(visitId) DESC) AS rank,
    ROW_NUMBER() OVER (PARTITION BY geoNetwork.country ORDER BY COUNT(visitId) DESC) AS row_number
  FROM
    `bigquery-public-data.google_analytics_sample.ga_sessions_20170801`
  WHERE
    device.deviceCategory = 'mobile'
    AND geoNetwork.country != '(not set)'
    AND device.operatingSystem != '(not set)'
  GROUP BY
    device.operatingSystem,
    device.browser,
    geoNetwork.country
  ORDER BY
    geoNetwork.country,
    device.browser,
    geoNetwork.country )
WHERE
  row_number <= 3
GROUP BY
  country
ORDER BY
  country