# SQLite and SpatiaLite Project

### This is a project to play around with SQLite and SpatiaLite.

## Creating Data
This is a project to show how to create multiple tables in a SQLite database. I used ChatGPT to create a .sql script that creates and fills three small tables with geometries; one point, one linestring, one polygon table. The geometry is put into a column named 'geom' in BLOB (Binary Large Object) format. This shows how to use the `CREATE TABLE` and `INSERT INTO` SQL commands to define the tables structure, data types and other constraints (e.g setting primary keys and null constraints) and then insert data values using WKT (Well-Known Text) constructors for the column that will store geometry. Finally, the script will register the geometry column with the SpatiaLite-specific function `RecoverGeometryColumn`, which tells SQLite which column contains the geometry, the SRID (coordinate reference system), geometry type and number of dimensions, and enables spatial indexing.


There is also a .sql that has various spatial queries, written by me, to practice working with the created data. 
