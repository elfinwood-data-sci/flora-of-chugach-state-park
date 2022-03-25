BEGIN;
UPDATE public.gbif_csp_20220320_clipped_foa_taxonomy tbl
SET authoradjudicated = s.adjudicated_author
FROM (
WITH d AS (SELECT kingdom, v.accepted_id, v.name_accepted, v.auth_accepted_id, v.accepted_author, v.hierarchy_id, v.link_source, v.family_id, v.accepted_family, 
v.level_id, v.level, v.habit_id, v.habit, v.category_id, v.category, v.native, v.non_native, v.taxon_source_id, v.accepted_taxon_source, v.accepted_citation, 
v.adjudicated_id, v.name_adjudicated, v.auth_adjudicated_id, v.adjudicated_author, v.status_adjudicated_id, v.taxon_status
	FROM public.flora_of_ak_accepted_join_adjudicated_view v
	RIGHT JOIN public.gbif_csp_20220320_clipped_foa_taxonomy ON  name_accepted = nameaccepted
	WHERE taxon_status IN ('accepted','taxonomy unresolved') OR taxon_status IS NULL)

SELECT * FROM d
	) AS s
WHERE tbl.nameaccepted = s.name_accepted
RETURNING tbl.nameaccepted, authoradjudicated

--85 rows fungi with no taxonomy data
--1491 rows total
--1406 rows should be updated

