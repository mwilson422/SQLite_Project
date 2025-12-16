-- Week 4 Project - SQLite and Spatialite
-- SQL query Practice

-- Calculate distance between Sydney and Melbourne
SELECT 
    ST_Distance(
        (SELECT geom FROM sample_points WHERE name = 'Sydney'),
        (SELECT geom FROM sample_points WHERE name = 'Melbourne')
    ) * 111 AS Distance_km;  -- multiply by 111 to convert degrees to km (approximate)


SELECT 
    ST_Length(
        (SELECT geom FROM sample_lines WHERE name = 'Rail Line')
    ) * 111 As Length_km; -- multiply by 111 to convert degrees to km (approximate)

SELECT ST_Length(
    ST_Transform((
        SELECT geom FROM sample_lines WHERE name = 'Rail Line'), 32750)
    )/1000 AS Length_km-- Converts to kms because SRID 32750 has units of meters;

