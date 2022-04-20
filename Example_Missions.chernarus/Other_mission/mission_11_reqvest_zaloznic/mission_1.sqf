//exeple
// [pos_mission,class_name_artilery,vehocle_classname_arry,_arry_class_name_terorist] execVM "${somepath\file.sqf}";

	// 	pos_mission - aryy ccordinate
	//	class_name_zaloznik - arry class name zaloznika
	// 	arry_class_name_terorist - arry class name terrorists
	// 	radius_find_bild - radius find bilding from pos mission
	//  arry_pos_coordinate_delivery_officer - vere need delivery zsloznic
// done example
/*

[
[1850.51,360.064,0.00161743],
["SpecLib_c_tk_civ_black_brown_jacket",
"SpecLib_c_tk_civ_blue_grey_waistcoat",
"SpecLib_c_tk_civ_grey_brown_waistcoat",
"SpecLib_c_tk_civ_tan_desert_waistcoat",
"SpecLib_c_tk_civ_olive_woodland_waistcoat",
"SpecLib_c_tk_civ_cream_tricolor_waistcoat",
"SpecLib_c_tk_civ_brown_brown_jacket",
"SpecLib_c_tk_civ_white_grey_waistcoat"],
["CPC_ME_O_KAM_soldier_l1a1",
"CPC_ME_O_KAM_soldier",
"CPC_ME_O_KAM_soldier_AR",
"CPC_ME_O_KAM_soldier_MG"],
200,
[1000,1000,0]
] execVM "modules\spec_other_missions\mission_11\mission_1.sqf";

*/

//param
params ["_pos_mission", "_class_name_zaloznik", "_arry_class_name_terorist","_radius_find_bild", "_arry_pos_coordinate_delivery_officer"];


// find building
private _arry_bilding = nearestObjects [_pos_mission, ["house"], _radius_find_bild];

private _bilding_from_mission_general = [];

	for "_i" from 0 to 100 do 
{
	_select_bilding = selectRandom _arry_bilding;
	_bilding_from_mission = [_select_bilding, -1] call BIS_fnc_buildingPositions;
	_count_bolding_pos = count _bilding_from_mission;
	if(_count_bolding_pos >= 4)exitWith{
		_bilding_from_mission_general = _bilding_from_mission;
		};
};


if (_bilding_from_mission_general isEqualTo [])exitWith{hint"Не найдено подходящих зданий"};




// create bot terrorist
private _group_terrorist = createGroup [enemy_side, true];

private _unit_1 = _group_terrorist createUnit [selectRandom _arry_class_name_terorist, _bilding_from_mission_general select 0, [], 0, "FORM"];

_unit_1 disableAI "Path";

_unit_1 setSkill 1;


private _group_zaloznic = createGroup [west, true];
private _unit_1_zaloznic = _group_zaloznic createUnit [selectRandom _class_name_zaloznik, _bilding_from_mission_general select 1, [], 0, "FORM"];
[_unit_1_zaloznic, true] call ACE_captives_fnc_setHandcuffed;

["Task_11", true, ["Нужно найти заложника и эвакуировать его на базу","Освободить заложнка","respawn_west"], getPos _unit_1_zaloznic, "CREATED", 5, true, true, "meet", true] call BIS_fnc_setTask;

_nearestRoad = [getPos _unit_1_zaloznic, 300] call BIS_fnc_nearestRoad;
_pos_bot = getPos _nearestRoad;
[
	_pos_bot,	// массив координатов где будет центр здания

	enemy_side,	// сторона ботов можнт быть: EAST, WEST, independent
	0.8, // уровень скила ботов (значение от 0.1 до 1)
	inf_missions_arry,
	car_mission_arry,
	hevy_vehicle_arry,
	anti_air_vehicle_arry,
	heli_vehecle_arry,
	static_weapon_arry,
	300, // радиус (от центра) размещения статичных орудий(м)
	3 * count allPlayers, // количество статичных орудий
	2 * count allPlayers,	// количество легких машин которые будут патрулировать зону
	1 * count allPlayers,	// количество тяжолой техники которая будует патрулировать зону
	1 * count allPlayers,	// количество самоходных зенитныйх установок которые будут патрулировать зону
	random 4,	//	количество вертолетов которые будут патрулировать зону
	4 * count allPlayers,	// количество групп ботов которые будет охранять зону
	3,	//	количество ботов в группах которые будут охранять зону
	true,	// спаунить ли ботов на крышах домов
	100, // радиус поиска домов внутри которых будут боты(на крышах и внутри)
	30,	// шанс появления бота в здании(на крыше) в % от 0 до 100
	true, // создавать ли ботов внутри зданий
	30, // шанс появления бота в каждой позиции в здании в % от 0 до 100
	3000, // радиус активации игроком
	200,	// радиус патрулирования ботов
	500,	// радиус размещения легких машин которые будут патрулировать зону(чем больше машин тем больше зону лучше сделать)
	600,	// радиус патрулирования всех машин и легких танков
	1000,	// радиус патрулирования вертолетов
	true, // включать ли ботам динамическую симуляцию?
	false	// условик при котром боты будут удалены(УСЛОВИК ДОЛЖНО БЫТЬ ГЛОБАЛЬНО!!!)
] execVM "Other_mission\Shared\fn_other_missions_spawnEnemyBot.sqf";



waitUntil{
	sleep 5;
	(((getPos _unit_1_zaloznic) inArea [_arry_pos_coordinate_delivery_officer, 100, 100, 0, false]) or !alive _unit_1_zaloznic)
};

if(!alive _unit_1_zaloznic)exitWith{
	["Task_11","FAILED"] call BIS_fnc_taskSetState;
	sleep 10;
	["Task_11"] call BIS_fnc_deleteTask;
};

["Task_11","SUCCEEDED"] call BIS_fnc_taskSetState;

sleep 10;

["Task_11"] call BIS_fnc_deleteTask;


choise_mission = false;
publicVariable "choise_mission";