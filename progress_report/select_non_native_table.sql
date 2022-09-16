WITH d AS (SELECT nameaccepted, rankstate, count(nameaccepted)
	FROM public.report_app_species_list_view v
	LEFT JOIN public.gbif_csp_20210211_clipped_foa_taxonomy USING (nameaccepted)
	WHERE v.list LIKE ('non%')
	GROUP BY nameaccepted, rankstate
	ORDER BY nameaccepted),
	
c AS (SELECT nameaccepted, 
	CASE 
		WHEN rankstate = 'NA' THEN '-999'
		ELSE rankstate
	END::text AS akepic_invasiveness_ranking , count
FROM d)

SELECT nameaccepted, akepic_invasiveness_ranking
FROM c
ORDER BY count dESC --
--akepic_invasiveness_ranking::integer DESC

