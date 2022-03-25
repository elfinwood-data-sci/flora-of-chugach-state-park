BEGIN;
UPDATE public.gbif_csp_20220320_clipped_foa_taxonomy tbl
SET familyy = s.familyy
FROM (
	SELECT ttt.kingdom, ttt.nameaccepted, tto.familyy
	FROM public.gbif_csp_20220320_clipped_foa_taxonomy ttt
	JOIN public.gbif_csp_20210211_clipped_foa_taxonomy tto ON ttt.nameaccepted = tto.nameaccepted
	WHERE ttt.reason LIKE 'fungi%' AND ttt.status = 'NA' 
	GROUP BY ttt.kingdom, ttt.nameaccepted, tto.familyy
) AS s
WHERE tbl.reason LIKE 'fungi%' AND tbl.status = 'NA' AND tbl.nameaccepted = s.nameaccepted
RETURNING tbl.kingdom, tbl.nameaccepted, tbl.familyy
