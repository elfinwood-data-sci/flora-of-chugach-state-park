WITH d AS (SELECT ttt.habit, ttt.nameaccepted, tto.list
FROM (SELECT habit, nameaccepted FROM public.gbif_csp_20220320_clipped_foa_taxonomy GROUP BY habit, nameaccepted) AS ttt
LEFT JOIN (SELECT scientific_name AS nameaccepted, list 
	  FROM public.observation_location_geometry_view
	  GROUP BY scientific_name, list) AS tto 
	  USING (nameaccepted)
WHERE list IS NULL 
ORDER BY ttt.nameaccepted)

SELECT * FROM d
