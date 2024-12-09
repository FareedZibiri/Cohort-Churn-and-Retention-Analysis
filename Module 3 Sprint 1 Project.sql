WITH
  cohorts AS (
  SELECT
    DATE_TRUNC(subscription_start, WEEK) AS cohort_week,
    user_pseudo_id,
    subscription_start,
    subscription_end
  FROM
    `tc-da-1.turing_data_analytics.subscriptions`
  WHERE
    subscription_start <= '2021-02-07' ),
  weekly_retention AS (
  SELECT
    cohort_week,
    COUNT ( DISTINCT user_pseudo_id) AS week_0,
    COUNT(DISTINCT
      CASE
        WHEN DATE(subscription_start) <= DATE_ADD(cohort_week, INTERVAL 1 WEEK) AND (subscription_end IS NULL OR subscription_end > DATE_ADD(cohort_week, INTERVAL 1 WEEK)) THEN user_pseudo_id
    END
      ) AS week_1,
    COUNT(DISTINCT
      CASE
        WHEN DATE(subscription_start) <= DATE_ADD(cohort_week, INTERVAL 2 WEEK) AND (subscription_end IS NULL OR subscription_end > DATE_ADD(cohort_week, INTERVAL 2 WEEK)) THEN user_pseudo_id
    END
      ) AS week_2,
    COUNT(DISTINCT
      CASE
        WHEN DATE(subscription_start) <= DATE_ADD(cohort_week, INTERVAL 3 WEEK) AND (subscription_end IS NULL OR subscription_end > DATE_ADD(cohort_week, INTERVAL 3 WEEK)) THEN user_pseudo_id
    END
      ) AS week_3,
    COUNT(DISTINCT
      CASE
        WHEN DATE(subscription_start) <= DATE_ADD(cohort_week, INTERVAL 4 WEEK) AND (subscription_end IS NULL OR subscription_end > DATE_ADD(cohort_week, INTERVAL 4 WEEK)) THEN user_pseudo_id
    END
      ) AS week_4,
    COUNT(DISTINCT
      CASE
        WHEN DATE(subscription_start) <= DATE_ADD(cohort_week, INTERVAL 5 WEEK) AND (subscription_end IS NULL OR subscription_end > DATE_ADD(cohort_week, INTERVAL 5 WEEK)) THEN user_pseudo_id
    END
      ) AS week_5,
    COUNT(DISTINCT
      CASE
        WHEN DATE(subscription_start) <= DATE_ADD(cohort_week, INTERVAL 6 WEEK) AND (subscription_end IS NULL OR subscription_end > DATE_ADD(cohort_week, INTERVAL 6 WEEK)) THEN user_pseudo_id
    END
      ) AS week_6
  FROM
    cohorts
  GROUP BY
    cohorts.cohort_week )
SELECT
  weekly_retention.cohort_week,
  week_0,
  (week_1/week_0) * 100 AS retention_rate_wk1,
  (week_2/week_0) * 100 AS retention_rate_wk2,
  (week_3/week_0) * 100 AS retention_rate_wk3,
  (week_4/week_0) * 100 AS retention_rate_wk4,
  (week_5/week_0) * 100 AS retention_rate_wk5,
  (week_6/week_0) * 100 AS retention_rate_wk6,
FROM
  weekly_retention
ORDER BY
  weekly_retention.cohort_week