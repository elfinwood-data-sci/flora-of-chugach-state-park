SELECT familyy, nameaccepted, authoraccepted, habit, list, basisofrecord, high_quality_location_data, level
FROM public.gbif_csp_20210211_clipped_foa_taxonomy
	WHERE location_in_chugach_state_park IS TRUE 
		AND level NOT IN ('genus','NA')
	GROUP BY familyy, nameaccepted, authoraccepted, habit, list, basisofrecord, high_quality_location_data, level
	ORDER BY familyy, nameaccepted, basisofrecord, high_quality_location_data