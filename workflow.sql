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
-- reproject to 27700 British National Grid 
SELECT
  fid,
  postcode,
  structure,
  postal1_id,
  ST_SimplifyPreserveTopology(
    ST_Transform(
      geom,
      27700
    ),
    -- British National Grid
20-- tolerance in METERS (e.g. 20m)

  ) AS geom
FROM
  cleaned_boundaries;
-- your fixed table 
DROP TABLE IF EXISTS simplified;
CREATE TABLE simplified AS SELECT
  fid,
  postcode,
  structure,
  postal1_id,
  ST_SimplifyPreserveTopology(
    ST_Transform(
      geom,
      27700
    ),
    -- British National Grid
20-- tolerance in METERS (e.g. 20m)

  ) AS geom
FROM
  cleaned_boundaries;
-- your fixed table 
CREATE TABLE transform AS SELECT
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
SELECT
  ST_SRID(geom)
FROM
  transform
LIMIT 1;
