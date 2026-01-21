# Working with Existing data in Shapefile Format

### Files
- Natural Earth provides free, public map data for learning (https://www.naturalearthdata.com/downloads/)
    - Downloaded:
        - Countries (1:110m)
        - Rivers,Lakes Centerlines (1:110m)
        - Populated Places (1:110m)

### Process

- Downloaded point, line and polygon data from Natural Earth to play around with. 
- Use ogr2orr to convert the shapefiles to a SQLite database. 
    - ogr2ogr is a command-line utility for converting and transforming geospatial vector data between different formats. It is part of the GDAL (Geospatial Data Abstraction Library). 
    - **Geometry Considerations**
        - By default, ogr2ogr will assume the geometry of the input shapefile is Point, LineString, or Polygon and will return an error if the shapefile is actually a MultiPoint, MultiLineString, or MultiPolygon. 
            - This happens when a feature contains multiple unconnected geometries and happens with geometries of countries, for example, because one country can have multiple polygons (think of islands like Japan). A Polygon can only representa single continuous area, while a MultiPolygon can represent multiple seperate polygons in one feature. 
            - No downside to specifying Multi- if unsure of the data type but should always check first. 
                - To check the metadata including the geometry and CRS of .shp file use `ogrinfo natural_earth\ne_110m_admin_0_countries.shp -al -so`
                    - `-al` = report all layers
                    - `-so` = summary only
- Load the first shapefile into the database using:
    ```
    ogr2ogr -f SQLite -dsco SPATIALITE=YES -nlt MULTIPOLYGON natural_earth.db natural_earth\ne_110m_admin_0_countries.shp -nln countries
    ```
    -  `ogr2ogr` runs the GDAL conversion tool
    - `-f "SQLite"` output format is SQlite
    - `-dsco SPATIALITE=YES` dataset creation option - make this a SpatiaLite databse.
    - `nlt MULTIPOLYGON` new layer type
    - `natural_earth.db` is the output database
    - `...countries.shp` input shapefile location
    - `-nln countries` name the new table created
- Load the next shapefiles into the database using:
    ```
    ogr2ogr -update -f "SQLite" -nlt MULTILINESTRING natural_earth.db natural_earth\ne_110m_rivers_lake_centerlines.shp -nln rivers
    ```
    - - `update` goes before the `-f` **This is to append to a database that is already created. Use this for adding more tables** Also do not need the `SPATIALITE=YES` part when adding to an already existing database