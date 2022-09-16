SELECT obs_data_source, collection_number, decimallatitude, decimallongitude, scientific_name, level, habit, native, nonnative, list, location_in_chugach_state_park, 
high_quality_location_data, basisofrecord, basisofrecord_agg, year, basis_loc, year_loc
	FROM public.observation_location_geometry_view
	ORDER BY scientific_name