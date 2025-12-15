# SQLite and SpatiaLite Project

### This is a project to play around with SQLite and SpatiaLite using the OSGeo4W shell.

### Files 

- .sql called "CreateTables.sql" that creates three tables (1 point, 1 linestring, 1 polygon).

### Process
- Installed the OSWGeo4W shell with GDAL libraries (includes SpatiaLite)
- Used shell to create a SQLite databse using `sqlite3 play.db`
- To get SQLite version number use `SELECT sqlite_version();` to make sure wverything is working.
- `.headers on` and `.mode column` to display tables in an organized way.
- To load the .sql file use `.read CreateTables.sql` or use the relative/full path to navigate to CreateTables.sql location.
    - The .sql file will load and initiliaze SpatiaLite
- To check that the tables are loaded corecctly use the sqlite command `.tables`. You should see the three tables created by running the Create Tables.sql and a bunch of other tables that hold the spatial information from SpatiaLite.
- To check the geometry of the tables just created use `SELECT * FROM geometry_columns;`
    - This will return information on the geometry column in following format: *table name | geometry column name | geometry type (POINT=1, LINESTRING=2, polygon=3, multipoint=4, multilinestring=5, multipolygon=6) | dimensions | ESPG code | spatial index? (0=no, 1=yes)*
- To check the actual geometry stored use `SELECT asText(geom) FROM sample_points;`
- To check the schema of the table created use `PRAGMA table_info(sample_points);`.
    - This returns each column on a line with pipe seperated values: *index | column name | data type | not null (1=not null, 0=can be null) | default value | primary key (1=yes, 0 =no)*
