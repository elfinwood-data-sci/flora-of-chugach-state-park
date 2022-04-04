BEGIN;
UPDATE public.voucher_metadata vm
SET category = s.category
FROM
(SELECT scientific_name, v.category
	FROM public.voucher_metadata
	JOIN public.flora_of_ak_accepted_join_adjudicated_view v ON scientific_name = name_accepted
	WHERE taxon_status = 'accepted') AS s
WHERE vm.scientific_name = s.scientific_name
RETURNING *;