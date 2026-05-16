> INSTALLS
- [x] psql install and test 
- [x] Docker - start from CLI 
- [x] Docker - run dockerfile 
- [x] ogr2ogr - install and test with boundaries 
- [x] Docker CLI explore

> SETUP 
- [x] Start instance 
- [x] Load boundaries data via psql 
- [x] Connect DB to QGIS - load data and inspect 
- [ ] Look for issues with the data 
- [ ] Bonus: connect to DB in notebook, load query as GDB, explore live 
- [ ] Bonus: lonboard - much faster visualization - try to load as parquet 
- [ ] Bonus: Load additional Michigan data into PostGIS - Capitals? 

> PSQL Section: 
- [ ] Determine what cleaning should be performed 
- [ ] Fix geometries 
- [ ] ReProjection 
- [ ] Simplify geometries 
- [ ] Topology/edge matching (snap, coverage)
- [ ] Dissolve if needed 
- [ ] Validation & Reporting 
- [ ] Area Calcs, duplicates, hierarchy checks(?)
- [ ] Spatial Indexes 
- [ ] Testing and reviewing results in QGIS & VSCode
- [ ] Running over these operations many times 


- [ ] Generate MVT with python 
- [ ] Python scripted pipeline to run multiple operations 


---
### NOTES

```bash
docker info
docker ps # list running containers and basic details 
docker ps -a #list all available containers 
docker desktop start # start docker docker daemon
docker start aacb8922f8f9 # start docker container 
 ```

1. Create a Dockerfile in your project root (example):

```Dockerfile 
FROM ubuntu:22.04
RUN apt-get update && apt-get install -y curl
COPY . /app
WORKDIR /app
CMD ["bash"]
```

2. Build the image:
`sudo docker build -t my-image-name .`

3. Run a container from the image:
```bash
sudo docker run -it my-image-name
```

**Flag	Purpose**
it	            Interactive + TTY (keep it alive)
-d	            Detached (background)
--name my-cont	Assign a name
-p 8080:80	    Port mapping (host:container)
-v $(pwd):/app	Mount current directory
--rm	        Auto-remove container on exit

>Quick one-liner (build + run):
`sudo docker build -t my-image . && sudo docker run -it --rm my-image`

4. Full Postgres container command
```bash
docker run -d \
  --name pg-container \
  -p 5432:5432 \
  -e POSTGRES_USER=admin \
  -e POSTGRES_PASSWORD=password \
  -e POSTGRES_DB=mydb \
  postgis/postgis:17-3.5
# had some trouble with this at first
```
