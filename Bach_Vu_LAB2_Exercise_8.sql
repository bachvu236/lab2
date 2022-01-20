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
