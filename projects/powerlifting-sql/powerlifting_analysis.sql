-- ✅ Average amount lifted for each lift type
SELECT 
  `Lift Type`,
  AVG(`Amount Lifted (kg)`) AS avg_lift
FROM 
  powerlifting_dataset
GROUP BY 
  `Lift Type`;

-- ✅ Heaviest lift (max amount lifted) for each lifter
SELECT 
  `Lifter Name`, 
  MAX(`Amount Lifted (kg)`) AS max_amount_lifted
FROM 
  powerlifting_dataset
GROUP BY 
  `Lifter Name`;

-- ✅ Lifter with the highest total amount lifted
SELECT 
  `Lifter Name`, 
  SUM(`Amount Lifted (kg)`) AS total_amount_lifted
FROM 
  powerlifting_dataset
GROUP BY 
  `Lifter Name`
ORDER BY 
  total_amount_lifted DESC
LIMIT 1;

-- ✅ Number of lifts performed in each weight class
SELECT 
  COUNT(`Amount Lifted (kg)`) AS total_lifted, 
  `Weight Class`
FROM 
  powerlifting_dataset
GROUP BY 
  `Weight Class`;

-- ✅ Lifters who performed more than one type of lift
SELECT 
  `Lifter Name`
FROM 
  powerlifting_dataset
GROUP BY 
  `Lifter Name`
HAVING 
  COUNT(DISTINCT `Lift Type`) > 1;

-- ✅ Lifters who improved performance over time (by age)
WITH pf AS (
  SELECT 
    `Lifter Name`, 
    `Age`, 
    `Lift Type`, 
    `Amount Lifted (kg)` AS amount, 
    LAG(`Amount Lifted (kg)`) OVER (
      PARTITION BY `Lifter Name`, `Lift Type`
      ORDER BY `Age`
    ) AS previous_lift		
  FROM 
    powerlifting_dataset
) 
SELECT * 
FROM pf 
WHERE 
  amount > previous_lift;

-- ✅ Top lifter (name + weight class) with max lift per type
WITH rank_lift AS (
  SELECT 
    `Lifter Name`, 
    `Weight Class`, 
    `Lift Type`, 
    `Amount Lifted (kg)` AS Amount, 
    ROW_NUMBER () OVER (
      PARTITION BY `Lift Type` 
      ORDER BY `Amount Lifted (kg)` DESC 
    ) AS row_nm
  FROM 
    powerlifting_dataset
) 
SELECT 
  `Lifter Name`, 
  `Weight Class`, 
  `Lift Type`,
  Amount
FROM rank_lift
WHERE row_nm = 1;

-- ✅ Average lift per age group (e.g., 20–29, 30–39)
SELECT 
  CONCAT(FLOOR(Age / 10) * 10, '-' ,FLOOR(Age / 10) * 10 + 9) AS age_group, 
  ROUND(AVG(`Amount Lifted (kg)`)) AS avg_lifted
FROM 
  powerlifting_dataset
GROUP BY
  age_group
ORDER BY 
  age_group;

-- ✅ Normalize weight class and check correlation
SELECT 
  REPLACE(`Weight Class`, 'kg', '') AS weight_class_kg, 
  `Amount Lifted (kg)`
FROM 
  powerlifting_dataset
WHERE 
  `Weight Class` IS NOT NULL
  AND `Amount Lifted (kg)` IS NOT NULL;

-- ✅ Rank all lifts by amount lifted (highest to lowest)
SELECT 
  `Lifter Name`, 
  `Lift Type`, 
  `Amount Lifted (kg)`, 
  RANK () OVER (
    ORDER BY `Amount Lifted (kg)` DESC
  ) AS `rank` 
FROM 
  powerlifting_dataset;
