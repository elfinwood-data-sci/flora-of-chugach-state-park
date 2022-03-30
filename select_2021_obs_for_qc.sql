WITH d AS (SELECT objectid, gbifid, accessrights, bibliographiccitation, identifier, language, license, modified, reference, rights, rightsholder, type, institutionid, 
collectionid, datasetid, institutioncode, collectioncode, datasetname, ownerinstitutioncode, basisofrecord, informationwithheld, dynamicproperties, occurrenceid, 
catalognumber, recordnumber, recordedby, individualcount, reproductivecondition, occurrencestatus, preparations, disposition, associatedreferences, associatedtaxa, 
othercatalognumbers, occurrenceremarks, organismid, previousidentifications, materialsampleid, eventid, fieldnumber, eventdate, eventtime, startdayofyear, enddayofyear, 
year, month, day, verbatimeventdate, habitat, highergeography, continent, countrycode, stateprovince, county, municipality, locality, verbatimlocality, verbatimelevation, 
minimumdistanceabovesurfaceinmeters, maximumdistanceabovesurfaceinmeters, locationaccordingto, decimallatitude, decimallongitude, coordinateuncertaintyinmeters, 
coordinateprecision, verbatimcoordinatesystem, georeferencedby, georeferenceprotocol, georeferencesources, georeferenceverificationstatus, georeferenceremarks, 
identificationid, identificationqualifier, identifiedby, dateidentified, identificationverificationstatus, identificationremarks, taxonid, higherclassification, 
kingdom, phylum, class, taxonomic_order, familyx, genus, specificepithet, infraspecificepithet, taxonrank, verbatimtaxonrank, vernacularname, nomenclaturalcode, 
taxonomicstatus, datasetkey, publishingcountry, lastinterpreted, elevation, elevationaccuracy, issue, mediatype, hascoordinate, hasgeospatialissues, taxonkey, 
acceptedtaxonkey, kingdomkey, phylumkey, classkey, orderkey, familykey, genuskey, specieskey, species, genericname, acceptedscientificname, verbatimscientificname, 
protocol, lastparsed, lastcrawled, repatriated, level0gid, level0name, level1gid, level1name, level2gid, level2name, scientificname, nameoriginal, nameadjudicated, 
reason, comment, nameid, authoradjudicated, status, nameaccepted, authoraccepted, familyy, taxonsource, level, category, habit, native, nonnative, list, rankstate, 
rankglobal, original_decimallatitude, original_decimallongitude, observation_office_note, location_in_chugach_state_park, high_quality_location_data, 
iucnredlistcategory, serial
	FROM public.gbif_csp_20220320_clipped_foa_taxonomy
	--WHERE coordinateuncertaintyinmeters::integer > 11d
	ORDER BY coordinateuncertaintyinmeters::integer DESC)

SELECT gbifid, recordedby, reference, scientificname, year, month, day, verbatimeventdate, coordinateuncertaintyinmeters, high_quality_location_data, decimallatitude, decimallongitude, informationwithheld, observation_office_note 
FROM d
WHERE --coordinateuncertaintyinmeters::integer < 11 AND informationwithheld IS NOT NULL --AND recordedby = 'aaronfwells' --AND reference LIKE '%73978153'
--coordinateuncertaintyinmeters::integer IS NULL AND length(decimallatitude::text) > 6 AND length(decimallongitude::text) > 8
high_quality_location_data IS TRUE
ORDER BY recordedby DESC, year::integer, month::integer, day::integer

/*SELECT kingdom, scientificname, count(scientificname) FROM d
GROUP BY kingdom, scientificname
ORDER BY count(scientificname) DESC --kingdom, scientificname*/

--SELECT * FROM d WHERE scientificname = 'Botrychium lunaria (L.) Sw.'