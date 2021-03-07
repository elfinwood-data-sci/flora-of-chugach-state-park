-- View: public.observation_location_geometry_view

--DROP VIEW public.observation_location_geometry_view;

CREATE OR REPLACE VIEW public.observation_location_geometry_view AS

WITH gbif AS (SELECT gbifid, decimallatitude, decimallongitude,
	CASE
		WHEN nameaccepted = 'NA' THEN nameadjudicated
		ELSE nameaccepted
	END::text AS nameaccepted_with_fungi, level,
	habit, native, nonnative, list,  location_in_chugach_state_park, high_quality_location_data
FROM public.gbif_csp_20210211_clipped_foa_taxonomy),

vouchers2020 AS (
SELECT project, family, v.scientific_name, collector, collection_number, month_collected, day_collected, year_collected, state, county, 
locality, minimum_elevation, elevation_unit, lat_degrees, n_or_s, lon_degrees, w_or_e, geodetic_datum, coordinate_source, site_description, 
specimen_notes, specimen_verifier, lat_deg_min_sec, long_deg_min_sec, high_quality_location_data,habit, level, native, nonnative, list
	FROM public.chugach_state_park_vouchers_uaah_template_v02 v
	LEFT JOIN voucher_metadata vm USING (scientific_name)
	GROUP BY (project, family, v.scientific_name, collector, collection_number, month_collected, day_collected, year_collected, state, county, 
locality, minimum_elevation, elevation_unit, lat_degrees, n_or_s, lon_degrees, w_or_e, geodetic_datum, coordinate_source, site_description, 
specimen_notes, specimen_verifier, lat_deg_min_sec, long_deg_min_sec, high_quality_location_data,habit, level, native, nonnative, list)
),


uni AS (SELECT 'gbif'::text AS obs_data_source, gbifid::text, decimallatitude, decimallongitude, nameaccepted_with_fungi, level,
	habit, native, nonnative, list,  location_in_chugach_state_park, high_quality_location_data FROM gbif
	UNION
	SELECT 'vouchers'::text AS obs_data_source, collection_number, lat_degrees, lon_degrees, scientific_name, 
		level, habit, native::text, nonnative::text, list,  'TRUE'::boolean AS location_in_chugach_state_park, high_quality_location_data
		FROM vouchers2020
	   )

SELECT ROW_NUMBER() OVER (ORDER BY gbifid) AS ogc_fid, obs_data_source, gbifid AS collection_number, decimallatitude, decimallongitude, nameaccepted_with_fungi AS scientific_name, level,
	habit, native, nonnative, list,  location_in_chugach_state_park, high_quality_location_data,
	ST_SetSRID(ST_MakePoint(decimallongitude, decimallatitude),4326) AS geom
	FROM uni
	--WHERE level NOT IN ('species','subspecies','variety','microspecies','hybrid')
	ORDER BY obs_data_source, collection_number;

ALTER TABLE public.observation_location_geometry_view
    OWNER TO aaronwells;
COMMENT ON VIEW public.observation_location_geometry_view
    IS 'This view creates a point geometry layer for the observations in Chugach State Park.';
