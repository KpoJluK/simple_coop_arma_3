/*

// done exemple

[
	[5972.95,10332.5,0], // pos mission
	[
		"UK3CB_CHC_I_BODYG", 
		"UK3CB_CHC_I_FUNC", 
		"UK3CB_CHC_I_POLITIC", 
		"UK3CB_CHC_I_CAN"
	],	// class name help man
	[
		"C_IDAP_Man_Paramedic_01_F",
		"C_Man_Paramedic_01_F"
	] // class name who help medic
] execVM "Other_mission\mission_15_help_man\mission_1.sqf";




*/


params ["_pos_mission", "_class_name_help_man","_class_name_who_help_medic"];


// find all bilding
private _arry_bilding = nearestObjects [_pos_mission, ["house"], 250];


{
	if(count ([_x] call BIS_fnc_buildingPositions) <= 0)then{ _arry_bilding = _arry_bilding - [_x] };
} forEach _arry_bilding;


if (_arry_bilding isEqualTo [])exitWith{hint"Не найдено подходящих зданий"};

// hind pos in bilding

_select_bilding = [];

waitUntil{
	_select_bilding = selectRandom _arry_bilding;
	count ([_select_bilding] call BIS_fnc_buildingPositions) >= 10	
};

private _select_pos = ([_select_bilding] call BIS_fnc_buildingPositions) select (random [6,7,8]);

// crate man who need help

_group_man_need_help = createGroup [side (selectRandom allPlayers), true];

_unit = _group_man_need_help createUnit [selectRandom _class_name_help_man, _select_pos, [], 0, "FORM"];

_unit disableAI "all";

// setAnimation 

_unit switchMove "Acts_CivilInjuredGeneral_1";

_unit addEventHandler ["AnimDone", {
	params ["_unit", "_anim"];
	_unit switchMove "Acts_CivilInjuredGeneral_1";
}];

_unit setCaptive true;

// crate medic

_group_man_medic = createGroup [side (selectRandom allPlayers), false];

unit_medic = _group_man_medic createUnit [selectRandom _class_name_who_help_medic, pos_base, [], 0, "FORM"];

[
	unit_medic,											// object the action is attached to
	"Давай за мной",										// Title of the action
	"\a3\ui_f\data\igui\cfg\actions\getincommander_ca.paa",	// Idle icon shown on screen
	"\a3\ui_f\data\igui\cfg\actions\getincommander_ca.paa",	// Progress icon shown on screen
	"_this distance _target < 3",						// Condition for the action to be shown
	"_caller distance _target < 3",						// Condition for the action to progress
	{},													// Code executed when action starts
	{},													// Code executed on every progress tick
	{ [unit_medic] join (group player); [[], {removeAllActions unit_medic}] remoteExec ["call"]; },				// Code executed on completion
	{},													// Code executed on interrupted
	[],													// Arguments passed to the scripts as _this select 3
	12,													// action duration in seconds
	0,													// priority
	true,												// Remove on completion
	false												// Show in unconscious state
] remoteExec ["BIS_fnc_holdActionAdd", 0, unit_medic];	// MP compatible implementation

// create mission

["Task_15", true, ["Вам нужно доставить медика к раненому","Доставить медика к важной особе","respawn_west"], getPos _unit, "CREATED", 5, true, true, "heal", true] call BIS_fnc_setTask;

waitUntil{
	sleep 5;
	!alive unit_medic or !alive _unit or getPos unit_medic inArea [getPos _unit, 20, 20, 45, false]
};

if(!alive unit_medic or !alive _unit)exitWith{
	["Task_15","FAILED"] call BIS_fnc_taskSetState;
	sleep 10; 
	["Task_15"] call BIS_fnc_deleteTask;
	deleteVehicle unit_medic;
	deleteVehicle _unit;
	deleteGroup _group_man_medic;
};

unit_medic disableAI "all";

unit_medic attachTo [_unit, [0, -1, 0]];

_vector = (getPos unit_medic) vectorFromTo (getPos _unit);  
unit_medic setVectorDir _vector;
 
unit_medic switchMove "AinvPknlMstpSnonWnonDnon_medic3";
unit_medic addEventHandler ["AnimDone", {
	params ["_unit", "_anim"];
	unit_medic switchMove "Acts_CivilInjuredGeneral_1";
}];

["Task_15","SUCCEEDED"] call BIS_fnc_taskSetState;

sleep 5;

[	
	getPos _unit,
	120, // 1 - время для подготовки
	8, // 2 - Количество волн
	3, // 3 - Количество ботов в группе
	40, // 4 - Шанс появления техники
	30, // 5 - Шанс появления средней техники
	20, // 6 - Шанс появления тяжолой техники
	10, // 7 - Шанс появления авиации
	60, // 8 - Время между волнами
	300, // 9 - Время для победы после последней волны
	0.8, // 10 = скилл ботов
	enemy_side // сторона ботов
] spawn {
	params[
	"_pos_defend",
	"_time_to_start",
	"_count_cicl_vawe",
	"_Count_enemy_unit_in_group",
	"_chanse_vehicle",
	"_chanse_vehicle_middle_armor",
	"_chanse_armor", 
	"_chanse_air",
	"_second_spawn_next_vawe",
	"_second_to_win_after_last_vawe",
	"_skill_bot",
	"_side_bot"
	];

	arry_bot_defend_mission = [];

	// create mission

	["Task_15_1", true, ["Удерживать позиции","Удерживать позиции","respawn_west"], _pos_defend, "CREATED", 5, true, true, "defend", true] call BIS_fnc_setTask;
	

	// find pos


	_pos_1 = [_pos_defend, 200, 500, 15, 0, 0.9, 0] call BIS_fnc_findSafePos;
	_pos_2 = [_pos_defend, 200, 500, 15, 0, 0.9, 0] call BIS_fnc_findSafePos;
	_pos_3 = [_pos_defend, 200, 500, 15, 0, 0.9, 0] call BIS_fnc_findSafePos;
	_pos_4 = [_pos_defend, 200, 500, 15, 0, 0.9, 0] call BIS_fnc_findSafePos;
	_pos_5 = [_pos_defend, 200, 500, 15, 0, 0.9, 0] call BIS_fnc_findSafePos;
	_pos_6 = [_pos_defend, 200, 500, 15, 0, 0.9, 0] call BIS_fnc_findSafePos;
	_pos_7 = [_pos_defend, 200, 500, 15, 0, 0.9, 0] call BIS_fnc_findSafePos;
	_pos_8 = [_pos_defend, 200, 500, 15, 0, 0.9, 0] call BIS_fnc_findSafePos;
	_pos_1_heli = [_pos_defend, 1500, 2000, 15, 0, 0.9, 0] call BIS_fnc_findSafePos;
	_pos_2_heli = [_pos_defend, 1500, 2000, 15, 0, 0.9, 0] call BIS_fnc_findSafePos;

	sleep _time_to_start;


	for "_i" from 0 to _count_cicl_vawe do 
	{
		// inf
		_grup_enemy = createGroup [_side_bot, true];
		_Pos_spawn = selectRandom [_pos_1,_pos_2,_pos_3,_pos_4,_pos_5,_pos_6,_pos_7,_pos_8];
		for "_i" from 0 to _Count_enemy_unit_in_group do 
		{
			_unit = _grup_enemy createUnit [selectRandom inf_missions_arry, _Pos_spawn, [], 0, "FORM"];
			sleep 0.5;
			_unit setSkill _skill_bot;
			arry_bot_defend_mission pushBack _unit;
		};

		_wp =_grup_enemy addWaypoint [_pos_defend, 0];
		[_grup_enemy, 0] setWaypointSpeed "FULL";
		_wp setWaypointType "SAD";
		_grup_enemy allowFleeing 0;

		_chanse = random 100;
		if(_chanse <= _chanse_vehicle)then{
			_Pos_spawn = selectRandom [_pos_1,_pos_2,_pos_3,_pos_4,_pos_5,_pos_6,_pos_7,_pos_8];
			_vehicle = [_Pos_spawn, 180, selectRandom car_mission_arry, _side_bot] call BIS_fnc_spawnVehicle;
			_wp_2 = _vehicle select 2 addWaypoint [_pos_defend, 0];
			[_vehicle select 2, 0] setWaypointSpeed "FULL";
			_wp_2 setWaypointType "SAD";
			{_x setSkill _skill_bot} forEach crew (_vehicle select 0);
			{arry_bot_defend_mission pushBack _x} forEach crew (_vehicle select 0);
			arry_bot_defend_mission pushBack (_vehicle select 0);

		};

		// vehicle middle armor
		_chanse = random 100;
		if(_chanse <= _chanse_vehicle_middle_armor)then{
			_Pos_spawn = selectRandom [_pos_1,_pos_2,_pos_3,_pos_4,_pos_5,_pos_6,_pos_7,_pos_8];
			_vehicle_middle = [_Pos_spawn, 180, selectRandom car_mission_arry, _side_bot] call BIS_fnc_spawnVehicle;
			_wp_2 = _vehicle_middle select 2 addWaypoint [_pos_defend, 0];
			[_vehicle_middle select 2, 0] setWaypointSpeed "FULL";
			_wp_2 setWaypointType "SAD";
			{_x setSkill _skill_bot} forEach crew (_vehicle_middle select 0);
			{arry_bot_defend_mission pushBack _x} forEach crew (_vehicle_middle select 0);
			arry_bot_defend_mission pushBack (_vehicle_middle select 0);

		};

		// armor


		_chanse = random 100;
		if(_chanse <= _chanse_armor)then{
			_Pos_spawn = selectRandom [_pos_1,_pos_2,_pos_3,_pos_4,_pos_5,_pos_6,_pos_7,_pos_8];
			_armor = [_Pos_spawn, 180, selectRandom hevy_vehicle_arry, _side_bot] call BIS_fnc_spawnVehicle;
			_wp_3 = (_armor select 2) addWaypoint [_pos_defend, 0];
			[(_armor select 2), 0] setWaypointSpeed "FULL";
			_wp_3 setWaypointType "SAD";
			{_x setSkill _skill_bot} forEach crew (_armor select 0);
			{arry_bot_defend_mission pushBack _x} forEach crew (_armor select 0);
			arry_bot_defend_mission pushBack (_armor select 0);

		};

		// air

		_chanse = random 100;
		if(_chanse <= _chanse_air)then{
			_Pos_spawn = selectRandom [_pos_1_heli, _pos_2_heli];
			_heli  = [_Pos_spawn, 180, selectRandom heli_vehecle_arry, _side_bot] call BIS_fnc_spawnVehicle;
			_wp_4 = (_heli select 2) addWaypoint [_pos_defend, 0];
			[(_heli select 2), 0] setWaypointSpeed "FULL";
			_wp_4 setWaypointType "SAD";
			{_x setSkill _skill_bot} forEach crew (_heli select 0);
			{arry_bot_defend_mission pushBack _x} forEach crew (_heli select 0);
			arry_bot_defend_mission pushBack (_heli select 0);

		};
		sleep _second_spawn_next_vawe;
	};
};

private _time = 0;

waitUntil{
	sleep 5;
	_time = _time + 5;
	!alive unit_medic or !alive _unit or  _time == 600
};

["Task_15_1","SUCCEEDED"] call BIS_fnc_taskSetState;

sleep 5;

["Task_15_2", true, ["Доставить важнуо особь на базу","Доставить важнуо особь на базу","respawn_west"], getPos _unit, "CREATED", 5, true, true, "meet", true] call BIS_fnc_setTask;


waitUntil{
	sleep 5;
	getPos _unit inArea [pos_base, 100, 100, 45, false] or !alive _unit
};

if( !alive _unit)exitWith{
	["Task_15_2","FAILED"] call BIS_fnc_taskSetState;
	sleep 10; 
	["Task_15"] call BIS_fnc_deleteTask;
	["Task_15_1"] call BIS_fnc_deleteTask;
	["Task_15_2"] call BIS_fnc_deleteTask;
	deleteVehicle _unit;
	deleteVehicle unit_medic;
	deleteGroup _group_man_medic;
	sleep 300;
	{
		deleteVehicle _x
	} forEach arry_bot_defend_mission;
	
};


["Task_15_2","SUCCEEDED"] call BIS_fnc_taskSetState;
sleep 10; 
["Task_15"] call BIS_fnc_deleteTask;
["Task_15_1"] call BIS_fnc_deleteTask;
["Task_15_2"] call BIS_fnc_deleteTask;
deleteVehicle _unit;
deleteVehicle unit_medic;
deleteGroup _group_man_medic;
sleep 300;
{
	deleteVehicle _x
} forEach arry_bot_defend_mission;