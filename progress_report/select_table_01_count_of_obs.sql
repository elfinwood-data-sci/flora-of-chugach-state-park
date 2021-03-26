WITH d AS (SELECT basisofrecord_agg AS "Observation Source", 
	CASE
		WHEN high_quality_location_data IS TRUE THEN 'High'
		ELSE 'Low'
	END::text AS "Location Quality"
	FROM public.observation_location_geometry_view)
	
	SELECT "Observation Source","Location Quality",count("Observation Source") AS "Number of Observations"
	FROM d
	GROUP BY "Observation Source", "Location Quality"
	ORDER BY "Observation Source","Location Quality","Number of Observations"