BEGIN;
UPDATE public.gbif_csp_20210211_clipped_foa_taxonomy
SET habit = 'fungi',
nameaccepted = nameadjudicated
WHERE reason = 'fungi'
RETURNING nameaccepted, habit;