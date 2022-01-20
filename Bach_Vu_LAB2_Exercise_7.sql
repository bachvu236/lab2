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