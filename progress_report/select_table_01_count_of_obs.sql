WITH d AS (SELECT basisofrecord_agg AS "Observation Source", 
	CASE
		WHEN high_quality_location_data IS TRUE THEN 'High'
		ELSE 'Low'
	END::text AS "Location Quality"
	FROM public.observation_location_geometry_view)
	
	SELECT "Location Quality", "Observation Source",count("Observation Source") AS "Number of Observations"
	FROM d
	GROUP BY "Location Quality", "Observation Source"
	ORDER BY "Location Quality","Observation Source","Number of Observations"