BEGIN;
UPDATE public.gbif_csp_20220320_clipped_foa_taxonomy
SET level = 'species'
WHERE reason LIKE 'fungi%' AND status = 'NA'
RETURNING nameaccepted, level

/*SELECT kingdom, nameaccepted, authors
	FROM public.gbif_csp_20220320_clipped_foa_taxonomy
	JOIN import.mycobank_taxon_list ON nameaccepted = taxon_name
	WHERE reason LIKE 'fungi%' AND status = 'NA' AND name_status = 'Legitimate'*/