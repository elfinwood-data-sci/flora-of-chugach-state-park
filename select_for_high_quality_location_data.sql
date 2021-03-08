BEGIN;
UPDATE public.gbif_csp_20210211_clipped_foa_taxonomy
SET high_quality_location_data = 'TRUE'
FROM (
WITH d AS (SELECT objectid, gbifid, basisofrecord, informationwithheld, CASE WHEN eventdate = 'NA' THEN NULL ELSE eventdate END::text AS eventdate, verbatimeventdate,
decimallatitude, char_length(split_part(decimallatitude::text,'.',2)) AS lat_decimal_length,
decimallongitude, char_length(split_part(decimallongitude::text,'.',2)) AS long_decimal_length,
CASE WHEN coordinateuncertaintyinmeters = 'NA' THEN NULL ELSE round(coordinateuncertaintyinmeters::numeric(28,16),0) END::text AS coordinateuncertaintyinmeters,
		   coordinateprecision, issue, nameadjudicated, reason, comment,location_in_chugach_state_park, 
high_quality_location_data, observation_office_note
	FROM public.gbif_csp_20210211_clipped_foa_taxonomy)
	
SELECT * FROM d 
	WHERE lat_decimal_length >=4 AND long_decimal_length >=4 AND
	(coordinateuncertaintyinmeters::integer IS NULL OR coordinateuncertaintyinmeters::integer <=11)
	AND eventdate::timestamp with time zone >= '2000-05-01'
	/*(lat_decimal_length IS NULL OR lat_decimal_length <4) OR
	(long_decimal_length IS NULL OR long_decimal_length <4)*/
	ORDER BY eventdate::timestamp with time zone 
	) AS subq
WHERE public.gbif_csp_20210211_clipped_foa_taxonomy.gbifid = subq.gbifid
RETURNING *;