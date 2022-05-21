--SUURVEY FUNNEL

  SELECT * FROM survey LIMIT 10;

  SELECT question,
    COUNT(DISTINCT user_id) AS 'num_responses'
  FROM survey
  GROUP BY question;

--HOME TRY ON FUNNEL

  SELECT * FROM quiz LIMIT 5;
  SELECT * FROM home_try_on LIMIT 5;
  SELECT * FROM purchase LIMIT 5;

  SELECT DISTINCT q.user_id,
    h.user_id IS NOT NULL AS 'is_home_try_on',
    h.number_of_pairs,
    p.user_id IS NOT NULL AS 'is_purchase'
  FROM quiz AS 'q'
  LEFT JOIN home_try_on AS 'h'
    ON h.user_id = q.user_id
  LEFT JOIN purchase AS 'p'
    ON p.user_id = h.user_id
  LIMIT 10;

  WITH hto_funnel AS (
    SELECT DISTINCT q.user_id,
      h.user_id IS NOT NULL AS 'is_home_try_on',
      h.number_of_pairs,
      p.user_id IS NOT NULL AS 'is_purchase'
    FROM quiz AS 'q'
    LEFT JOIN home_try_on AS 'h'
      ON h.user_id = q.user_id
    LEFT JOIN purchase AS 'p'
      ON p.user_id = h.user_id)
  SELECT
    COUNT(*) AS 'num_quiz',
    SUM(is_home_try_on) AS 'num_home_try_on',
    SUM(is_purchase) AS 'num_purchase',
    1.0 * SUM(is_home_try_on) / COUNT(user_id)
      AS 'quiz_to_home_try_on',
    1.0 * SUM(is_purchase) / COUNT(is_home_try_on)
      AS 'home_try_on_to_purchase'
  FROM hto_funnel;

  WITH hto_funnel AS (
    SELECT DISTINCT q.user_id,
      h.user_id IS NOT NULL AS 'is_home_try_on',
      h.number_of_pairs,
      p.user_id IS NOT NULL AS 'is_purchase'
    FROM quiz AS 'q'
    LEFT JOIN home_try_on AS 'h'
      ON h.user_id = q.user_id
    LEFT JOIN purchase AS 'p'
      ON p.user_id = h.user_id)
  SELECT
    number_of_pairs,
    SUM(is_home_try_on) AS 'num_home_try_on',
    SUM(is_purchase) AS 'num_purchase',
    ROUND(1.0 * SUM(is_purchase) / COUNT(is_home_try_on), 2)
      AS 'home_try_on_to_purchase'
  FROM hto_funnel
  GROUP BY number_of_pairs
  HAVING number_of_pairs > 0;
