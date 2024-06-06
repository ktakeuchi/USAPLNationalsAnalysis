/************
QUESTION 2: How many times have 1st place finishers in the Open Division also won on subtotal?
************/
-- This gives us a table with every competititor in each year's nationals, their subtotal, and their total
SELECT
	Name,
	Year(Date) as Year,
	--WeightClassKg,
	CASE -- Since OpenPowerlifting combines the Womens 100 and 100+ under one weightClass, we need to separate the two to not get multiple 1st places under one category. 
		 --	100+ is denoted as 101 for ease of organization. Same with the Mens 140 category, where 140+ is denoted as 141
		WHEN WeightClassKg = 100 AND BodyweightKg > 100 AND Sex = 'F' AND Year(Date) = 2023 THEN 101 -- Setting year since 100+ was added in 2023
		WHEN WeightClassKg = 140 AND BodyweightKg > 140 AND Sex = 'M' AND Year(Date) = 2023 THEN 141 -- Setting year since 140+ was added in 2023
		WHEN WeightClassKg = 84 AND BodyweightKg > 84 AND Sex = 'F' AND Year(Date) <= 2021 AND Year(Date) > 2012 THEN 85 -- Setting year since 84+ was added from 2013-2021
		WHEN WeightClassKg = 120 AND BodyweightKg > 120 AND Sex = 'M' AND Year(Date) <= 2021 AND Year(Date) > 2012 THEN 121 -- Setting year since 120+ was added from 2013-2021
		WHEN WeightClassKg = 90 AND BodyweightKg > 90 AND Sex = 'F' AND Year(Date) <= 2012 THEN 91 -- Setting year since 90+ was added from 2008-2012
		WHEN WeightClassKg = 125 AND BodyweightKg > 125 AND Sex = 'M' AND Year(Date) <= 2012 THEN 126 -- Setting year since 125+ was added from 2008-2012
		ELSE WeightClassKg
	END AS WeightClass,
	Sex,
	Place,
	(Best3SquatKg + Best3BenchKg) as Subtotal,
	TotalKg
FROM [dbo].usapl_nationals
WHERE (Division = 'MR-O' OR Division = 'FR-O') 
AND (Place IS NOT NULL) 
AND (Best3SquatKg IS NOT NULL AND Best3BenchKg IS NOT NULL)
GROUP BY Sex, Name, WeightClassKg, Place, Year(Date), Best3SquatKg, Best3BenchKg, TotalKg, BodyweightKg
ORDER BY Sex, Year, WeightClass, Place, Subtotal DESC

-- Using CTE and Window Function to find Subtotal Rank and Place Rank, resulting table shows all 1st places that also won in subtotal
WITH WeightClassData AS (
    SELECT
        Name,
        YEAR(Date) as Year,
        WeightClassKg,
        BodyweightKg,
        Sex,
        Place,
        (Best3SquatKg + Best3BenchKg) as Subtotal,
        TotalKg
    FROM [dbo].usapl_nationals
    WHERE (Division = 'MR-O' OR Division = 'FR-O') 
        AND (Place IS NOT NULL) 
        AND (Best3SquatKg IS NOT NULL AND Best3BenchKg IS NOT NULL)
), WeightClassCalculation AS (
    SELECT
        *,
        CASE 
            WHEN WeightClassKg = 100 AND BodyweightKg > 100 AND Sex = 'F' AND Year = 2023 THEN 101
            WHEN WeightClassKg = 140 AND BodyweightKg > 140 AND Sex = 'M' AND Year = 2023 THEN 141
            WHEN WeightClassKg = 84 AND BodyweightKg > 84 AND Sex = 'F' AND Year <= 2021 AND Year > 2012 THEN 85
            WHEN WeightClassKg = 120 AND BodyweightKg > 120 AND Sex = 'M' AND Year <= 2021 AND Year > 2012 THEN 121
            WHEN WeightClassKg = 90 AND BodyweightKg > 90 AND Sex = 'F' AND Year <= 2012 THEN 91
            WHEN WeightClassKg = 125 AND BodyweightKg > 125 AND Sex = 'M' AND Year <= 2012 THEN 126
            ELSE WeightClassKg
        END AS WeightClass
    FROM WeightClassData
), RankedCompetitors AS (
    SELECT
        Name,
        Year,
        WeightClass,
        Sex,
        Place,
        Subtotal,
        TotalKg,
        RANK() OVER (PARTITION BY Sex, WeightClass, Year ORDER BY Subtotal DESC) AS SubtotalRank,
        RANK() OVER (PARTITION BY Sex, WeightClass, Year ORDER BY Place ASC) AS PlaceRank
    FROM WeightClassCalculation
)
SELECT
    Name,
    Year,
    WeightClass,
    Sex,
    Place,
    Subtotal,
    TotalKg
FROM RankedCompetitors
WHERE SubtotalRank = 1 AND PlaceRank = 1
ORDER BY Sex, Year, WeightClass, Place, Subtotal DESC;


/*********
 ANSWER 2: Using CTE's, Window functions, and aggregate function COUNT()
 *********/
WITH WeightClassData AS (
    SELECT
        Name,
        YEAR(Date) as Year,
        WeightClassKg,
        BodyweightKg,
        Sex,
        Place,
        (Best3SquatKg + Best3BenchKg) as Subtotal,
        TotalKg
    FROM [dbo].usapl_nationals
    WHERE (Division = 'MR-O' OR Division = 'FR-O') 
        AND (Place IS NOT NULL) 
        AND (Best3SquatKg IS NOT NULL AND Best3BenchKg IS NOT NULL)
), WeightClassCalculation AS (
    SELECT
        *,
        CASE 
            WHEN WeightClassKg = 100 AND BodyweightKg > 100 AND Sex = 'F' AND Year = 2023 THEN 101
            WHEN WeightClassKg = 140 AND BodyweightKg > 140 AND Sex = 'M' AND Year = 2023 THEN 141
            WHEN WeightClassKg = 84 AND BodyweightKg > 84 AND Sex = 'F' AND Year <= 2021 AND Year > 2012 THEN 85
            WHEN WeightClassKg = 120 AND BodyweightKg > 120 AND Sex = 'M' AND Year <= 2021 AND Year > 2012 THEN 121
            WHEN WeightClassKg = 90 AND BodyweightKg > 90 AND Sex = 'F' AND Year <= 2012 THEN 91
            WHEN WeightClassKg = 125 AND BodyweightKg > 125 AND Sex = 'M' AND Year <= 2012 THEN 126
            ELSE WeightClassKg
        END AS WeightClass
    FROM WeightClassData
), RankedCompetitors AS (
    SELECT
        Name,
        Year,
        WeightClass,
        Sex,
        Place,
        Subtotal,
        TotalKg,
        RANK() OVER (PARTITION BY Sex, WeightClass, Year ORDER BY Subtotal DESC) AS SubtotalRank,
        RANK() OVER (PARTITION BY Sex, WeightClass, Year ORDER BY Place ASC) AS PlaceRank
    FROM WeightClassCalculation
)
SELECT
    COUNT(*) AS 'Won in Subtotal AND Total',
	(SELECT COUNT(*) FROM WeightClassData WHERE Place = 1) AS 'Total Count of First Places'
FROM RankedCompetitors
WHERE SubtotalRank = 1 AND PlaceRank = 1