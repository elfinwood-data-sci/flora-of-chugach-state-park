ALTER TABLE public.gbif_csp_20210211_clipped_foa_taxonomy
    ADD COLUMN original_decimallatitude double precision;

ALTER TABLE public.gbif_csp_20210211_clipped_foa_taxonomy
    ADD COLUMN original_decimallongitude double precision;

ALTER TABLE public.gbif_csp_20210211_clipped_foa_taxonomy
    ADD COLUMN observation_office_note text;