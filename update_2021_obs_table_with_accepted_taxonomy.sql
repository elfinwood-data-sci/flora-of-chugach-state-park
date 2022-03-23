BEGIN;
UPDATE public.gbif_csp_20220320_clipped_foa_taxonomy t
	SET nameoriginal=sciname, 
	nameadjudicated=name_adjudicated, 
	comment=taxon_crossref, 
	nameaccepted=name_accepted
FROM (
SELECT kingdom, scientificname, sciname, name_adjudicated, name_accepted, taxon_crossref
	FROM public.taxonomy_crossref_view_2021
	) AS subq
WHERE t.scientificname = subq.scientificname
RETURNING t.nameoriginal,
	t.nameadjudicated, 
	t.comment, 
	t.nameaccepted