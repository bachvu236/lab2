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