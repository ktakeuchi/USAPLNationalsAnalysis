/************
QUESTION 3: Which weight class is the most competitive (Based on number of participants)?
************/
-- Using Case statements from Question 1 since it combines both USAPL and IPF Weight classes into a weight range
/*********
 ANSWER 3: Using Subqueries and COUNT(), ordering by descending participant count
 *********/
SELECT
	Sex,
	WeightClass,
	COUNT(Name) as ParticipantCount
FROM (
	SELECT
		Sex,
		Name,
		Division,
		CASE
			WHEN Sex = 'F' THEN
				CASE
					WHEN BodyweightKg <= 44 THEN '43-44'
					WHEN BodyweightKg > 44 AND BodyweightKg <= 48 THEN '47-48'
					WHEN BodyweightKg > 48 AND BodyweightKg <= 52 THEN '52'
					WHEN BodyweightKg > 52 AND BodyweightKg <= 57 THEN '56-57'
					WHEN BodyweightKg > 57 AND BodyweightKg <= 63 THEN '60-63'
					WHEN BodyweightKg > 63 AND BodyweightKg <= 69 THEN '67.5-69'
					WHEN BodyweightKg > 69 AND BodyweightKg <= 76 THEN '72-76'
					WHEN BodyweightKg > 76 AND BodyweightKg <= 84 THEN '82.5-84'
					WHEN BodyweightKg > 84 AND BodyweightKg <= 90 THEN '84-90'
					WHEN BodyweightKg > 90 AND BodyweightKg <= 100 THEN '100'
					WHEN BodyweightKg > 100 THEN '100+' 
				END
			WHEN Sex = 'M' THEN
				CASE
					WHEN BodyweightKg <= 53 THEN '52-53'
					WHEN BodyweightKg > 53 AND BodyweightKg <= 56 THEN '56'
					WHEN BodyweightKg > 56 AND BodyweightKg <= 60 THEN '59-60'
					WHEN BodyweightKg > 60 AND BodyweightKg <= 67.5 THEN '66-67.5'
					WHEN BodyweightKg > 67.5 AND BodyweightKg <= 75 THEN '74-75'
					WHEN BodyweightKg > 75 AND BodyweightKg <= 83 THEN '82.5-83'
					WHEN BodyweightKg > 83 AND BodyweightKg <= 93 THEN '90-93'
					WHEN BodyweightKg > 93 AND BodyweightKg <= 105 THEN '100-105'
					WHEN BodyweightKg >= 105 AND BodyweightKg <= 110 THEN '105-110' -- 105's were in between 100 and 110
					WHEN BodyweightKg > 110 AND BodyweightKg <= 125 THEN '120-125'
					WHEN BodyweightKg > 125 AND BodyweightKg <= 140 THEN '140'
					WHEN BodyweightKg > 140 THEN '140+'
				END
		END AS WeightClass,
		CASE
			WHEN Sex = 'F' THEN
				CASE
					WHEN BodyweightKg <= 44 THEN 43
					WHEN BodyweightKg > 44 AND BodyweightKg <= 48 THEN 47
					WHEN BodyweightKg > 48 AND BodyweightKg <= 52 THEN 52
					WHEN BodyweightKg > 52 AND BodyweightKg <= 57 THEN 56
					WHEN BodyweightKg > 57 AND BodyweightKg <= 63 THEN 60
					WHEN BodyweightKg > 63 AND BodyweightKg <= 69 THEN 67
					WHEN BodyweightKg > 69 AND BodyweightKg <= 76 THEN 72
					WHEN BodyweightKg > 76 AND BodyweightKg <= 84 THEN 82
					WHEN BodyweightKg > 84 AND BodyweightKg <= 90 THEN 84
					WHEN BodyweightKg > 90 AND BodyweightKg <= 100 THEN 91
					WHEN BodyweightKg > 100 THEN 100
				END
			WHEN Sex = 'M' THEN
				CASE
					WHEN BodyweightKg <= 53 THEN 52
					WHEN BodyweightKg > 53 AND BodyweightKg <= 56 THEN 56
					WHEN BodyweightKg > 56 AND BodyweightKg <= 60 THEN 59
					WHEN BodyweightKg > 60 AND BodyweightKg <= 67.5 THEN 66
					WHEN BodyweightKg > 67.5 AND BodyweightKg <= 75 THEN 74
					WHEN BodyweightKg > 75 AND BodyweightKg <= 83 THEN 82
					WHEN BodyweightKg > 83 AND BodyweightKg <= 93 THEN 90
					WHEN BodyweightKg > 93 AND BodyweightKg <= 105 THEN 100
					WHEN BodyweightKg >= 105 AND BodyweightKg <= 110 THEN 110 -- 105's were in between 100 and 110
					WHEN BodyweightKg > 110 AND BodyweightKg <= 125 THEN 120
					WHEN BodyweightKg > 125 AND BodyweightKg <= 140 THEN 140
					WHEN BodyweightKg > 140 THEN 141
				END
		END AS SortOrder
	FROM [dbo].usapl_nationals
) AS WeightClassData
WHERE (Division = 'MR-O' OR Division = 'FR-O') 
GROUP BY Sex, WeightClass
ORDER BY ParticipantCount DESC