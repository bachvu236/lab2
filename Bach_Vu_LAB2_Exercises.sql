-- Exercise 1 Given the shared file top_4000_movies_data.csv
-- 1. Create a BigQuery table “Movie”
-- 2. Find the top 10 highest budget films, year by year, from 2016 to 2020.
SELECT
EXTRACT(YEAR FROM Release_Date) as year,
Movie_Title, 
Production_Budget,
DENSE_RANK() OVER (ORDER BY Production_Budget DESC ) AS rank
FROM `nttdata-c4e-bde.uc1_8.Movie` 
WHERE Release_Date BETWEEN DATE '2016-01-01' AND DATE '2020-01-01'
ORDER BY Production_Budget 
DESC
LIMIT 10
-- Exercise 2 
SELECT  visitId,
        visitStartTime,
        hits.page.pageTitle,
        hits.page.pagePath,
    
FROM `bigquery-public-data.google_analytics_sample.ga_sessions_20170801`,
UNNEST(hits) AS hits
WHERE date = "20170801"
 LIMIT 1000
--  Exercise 3 
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
-- Exercise 4
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
-- Exercise 5
SELECT
  posts_answers.owner_user_id AS id_user,
  COUNT(posts_answers.id) AS count
FROM
  `bigquery-public-data.stackoverflow.posts_answers` AS posts_answers
JOIN
  `bigquery-public-data.stackoverflow.users` AS users
ON
  posts_answers.owner_user_id = users.id
GROUP BY
  posts_answers.owner_user_id
ORDER BY
  count DESC
LIMIT
  10
--Exercise 6
  SELECT
  posts_answers.owner_user_id AS id_user,
  COUNT(posts.id) AS count
FROM
  `bigquery-public-data.stackoverflow.stackoverflow_posts` AS posts
JOIN
  `bigquery-public-data.stackoverflow.posts_answers` AS posts_answers
ON
  posts.accepted_answer_id = posts_answers.id
JOIN
  `bigquery-public-data.stackoverflow.users` AS user
ON
  user.id = posts_answers.owner_user_id
WHERE
  EXTRACT(YEAR
  FROM
    posts.creation_date) = 2010
  AND posts_answers.owner_user_id IS NOT NULL
GROUP BY
  posts_answers.owner_user_id
ORDER BY
  count DESC
LIMIT
  10
--Exercise 7
SELECT
  languages.name AS language_name,
  COUNT(repo_name) AS count
FROM
  `bigquery-public-data.github_repos.languages`,
  UNNEST (LANGUAGE) AS languages
GROUP BY
  language_name
ORDER BY
  count DESC
LIMIT
  1
--Exercise 8
  SELECT
  sample_commits.committer.name,
  COUNT(sample_commits.commit) count
FROM
  `bigquery-public-data.github_repos.languages` languages,
  UNNEST(LANGUAGE) language
JOIN
  `bigquery-public-data.github_repos.sample_commits` sample_commits
ON
  languages.repo_name = sample_commits.repo_name
WHERE
  language.name = 'Java'
  AND EXTRACT(YEAR FROM sample_commits.committer.date) = 2016
GROUP BY
  sample_commits.committer.name
ORDER BY
  count DESC
LIMIT
  10;




