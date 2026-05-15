### Tricks and Tips 
```bash
# WSL2 docker sudo solution 
newgrp docker
# newgrp also clears atuin history!
# atuin for CLI command fzf 

#Docker Flags 
-it  #Interactive + TTY (keep it alive)
-d   #detached mode 

### QGIS Keybinds 
<CTRL>-<SHIFT>-I      # Identify  
<CTRL>-<SHIFT>-<TAB>  # Map Only View 
<CTRL>-D              # Remove layer from project 

### psql 
sudo apt install postgresql-client 
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
ogrinfo boundaries.gpkg postcodes -limit 5 # actual data 
ogrinfo boundaries.gpkg -al -so #spatial extent and CRS
-so # summary only 



```

### QUESTIONS
1. Strange coords conversion in QGIS for bringing in layers
==Yes, transformations have their own EPSG codes — they're called coordinate operation codes in the EPSG database.== 

- Schema = directory/folder
- Table = a file inside that directory

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

# AND MORE forot proj
sudo apt-get remove --purge gdal-bin libgdal-dev python3-gdal
sudo apt-get remove --purge libproj-dev proj
sudo apt-get autoremove
# install 
sudo add-apt-repository ppa:ubuntugis/ubuntugis-unstable
sudo apt-get update
sudo apt-get install gdal-bin libgdal-dev python3-gdal
```
