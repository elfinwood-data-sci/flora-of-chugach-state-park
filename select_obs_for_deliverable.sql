SELECT scientific_name, level, habit, list AS rare_or_nonnative_listing, obs_data_source, collection_number, decimallatitude AS decimallatitude_wgs84, 
decimallongitude AS decimallongitude_wgs84, high_quality_location_data, basisofrecord_agg, basis_loc
	FROM public.observation_location_geometry_view
	ORDER BY scientific_name