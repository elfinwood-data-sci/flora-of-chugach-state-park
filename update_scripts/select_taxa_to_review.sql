SELECT ttt.habit, ttt.nameaccepted, tto.list, tto.rankstate, tto.rankglobal
FROM (SELECT habit, nameaccepted FROM public.gbif_csp_20220320_clipped_foa_taxonomy GROUP BY habit, nameaccepted) AS ttt
LEFT JOIN (SELECT nameaccepted, list, rankstate, rankglobal 
	  FROM public.gbif_csp_20210211_clipped_foa_taxonomy 
	  GROUP BY nameaccepted, list, rankstate, rankglobal) AS tto 
	  USING (nameaccepted)
WHERE habit NOT IN ('Fungi') AND list IS NULL
ORDER BY ttt.nameaccepted