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
  public.boundaries;
