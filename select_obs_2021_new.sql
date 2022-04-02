WITH d AS (SELECT ttt.habit, ttt.nameaccepted, ttt.level, tto.list
FROM (SELECT habit, nameaccepted, level,location_in_chugach_state_park FROM public.gbif_csp_20220320_clipped_foa_taxonomy GROUP BY habit, nameaccepted,level,location_in_chugach_state_park) AS ttt
LEFT JOIN (SELECT scientific_name AS nameaccepted, list, year 
	  FROM public.observation_location_geometry_view
		   WHERE year NOT IN ('2022','2021') 
	  GROUP BY scientific_name, list, year) AS tto 
	  USING (nameaccepted)
WHERE list IS NULL AND level IN ('species','subspecies','variety','microspecies','hybrid') AND location_in_chugach_state_park IS TRUE
ORDER BY ttt.nameaccepted)

SELECT * FROM d
--WHERE habit NOT IN ('Fungi')
