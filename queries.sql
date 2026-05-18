-- -- Show all invalid geometries 
-- SELECT
--     COUNT(*) AS total_features,
--     SUM(CASE
--         WHEN ST_IsValid(geom) THEN 1
--         ELSE 0
--     END) AS valid_count,
--     SUM(CASE
--         WHEN NOT ST_IsValid(geom) THEN 1
--         ELSE 0
--     END) AS invalid_count
-- FROM
--     public.boundaries;
-- -- 
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
-- SELECT
--   column_name,
--   data_type,
--   is_nullable
-- FROM
--   information_schema.columns
-- WHERE
--   table_name = 'boundaries';
--GET geom FOR ALL features 
-- SELECT
--   geometrytype(geom)
-- FROM
--   public.boundaries;
-- GET COUNT OF geometry types 
-- SELECT
--   geometrytype(geom),
--   COUNT(*)
-- FROM
--   public.boundaries
-- GROUP BY
--   geometrytype(geom)
-- SELECT DISTINCT postcode,
--     COUNT(*)
--   FROM
--     public.boundaries
--   GROUP BY
--     postcode;
-- SELECT
--   *
-- FROM
--   public.boundaries
-- LIMIT 5;
-- Fix self intersections 
DROP TABLE IF EXISTS cleaned_boundaries;
CREATE TABLE cleaned_boundaries AS SELECT
  fid,
  postcode,
  structure,
  postal1_id,
  ST_MakeValid(geom) AS geom
FROM
  public.boundaries;
-- SELECT
--   *
-- FROM
--   public.boundaries.columns;
\dpublic.boundaries
