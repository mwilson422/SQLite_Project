# Creating Spatial Data in SQLite Database

### Files 

- .sql script called 'CreateTables.sql' that creates three tables (1 point, 1 linestring, 1 polygon).
- .sql script called 'SpatialQueries.sql' for practicing various spatial queries using the created tables.

### Process to Create Tables in SQLite Database 
- For Windows: Installed the OSWGeo4W shell with GDAL libraries (includes SpatiaLite).
- For MacOS: Installed via Homebrew by running `brew install sqlite` in terminal.

- Navigate to directory in shell where database will be created.
- Used shell to create a SQLite database named 'play' using `sqlite3 play.db` and enter SQLite environment.
- To get SQLite version number in SQLite use `SELECT sqlite_version();` to make sure evrything is working.
- Load the SpatiaLite in SQLite prompt using `.load /opt/homebrew/lib/mod_spatialite.dylib` or wherever `mod_spatialite.dtlib` is located. And check it worked by checking the version with `SELECT spatialite_version();`
- `.headers on` and `.mode column` to display tables in an organized way.
    - Another way of doing this is creating a SQLite conguration file that runs automatically when starting SQLite.
        - Create using `nano ~/.sqliterc` which will create a hidden file (`.`) in the home directory (`~`).
        - Then using the nano text editor in the shell to enter the following commands:
            ```
            .headers on
            .mode table
            .load /opt/homebrew/lib/mod_spatialite
            ```
        - And save 
- Then initialize spatial metadata (only need to do this once per database) with `SELECT InitSpatialMetadata(1);`
- The sql file that creates the database tables is `CreateTables.sql`. To load the .sql file use `.read CreateTables.sql` or use the relative/full path to navigate to CreateTables.sql location.
- To check that the tables are loaded correctly use the sqlite command `.tables`. You should see the three tables created by running the CreateTables.sql (sample_points, sample_lines, and sample_polygons) and a bunch of other tables that hold the spatial information from SpatiaLite.
- To check the geometry of the tables just created use `SELECT * FROM geometry_columns;`.
    - This will return information on the geometry column in following format: *table name | geometry column name | geometry type (POINT=1, LINESTRING=2, polygon=3, multipoint=4, multilinestring=5, multipolygon=6) | dimensions | ESPG code | spatial index? (0=no, 1=yes)*
- To check the actual geometry stored use `SELECT asText(geom) FROM sample_points;`.
- To check the schema of the table created use `PRAGMA table_info(sample_points);`.
    - This returns each column on a line with pipe seperated values: *index | column name | data type | not null (1=not null, 0=can be null) | default value | primary key (1=yes, 0 =no)*

- **REMEMBER if you exit the database and return to it you must re-load spatialite to be able to do any spatial calculations if you are not using a configuration file. USE `.load mod_spatialite` or `SELECT load_extension('mod_spatialite');`**

### Notes
- The tables are created with SRID 4326 (WGS84) which is a Geographic Coordinate System so any length or area calculations will have units of degrees which, because lines of longitude converge at the poles, are not consistent units of measurement. So will need to transform before using measurement functions. Because the points are all over Australia, I transformed to GDA2020/Albers Equal Area (SRID 3577). It preserves area across Australia (distances will still be not perfect but will be reasonably accurate). The units are meters. 


- The SpatialQueries.sql will run a series of spatial queries with the goal of practicing the following spatial functions:
    - **ST_Distance(geom1,geom2)** will return the shortest distance between two geometries
    - **ST_Length(geom)** will return the length of a linestring or multilinestring
    - **ST_Area(geom)** will return the area of a polygon or multipolygon
    - **ST_Intersects(geom1,geom2)** will return 1(true) if the geometries share *any* space or 0(false) if they do not
    - **ST_Within(geomA,geomB)** returns 1(true) if geometry A is completely insdie of geometry B
    - **ST_Contains(geomA,geomB)** returns 1(true) if geometry A fully wraps geometry B, logical inverse of ST_Within
    - **ST_Touches(geom1,geom2)** returns 1(true) if geometries touch *only* at boundaries (no overlap) 
    - **ST_Transform(geom, target_srid)** will reproject geometry into a new CRS
    - **ST_Buffer(geom, distance)** creates a buffer zone
    - **ST_Centroid(geom)** finds and returns the center of a polygon
    - **ST_Envelope(geom)** returns bounding box of geometry
    - **ST_Union(geom)** merge geometries together
    - **ST_Difference(geomA,geomB)** subtract geometry B from geometry A where they overlap, if there is no overlap then they are both unchanged
    - **ST_IsValid(geom)** check if geometry is broken
    - **ST_GeometryType(geom)** will return the type of geometry
- The ST is the indicator the function is speaking geometry. It stands for Spatial Type and is a OGC standard when using spatial functions so that they are recongizable. This is the standard across different databse systems. A full list can be found at [SpatiaLite Function List](https://www.gaia-gis.it/gaia-sins/spatialite-sql-5.1.0.html#p4).