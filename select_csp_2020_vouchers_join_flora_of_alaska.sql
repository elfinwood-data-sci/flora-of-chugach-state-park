SELECT project, family, scientific_name, name_accepted, collector, collection_number, month_collected, day_collected, year_collected, 
state, county, locality, minimum_elevation, elevation_unit, lat_degrees, n_or_s, lon_degrees, w_or_e, geodetic_datum, coordinate_source, 
site_description, specimen_notes, specimen_verifier, lat_deg_min_sec, long_deg_min_sec, serial, high_quality_location_data, 
location_in_chugach_state_park, 
author, hierarchy_id, taxon_source_id, link_source, level, habit, list, native, non_native
	FROM public.chugach_state_park_vouchers_uaah_template_v02
	JOIN flora_of_alaska_view ON scientific_name = name_accepted