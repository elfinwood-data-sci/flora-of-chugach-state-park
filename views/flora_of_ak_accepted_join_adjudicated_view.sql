-- DETAIL:  view taxonomy_crossref_view_2021 depends on view flora_of_ak_accepted_join_adjudicated_view
-- View: public.flora_of_ak_accepted_join_adjudicated_view

--DROP VIEW public.flora_of_ak_accepted_join_adjudicated_view CASCADE;

CREATE OR REPLACE VIEW public.flora_of_ak_accepted_join_adjudicated_view AS
 SELECT taxon_accepted.accepted_id,
    taxon_accepted.name_accepted,
    taxon_accepted.auth_accepted_id,
    aa.author AS accepted_author,
    taxon_accepted.hierarchy_id,
    taxon_accepted.link_source,
	h.family_id,
	f.family AS accepted_family,
    taxon_accepted.level_id,
    taxon_level.level,
    taxon_accepted.habit_id,
	habit.habit,
	h.category_id,
	category.category,
    taxon_accepted.native,
    taxon_accepted.non_native,
    taxon_accepted.taxon_source_id,
    taxon_source.taxon_source AS accepted_taxon_source,
    taxon_source.citation AS accepted_citation,
    taxon_adjudicated.adjudicated_id,
    taxon_adjudicated.name_adjudicated,
    taxon_adjudicated.auth_adjudicated_id,
	ana.author AS adjudicated_author,
    taxon_adjudicated.status_adjudicated_id,
    taxon_status.taxon_status
   FROM taxon_accepted
     LEFT JOIN author aa ON taxon_accepted.auth_accepted_id = aa.author_id
     LEFT JOIN taxon_source USING (taxon_source_id)
     LEFT JOIN taxon_level USING (level_id)
     LEFT JOIN taxon_adjudicated USING (accepted_id)
	 LEFT JOIN author ana ON taxon_adjudicated.auth_adjudicated_id = ana.author_id
     LEFT JOIN taxon_status ON taxon_adjudicated.status_adjudicated_id = taxon_status.taxon_status_id
	 LEFT JOIN public.hierarchy h ON split_part(taxon_accepted.name_accepted,' ',1) = h.genus_accepted
	 LEFT JOIN public.family f ON h.family_id = f.family_id
	 LEFT JOIN public.habit ON taxon_accepted.habit_id = habit.habit_id
	 LEFT JOIN public.category ON h.category_id = category.category_id
  ORDER BY taxon_accepted.name_accepted, taxon_adjudicated.name_adjudicated;

ALTER TABLE public.flora_of_ak_accepted_join_adjudicated_view
    OWNER TO postgres;
COMMENT ON VIEW public.flora_of_ak_accepted_join_adjudicated_view
    IS 'This view performs a join between the taxon_accepted and taxon_adjudicated tables, and pulls in title from other reference tables (e.g., taxon_status).';
