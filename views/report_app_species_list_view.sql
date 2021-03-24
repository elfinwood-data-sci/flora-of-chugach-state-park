WITH d AS (SELECT familyy, familyx, acceptedscientificname, nameaccepted, authoraccepted, authors, habit, list, basisofrecord, high_quality_location_data, level
FROM public.gbif_csp_20210211_clipped_foa_taxonomy
		   LEFT JOIN (SELECT taxon_name, name_status, authors FROM import.mycobank_taxon_list WHERE name_status = 'Legitimate') AS subq ON nameaccepted = taxon_name
	WHERE location_in_chugach_state_park IS TRUE 
		AND level NOT IN ('genus','NA') 
	GROUP BY familyy, familyx, acceptedscientificname,nameaccepted, authoraccepted,authors, habit, list, basisofrecord, high_quality_location_data, level
	ORDER BY familyy, nameaccepted, basisofrecord, high_quality_location_data),
	
funguy AS (SELECT  
	CASE
		WHEN familyy = 'NA' THEN familyx
		ELSE familyy
	END::text AS family,
	nameaccepted, 
	CASE
		WHEN authoraccepted = 'NA' THEN authors
		ELSE authoraccepted
	END::text AS authoraccepted,
	habit, list, basisofrecord, high_quality_location_data, level, basisofrecord || ': ' || high_quality_location_data AS basis_loc
FROM d),

inatty_high AS (SELECT family, nameaccepted, authoraccepted, habit, list, level, count(nameaccepted) AS inat_h
FROM funguy
WHERE basis_loc = 'HUMAN_OBSERVATION: true'
GROUP BY family, nameaccepted, authoraccepted, habit, list, level),

inatty_low AS (SELECT family, nameaccepted, authoraccepted, habit, list, level, count(nameaccepted) AS inat_l
FROM funguy
WHERE basis_loc = 'HUMAN_OBSERVATION: false'
GROUP BY family, nameaccepted, authoraccepted, habit, list, level),

phys_high AS (SELECT family, nameaccepted, authoraccepted, habit, list, level, count(nameaccepted) AS phys_h
FROM funguy
WHERE basis_loc = 'PRESERVED_SPECIMEN: true'
GROUP BY family, nameaccepted, authoraccepted, habit, list, level),

phys_low AS (SELECT family, nameaccepted, authoraccepted, habit, list, level, count(nameaccepted) AS phys_l
FROM funguy
WHERE basis_loc = 'PRESERVED_SPECIMEN: false'
GROUP BY family, nameaccepted, authoraccepted, habit, list, level)

SELECT subq.family, subq.nameaccepted, subq.authoraccepted, subq.habit, subq.list, subq.level,
	COALESCE(inat_h,0) AS inat_h,
	COALESCE(inat_l,0) AS inat_l,
	COALESCE(phys_h,0) AS phys_h,
	COALESCE(phys_l,0) AS phys_l
FROM (SELECT family, nameaccepted, authoraccepted, habit, list, level FROM funguy 
	 GROUP BY family, nameaccepted, authoraccepted, habit, list, level
	 ORDER BY authoraccepted) AS subq
LEFT JOIN inatty_high USING (nameaccepted)
LEFT JOIN inatty_low USING (nameaccepted)
LEFT JOIN phys_high USING (nameaccepted)
LEFT JOIN phys_low USING (nameaccepted)
ORDER BY nameaccepted
	 