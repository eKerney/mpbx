### Tricks and Tips 
```bash
# WSL2 docker sudo solution 
newgrp docker
# newgrp also clears atuin history!
# atuin for CLI command fzf 
# GDAL original version was 2021 - what features are lacking?

### Docker 

#Docker Flags 
-it  #Interactive + TTY (keep it alive)
-d   #detached mode 

docker run -d \                                                                                                         02:00:00 PM
--name postgres \
-p 15432:5432 \
-e POSTGRES_USER=postgres \
-e POSTGRES_PASSWORD=postgres \
-e POSTGRES_DB=postgres \
postgis/postgis:17-3.5

### QGIS Keybinds 
<CTRL>-<SHIFT>-I      # Identify  
<CTRL>-<SHIFT>-<TAB>  # Map Only View 
<CTRL>-D              # Remove layer from project 

### psql 
sudo apt install postgresql-client # install psql 
# psql -h localhost -U admin -d mydb # open db mydb with psql
psql -h localhost -p 15432 -U postgres

\dt              -- list tables
\dn              -- list schemas
SELECT * FROM spatial_ref_sys LIMIT 5;  -- check PostGIS is working

### pgcli 
pgcli -h localhost -U admin -d mydb 

### ogr2ogr
sudo apt update && sudo apt install gdal-bin
# GDAL version 3.4.1 - outdated version 
# Now GDAL version 3.8.4! 
# ogr2ogr
ogrinfo # get file info!  
ogrinfo boundaries_coding_interview_data.gpkg # list layer 
ogrinfo boundaries.gpkg -so postcodes # layer summary 
# ogrinfo boundaries.gpkg postcodes -limit 5 # actual data 
ogrinfo boundaries.gpkg -al -so #spatial extent and CRS
-so # summary only 
-al # all layers
-q # quiet

# this works wirth sudo 
sudo ogrinfo boundaries_coding_interview_data.gpkg -q -sql "SELECT count(*) FROM postcodes"
ogr2ogr -f "PostgreSQL" PG:"dbname=postgres user=postgres host=localhost port=15432 password=postgres" boundaries_coding_interview_data.gpkg postcodes -nln public.boundaries -lco GEOMETRY_NAME=geom

# loading into postgres 

# one liner works better  
ogr2ogr -f "PostgreSQL" PG:"dbname=mydb user=admin host=localhost port=5432 password=password" boundaries_coding_interview_data.gpkg postcodes -nln public.boundaries -lco GEOMETRY_NAME=geom

-lco # layer creation option

###  POSTGIS 
SELECT COUNT(*) AS total_features FROM public.boundaries;
#total_features=25508

# column info 
SELECT column_name, data_type, is_nullable FROM information_schema.columns WHERE table_name = 'boundaries';
# get geom for all features 
SELECT geometrytype(geom) FROM public.boundaries;
# get count of geometry types 
SELECT geometrytype(geom), COUNT(*) FROM public.boundaries GROUP BY geometrytype(geom) 

SELECT DISTINCT postcode, COUNT(*) from public.boundaries GROUP BY postcode;

# -- Check if geom is valid
SELECT 
    COUNT(*) AS total_features,
    SUM(CASE WHEN ST_IsValid(geom) THEN 1 ELSE 0 END) AS valid_count,
    SUM(CASE WHEN NOT ST_IsValid(geom) THEN 1 ELSE 0 END) AS invalid_count
FROM your_table_name;
```

### QUESTIONS
1. Strange coords conversion in QGIS for bringing in layers
==Yes, transformations have their own EPSG codes — they're called coordinate operation codes in the EPSG database.== 

- Schema = directory/folder
- Table = a file inside that directory

ogr2ogr                                    ← "I want to convert data"
  -f "PostgreSQL"                           ← "Output format = Postgres"
  PG:"dbname=mydb user=admin ..."           ← "Destination = my PostGIS db" 
  boundaries_coding_interview_data.gpkg     ← "Source file"
  -nln public.aoi                           ← "Call the new table 'aoi'"

The pattern is always: tool → format → where to put it → what file → what to call it

---

```bash
sudo add-apt-repository ppa:ubuntugis/ppa
sudo apt-get update
sudo apt-get install gdal-bin 
# reinstall GDAL - seg fault 
sudo apt update
sudo apt purge gdal-bin libgdal-dev libgdal* --autoremove
sudo apt install gdal-bin libgdal-dev
# yet one more try 
sudo apt purge gdal-bin libgdal* libproj* libgeos* --autoremove
sudo apt autoremove
sudo apt install gdal-bin libgdal-dev
sudo ldconfig

# AND MORE forgot proj
sudo apt-get remove --purge gdal-bin libgdal-dev python3-gdal
sudo apt-get remove --purge libproj-dev proj
sudo apt-get autoremove
# install 
sudo add-apt-repository ppa:ubuntugis/ubuntugis-unstable
sudo apt-get update
sudo apt-get install gdal-bin libgdal-dev python3-gdal
```
