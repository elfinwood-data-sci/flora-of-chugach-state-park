-- View: public.observation_location_geometry_view
--DETAIL:  view taxa_by_lifeform_donut_chart_view depends on view observation_location_geometry_view
--3161 records from 2020 and previous + 1487 from 2021 iNaturalist (as of March 29) + 50 rows from 2021 voucher specimens equals 4,698 records

--DROP VIEW public.observation_location_geometry_view --CASCADE;

CREATE OR REPLACE VIEW public.observation_location_geometry_view AS

WITH gbif AS (SELECT gbifid, decimallatitude, decimallongitude,
	CASE
		WHEN nameaccepted = 'NA' THEN nameadjudicated
		ELSE nameaccepted
	END::text AS nameaccepted_with_fungi, level,
	habit, native, nonnative, list,  location_in_chugach_state_park, high_quality_location_data,basisofrecord,year
FROM public.gbif_csp_20210211_clipped_foa_taxonomy
			 WHERE location_in_chugach_state_park IS TRUE),
			 
gbif21 AS (SELECT gbifid, decimallatitude, decimallongitude,
	CASE
		WHEN nameaccepted = 'NA' THEN nameadjudicated
		ELSE nameaccepted
	END::text AS nameaccepted_with_fungi, level,
	habit, native, nonnative, list,  location_in_chugach_state_park, high_quality_location_data,basisofrecord,year
FROM public.gbif_csp_20220320_clipped_foa_taxonomy
			 WHERE location_in_chugach_state_park IS TRUE),

vouchers2020 AS (
SELECT project, family, v.scientific_name, collector, collection_number, month_collected, day_collected, year_collected, state, county, 
locality, minimum_elevation, elevation_unit, lat_degrees, n_or_s, lon_degrees, w_or_e, geodetic_datum, coordinate_source, site_description, 
specimen_notes, specimen_verifier, lat_deg_min_sec, long_deg_min_sec, high_quality_location_data,habit, level, native, nonnative, v.list,
	'PRESERVED_SPECIMEN'::text AS basisofrecord
	FROM public.chugach_state_park_vouchers_uaah_template_v02 v
	LEFT JOIN voucher_metadata vm USING (scientific_name)
	GROUP BY (project, family, v.scientific_name, collector, collection_number, month_collected, day_collected, year_collected, state, county, 
locality, minimum_elevation, elevation_unit, lat_degrees, n_or_s, lon_degrees, w_or_e, geodetic_datum, coordinate_source, site_description, 
specimen_notes, specimen_verifier, lat_deg_min_sec, long_deg_min_sec, high_quality_location_data,habit, level, native, nonnative, v.list,
			 'PRESERVED_SPECIMEN'::text)
),
uni AS (SELECT 'gbif'::text AS obs_data_source, gbifid::text, decimallatitude, decimallongitude, nameaccepted_with_fungi, level,
	habit, native, nonnative, list,  location_in_chugach_state_park, high_quality_location_data,basisofrecord, year 
		FROM gbif
	UNION 
	SELECT 'gbif'::text AS obs_data_source, gbifid::text, decimallatitude, decimallongitude, nameaccepted_with_fungi, level,
	habit, native, nonnative, list,  location_in_chugach_state_park, high_quality_location_data,basisofrecord, year 
		FROM gbif21
	UNION
	SELECT 'vouchers'::text AS obs_data_source, collection_number, lat_degrees, lon_degrees, scientific_name, 
		level, habit, native::text, nonnative::text, list,  'TRUE'::boolean AS location_in_chugach_state_park, high_quality_location_data, 
		basisofrecord, year_collected
		FROM vouchers2020
	   ),

gm AS (SELECT ROW_NUMBER() OVER (ORDER BY gbifid) AS ogc_fid, obs_data_source, gbifid AS collection_number, decimallatitude, decimallongitude, nameaccepted_with_fungi AS scientific_name, level,
	habit, native, nonnative, list,  location_in_chugach_state_park, high_quality_location_data,basisofrecord, year,
	CASE
		WHEN basisofrecord = 'HUMAN_OBSERVATION' THEN 'iNaturalist Obs.'
		WHEN basisofrecord = 'LIVING_SPECIMEN' THEN 'Physical Specimen'
		WHEN basisofrecord = 'MATERIAL_SAMPLE' THEN 'Physical Specimen'
		WHEN basisofrecord = 'PRESERVED_SPECIMEN' THEN 'Physical Specimen'
		WHEN basisofrecord = 'UNKNOWN' THEN 'Unknown'
	END::text AS basisofrecord_agg,
	ST_SetSRID(ST_MakePoint(decimallongitude, decimallatitude),4326) AS geom
	FROM uni
	WHERE level IN ('species','subspecies','variety','microspecies','hybrid')
	ORDER BY obs_data_source, collection_number)

SELECT ogc_fid, obs_data_source, collection_number, decimallatitude, decimallongitude, scientific_name, level,
	habit, native, nonnative, list,  location_in_chugach_state_park, high_quality_location_data,basisofrecord,
	basisofrecord_agg, year,
	CASE
		WHEN basisofrecord_agg = 'iNaturalist Obs.' AND high_quality_location_data IS TRUE THEN 'iNaturalist Obs. High Quality Loc.'
		WHEN basisofrecord_agg = 'iNaturalist Obs.' AND high_quality_location_data IS FALSE THEN 'iNaturalist Obs. Low Quality Loc.'
		WHEN basisofrecord_agg = 'Physical Specimen' AND high_quality_location_data IS TRUE THEN 'Physical Specimen High Quality Loc.'
		WHEN basisofrecord_agg = 'Physical Specimen' AND high_quality_location_data IS FALSE THEN 'Physical Specimen Low Quality Loc.'
		WHEN basisofrecord_agg = 'Unknown' AND high_quality_location_data IS TRUE THEN 'Unknown Obs. High Quality Loc.'
		WHEN basisofrecord_agg = 'Unknown' AND high_quality_location_data IS FALSE THEN 'Unknown Obs. Low Quality Loc.'
		ELSE 'SOMETHING ELSE'
	END::text AS basis_loc, 
	geom,
	CASE
		WHEN year IN ('2021', '2022') AND high_quality_location_data IS TRUE THEN '2021 High Quality Loc.'
		WHEN year IN ('2021', '2022') AND high_quality_location_data IS FALSE THEN '2021 Low Quality Loc.'
		WHEN year NOT IN ('2021', '2022') AND high_quality_location_data IS TRUE THEN 'Pre-2021 High Quality Loc.'
		WHEN year NOT IN ('2021', '2022') AND high_quality_location_data IS FALSE THEN 'Pre-2021 Low Quality Loc.'
		ELSE 'SOMETHING ELSE'
	END::text AS year_loc
FROM gm;

ALTER TABLE public.observation_location_geometry_view
    OWNER TO aaronwells;
COMMENT ON VIEW public.observation_location_geometry_view
    IS 'This view creates a point geometry layer for the observations in Chugach State Park.';