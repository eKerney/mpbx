-- Load data into postgres 
--
-- clear all old tables 
-- Check Geom ST_IsValid() 
SELECT
  COUNT(*) AS total_features,
  SUM(CASE
    WHEN ST_IsValid(geom) THEN 1
  END) AS valid_count,
  SUM(CASE
    WHEN NOT ST_IsValid(geom) THEN 1
  END) AS invalid_count
FROM
  public.boundaries;
--
-- NEW FIX GEOM SECTION 
DROP TABLE IF EXISTS cleaned_boundaries;
CREATE TABLE cleaned_boundaries AS SELECT
  fid,
  postcode,
  structure,
  postal1_id,
  ST_Multi(ST_CollectionExtract(
    ST_MakeValid(geom),
    3
  )-- 3 = Polygon/MultiPolygon
) AS geom
FROM
  public.boundaries;
-- register key for QGIS
ALTER TABLE cleaned_boundaries ADD PRIMARY KEY(fid);
SELECT
  Populate_Geometry_Columns(
    'public.cleaned_boundaries'::REGCLASS,
    TRUE
  );
CREATE INDEX idx_cleaned_boundaries_geom
ON cleaned_boundaries USING GIST(geom);
--
--
-- ReCheck Geom ST_IsValid() 
SELECT
  COUNT(*) AS total_features,
  SUM(CASE
    WHEN ST_IsValid(geom) THEN 1
  END) AS valid_count,
  SUM(CASE
    WHEN NOT ST_IsValid(geom) THEN 1
  END) AS invalid_count
FROM
  cleaned_boundaries;
--
-- ReProject to 27700 ST_Transform() 
DROP TABLE IF EXISTS proj_boundaries;
CREATE TABLE proj_boundaries AS SELECT
  fid,
  postcode,
  structure,
  postal1_id,
  ST_Transform(
    geom,
    27700
  ) AS geom
FROM
  cleaned_boundaries;
-- Setup table for QGIS
ALTER TABLE proj_boundaries ADD PRIMARY KEY(fid);
SELECT
  Populate_Geometry_Columns(
    'public.proj_boundaries'::REGCLASS,
    TRUE
  );
CREATE INDEX idx_proj_boundaries_geom
ON proj_boundaries USING GIST(geom);
--
-- SELECT ST_SRID() to find CRS 
SELECT
  ST_SRID(geom) AS srid
FROM
  proj_boundaries
LIMIT 1;
--
-- Simplify  ST_SimplifyPreserveTopology() 
DROP TABLE IF EXISTS simp_boundaries;
CREATE TABLE simp_boundaries AS SELECT
  fid,
  postcode,
  structure,
  postal1_id,
  ST_Multi(ST_CollectionExtract(
    ST_SimplifyPreserveTopology(
      geom,
      0.001
    ),
    3
  )) AS geom
FROM
  proj_boundaries;
ALTER TABLE simp_boundaries ADD PRIMARY KEY(fid);
SELECT
  Populate_Geometry_Columns(
    'public.simp_boundaries'::REGCLASS,
    TRUE
  );
CREATE INDEX idx_simp_boundaries_geom
ON simp_boundaries USING GIST(geom);
--
-- Topology 
DROP TABLE IF EXISTS cleaned_boundaries;
CREATE TABLE cleaned_boundaries AS SELECT
  fid,
  postcode,
  structure,
  postal1_id,
  ST_Multi(ST_CollectionExtract(
    ST_SnapToGrid(
      geom,
      0.005
    ),
    -- 5mm 
3
  )) AS geom
FROM
  simp_boundaries;
ALTER TABLE cleaned_boundaries ADD PRIMARY KEY(fid);
SELECT
  Populate_Geometry_Columns(
    'public.cleaned_boundaries'::REGCLASS,
    TRUE
  );
CREATE INDEX idx_cleaned_boundaries_geom
ON cleaned_boundaries USING GIST(geom);
-- Remove Slivers 
-- Final Validation & Index 
-- pg_tileserv - generate MVTs 
-- open tiles in Mapbox App 
