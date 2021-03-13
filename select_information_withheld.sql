SELECT recordedby, objectid, nameoriginal, eventdate::timestamp with time zone, decimallatitude, decimallongitude, 
observation_office_note, high_quality_location_data, location_in_chugach_state_park, informationwithheld
	FROM public.gbif_csp_20210211_clipped_foa_taxonomy
	WHERE informationwithheld IS NOT NULL
AND informationwithheld NOT IN ('NA')
AND recordedby NOT IN ('Aaron Wells')
AND observation_office_note IS NULL
ORDER BY recordedby, nameoriginal