--Exercise 5
SELECT
  posts_answers.owner_user_id AS id_user,
  COUNT(posts_answers.id) AS count
FROM
  `bigquery-public-data.stackoverflow.posts_answers` AS posts_answers
JOIN
  `bigquery-public-data.stackoverflow.users` AS users
ON
  posts_answers.owner_user_id = users.id
  WHERE
    EXTRACT(YEAR FROM posts_answers.creation_date) = 2010
GROUP BY
  posts_answers.owner_user_id
ORDER BY
  count DESC
LIMIT
  10