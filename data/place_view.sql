CREATE VIEW place_hierarchy AS
SELECT 
    dept.department_id AS place_id,
    dept.name AS department_name,
    NULL AS province_name,
    NULL AS district_name,
    'Department' AS place_level,
    dept.name AS full_location
FROM 
    departments dept
    
UNION ALL

SELECT 
    p.province_id AS place_id,
    dept.name AS department_name,
    p.name AS province_name,
    NULL AS district_name,
    'Province' AS place_level,
    CONCAT(dept.name, ',', p.name) AS full_location 
FROM 
    provinces p
JOIN 
    departments dept ON p.department_id = dept.department_id

UNION ALL

SELECT 
    d.district_id AS place_id,
    dept.name AS department_name,
    p.name AS province_name,
    d.name AS district_name,
    'District' AS place_level,
    CONCAT(dept.name, ',', p.name, ',', d.name) AS full_location
FROM 
    districts d
JOIN 
    provinces p ON d.province_id = p.province_id
JOIN 
    departments dept ON p.department_id = dept.department_id;

-- =================================================================================================

CREATE OR REPLACE FUNCTION search_places_and_shelters(search_term TEXT)
RETURNS TABLE (
    place_id TEXT,
    department_name TEXT,
    province_name TEXT,
    district_name TEXT,
    place_level TEXT,
    full_location TEXT,
    shelter_address TEXT
) AS $$
BEGIN
    RETURN QUERY
    WITH dynamic_matches AS (
        SELECT 
            s.shelter_id::TEXT AS place_id,
            NULL AS department_name,
            NULL AS province_name,
            NULL AS district_name,
            'Shelter' AS place_level,
            s.name AS full_location,
            s.address AS shelter_address
        FROM 
            shelters s
    )
    SELECT 
        ph.place_id::TEXT AS place_id, 
        ph.department_name,
        ph.province_name,
        ph.district_name,
        ph.place_level,
        ph.full_location,
        NULL AS shelter_address 
    FROM 
        place_hierarchy ph
    WHERE 
        ph.full_location ILIKE search_term 

    UNION ALL

    SELECT 
        dm.place_id,
        NULL AS department_name,
        NULL AS province_name,
        NULL AS district_name,
        dm.place_level,
        dm.full_location,
        dm.shelter_address 
    FROM 
        dynamic_matches dm
    WHERE 
        dm.full_location ILIKE search_term 
       OR dm.shelter_address ILIKE search_term
    ORDER BY 
        place_level, 
        full_location;
END;
$$ LANGUAGE plpgsql;


-- =====================================================================================

WITH dynamic_matches AS (
    SELECT 
        s.shelter_id::TEXT AS place_id, 
        NULL AS department_name,
        NULL AS province_name,
        NULL AS district_name,
        'Shelter' AS place_level,
        s.name AS full_location,
        s.address AS shelter_address
    FROM 
        shelters s
)
SELECT 
    ph.place_id::TEXT AS place_id,
    ph.department_name,
    ph.province_name,
    ph.district_name,
    ph.place_level,
    ph.full_location,
    NULL AS shelter_address -
FROM 
    place_hierarchy ph
WHERE 
    ph.full_location ILIKE '%Puno%' 

UNION ALL

SELECT 
    dm.place_id,
    NULL AS department_name,
    NULL AS province_name,
    NULL AS district_name,
    dm.place_level,
    dm.full_location,
    dm.shelter_address 
FROM 
    dynamic_matches dm
WHERE 
    dm.full_location ILIKE '%Puno%'
   OR dm.shelter_address ILIKE '%Puno%' 
ORDER BY 
    place_level, 
    full_location;


==

SELECT 
	COALESCE(FP.value, false) AS is_favorite,
	P.pet_id,
	P.category_id,
	P.name, 
	P.profile_picture, 
	P.gender, 
	P.breed_id, 
	P.birthdate, 
	EXTRACT(YEAR FROM AGE(P.birthdate)) * 12 + EXTRACT(MONTH FROM AGE(P.birthdate)) AS total_months,
	S.shelter_id,
	S.name, 
	S.address,
	S.district_id,
	D.province_id,
	D.department_id
FROM public.pets P
INNER JOIN public.shelters S ON S.shelter_id = P.shelter_id
INNER JOIN public.districts D ON D.district_id = S.district_id
LEFT JOIN public.favorite_pets FP ON FP.pet_id = P.pet_id  AND FP.user_id = '123e4567-e89b-12d3-a456-426614174000'
WHERE 
	P.category_id = 1 AND
	P.breed_id = 1 AND
	(EXTRACT(YEAR FROM AGE(P.birthdate)) * 12 + EXTRACT(MONTH FROM AGE(P.birthdate)) BETWEEN 10 AND 50) AND
	P.gender = 'Male'	
	
ORDER BY pet_id ASC 