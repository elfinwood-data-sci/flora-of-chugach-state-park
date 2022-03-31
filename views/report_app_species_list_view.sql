-- View: public.report_app_species_list_view

-- DROP VIEW public.report_app_species_list_view;

--CREATE OR REPLACE VIEW public.report_app_species_list_view AS

WITH d AS (SELECT gbifid::text, familyy, familyx, acceptedscientificname, nameaccepted, authoraccepted, authors, habit, list, basisofrecord, high_quality_location_data, level
FROM public.gbif_csp_20210211_clipped_foa_taxonomy
		   LEFT JOIN (SELECT taxon_name, name_status, authors FROM import.mycobank_taxon_list WHERE name_status = 'Legitimate') AS subq ON nameaccepted = taxon_name
	WHERE location_in_chugach_state_park IS TRUE 
		AND level NOT IN ('genus','NA') 
	--GROUP BY familyy, familyx, acceptedscientificname,nameaccepted, authoraccepted,authors, habit, list, basisofrecord, high_quality_location_data, level
	ORDER BY familyy, nameaccepted, basisofrecord, high_quality_location_data),

vouch AS (SELECT collection_number::text, family AS famx, family AS famy, scientific_name, name_accepted, author, author, habit, list, 
		  'PRESERVED_SPECIMEN'::text AS basisofrecord, high_quality_location_data, level
	FROM public.chugach_state_park_vouchers_uaah_template_v02
	JOIN flora_of_alaska_view ON scientific_name = name_accepted),

uni AS (SELECT * FROM d
	   UNION ALL
	   SELECT * FROM vouch),
	
funguy AS (SELECT gbifid,
	CASE
		WHEN familyy = 'NA' THEN familyx
		ELSE familyy
	END::text AS family,
	nameaccepted, 
	CASE
		WHEN authoraccepted = 'NA' THEN authors
		ELSE authoraccepted
	END::text AS authoraccepted,
	habit, list, basisofrecord, high_quality_location_data, level, basisofrecord || ': ' || high_quality_location_data AS basis_loc
FROM uni),

notsofunguy AS (
	SELECT gbifid,family,nameaccepted,authoraccepted,habit,list,basisofrecord,high_quality_location_data,level,basis_loc
	FROM funguy
	GROUP BY gbifid,family,nameaccepted,authoraccepted,habit,list,basisofrecord,high_quality_location_data,level,basis_loc
),

inatty_high AS (SELECT family, nameaccepted, authoraccepted, habit, list, level, 'inat_h'::text AS attr, count(nameaccepted) AS cnt
FROM notsofunguy
WHERE basis_loc = 'HUMAN_OBSERVATION: true'
GROUP BY family, nameaccepted, authoraccepted, habit, list, level),

inatty_low AS (SELECT family, nameaccepted, authoraccepted, habit, list, level, 'inat_l'::text AS attr, count(nameaccepted) AS inat_l
FROM notsofunguy
WHERE basis_loc = 'HUMAN_OBSERVATION: false'
GROUP BY family, nameaccepted, authoraccepted, habit, list, level),

phys_high AS (SELECT family, nameaccepted, authoraccepted, habit, list, level, 'phys_h'::text AS attr, count(nameaccepted) AS phys_h
FROM notsofunguy
WHERE basis_loc IN ('PRESERVED_SPECIMEN: true','LIVING_SPECIMEN: true', 'MATERIAL_SAMPLE: true')
GROUP BY family, nameaccepted, authoraccepted, habit, list, level),

phys_low AS (SELECT family, nameaccepted, authoraccepted, habit, list, level, 'phys_l'::text AS attr, count(nameaccepted) AS phys_l
FROM notsofunguy
WHERE basis_loc IN ('PRESERVED_SPECIMEN: false','LIVING_SPECIMEN: false', 'MATERIAL_SAMPLE: false')
GROUP BY family, nameaccepted, authoraccepted, habit, list, level),

unk_high AS (SELECT family, nameaccepted, authoraccepted, habit, list, level, 'unk_h'::text AS attr, count(nameaccepted) AS unk_h
FROM notsofunguy
WHERE basis_loc IN ('UNKNOWN: true')
GROUP BY family, nameaccepted, authoraccepted, habit, list, level),

unk_low AS (SELECT family, nameaccepted, authoraccepted, habit, list, level, 'unk_l'::text AS attr, count(nameaccepted) AS unk_l
FROM notsofunguy
WHERE basis_loc IN ('UNKNOWN: false')
GROUP BY family, nameaccepted, authoraccepted, habit, list, level),

uni_two AS (
SELECT * FROM inatty_high
	UNION
	SELECT * FROM inatty_low
	UNION
	SELECT * FROM phys_high
	UNION
	SELECT * FROM phys_low
	UNION
	SELECT * FROM unk_high
	UNION
	SELECT * FROM unk_low
),

xyz AS (SELECT family, nameaccepted, authoraccepted, habit, list, level,
round(max((case when attr = 'inat_h' then cnt else 0 end)),0) as inat_h,
round(max((case when attr = 'inat_l' then cnt else 0 end)),0) as inat_l,
round(max((case when attr = 'phys_h' then cnt else 0 end)),0) as phys_h,
round(max((case when attr = 'phys_l' then cnt else 0 end)),0) as phys_l,
round(max((case when attr = 'unk_h' then cnt else 0 end)),0) as unk_h,
round(max((case when attr = 'unk_l' then cnt else 0 end)),0) as unk_l
FROM uni_two
GROUP BY family, nameaccepted, authoraccepted, habit, list, level
ORDER BY nameaccepted),

tot AS (SELECT family, nameaccepted, authoraccepted, habit, list, level, inat_h, inat_l, phys_h, phys_l, unk_h, unk_l,
inat_h + inat_l + phys_h + phys_l + unk_h + unk_l AS total_observations
FROM xyz)

SELECT * FROM tot

/*;

ALTER TABLE public.report_app_species_list_view
    OWNER TO postgres;
COMMENT ON VIEW public.report_app_species_list_view
    IS 'This view creates an appendix for the report that displays the species list from Chugach State Park.';*/