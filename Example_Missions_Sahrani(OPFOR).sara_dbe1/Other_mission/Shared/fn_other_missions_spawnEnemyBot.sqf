///////////////// created by KpoJLuK ////////////////////
///////////////// https://github.com/KpoJluK/deffend_City /////////////////////////////




/*
/////////// Пример вызова скрипта//////////////////////
[
	[1943.007,2312.045,0],	// массив координатов где будет центр здания
	WEST,	// сторона ботов можнт быть: EAST, WEST, independent
	0.8, // уровень скила ботов (значение от 0.1 до 1)
	[
		// массив класс наймов ботов которые будут патрулировать зону(обатить внимание в последней строке НЕ ДОЛЖНО БЫТЬ запятой!)
		"B_medic_F", 
		"B_Soldier_SL_F",
		"B_soldier_AT_F",
		"B_soldier_AA_F",
		"B_soldier_M_F"
	],
	[
		// массив класс неймов легких машин которые будут патрулировать зону(обатить внимание в последней строке НЕ ДОЛЖНО БЫТЬ запятой!)
		"B_MRAP_01_hmg_F",	
		"B_MRAP_01_gmg_F"
	],
	[
		// массив тяжолой техники кторая будет патрулировать зону(обатить внимание в последней строке НЕ ДОЛЖНО БЫТЬ запятой!)
		"B_MBT_01_cannon_F", 
		"B_MBT_01_TUSK_F",
		"B_APC_Wheeled_01_cannon_F",
		"B_APC_Tracked_01_CRV_F"
	],
	[
		// массив самоходных зенитныйх установок кторая будет патрулировать зону(обатить внимание в последней строке НЕ ДОЛЖНО БЫТЬ запятой!)
		"B_APC_Tracked_01_AA_F"	
	],
	[
		// массив вертолетов кторая будет патрулировать зону(обатить внимание в последней строке НЕ ДОЛЖНО БЫТЬ запятой!)
		"B_Heli_Attack_01_dynamicLoadout_F", 
		"B_Heli_Transport_01_F"
	],
	[
		// массив статичного вооружения кторая будет размещена в зоне(обатить внимание в последней строке НЕ ДОЛЖНО БЫТЬ запятой!)
		"B_HMG_01_high_F",	
		"B_GMG_01_high_F",
		"B_Mortar_01_F"
	],
	300, // радиус (от центра) размещения статичных орудий(в метраъ)
	3, // количество статичных орудий
	2,	// количество легких машин которые будут патрулировать зону
	2,	// количество тяжолой техники которая будует патрулировать зону
	2,	// количество самоходных зенитныйх установок которые будут патрулировать зону
	0,	//	количество вертолетов которые будут патрулировать зону
	4,	// количество групп ботов которые будет охранять зону
	4,	//	количество ботов в группах которые будут охранять зону
	true,	// спаунить ли ботов на крышах домов(true - спаунить / false - не спунить)
	100, // радиус поиска домов внутри которых будут боты(на крышах и внутри)
	30,	// шанс появления бота в здании(на крыше) в % от 0 до 100
	true, // создавать ли ботов внутри зданий(true - создавать / false - не создавать)
	30, // шанс появления бота в каждой позиции в здании в % от 0 до 100
	2000, // радиус активации игроком
	300,	// радиус патрулирования ботов
	500,	// радиус размещения легких машин которые будут патрулировать зону(чем больше машин тем больше зону лучше сделать)
	600,	// радиус патрулирования всех машин и легких танков
	1000,	// радиус патрулирования вертолетов
	true, // включать ли ботам динамическую симуляцию?
	false	// условик при котром боты будут удалены(УСЛОВИК ДОЛЖНО БЫТЬ ГЛОБАЛЬНО!!!)
] execVM "spawn_enemy_bot_area.sqf";
/////////////////// Конец примера вызоза скрипта!/////////////////////
*/



///////// ВСЕ ЧТО НИЖЕ НЕ ТРОГАТЬ ЭТО САМ СКРИПТ!! Не меняйте ничего ниже если вы не понимаете ничего в этом!////////////////////////

																		// принимаю парметры

params [
	["_pos_spawn", [1841.75,2224.26,0]],
	["_side_bot", WEST],
	["_bot_skill", 0.8],
	["_arry_class_name_bot",	
		[
			"B_medic_F",
			"B_Soldier_SL_F",
			"B_soldier_AT_F",
			"B_soldier_AA_F",
			"B_soldier_M_F"
		]
	],
	["_arry_class_name_vehicle_track",
		[
			"B_MRAP_01_hmg_F",
			"B_MRAP_01_gmg_F"
		]
	],
	["_arry_class_name_vehicle",
		[
			"B_MBT_01_cannon_F",
			"B_MBT_01_TUSK_F",
			"B_APC_Wheeled_01_cannon_F",
			"B_APC_Tracked_01_CRV_F"
		]
	],
	["_arry_class_name_PVO",
		[
			"B_APC_Tracked_01_AA_F"
		]
	],
	["_arry_class_name_heli",
		[
			"B_Heli_Attack_01_dynamicLoadout_F",
			"B_Heli_Transport_01_F"
		]
	],
	["_arry_class_name_statica",
		[
			"B_HMG_01_high_F",
			"B_GMG_01_high_F",
			"B_Mortar_01_F"
		]
	],
	["_radius_deploy_statica", 300],
	["_count_stacika",3],
	["_count_vehicle_track",3],
	["_count_vehicle",1],
	["_count_vehicle_pvo",2],
	["_count_vehicle_heli",1],
	["_count_patrul_bot_grup",3],
	["_count_bot_in_grup",4],
	["_spawn_bot_in_roof", true],
	["_radius_find_bilding_from_bot", 100],
	["_chanse_spawn_bot_in_roof", 30],
	["_spawn_bot_in_bilding",true],
	["_chanse_spawn_in_bilding",30],
	["_radius_activation",2000],
	["_radius_patroul_bot",500],
	["_radius_deploy_car_vehicle",200],
	["_radius_patroul_bot_vehicle",1000],
	["_radius_patroul_bot_heli",1500],
	["_hide_bot",true],
	["_delete_bot",false]
];

If(_hide_bot)then{
	enableDynamicSimulationSystem true;
	"Group" setDynamicSimulationDistance _radius_activation;
	"Vehicle" setDynamicSimulationDistance _radius_activation;
	"EmptyVehicle" setDynamicSimulationDistance _radius_activation;
	"Prop" setDynamicSimulationDistance _radius_activation;

	"IsMoving" setDynamicSimulationDistanceCoef 1;
};


																		// жду появления игрока

waitUntil{
sleep 5;
	_player_in_area = allPlayers inAreaArray [_pos_spawn, _radius_activation, _radius_activation, 0, false];
	!isNil {_player_in_area select 0}
};							

_arry_group_bot = []; // общий масив который будет содержать все юниты которые будут созданы


																		// создаю группы патруля



while {_count_patrul_bot_grup > 0} do
{

	private _group = createGroup [_side_bot, true];


// создаю юниты внутри групп
		local_count_bot_in_grup = _count_bot_in_grup;

		while {local_count_bot_in_grup > 0} do
		{
			_unit = _group createUnit [selectRandom _arry_class_name_bot, _pos_spawn, [], 0, "FORM"];

			sleep 0.5;

			_arry_group_bot pushBack _unit; // добавляю юнит в массив что бы потом все вместе удалить
			
			local_count_bot_in_grup = local_count_bot_in_grup - 1;

		};

	[_group, _pos_spawn, _radius_patroul_bot] call bis_fnc_taskPatrol;


	_count_patrul_bot_grup = _count_patrul_bot_grup - 1;

	sleep 1;

};



																	// создаю статику

while {_count_stacika > 0} do 
{

	// поиск позицый
	private _pos_from_statica = [_pos_spawn, 15, 300, 5, 0, 0.4, 0] call BIS_fnc_findSafePos;
	// спаун статики
	_static_weapon = [_pos_from_statica, 180, selectRandom _arry_class_name_statica, _side_bot] call BIS_fnc_spawnVehicle;

	// спаун мешков с песком вокруг

	/*
	_objectsArray = [
		["Land_BagFence_Short_F",[-1.99707,-1.44775,-9.91821e-005],232.961,1,0,[0,0],"","",true,false], 
		["Land_BagFence_Short_F",[1.63672,-1.85156,-0.000999451],322.006,1,0,[0,0],"","",true,false], 
		["Land_BagFence_Round_F",[-2.84131,0.419922,-0.00130463],95.2003,1,0,[0,-0],"","",true,false], 
		["Land_BagFence_Round_F",[-0.348145,-2.89111,-0.00130463],4.9125,1,0,[0,0],"","",true,false], 
		["Land_BagFence_Short_F",[-1.3501,2.22363,-0.000999451],318.403,1,0,[0,0],"","",true,false], 
		["Land_BagFence_Round_F",[3.10596,-0.118164,-0.00130463],274.818,1,0,[0,0],"","",true,false], 
		["Land_BagFence_Round_F",[0.509766,3.41699,-0.00130463],179.666,1,0,[0,-0],"","",true,false]
	];
	[getPos (_static_weapon select 0), 0, _objectsArray, 0] call BIS_fnc_objectsMapper; // воссоздаю композицыю обьектов
	*/
	_arry_group_bot pushBack (_static_weapon select 0);
	_arry_group_bot append (_static_weapon select 1);

	_count_stacika = _count_stacika - 1;

	sleep 0.5;
};


																	// Создаю машины


while { _count_vehicle_track > 0} do
{

	// поиск позицый
	private _pos_from_vehicle_track = [_pos_spawn, 15, _radius_deploy_car_vehicle, 6, 0, 0.5, 0] call BIS_fnc_findSafePos;
	// спаун статики
	_vehecle_track = [_pos_from_vehicle_track, 180, selectRandom _arry_class_name_vehicle_track, _side_bot] call BIS_fnc_spawnVehicle;
	// задать патруль технике
	[_vehecle_track select 2, _pos_spawn, _radius_patroul_bot_vehicle] call bis_fnc_taskPatrol;
	_arry_group_bot pushBack (_vehecle_track select 0);
	_arry_group_bot append (_vehecle_track select 1);
	sleep 0.5;
	_count_vehicle_track = _count_vehicle_track - 1;
};


																	// Создаю бронетехнику


while {_count_vehicle > 0} do
{

	// поиск позицый
	private _pos_from_vehicle = [_pos_spawn, 15, _radius_deploy_car_vehicle, 10, 0, 0.5, 0] call BIS_fnc_findSafePos;
	// спаун статики
	_vehecle = [_pos_from_vehicle, 180, selectRandom _arry_class_name_vehicle, _side_bot] call BIS_fnc_spawnVehicle;
	// задать патруль технике
	[_vehecle select 2, _pos_spawn, _radius_patroul_bot_vehicle] call bis_fnc_taskPatrol;
	_arry_group_bot pushBack (_vehecle select 0);
	_arry_group_bot append (_vehecle select 1);
	sleep 0.5;
	_count_vehicle = _count_vehicle - 1;
};



																	// Создаю зенитки

while {_count_vehicle_pvo > 0} do
{

	// поиск позицый
	private _pos_from_vehicle_pvo = [_pos_spawn, 15, _radius_deploy_car_vehicle, 8, 0, 0.5, 0] call BIS_fnc_findSafePos;
	// спаун статики
	_vehecle_pvo = [_pos_from_vehicle_pvo, 180, selectRandom _arry_class_name_PVO, _side_bot] call BIS_fnc_spawnVehicle;
	// задать патруль технике
	[_vehecle_pvo select 2, _pos_spawn, _radius_patroul_bot] call bis_fnc_taskPatrol;
	_arry_group_bot pushBack (_vehecle_pvo select 0);
	_arry_group_bot append (_vehecle_pvo select 1);
	sleep 0.5;
	_count_vehicle_pvo = _count_vehicle_pvo - 1;
};




																	// Создаю вертолет


while {_count_vehicle_heli > 0} do
{
	_pos_spawn_x = (_pos_spawn select 0) + selectRandom[100, 80, 60, 40, 20] + random 100;
	_pos_spawn_y = (_pos_spawn select 1) + selectRandom[100, 80, 60, 40, 20] + random 100;
	// спаун статики
	_vehecle_heli = [[_pos_spawn_x, _pos_spawn_y, _pos_spawn select 2], 180, selectRandom _arry_class_name_heli, _side_bot] call BIS_fnc_spawnVehicle;
	// задать патруль технике
	[_vehecle_heli select 2, _pos_spawn, _radius_patroul_bot] call bis_fnc_taskPatrol;
	_arry_group_bot pushBack (_vehecle_heli select 0);
	_arry_group_bot append (_vehecle_heli select 1);
	sleep 0.5;
	_count_vehicle_heli = _count_vehicle_heli - 1;
};


																		// создаю группы внутри зданий(на крышах)

if(_spawn_bot_in_roof)then{
	// создаю группу

	private _group_bot_in_bilding = createGroup [_side_bot, true];


	// поиск всех обьектов с класнеймом "дом"
	private _arry_bilding_from_bot = nearestObjects [_pos_spawn, ["house"], _radius_find_bilding_from_bot];

	// подсчет сколько найдено значений
	private _count_bliding = count _arry_bilding_from_bot - 1;

	// если в здании есть позицыя посадить туда бота
	while {_count_bliding > 0} do
	{
		_select_bilding_from_bot = [_arry_bilding_from_bot select _count_bliding, -1] call BIS_fnc_buildingPositions; // поиск позицый в заднии
		if(isnil {_select_bilding_from_bot select 0}) then{} else{
			private _seed = [1,101] call BIS_fnc_randomInt; // рандомное число от 0 до 100
			if(_seed <= _chanse_spawn_in_bilding) // если рандомное число больше или равно шансу спауна спаунится бот в здании
			then {
			_last_pos_bilding = count _select_bilding_from_bot; // подсчет количество позицый в выбраном здании
			_unit = _group_bot_in_bilding createUnit [selectRandom _arry_class_name_bot, _select_bilding_from_bot select _last_pos_bilding - 1, [], 0, "FORM"]; //спаун бота
			_unit disableAI "PATH";// отключить боту перемещение
			_arry_group_bot pushBack _unit; 
				};
		};
	_count_bliding = _count_bliding - 1;

	sleep 0.1;
	};

};


																// Создаю ботов в зданиях

if(_spawn_bot_in_bilding)then{
	_Arry_redy_bildings = [];  
	
	// поиск зданий который имеют позиции 
	{  
	If(!isNil {[_x] call BIS_fnc_buildingPositions select 0}) then {_Arry_redy_bildings pushBack _x}  
	} forEach nearestTerrainObjects [
	_pos_spawn, //массив координат центра поиска
	["house"],
	_radius_find_bilding_from_bot // радиус поиска зданий
	]; 

	private _group_defend = createGroup [_side_bot, true];
	
	
	{   
	
	for "_i" from 0 to (count ([_x] call BIS_fnc_buildingPositions) - 1) do  
	{ 
	// создание юнита
	if(random 100 <= _chanse_spawn_in_bilding)then 
	{ 
				_unit = _group_defend createUnit [selectRandom _arry_class_name_bot, ([_x] call BIS_fnc_buildingPositions) select _i, [], 0, "FORM"]; 
				_unit disableAi "path"; 
				_unit setPos (([_x] call BIS_fnc_buildingPositions) select _i); 
				_arry_group_bot pushBack _unit;
	}; 
		sleep 0.5; 
	}   
	} forEach _Arry_redy_bildings;
};

// задаю уровень скила ботов

{
	_x setSkill _bot_skill
} forEach _arry_group_bot;

If(_hide_bot)then{
	{
		group _X enableDynamicSimulation true
	} forEach _arry_group_bot;
	
};

	
// удаляю ботов

waitUntil{
	sleep 20;
	_delete_bot
};
{
	deleteVehicle _x;
} forEach _arry_group_bot;