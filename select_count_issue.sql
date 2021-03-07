SELECT issue, count(issue)
	FROM public.gbif_csp_20210211_clipped_foa_taxonomy
	
	GROUP BY issue
ORDER BY issue
	