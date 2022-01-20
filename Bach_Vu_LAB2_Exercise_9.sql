--Exercise 9
SELECT
  repo_name,
  diff.new_path AS file,
  committer.date AS date,
  LAG(
    commit
  ) OVER (PARTITION BY diff.new_path ORDER BY committer.date ASC ) AS previous_commit,
  commit
  ,
  LEAD(
    commit
  ) OVER (PARTITION BY diff.new_path ORDER BY committer.date ASC) AS next_commit,
FROM
  `bigquery-public-data.github_repos.sample_commits`,
  UNNEST (difference) AS diff
WHERE
  diff.new_path LIKE 'kernel/%.c'
  AND diff.new_path = diff.old_path
  AND repo_name = 'torvalds/linux'
ORDER BY
  diff.new_path,committer.date
   ASC