-- Week 4 Project - SQLite and Spatialite
-- SQL Query Practice

-- used .mode table and .headers on in sqlite before running to display results


-- Calculate distance between Sydney and Melbourne
SELECT 'Distance Between Sydney and Melbourne' as '',
    ST_Distance(
        ST_Transform((SELECT geom FROM sample_points WHERE name = 'Sydney'),3577), --Transform to SRID 3577 with units of meters
        ST_Transform((SELECT geom FROM sample_points WHERE name = 'Melbourne'),3577)
    )/1000 AS Distance_km; -- Convert to kms


-- Calculate length of linestring 
SELECT 'Length of Rail Line' as'',
    ROUND(ST_Length(
        ST_Transform((
            SELECT geom FROM sample_lines WHERE name = 'Rail Line'),3577)
        )/1000) AS Length_km; -- Converts to kms 

-- Calculate area of some polygons 
SELECT 'Area of Industrial Zone Polygon' as '', 
ST_Area(
    ST_Transform((SELECT geom FROM sample_polygons WHERE name = 'Industrial Zone'), 3577)
)/1000000 AS Area_sqkm;

SELECT 'Area of Sydney Zone Polygon' as '', 
ST_Area(
    ST_Transform((SELECT geom FROM sample_polygons WHERE name = 'Sydney Zone'), 3577)
)/1000000 AS Area_sqkm;

SELECT 'Area of Melbourne Zone Polygon' as '', 
ST_Area(
    ST_Transform((SELECT geom FROM sample_polygons WHERE name = 'Melbourne Zone'), 3577)
)/1000000 AS "Area in sqkm";

-- Get names and areas for all polygons
SELECT name AS Name, ROUND(ST_Area(ST_Transform(geom, 3577))/1000000) AS "Area in sq kms"
FROM sample_polygons;


-- Check if a linestring and a polygon intersect (share any space)
-- Notice: do not need to transform because this is checking topology only 
SELECT ST_Intersects(
    (SELECT geom FROM sample_lines WHERE name = 'River X'),
    (SELECT geom FROM sample_polygons WHERE name = 'Brisbane Zone')
) AS True_if_one;


-- Find points within 200km of Sydney
SELECT name, 
    ROUND(
        ST_Distance(
            ST_Transform(geom,3577), 
            ST_transform((SELECT geom FROM sample_points WHERE name = 'Sydney'),3577)
            ), 0
        ) AS meters_away
FROM sample_points
WHERE meters_away < 20000 AND name != 'Sydney'
ORDER BY meters_away;