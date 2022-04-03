BEGIN;
INSERT INTO voucher_metadata (scientific_name, habit, level, native, nonnative)
SELECT * FROM (
WITH d AS (SELECT scientific_name
FROM (SELECT scientific_name FROM public.chugach_state_park_vouchers_uaah_template_v02 GROUP BY scientific_name) AS subq
LEFT JOIN voucher_metadata vm USING (scientific_name)
WHERE vm.scientific_name IS NULL
ORDER BY scientific_name)

SELECT scientific_name, ssb.habit, ssb.level, native, non_native FROM d
JOIN (SELECT * FROM public.flora_of_ak_accepted_join_adjudicated_view WHERE taxon_status = 'accepted') AS ssb ON scientific_name = name_accepted
LEFT JOIN public.report_app_species_list_view ON scientific_name = nameaccepted
ORDER BY scientific_name
) AS bbb
RETURNING *;
