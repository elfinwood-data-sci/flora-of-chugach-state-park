-- View: public.flora_of_alaska_view

-- DROP VIEW public.flora_of_alaska_view;

CREATE OR REPLACE VIEW public.flora_of_alaska_view AS
SELECT accepted_id, name_accepted, author, hierarchy_id, taxon_source_id, link_source, level, habit, native, non_native
	FROM public.taxon_accepted
	JOIN author ON auth_accepted_id = author_id
	JOIN taxon_level USING (level_id)
	JOIN habit USING (habit_id);

ALTER TABLE public.flora_of_alaska_view
    OWNER TO aaronwells;


	