BEGIN;
UPDATE public.gbif_csp_20210211_clipped_foa_taxonomy gb
SET level = s.level
FROM (
WITH d AS (SELECT gbifid, nameaccepted, habit, array_length(string_to_array(nameaccepted,' '),1) AS word_count
FROM public.gbif_csp_20210211_clipped_foa_taxonomy
WHERE habit = 'fungi'
ORDER BY nameaccepted)

SELECT gbifid, nameaccepted, habit, word_count,
CASE
	WHEN word_count = 1 THEN 'genus'
	WHEN word_count = 2 THEN 'species'
	WHEN word_count = 4 and nameaccepted LIKE '%var.%' THEN 'variety'
	ELSE 'SOMETHING ELSE'
END::character varying(32) AS level
FROM d
) AS s
WHERE gb.gbifid = s.gbifid AND gb.nameaccepted = s.nameaccepted
RETURNING gb.gbifid, gb.nameaccepted, gb.habit, word_count, gb.level