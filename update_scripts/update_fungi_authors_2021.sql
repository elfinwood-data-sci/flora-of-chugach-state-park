BEGIN;
UPDATE public.gbif_csp_20220320_clipped_foa_taxonomy tbl
SET authoraccepted = s.authors
FROM 
(SELECT kingdom, nameaccepted, authors
	FROM public.gbif_csp_20220320_clipped_foa_taxonomy
	JOIN import.mycobank_taxon_list ON nameaccepted = taxon_name
	WHERE reason LIKE 'fungi%' AND status = 'NA' AND name_status = 'Legitimate')
	AS s
WHERE tbl.reason LIKE 'fungi%' AND tbl.status = 'NA' AND tbl.nameaccepted = s.nameaccepted
RETURNING tbl.kingdom, tbl.nameaccepted, tbl.authoraccepted
