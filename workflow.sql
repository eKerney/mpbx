-- Find self intersections/invalid geometries 
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
-- Fix geoemetries for self intersections
DROP TABLE IF EXISTS cleaned_boundaries;
CREATE TABLE cleaned_boundaries AS SELECT
  fid,
  postcode,
  structure,
  postal1_id,
  ST_MakeValid(geom) AS geom
FROM
  public.boundaries;
--
-- recheck with new table 
SELECT
  COUNT(*) AS total_features,
  SUM(CASE
    WHEN ST_IsValid(geom) THEN 1
  END) AS valid_count,
  SUM(CASE
    WHEN NOT ST_IsValid(geom) THEN 1
  END) AS invalid_count
FROM
  public.cleaned_boundaries;
--
-- list tables
\d--
-- reproject to 27700 British National Grid and create table
DROP TABLE IF EXISTS british_boundaries;
CREATE TABLE british_boundaries AS SELECT
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
--
-- your fixed table 
--
DROP TABLE IF EXISTS simplified;
CREATE TABLE simplified AS SELECT
  fid,
  postcode,
  structure,
  postal1_id,
  ST_SimplifyPreserveTopology(
    geom,
    0.0001
  ) AS geom
FROM
  british_boundaries;
-- 
\d-- 
-- get CRS only from one feautre
SELECT
  ST_SRID(geom) AS srid
FROM
  simplified-- british_boundaries
-- cleaned_boundaries

LIMIT 1;
-- 
-- get additional info from SRID
WITH table_srid AS (
  SELECT
    ST_SRID(geom) AS my_srid
  FROM
    -- cleaned_boundaries
simplified
LIMIT 1
) SELECT
  s.srid,
  s.auth_name,
  s.proj4text
FROM
  spatial_ref_sys s,
  table_srid t
WHERE
  s.srid = t.my_srid--
-- Reproject bristol_museums
DROP TABLE IF EXISTS bristol_proj;
CREATE TABLE bristol_proj AS SELECT
  name,
  ST_Transform(
    geom,
    27700
  ) AS geom
FROM
  bristol_museums;
--
--
SELECT
  ST_SRID(geom) AS my_srid
FROM
  bristol_proj
LIMIT 1;
-- 
-- topology 
DROP TABLE IF EXISTS cleaned_topology;
CREATE TABLE cleaned_topology AS SELECT
  fid,
  postcode,
  structure,
  postal1_id,
  ST_CoverageClean(geom) AS geom-- Best modern function

FROM
  simplified;
-- 
-- 
DROP TABLE IF EXISTS simplified_clean;
CREATE TABLE simplified_clean AS SELECT
  fid,
  postcode,
  structure,
  postal1_id,
  ST_MakeValid(ST_SimplifyPreserveTopology(
    ST_Transform(
      geom,
      27700
    ),
    20
  )) AS geom
FROM
  simplified;
-- your previous table
SELECT
  pg_terminate_backend(pid)
FROM
  pg_stat_activity
WHERE
  pid IN(
    SELECT
      activity.pid
    FROM
      pg_stat_activity activity
    JOIN pg_locks lock
      ON activity.pid = lock.pid
    WHERE
      lock.relation = 'public.british_boundaries' ::REGCLASS
  );
DROP TABLE IF EXISTS public.british_boundaries CASCADE;
\dt
