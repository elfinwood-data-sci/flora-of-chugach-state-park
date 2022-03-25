BEGIN;
UPDATE public.gbif_csp_20220320_clipped_foa_taxonomy
SET taxonsource = 'NA',
category = 'Fungi',
habit = 'Fungi',
native = 'NA',
nonnative = 'NA',
list = 'NA',
rankstate = 'NA',
rankglobal = 'NA'
WHERE reason LIKE 'fungi%' AND status = 'NA'
RETURNING taxonsource,
category,
habit,
native,
nonnative,
list,
rankstate,
rankglobal

/*SELECT kingdom, nameaccepted, authors
	FROM public.gbif_csp_20220320_clipped_foa_taxonomy
	JOIN import.mycobank_taxon_list ON nameaccepted = taxon_name
	WHERE reason LIKE 'fungi%' AND status = 'NA' AND name_status = 'Legitimate'*/