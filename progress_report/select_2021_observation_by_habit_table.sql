WITH d AS (SELECT collection_number, v.year, v.scientific_name, 
		   CASE
                    WHEN v.habit = 'Shrub, Deciduous Tree'::text THEN 'Shrub'::text
		   			 WHEN v.habit = 'Shrub'::text THEN 'Low or Tall Shrub'::text
                    WHEN v.habit = 'Dwarf Shrub, Shrub'::text THEN 'Dwarf Shrub'::text
                    ELSE v.habit
                END AS habit_agg,
		   v.habit AS habit_orig
	FROM public.observation_location_geometry_view v
	LEFT JOIN public.gbif_csp_20220320_clipped_foa_taxonomy ON collection_number = gbifid::text
	WHERE v.year IN ('2021','2022') AND v.location_in_chugach_state_park IS TRUE
	AND collection_number NOT IN ('3031774505',
'3032107840',
'3031767010',
'3031712440',
'3032076413') --observations from January 2021 that were reported on in the 2020 progress report
		   )
		   
		   SELECT habit_agg, count(habit_agg) FROM d
		   GROUP BY habit_agg
		   ORDER BY habit_agg
	