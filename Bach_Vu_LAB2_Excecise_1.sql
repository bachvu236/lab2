--Exercise 1 Given the shared file top_4000_movies_data.csv
--             1. Create a BigQuery table “Movie”
--             2. Find the top 10 highest budget films, year by year, from 2016 to 2020.

SELECT
  *
FROM
  (
     WITH
       movies AS (
       SELECT
         EXTRACT(YEAR
         FROM
          release_date) year,
         movie_title,
         cast(production_budget as numeric) production_budget
       FROM
         `nttdata-c4e-bde.uc1_8.Movie`)
     SELECT
       year,
       movie_title,
       production_budget,
       RANK() OVER (PARTITION BY year ORDER BY production_budget DESC) rank
     FROM
       movies
     WHERE
       year BETWEEN 2016
       AND 2020
     ORDER BY
       year DESC)
WHERE
  rank <= 10;
