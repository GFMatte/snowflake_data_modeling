 SELECT 
ship.ship_id AS ship_id
, pc.name as captain
, c.value:name::STRING AS name
, c.value:nickname::STRING AS nickname
, c.value:had_bird::boolean AS had_bird
, p.__load_dts
FROM pirate_json p
INNER JOIN ship ON v:ship.name::STRING = ship.NAME
INNER JOIN pirate pc on pc.name = v:name::string
,LATERAL FLATTEN(v:crew) c
;


select * from pirate_weapons;