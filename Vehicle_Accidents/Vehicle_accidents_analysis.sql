--- Q1. How many accidents have occurred in urban areas versus rural areas
select area,count(accidentindex) as number_of_accidents from accident group by Area

--- Q2. Which day of the week has the highest number of accidents
select top 1 day,count(accidentindex) as number_of_accidents from accident group by day order by number_of_accidents desc

--- Q3. What is the average age of vehicles involved in accidents based on their types
select vehicletype,count(accidentindex)as number_of_accidents
,avg(Agevehicle) as avg_age from vehicle  
where AgeVehicle is not null group by VehicleType
order by number_of_accidents desc

--- Q4. Can we identify any trends in accidents based on the age of vehicles involved
SELECT 
	AgeGroup,
	COUNT([AccidentIndex]) AS 'Total Accident',
	AVG([AgeVehicle]) AS 'Average Year'
FROM (
	SELECT
		[AccidentIndex],
		[AgeVehicle],
		CASE
			WHEN [AgeVehicle] BETWEEN 0 AND 5 THEN 'New'
			WHEN [AgeVehicle] BETWEEN 6 AND 10 THEN 'Regular'
			ELSE 'Old'
		END AS AgeGroup
	FROM [dbo].[vehicle]
) AS SubQuery
GROUP BY 
	AgeGroup;

--- Q5. Are there any specific weather conditions that contribute to severe conditions?
select weatherconditions,severity,count(accidentindex) as number_of_accidents
from accident group by WeatherConditions,Severity order by number_of_accidents desc,Severity

--- Q6. Do accidents often involve impacts on left hand side of vehicles?
select LeftHand,count(accidentIndex) as number_of_accidents from vehicle group by LeftHand having LeftHand is not null

--- Q7. Are there any relationships between journey purpose and the severity of accidents?
SELECT 
	V.[JourneyPurpose], 
	COUNT(A.[Severity]) AS 'Total Accident',
	CASE 
		WHEN COUNT(A.[Severity]) BETWEEN 0 AND 1000 THEN 'Low'
		WHEN COUNT(A.[Severity]) BETWEEN 1001 AND 3000 THEN 'Moderate'
		ELSE 'High'
	END AS 'Level'
FROM 
	[dbo].[accident] A
JOIN 
	[dbo].[vehicle] V ON A.[AccidentIndex] = V.[AccidentIndex]
GROUP BY 
	V.[JourneyPurpose]
ORDER BY 
	'Total Accident' DESC;

--  Q8.Calculate the average age of vehicles involved in accidents , considering Day light and point of impact:
select  a.LightConditions , v.pointimpact,avg(v.AgeVehicle) as avg_age from vehicle v join accident a on v.AccidentIndex = a.AccidentIndex 
group by LightConditions , PointImpact order by avg_age desc