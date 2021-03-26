WITH d AS (SELECT 
	CASE 
		WHEN habit = 'Shrub, Deciduous Tree' THEN 'Shrub'
		WHEN habit = 'Dwarf Shrub, Shrub' THEN 'Dwarf Shrub'
		ELSE habit
	END::text AS habit,
	scientific_name
	FROM public.observation_location_geometry_view),

gb AS (SELECT habit, scientific_name FROM d
GROUP BY habit, scientific_name
ORDER BY habit, scientific_name),

gbhab AS (SELECT habit, count(scientific_name)
FROM gb
GROUP BY habit
ORDER BY habit),

srt AS (SELECT 
	CASE
		WHEN habit = 'Coniferous Tree' THEN 1.0
		WHEN habit = 'Deciduous Tree' THEN 2.0
		WHEN habit = 'Dwarf Shrub' THEN 4.0
		WHEN habit = 'Forb' THEN 5.0
		WHEN habit = 'Fungi' THEN 11.0
		WHEN habit = 'Graminoid' THEN 6.0
		WHEN habit = 'Lichen' THEN 10.0
		WHEN habit = 'Liverwort' THEN 9.0
		WHEN habit = 'Moss' THEN 8.0
		WHEN habit = 'Shrub' THEN 3.0
		WHEN habit = 'Spore-bearing' THEN 7.0
		ELSE -999.900
	END::numeric(4,1) AS sort_order,
	CASE
		WHEN habit = 'Shrub' THEN 'Low or Tall Shrub'
		ELSE habit
	END::text AS "Lifeform", count
FROM gbhab)

SELECT * FROM srt 
ORDER BY sort_order

