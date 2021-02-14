WITH arr AS (SELECT scientific_name, array_length(string_to_array(scientific_name,' '),1) AS sciname_len
	FROM public.gbif_csp_20210211_clipped_spplist)
	
SELECT scientific_name, sciname_len,
CASE
	WHEN sciname_len = 1 AND scientific_name IN ('Haloragaceae') THEN 'Family only'
	WHEN sciname_len = 1 AND scientific_name IN ('Mnium') THEN 'Genus only'
	WHEN sciname_len = 1 AND scientific_name IN ('Plantae') THEN 'Kingdom only'
	WHEN sciname_len = 2 AND scientific_name IN ('Ulva fenestrata') THEN 'Algae'
	WHEN sciname_len = 2 THEN 'Genus only'
	WHEN sciname_len = 3 AND scientific_name IN ('Clitocybe (Fr.) Staude','Cortinarius (Pers.) Gray','Hebeloma (Fr.) P.Kumm.',
												'Lepista (Fr.) W.G.Sm.','Lophozia (Dumort.) Dumort.','Mycena (Pers.) Roussel',
												'Pholiota (Fr.) P.Kumm.','Pleurotus (Fr.) P.Kumm.','Schistidium Brid., 1819',
												'Tricholoma (Fr.) Staude','Tubaria (W.G.Sm.) Gillet')
												THEN 'Genus only'
	WHEN sciname_len = 3 THEN 'Species level'
	WHEN sciname_len = 4 THEN 'START HERE'
	ELSE 'SOMETHING ELSE'
END::character varying(255) AS classification_level
FROM arr 
WHERE sciname_len = 4