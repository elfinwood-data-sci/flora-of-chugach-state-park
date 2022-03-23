-- View: public.taxonomy_crossref_view_2021

-- DROP VIEW public.taxonomy_crossref_view_2021;

CREATE OR REPLACE VIEW public.taxonomy_crossref_view_2021 AS

WITH d AS (SELECT kingdom, scientificname, genus, specificepithet, infraspecificepithet, taxonrank,
	CASE
		WHEN taxonrank = 'SPECIES' THEN genus || ' ' || specificepithet
		WHEN taxonrank = 'SUBSPECIES' THEN genus || ' ' || specificepithet || ' ' || 'ssp.' || ' ' || infraspecificepithet
		WHEN taxonrank = 'VARIETY' THEN genus || ' ' || specificepithet || ' ' || 'var.' || ' ' || infraspecificepithet
		ELSE genus || ' ' || specificepithet
	END::text AS sciname 
	FROM public.gbif_csp_20220320_clipped_foa_taxonomy),
	
	g AS (SELECT kingdom, scientificname, sciname FROM d
	GROUP BY kingdom, scientificname, sciname
	ORDER BY kingdom DESC, scientificname, sciname),
	
	nomatch AS (SELECT kingdom, scientificname, sciname, sciname AS name_adjudicated, 
				CASE
					WHEN scientificname = 'Aconitum delphinifolium subsp. delphinifolium' THEN 'Aconitum delphiniifolium ssp. delphiniifolium'
					WHEN scientificname = 'Amelanchier alnifolia var. semiintegrifolia (Hook.) C.L.Hitchc.' THEN 'Amelanchier alnifolia'
					WHEN scientificname = 'Anemonastrum narcissiflorum (L.) Holub' THEN 'Anemonastrum sibiricum'
					WHEN scientificname = 'Artemisia norvegica Fr.' THEN 'Artemisia norvegica ssp. saxatilis'
					WHEN scientificname = 'Cerastium arvense subsp. arvense' THEN 'Cerastium arvense'
					WHEN scientificname = 'Dryas octopetala L.' THEN 'Dryas'
					WHEN scientificname = 'Pilosella tristis (Willd. ex Spreng.) F.W.Schultz & Sch.Bip.' THEN 'Stenotheca tristis'
					WHEN scientificname = 'Primula pauciflora (Durand) A.R.Mast & Reveal' THEN 'Dodecatheon pulchellum var. pulchellum'
					WHEN scientificname = 'Rhinanthus groenlandicus Chabert' THEN 'Rhinanthus'
					WHEN scientificname = 'Rhodiola rosea L.' THEN 'Rhodiola integrifolia'
					WHEN scientificname = 'Sambucus racemosa subsp. racemosa' THEN 'Sambucus racemosa'
					WHEN scientificname = 'Saxifraga bronchialis L.' THEN 'Saxifraga funstonii'
				
					WHEN scientificname = 'Amanita muscaria (L.) Lam.' THEN sciname
					WHEN scientificname = 'Apioperdon pyriforme (Schaeff.) Vizzini' THEN sciname
					WHEN scientificname = 'Boletus edulis Bull.' THEN sciname
					WHEN scientificname = 'Calycina citrina (Hedw.) Gray' THEN sciname
					WHEN scientificname = 'Chrysomyxa arctostaphyli Dietel' THEN sciname
					WHEN scientificname = 'Clavaria rosea Fr.' THEN sciname
					WHEN scientificname = 'Cortinarius caperatus (Pers.) Fr.' THEN sciname
					WHEN scientificname = 'Deconica montana (Pers.) P.D.Orton' THEN sciname
					WHEN scientificname = 'Diplodia tumefaciens (Shear) Zalasky' THEN sciname
					WHEN scientificname = 'Fomes fomentarius (L.) Fr.' THEN sciname
					WHEN scientificname = 'Fomitopsis betulina (Bull.) B.K.Cui, M.L.Han & Y.C.Dai' THEN sciname
					WHEN scientificname = 'Fomitopsis mounceae Haight & Nakasone' THEN sciname
					WHEN scientificname = 'Ganoderma applanatum (Pers.) Pat.' THEN sciname
					WHEN scientificname = 'Gloeophyllum sepiarium (Wulfen) P.Karst.' THEN sciname
					WHEN scientificname = 'Hericium coralloides (Scop.) Pers.' THEN sciname
					WHEN scientificname = 'Inonotus obliquus (Fr.) Pilát' THEN sciname
					WHEN scientificname = 'Lactarius deterrimus Gröger' THEN sciname
					WHEN scientificname = 'Leccinum scabrum (Bull.) Gray' THEN sciname
					WHEN scientificname = 'Lycoperdon perlatum Pers.' THEN sciname
					WHEN scientificname = 'Merulius tremellosus Schrad.' THEN 'Phlebia tremellosa' --Phlebia tremellosus not valid, orthographic variant
					WHEN scientificname = 'Microstoma protractum (Fr.) Kanouse' THEN sciname
					WHEN scientificname = 'Neoboletus luridiformis (Rostk.) Gelardi, Simonini & Vizzini' THEN sciname
					WHEN scientificname = 'Phaeolus schweinitzii (Fr.) Pat.' THEN sciname
					WHEN scientificname = 'Phellinus igniarius (L.) Quél.' THEN sciname
					WHEN scientificname = 'Phellinus tremulae (Bondartsev) Bondartsev & P.N.Borisov' THEN sciname
					WHEN scientificname = 'Physcia millegrana Degel.' THEN sciname
					WHEN scientificname = 'Pleurotus populinus O.Hilber & O.K.Mill.' THEN sciname
					WHEN scientificname = 'Plicatura nivea (Fr.) P.Karst.' THEN sciname
					WHEN scientificname = 'Plicaturopsis crispa (Pers.) D.A.Reid' THEN sciname
					WHEN scientificname = 'Porodaedalea pini (Brot.) Murrill' THEN sciname
					WHEN scientificname = 'Sarcomyxa serotina (Schrad.) P.Karst.' THEN sciname
					WHEN scientificname = 'Taphrina betulina Rostr.' THEN sciname
					WHEN scientificname = 'Trametes ochracea (Pers.) Gilb. & Ryvarden' THEN sciname
				ELSE 'SOMETHING ELSE'
				END::character varying (120) AS name_accepted,
				'no match'::text AS taxon_crossref
				FROM g
	LEFT JOIN public.flora_of_ak_accepted_join_adjudicated_view ON sciname = name_adjudicated
	WHERE name_adjudicated IS NULL), -- no match in AKVEG taxonomy table
	
	matching AS (SELECT kingdom, scientificname, sciname, name_adjudicated, name_accepted,'match'::text AS taxon_crossref 
				FROM g
	LEFT JOIN public.flora_of_ak_accepted_join_adjudicated_view ON sciname = name_adjudicated
	WHERE name_adjudicated IS NOT NULL) -- match in AKVEG taxonomy table
	
	SELECT * FROM matching
	UNION
	SELECT * FROM nomatch
	ORDER BY kingdom DESC, sciname;

ALTER TABLE public.taxonomy_crossref_view_2021
    OWNER TO postgres;
COMMENT ON VIEW public.taxonomy_crossref_view_2021
    IS 'This view prepares a cross reference table between the iNaturalist taxonomic names and the accepted names in the new Flora of Alaska from the AKVEG database.';


