-- View: public.flora_of_alaska_view

-- DROP VIEW public.flora_of_alaska_view;

CREATE OR REPLACE VIEW public.flora_of_alaska_view AS
SELECT t.accepted_id, t.name_accepted, author, t.hierarchy_id, t.taxon_source_id, t.link_source,taxon_level.level, habit.habit, t.native, t.non_native,
	state_rank, global_rank, federal_listing
	FROM public.taxon_accepted t
	JOIN author ON auth_accepted_id = author_id
	JOIN taxon_level USING (level_id)
	JOIN habit USING (habit_id)
	LEFT JOIN bioblitz.accs_rare_plant_list_taxonomy_crossref_view ON t.name_accepted = name_accepted_adjusted
	;

ALTER TABLE public.flora_of_alaska_view
    OWNER TO aaronwells;


	