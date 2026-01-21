-- Week 4 Project - SQLite and Spatialite
-- SQL Query Practice

-- used `.mode table` and `.headers on` in sqlite before running to display results in pretty tables

-- Display the tables
SELECT * FROM sample_points;
SELECT * FROM sample_lines;
SELECT * FROM sample_polygons;

-- Calculate distance between Sydney and Melbourne
SELECT 'Distance Between Sydney and Melbourne' as '',
    ST_Distance(
        ST_Transform((SELECT geom FROM sample_points WHERE name = 'Sydney'),3577), --Transform to SRID 3577 with units of meters
        ST_Transform((SELECT geom FROM sample_points WHERE name = 'Melbourne'),3577)
    )/1000 AS Distance_km; -- Convert to kms by dividing by 1000

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
SELECT 'Intersection of Brisbane Zone and River X' as '',
ST_Intersects(
    (SELECT geom FROM sample_lines WHERE name = 'River X'),
    (SELECT geom FROM sample_polygons WHERE name = 'Brisbane Zone')
) AS True_if_one;

-- Find points within 200km of Sydney
SELECT 'Points within 200km of Sydney' as '', name, 
    ROUND(
        ST_Distance(
            ST_Transform(geom,3577), 
            ST_Transform((SELECT geom FROM sample_points WHERE name = 'Sydney'),3577)
            ), 0
        ) AS meters_away
FROM sample_points
WHERE meters_away < 200000 AND name != 'Sydney'
ORDER BY meters_away;

-- Identify invalid geometries if any 
SELECT id, name,  ST_GeometryType(geom) as geom_type
FROM sample_points
WHERE ST_IsValid(geom) = 0;

-- Identify invalid geometries if any for each table
SELECT 'Points' AS table_name, COUNT(*) AS invalid_count
FROM sample_points WHERE ST_IsValid(geom) = 0
UNION ALL
SELECT 'Lines', COUNT(*) FROM sample_lines WHERE ST_IsValid(geom) = 0
UNION ALL
SELECT 'Polygons', COUNT(*) FROM sample_polygons WHERE ST_IsValid(geom) = 0;

-- Identify geometry type of elements in polygon layer
SELECT name, ST_GeometryType(geom) as 'Geometry Type'
FROM sample_polygons;

-- Create a buffer of 50 km from Sydney and check for points within that buffer
SELECT 'Buffer of 50km around Sydney' as '', 
ST_Buffer(
    (SELECT geom FROM sample_points WHERE name = 'Sydney'),
    (50*1000)
) AS Distance_in_kms;


SELECT *
FROM sample_points
WHERE ST_Distance(
    ST_Transform(geom, 3577), 
    (ST_Transform((SELECT geom FROM sample_points WHERE name = 'Sydney'),3577)) 
    < 10000*1000);
