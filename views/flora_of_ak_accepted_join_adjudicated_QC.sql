WITH d AS (SELECT accepted_id, name_accepted, auth_accepted_id, accepted_author, hierarchy_id, link_source, family_id, accepted_family, level_id, 
level, habit_id, habit, category_id, category, native, non_native, taxon_source_id, accepted_taxon_source, accepted_citation, adjudicated_id, 
name_adjudicated, auth_adjudicated_id, adjudicated_author, status_adjudicated_id, taxon_status
	FROM public.flora_of_ak_accepted_join_adjudicated_view)

SELECT non_native, name_accepted
FROM d
WHERE non_native IS TRUE
GROUP BY non_native, name_accepted
ORDER BY non_native, name_accepted