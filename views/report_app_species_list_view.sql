WITH d AS (SELECT familyy, familyx, acceptedscientificname, nameaccepted, authoraccepted, authors, habit, list, basisofrecord, high_quality_location_data, level
FROM public.gbif_csp_20210211_clipped_foa_taxonomy
		   LEFT JOIN (SELECT taxon_name, name_status, authors FROM import.mycobank_taxon_list WHERE name_status = 'Legitimate') AS subq ON nameaccepted = taxon_name
	WHERE location_in_chugach_state_park IS TRUE 
		AND level NOT IN ('genus','NA') 
	GROUP BY familyy, familyx, acceptedscientificname,nameaccepted, authoraccepted,authors, habit, list, basisofrecord, high_quality_location_data, level
	ORDER BY familyy, nameaccepted, basisofrecord, high_quality_location_data)
	
SELECT  
	CASE
		WHEN familyy = 'NA' THEN familyx
		ELSE familyy
	END::text AS family,
	nameaccepted, 
	CASE
		WHEN authoraccepted = 'NA' THEN authors
		ELSE authoraccepted
	END::text AS authoraccepted,
	habit, list, basisofrecord, high_quality_location_data, level
FROM d
