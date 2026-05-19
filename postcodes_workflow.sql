-- Load data into postgres 
--
-- clear all old tables 
DROP TABLE IF EXISTS proj_boundaries,
cleaned_boundaries,
simplified,
simplified_clean,
transform,
your_table,
british_boundaries;
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
-- Fix Geom ST_MakeValid() 
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
  ST_SimplifyPreserveTopology(
    geom,
    0.00001
  ) AS geom
FROM
  proj_boundaries;
--
-- Topology ST_CoverageClean 
DROP TABLE IF EXISTS cleaned_boundaries;
CREATE TABLE cleaned_boundaries AS SELECT
  fid,
  postcode,
  structure,
  postal1_id,
  ST_CoverageClean(geom) AS geom
FROM
  simp_boundaries;
-- Remove Slivers 
-- Final Validation & Index 
-- pg_tileserv - generate MVTs 
-- open tiles in Mapbox App 
