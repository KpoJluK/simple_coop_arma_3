params [ 
	"_classnave_vehicle_bot_attack_btr",
	"_classnave_vehicle_bot_attack_heli", 
	"_side_bot_to_attack", 
	"_arry_bot_to_attac"
];

waitUntil{
	sleep 5;
	attack_bot_mission_4_true
};

private _group_bot_attac_dron = createGroup [_side_bot_to_attack, true];
//find pos
private _find_pos_from_bot = [getPos dron_down, 300, 500, 5, 0, 0.9, 0] call BIS_fnc_findSafePos;
//find pos enemy heli
private _find_pos_from_bot_air = [getPos dron_down, 1000, 1500, 20, 0, 0.7, 0] call BIS_fnc_findSafePos;
//btr
private _BTR_attac_drone = [_find_pos_from_bot, 180, _classnave_vehicle_bot_attack_btr, _side_bot_to_attack] call BIS_fnc_spawnVehicle;
//heli
private _heli_attac_drone = [_find_pos_from_bot_air, 180, _classnave_vehicle_bot_attack_heli, _side_bot_to_attack] call BIS_fnc_spawnVehicle;
//waipoint for btr
private _wp_for_bot_go_tu_drone_btr = _BTR_attac_drone select 2 addWaypoint [getPos dron_down, 0];
_wp_for_bot_go_tu_drone_btr setWaypointType "SAD";
_wp_for_bot_go_tu_drone_btr setWaypointSpeed "FULL";
//waipoint for heli
private _wp_for_bot_go_tu_drone_heli = _heli_attac_drone select 2 addWaypoint [getPos dron_down, 0];
_wp_for_bot_go_tu_drone_heli setWaypointType "GUARD";
_wp_for_bot_go_tu_drone_heli setWaypointSpeed "FULL";
//cyrcl from create bot
sleep 5;
for "_i" from 0 to 10 * count allPlayers do 
{
	sleep 0.5;
	_unit = _group_bot_attac_dron createUnit [selectRandom _arry_bot_to_attac, _find_pos_from_bot, [], 0, "FORM"];
};

//waipoint 
private _wp_for_bot_go_tu_drone = _group_bot_attac_dron addWaypoint [getPos dron_down, 0];
_wp_for_bot_go_tu_drone setWaypointType "SAD";
[_group_bot_attac_dron, 0] setWaypointSpeed "FULL";