
// set frend
resistance setFriend [east, 0];
resistance setFriend [west, 0];
east setFriend [resistance, 0];
west setFriend [resistance, 0];


// init param

[] execVM "Param_mision\Param_mision.sqf";


//add class names 
[] execVM "class_names.sqf";

sleep 5;

// init MHQ

[
	mhq_class_name,	//- класс нейм КШМ
	getMarkerPos "Pos_base"		//- кординаты где он будет появлятся в начале и после смерти, можно использовать поизцию предмета getPos player или позицию маркера getMarkerPos "Marker_1"
] execVM "MHQ\MHQ_script.sqf";

// add vehicle in fire
[
	true, // будут ли возгоратся машины (true - да false - нет)
    true,   // будут ли возгоратся Танки/БПМ (true - да false - нет)
    false,   // будут ли возгоратся воздушная техника (true - да false - нет) работает не всегда коректно 
    true, // наносить ли урон экипажу в горящей машине
    true,   // убитьвать ли экипаж машины если она сгорает (true - да false - нет)
    [60,90,120] // время за которое машина сгорит минимальное/среднее/максимальное (в сек) 
] execVM "Script\Vehicle_in_fire.sqf";

teleport1 = false;
publicVariable "teleport1";



pos_base = getMarkerPos "Pos_base";



//				find pos from mission			//

axis_map = worldSize / 2;
center_map = [axis_map, axis_map , 0];
radius_map = sqrt 2 * axis_map;


// all_roads 

list_roads_all_map = center_map nearRoads radius_map;

waitUntil{
	!isNil {enemy_fraction}
};

	// Add class names to arry form mission

	//inf 

	_inf_missions_arry_not_redy = "(getText (_x >> 'faction') == enemy_fraction select 0) and (configName _x isKindOf ""Man"")" configClasses (configFile >> "CfgVehicles"); 

	inf_missions_arry = [];
	{
		inf_missions_arry pushBack (configName _x)
	} forEach _inf_missions_arry_not_redy;
	// is visible
	{
		if(getNumber (configFile >> "CfgVehicles" >> _x >> "scope") < 1)then{inf_missions_arry = inf_missions_arry - [_x]};
	} forEach inf_missions_arry;
	// is have weapon
	{
		if((getUnitLoadout _x select 0) isEqualTo [])then{inf_missions_arry = inf_missions_arry - [_x]};
	} forEach inf_missions_arry; 
	

	//car

	_car_mission_arry_not_redy = "(getText (_x >> 'faction') == enemy_fraction select 0) and (configName _x isKindOf ""Car"")" configClasses (configFile >> "CfgVehicles"); 

	car_mission_arry = [];
	{
		car_mission_arry pushBack (configName _x)
	} forEach _car_mission_arry_not_redy;

	// visible car
	{ 
		if(getNumber (configFile >> "CfgVehicles" >> _x >> "scope") < 1)then{car_mission_arry = car_mission_arry - [_x]}; 
	} forEach car_mission_arry;

	// have Turrets

	{ 
		if((_x call BIS_fnc_allTurrets) isEqualTo [] )then{car_mission_arry = car_mission_arry - [_x]}; 
	} forEach car_mission_arry;


	//tank 

	_hevy_vehicle_arry_not_redy = "(getText (_x >> 'faction') == enemy_fraction select 0) and (configName _x isKindOf ""Tank"")" configClasses (configFile >> "CfgVehicles");

	hevy_vehicle_arry = [];
	{
		hevy_vehicle_arry pushBack (configName _x)
	} forEach _hevy_vehicle_arry_not_redy;

	{ 
		if(getNumber (configFile >> "CfgVehicles" >> _x >> "scope") < 1)then{hevy_vehicle_arry = hevy_vehicle_arry - [_x]}; 
	} forEach hevy_vehicle_arry;

	//helicopter

	_heli_vehecle_arry_not_redy = "(getText (_x >> 'faction') == enemy_fraction select 0) and (configName _x isKindOf ""Helicopter"")" configClasses (configFile >> "CfgVehicles");

	heli_vehecle_arry = [];
	{
		heli_vehecle_arry pushBack (configName _x)
	} forEach _heli_vehecle_arry_not_redy;

	{ 
		if(getNumber (configFile >> "CfgVehicles" >> _x >> "scope") < 1)then{heli_vehecle_arry = heli_vehecle_arry - [_x]}; 
	} forEach heli_vehecle_arry;


	// heli_form_help



	_not_redy_help_heli = "(getText (_x >> 'faction') == faction(selectRandom allPlayers)) and (configName _x isKindOf ""Helicopter"" and getNumber (_x >> 'transportSoldier') >= 4)" configClasses (configFile >> "CfgVehicles");

	heli_help = [];

	{
		heli_help pushBack (configName _x)
	} forEach _not_redy_help_heli;

	{ 
		if(getNumber (configFile >> "CfgVehicles" >> _x >> "scope") < 1)then{heli_help = heli_help - [_x]}; 
	} forEach heli_help;


	// anti air

	anti_air_vehicle_arry = [];

	{ 
		private _subCategory = getText (configFile >> "CfgVehicles" >> _x >> "editorSubcategory");
		if(["EdSubcat_AAs", _subCategory] call BIS_fnc_inString)then{anti_air_vehicle_arry = anti_air_vehicle_arry + [_x]};
	} forEach car_mission_arry;

	{ 
		private _subCategory = getText (configFile >> "CfgVehicles" >> _x >> "editorSubcategory");
		if(["EdSubcat_AAs", _subCategory] call BIS_fnc_inString)then{anti_air_vehicle_arry = anti_air_vehicle_arry + [_x]};
	} forEach hevy_vehicle_arry;



	//StaticWeapon

	_static_weapon_arry_not_redy = "(getText (_x >> 'faction') == enemy_fraction select 0) and (configName _x isKindOf ""StaticWeapon"")" configClasses (configFile >> "CfgVehicles");

	static_weapon_arry = [];
	{
		static_weapon_arry pushBack (configName _x)
	} forEach _static_weapon_arry_not_redy;

	{ 
		if(getNumber (configFile >> "CfgVehicles" >> _x >> "scope") < 1)then{static_weapon_arry = static_weapon_arry - [_x]}; 
	} forEach static_weapon_arry;

	// static_mortar 

	_static_weapon_arry_not_redy_mortar = "(getText (_x >> 'faction') == enemy_fraction select 0) and (configName _x isKindOf ""StaticMortar"")" configClasses (configFile >> "CfgVehicles");

	static_weapon_arry_mortar = [];
	{
		static_weapon_arry_mortar pushBack (configName _x)
	} forEach _static_weapon_arry_not_redy_mortar;

	{
		if(getNumber (configFile >> "CfgVehicles" >> _x >> "scope") < 1)then{static_weapon_arry_mortar = static_weapon_arry_mortar - [_x]}; 
	} forEach static_weapon_arry_mortar;

	// static form bloc bost

	static_weapon_bloc_post = static_weapon_arry;
	{
		if((static_weapon_arry_mortar select _forEachIndex) in static_weapon_bloc_post)then{static_weapon_bloc_post = static_weapon_bloc_post - [_x]};
	} forEach static_weapon_arry_mortar;

	// if no car_vehilce

	if(car_mission_arry isEqualTo [])then{
		car_mission_arry append [str objNull];
	};

	// if no hevy_vehilce

	if(hevy_vehicle_arry isEqualTo [])then{
		if(isNil (car_mission_arry select 0))then{hevy_vehicle_arry append [str objNull];}else{car_mission_arry append car_mission_arry};
	};
	

	// if no heli_vehilce

	if(heli_vehecle_arry isEqualTo [])then{
		heli_vehecle_arry append [str objNull];
	};

	// if no Static_weapon

	if(static_weapon_arry isEqualTo [])then{
		static_weapon_arry append [str objNull];
	};

	// if no anti air
	if(anti_air_vehicle_arry isEqualTo [])then{
		anti_air_vehicle_arry append hevy_vehicle_arry;
		anti_air_vehicle_arry append car_mission_arry;
	};


	if((car_mission_arry select 0) isEqualTo str objNull)then{
	["ВНИМАНИЕ В ВЫБРАНОЙ ФАРКЦИИ ОТСУЦТВУЮТ КЛЮЧЕНЫЕ ЮНИТЫ ДЛЯ ЗАДАНИЙ! Некоторые задания НЕ БУДУТ РАБОТАТЬ КОРРЕКТНО! Выберете другую фракцию!!"] remoteExec ["hint"];
	};

	Ready_enemy = true;
	publicVariable "Ready_enemy";
	publicVariable "heli_help";
	publicVariable "inf_missions_arry";
	publicVariable "car_mission_arry";
	publicVariable "hevy_vehicle_arry";
	publicVariable "heli_vehecle_arry";
	publicVariable "static_weapon_arry";
	publicVariable "anti_air_vehicle_arry";

!isNil {Ready_enemy};

sleep 5;

// script patrol

if!((car_mission_arry select 0) isEqualTo str objNull)then{
    [] execVM "Script\enemy_patrol.sqf";
};

sleep 5;
// init bloc post
if!((static_weapon_bloc_post select 0) isEqualTo str objNull)then{
    [] execVM "Script\bloc_post.sqf";
};

// IED
sleep 5;
if!(trash_from_ied isEqualTo [])then{
    [] execVM "Script\IED.sqf";
};

// civilian script
sleep 5;
if!(vehicle_vivilian_arry isEqualTo [])then{
    [] execVM "Script\civilian_ambient.sqf";
};

sleep 5;
// init setConvoy
if!((car_mission_arry select 0) isEqualTo str objNull)then{
    [] execVM "Script\Convoy\ConvoyInit.sqf";
};



//choise_mission = false;
//publicVariable "choise_mission";

//[] execVM "Script\ambush.sqf";



