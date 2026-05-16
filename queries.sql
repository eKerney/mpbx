-- Show all invalid geometries 
SELECT 
    COUNT(*) AS total_features,
    SUM(CASE WHEN ST_IsValid(geom) THEN 1 ELSE 0 END) AS valid_count,
    SUM(CASE WHEN NOT ST_IsValid(geom) THEN 1 ELSE 0 END) AS invalid_count
FROM public.boundaries;


SELECT 
    COUNT(*) AS total_features,
    SUM(CASE WHEN ST_IsValid(geom) THEN 1 END) AS valid_count,
    SUM(CASE WHEN NOT ST_IsValid(geom) THEN 1 END) AS invalid_count
FROM public.boundaries;
