WITH d AS (SELECT nameaccepted, rankstate
	FROM public.report_app_species_list_view v
	LEFT JOIN public.gbif_csp_20210211_clipped_foa_taxonomy USING (nameaccepted)
	WHERE v.list LIKE ('rare%')
	GROUP BY nameaccepted, rankstate
	ORDER BY nameaccepted)
	
SELECT nameaccepted, 
	CASE
		WHEN nameaccepted = 'Botrychium ascendens' THEN 'S2S3'
		WHEN nameaccepted = 'Botrychium yaaxudakeit' THEN 'S2'
		WHEN nameaccepted = 'Draba densifolia' THEN 'S2S3Q'
		WHEN nameaccepted = 'Draba macounii' THEN 'S3'
	 	ELSE rankstate
	END::text AS rankstate
FROM d
ORDER BY nameaccepted