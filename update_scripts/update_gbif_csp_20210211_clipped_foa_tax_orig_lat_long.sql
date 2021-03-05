BEGIN;
UPDATE public.gbif_csp_20210211_clipped_foa_taxonomy
	SET original_decimallatitude = decimallatitude,
	original_decimallongitude = decimallongitude
RETURNING objectid, original_decimallatitude, decimallatitude,
	original_decimallongitude, decimallongitude