BEGIN;
UPDATE public.gbif_csp_20220320_clipped_foa_taxonomy
SET high_quality_location_data = 'TRUE'
WHERE coordinateuncertaintyinmeters::integer <= 11
RETURNING nameaccepted, coordinateuncertaintyinmeters, high_quality_location_data