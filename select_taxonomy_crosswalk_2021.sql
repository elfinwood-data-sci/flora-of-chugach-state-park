WITH d AS (SELECT kingdom, scientificname, genus, specificepithet, infraspecificepithet, taxonrank,
	CASE
		WHEN taxonrank = 'SPECIES' THEN genus || ' ' || specificepithet
		WHEN taxonrank = 'SUBSPECIES' THEN genus || ' ' || specificepithet || ' ' || 'ssp.' || ' ' || infraspecificepithet
		WHEN taxonrank = 'VARIETY' THEN genus || ' ' || specificepithet || ' ' || 'var.' || ' ' || infraspecificepithet
		ELSE genus || ' ' || specificepithet
	END::text AS sciname 
	FROM public.gbif_csp_20220320_clipped_foa_taxonomy),
	
	g AS (SELECT kingdom, scientificname, sciname FROM d
	GROUP BY kingdom, scientificname, sciname
	ORDER BY kingdom, scientificname, sciname)
	
	SELECT kingdom, scientificname, sciname, name_adjudicated, name_accepted FROM g
	LEFT JOIN public.flora_of_ak_accepted_join_adjudicated_view ON sciname = name_adjudicated
	WHERE name_adjudicated IS NULL -- no match in AKVEG taxonomy table
	