WITH d AS (SELECT ttt.habit, ttt.nameaccepted, ttt.level, tto.list
FROM (SELECT habit, nameaccepted, level FROM public.gbif_csp_20220320_clipped_foa_taxonomy GROUP BY habit, nameaccepted,level) AS ttt
LEFT JOIN (SELECT scientific_name AS nameaccepted, list 
	  FROM public.observation_location_geometry_view
	  GROUP BY scientific_name, list) AS tto 
	  USING (nameaccepted)
WHERE list IS NULL AND level IN ('species','subspecies','variety','microspecies','hybrid')
ORDER BY ttt.nameaccepted)

SELECT * FROM d
WHERE habit NOT IN ('Fungi')
