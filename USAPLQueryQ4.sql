/************
QUESTION 4: How have Male and Female participation in Nationals grown over the years?
************/
/*********
 ANSWER 4: Count Names of participants, Group by Sex and Year, order by year ascending
 *********/
SELECT
	Year(Date) as Year,
	Sex,
	COUNT(Name) as NumberOfParticipants
FROM [dbo].usapl_nationals
WHERE (Division = 'MR-O' OR Division = 'FR-O') 
GROUP BY Sex, Year(Date)
ORDER BY Year ASC
