CREATE PROCEDURE placesOfInterestPairs()
BEGIN
    SET @row_number = 0;
    SELECT 
        dataResult.place1,
        dataResult.place2
    FROM (
        SELECT 
            MIN((@row_number:=@row_number + 1)) AS num,
            dataPlaces.place1,
            dataPlaces.place2,
            dataPlaces.comb, dataPlaces.distance
        FROM (
            SELECT 
                p1.id as place1id,
                p2.id as place2id,
                p1.name as place1, 
                p2.name as place2,
                (p1.id + p2.id) as comb,
                ST_Length(ST_GeomFromText(CONCAT('LineString(',p1.x, ' ', p1.y,', ', p2.x, ' ', p2.y, ')'))) as distance
            FROM 
                sights p1 INNER JOIN 
                sights p2 ON p2.id != p1.id
            WHERE 
                ST_Length(ST_GeomFromText(CONCAT('LineString(',p1.x, ' ', p1.y,', ', p2.x, ' ', p2.y, ')'))) < 5
            ORDER BY 
                place1, place2, distance
        ) dataPlaces
        GROUP BY dataPlaces.comb, dataPlaces.distance
        ORDER BY place1, place2, num
    ) dataResult;
END