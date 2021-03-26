WITH d AS (SELECT family, sum(total_observations) AS total_obs, count(family) AS number_of_taxa
	FROM public.report_app_species_list_view
	GROUP BY family
	ORDER BY sum(total_observations) DESC)

SELECT ROW_NUMBER() OVER (ORDER BY total_obs DESC,family) AS sort_order, family, total_obs, number_of_taxa
FROM d
	