SELECT scientific_name, count(scientific_name)
	FROM public.observation_location_geometry_view
	WHERE habit = 'Lichen'  --AND high_quality_location_data IS FALSE --basisofrecord NOT IN ('HUMAN_OBSERVATION')
	GROUP BY scientific_name
	ORDER BY count(scientific_name) DESC