WITH d AS (SELECT  ttt.scientific_name, location_in_chugach_state_park
FROM (SELECT scientific_name,location_in_chugach_state_park 
	  FROM public.chugach_state_park_vouchers_uaah_template_v02
	  WHERE year_collected = '2021'
	  GROUP BY scientific_name, location_in_chugach_state_park) AS ttt
LEFT JOIN (SELECT scientific_name, list, year 
	  FROM public.observation_location_geometry_view
		   WHERE year NOT IN ('2022','2021') 
	  GROUP BY scientific_name, list, year) AS tto 
	  USING (scientific_name)
WHERE list IS NULL AND location_in_chugach_state_park IS TRUE
ORDER BY ttt.scientific_name)

SELECT * FROM d