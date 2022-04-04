-- View: public.count_of_family_bubble_chart_view

DROP VIEW public.count_of_family_bubble_chart_view;

CREATE OR REPLACE VIEW public.count_of_family_bubble_chart_view AS
WITH d AS (SELECT family, sum(total_observations) AS total_obs, count(family) AS number_of_taxa
	FROM public.report_app_species_list_view
	GROUP BY family
	ORDER BY sum(total_observations) DESC),

cnt AS (SELECT ROW_NUMBER() OVER (ORDER BY total_obs DESC,family) AS sort_order, family, total_obs, number_of_taxa,
	CASE
		WHEN number_of_taxa < 10 THEN 1
		WHEN number_of_taxa BETWEEN 10 AND 30 THEN  2
		WHEN number_of_taxa > 30 THEN 3
		ELSE -999
	END::integer AS number_of_taxa_rank
FROM d),

uu AS (
	SELECT nameaccepted, category FROM (SELECT nameaccepted, category 
										FROM public.gbif_csp_20210211_clipped_foa_taxonomy 
										WHERE level IN ('species','subspecies','variety','microspecies','hybrid') AND location_in_chugach_state_park IS TRUE
										GROUP BY nameaccepted, category) AS tto
	UNION
	SELECT nameaccepted, category FROM (SELECT nameaccepted, category 
										FROM public.gbif_csp_20220320_clipped_foa_taxonomy 
										WHERE level IN ('species','subspecies','variety','microspecies','hybrid') AND location_in_chugach_state_park IS TRUE
										GROUP BY nameaccepted, category) AS ttt
	UNION
	SELECT scientific_name, category FROM voucher_metadata
	ORDER BY nameaccepted
),

uug AS (SELECT nameaccepted, category FROM uu
GROUP BY nameaccepted, category
ORDER BY nameaccepted, category
),

fam AS (SELECT family, category FROM public.observation_location_geometry_view 
JOIN (SELECT replace(nameaccepted,'*','') AS nameaccepted, family FROM public.report_app_species_list_view GROUP BY nameaccepted, family) AS l ON scientific_name = l.nameaccepted
JOIN uug ON scientific_name = uug.nameaccepted
GROUP BY family, category
ORDER BY family, category),

dat AS (SELECT sort_order, family, total_obs, number_of_taxa, number_of_taxa_rank, category
FROM cnt
JOIN fam USING (family)
WHERE sort_order <=35
ORDER BY sort_order)

/*SELECT * FROM fam
WHERE family = 'Physciaceae'*/

SELECT * FROM dat;

ALTER TABLE public.count_of_family_bubble_chart_view
OWNER TO aaronwells;

	