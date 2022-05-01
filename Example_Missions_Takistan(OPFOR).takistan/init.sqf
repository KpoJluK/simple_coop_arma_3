resistance setFriend [east, 0];
resistance setFriend [west, 0];



// add choise faction

If(serverCommandAvailable '#kick' or !isMultiplayer)then{
	// *****
	// EXTRACT FACTION DATA
	// *****

	// Check for factions that have units
	_availableFactions = [];
	_availableFactionsData = [];
	_availableFactionsDataNoInf = [];
	_unavailableFactions = [];
	//_factionsWithUnits = [];
	_factionsWithNoInf = [];
	_factionsWithUnitsFiltered = [];

	West_side = [];
	East_side = [];
	Independent_side = [];


	// Record all factions with valid vehicles
	{
		if (isNumber (configFile >> "CfgVehicles" >> (configName _x) >> "scope")) then {
			if (((configFile >> "CfgVehicles" >> (configName _x) >> "scope") call BIS_fnc_GetCfgData) == 2) then {
				_factionClass = ((configFile >> "CfgVehicles" >> (configName _x) >> "faction") call BIS_fnc_GetCfgData);
				//_factionsWithUnits pushBackUnique _factionClass;		
				if ((configName _x) isKindOf "Man") then {
					_index = ([_factionsWithUnitsFiltered, _factionClass] call BIS_fnc_findInPairs);
					if (_index == -1) then {
						_factionsWithUnitsFiltered pushBack [_factionClass, 1];
					} else {
						_factionsWithUnitsFiltered set [_index, [((_factionsWithUnitsFiltered select _index) select 0), ((_factionsWithUnitsFiltered select _index) select 1)+1]];
					}; 
				};		
			};
		};
	} forEach ("(configName _x) isKindOf 'AllVehicles'" configClasses (configFile / "CfgVehicles"));
	// Filter factions with 1 or less infantry units
	/*
	{
		_factionsWithUnitsFiltered pushBack [_x, 0];
	} forEach _factionsWithUnits;
	{		
		_index = [_factionsWithUnitsFiltered, ((configFile >> "CfgVehicles" >> (configName _x) >> "faction") call BIS_fnc_GetCfgData)] call BIS_fnc_findInPairs; 
		if (_index > -1) then {		
			_factionsWithUnitsFiltered set [_index, [((_factionsWithUnitsFiltered select _index) select 0), ((_factionsWithUnitsFiltered select _index) select 1)+1]];
		};
	} forEach ("(configName _x) isKindOf 'Man'" configClasses (configFile / "CfgVehicles"));
	*/
	diag_log format ["DRO: _factionsWithUnitsFiltered = %1", _factionsWithUnitsFiltered];

	// Filter out factions that have no vehicles
	{
		_thisFaction = (_x select 0);
		_thisSideNum = ((configFile >> "CfgFactionClasses" >> _thisFaction >> "side") call BIS_fnc_GetCfgData);
		//diag_log format ["DRO: Fetching faction info for %1", _thisFaction];	
		//diag_log format ["DRO: faction sideNum = %1", _thisSideNum];
		if (!isNil "_thisSideNum") then {
			if (typeName _thisSideNum == "TEXT") then {
				if ((["west", _thisSideNum, false] call BIS_fnc_inString)) then {
					_thisSideNum = 1;
				};
				if ((["east", _thisSideNum, false] call BIS_fnc_inString)) then {
					_thisSideNum = 0;
				};
				if ((["guer", _thisSideNum, false] call BIS_fnc_inString) || (["ind", _thisSideNum, false] call BIS_fnc_inString)) then {
					_thisSideNum = 2;
				};
			};	
			
			if (typeName _thisSideNum == "SCALAR") then {
				if (_thisSideNum <= 3 && _thisSideNum > -1) then {
						
					_thisFactionName = ((configFile >> "CfgFactionClasses" >> _thisFaction >> "displayName") call BIS_fnc_GetCfgData);			
					_thisFactionFlag = ((configfile >> "CfgFactionClasses" >> _thisFaction >> "flag") call BIS_fnc_GetCfgData);
					
					if ((_x select 1) <= 1) then {
						if (!isNil "_thisFactionFlag") then {
							_availableFactionsDataNoInf pushBack [_thisFaction, _thisFactionName, _thisFactionFlag, _thisSideNum];
						} else {
							_availableFactionsDataNoInf pushBack [_thisFaction, _thisFactionName, "", _thisSideNum];
						};
					} else {				
						if (!isNil "_thisFactionFlag") then {
							_availableFactionsData pushBack [_thisFaction, _thisFactionName, _thisFactionFlag, _thisSideNum];
						} else {
							_availableFactionsData pushBack [_thisFaction, _thisFactionName, "", _thisSideNum];
						};
					};
							
				};	
			};
		};
	} forEach _factionsWithUnitsFiltered;
		
	// west
	

	for "_i" from 0 to (count _availableFactionsData - 1) do 
	{
		if(((_availableFactionsData select _i) select 3) == 1)then{West_side pushBack (_availableFactionsData select _i)}
	};

	// east

	for "_i" from 0 to (count _availableFactionsData - 1) do 
	{
		if(((_availableFactionsData select _i) select 3) == 0)then{East_side pushBack (_availableFactionsData select _i)}
	};

	// enemy_side

	for "_i" from 0 to (count _availableFactionsData - 1) do 
	{
		if(((_availableFactionsData select _i) select 3) == 2)then{Independent_side pushBack (_availableFactionsData select _i)}
	};
	waitUntil{
		alive player
	};
	// add action


	if!(side (selectRandom allPlayers) isEqualTo west)then{
		{

			private _action = Board_1 addAction [format ["<t color='#2e85ff'>%1</t>",((West_side select _forEachIndex) select 1)], {enemy_fraction = (West_side select (_this select 3));enemy_side = WEST; publicVariable "enemy_side";},_forEachIndex];
			Board_1 setUserActionText [_action , format ["<t color='#2e85ff'>%1</t>",((West_side select _forEachIndex) select 1)], format ["<img size='4' image='%1'/>", ((West_side select _forEachIndex) select 2)]];
			
		} forEach West_side;
	};

	if!(side (selectRandom allPlayers) isEqualTo EAST)then{
		{

			private _action = Board_1 addAction [format ["<t color='#ff0d00'>%1</t>",((East_side select _forEachIndex) select 1)], {enemy_fraction = (East_side select (_this select 3));enemy_side = EAST; publicVariable "enemy_side";},_forEachIndex];
			Board_1 setUserActionText [_action , format ["<t color='#ff0d00'>%1</t>",((East_side select _forEachIndex) select 1)], format ["<img size='4' image='%1'/>", ((East_side select _forEachIndex) select 2)]];
			
		} forEach East_side;
	};

	if!(side (selectRandom allPlayers) isEqualTo independent)then{
		{

			private _action = Board_1 addAction [format ["<t color='#57ff24'>%1</t>",((Independent_side select _forEachIndex) select 1)], {enemy_fraction = (Independent_side select (_this select 3));enemy_side = independent; publicVariable "enemy_side";},_forEachIndex];
			Board_1 setUserActionText [_action , format ["<t color='#57ff24'>%1</t>",((Independent_side select _forEachIndex) select 1)], format ["<img size='4' image='%1'/>", ((Independent_side select _forEachIndex) select 2)]];
			
		} forEach Independent_side;
	};


	waitUntil{
		!isNil{enemy_fraction}
	};

	removeAllActions Board_1;

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
};


// add action

[]spawn{

    waitUntil{
        !isNil {Ready_enemy}
    };
	// action to select mission on board
	If(serverCommandAvailable '#kick' or !isMultiplayer)then{

	Board_1 addAction ["<t color='#ff2e2e'>Миссия уничтожить танк</t>", "  
	[[], {  
	0 spawn{  
	private _nearbyLocations = nearestLocations [center_map, ['Name','NameCity','NameCityCapital','NameVillage'], radius_map];  
	private _select_location = selectRandom _nearbyLocations;  
	private _locationPos = locationPosition _select_location;  
	private _list_roads = _locationPos nearRoads 500;  
	private _select_road = selectRandom _list_roads;  
	pos_mision_1 = getPos _select_road;  
	[pos_mision_1,tank_from_first_mission,enemy_side,1500] execVM 'Other_mission\mission_1_destroy_tank\mission_1.sqf'  
	};  
	}] remoteExec ['call',2];  
	"]; 
	
	
	Board_1 addAction ["<t color='#ff2e2e'>Миссия уничтожить вертолет</t>", "  
	[[], {  
	0 spawn{  
	private _nearbyLocations = nearestLocations [center_map, ['Name','NameCity','NameCityCapital','NameVillage'], radius_map];  
	private _select_location = selectRandom _nearbyLocations;  
	private _locationPos = locationPosition _select_location;  
	private _list_roads = _locationPos nearRoads 500;  
	private _select_road = selectRandom _list_roads;  
	pos_mision_2 = getPos _select_road;  
	[pos_mision_2,Heli_from_second_mission,enemy_side,1500] execVM 'Other_mission\mission_2_destroy_helocopter\mission_1.sqf' 
	};  
	}] remoteExec ['call',2];  
	"]; 
	
	Board_1 addAction ["<t color='#ff2e2e'>Эвакуировать пилотов сбитого вертолета</t>", "  
	[[], {  
	0 spawn{  
	private _nearbyLocations = nearestLocations [center_map, ['Name','NameCity','NameCityCapital','NameVillage'], radius_map]; 
	private _select_location = selectRandom _nearbyLocations; 
	private _locationPos = locationPosition _select_location; 
	_locationPos set [2,0]; 
	pos_mision_3 = [_locationPos, 500, 1500, 20, 0, 0.5, 0] call BIS_fnc_findSafePos; 
	_select_next_location = nearestLocation [pos_mision_3, 'NameVillage']; 
	pos_mision_3_next = locationPosition _select_next_location; 
	pos_mision_3_next set[2,0]; 
		[pos_mision_3,frendly_down_heli_from_third_mission,pos_mision_3_next,side_frendly_pilots,class_name_frendly_pilots,pos_base] execVM 'Other_mission\mission_3_reqvest_pilots\mission_1.sqf' 
	};  
	}] remoteExec ['call',2];  
	"]; 
	
	Board_1 addAction ["<t color='#ff2e2e'>Найти сбитый беспилотник</t>", "  
	[[], {  
	0 spawn{  
	private _nearbyLocations = nearestLocations [center_map, ['Name','NameCity','NameCityCapital','NameVillage'], radius_map]; 
	private _select_location = selectRandom _nearbyLocations; 
	private _locationPos = locationPosition _select_location; 
	_locationPos set [2,0]; 
	pos_mision_4 = [_locationPos, 500, 1500, 20, 0, 0.5, 0] call BIS_fnc_findSafePos; 
		[ 
			pos_mision_4, 
			class_name_bespilotnik, 
			class_neme_APC_four_missions, 
			class_neme_helicopter_four_missions, 
			enemy_side, 
			inf_missions_arry 
		] execVM 'Other_mission\mission_4_find_bespilotnik\mission_1.sqf'; 
	};  
	}] remoteExec ['call',2];  
	"]; 
	
	
	Board_1 addAction ["<t color='#ff2e2e'>Уничтожить груз</t>", "  
	[[], {  
	0 spawn{  
	private _nearbyLocations = nearestLocations [center_map, ['Name','NameCity','NameCityCapital','NameVillage'], radius_map]; 
	private _select_location = selectRandom _nearbyLocations; 
	private _locationPos = locationPosition _select_location; 
	private _list_roads = _locationPos nearRoads 500; 
	private _select_road = selectRandom _list_roads; 
	pos_mision_5 = getPos _select_road; 
	[pos_mision_5,'Box_NATO_AmmoVeh_F',arry_class_name_vehicle_frendly,pos_base] execVM 'Other_mission\mission_5_destroy_cargo\mission_1.sqf'; 
	};  
	}] remoteExec ['call',2];  
	"]; 
	
	
	Board_1 addAction ["<t color='#ff2e2e'>Забрать чёрный ящик с упавшего вертолета</t>", "  
	[[], {  
	0 spawn{  
	private _nearbyLocations = nearestLocations [center_map, ['Name','NameCity','NameCityCapital','NameVillage'], radius_map]; 
	private _select_location = selectRandom _nearbyLocations; 
	private _locationPos = locationPosition _select_location; 
	_locationPos set [2,0]; 
	pos_mision_6 = [_locationPos, 500, 1500, 20, 0, 0.5, 0] call BIS_fnc_findSafePos; 
	[pos_mision_6,class_name_heli_pidbity_six_mission,class_nsme_box_to_destroy,pos_base] execVM 'Other_mission\mission_6_reqvest_black_cargo\mission_1.sqf'; 
	};  
	}] remoteExec ['call',2];  
	"]; 
	
	Board_1 addAction ["<t color='#ff2e2e'>Уничтожить артилерию</t>", "  
	[[], {  
	0 spawn{  
	private _nearbyLocations = nearestLocations [center_map, ['Name','NameCity','NameCityCapital','NameVillage'], radius_map]; 
	private _select_location = selectRandom _nearbyLocations; 
	private _locationPos = locationPosition _select_location; 
	_locationPos set [2,0]; 
	pos_mision_7 = [_locationPos, 500, 1500, 20, 0, 0.5, 0] call BIS_fnc_findSafePos; 
	[pos_mision_7,class_name_artilery_to_destroy,getPos MHQ_1] execVM 'Other_mission\mission_7_destroy_artilery\mission_1.sqf' 
	};  
	}] remoteExec ['call',2];  
	"]; 
	
	Board_1 addAction ["<t color='#ff2e2e'>Уничтожить колонну</t>", "     
	[[], {     
	0 spawn{
		waitUntil{
		pos_mision_8 = [0,0,0];
		private _nearbyLocations = nearestLocations [center_map, ['Name','NameCity','NameCityCapital','NameVillage'], radius_map];    
	private _randomLoacation = getPos selectRandom _nearbyLocations;   
	pos_mision_8 = [_randomLoacation, 200, 1000, 50, 0, 0.9, 0] call BIS_fnc_findSafePos;
	!(pos_mision_8 inArea [[0,0,0], 1000, 1000, 0, false])
	};       
	[pos_mision_8] execVM 'Other_mission\mission_8_destroy_vehicle_before\mission_1.sqf'    
	};     
	}] remoteExec ['call',2];     
	"];   
	
	Board_1 addAction ["<t color='#ff2e2e'>Освободить город</t>", "  
	[[], {  
	0 spawn{  
	private _nearbyLocations = nearestLocations [center_map, ['Name','NameCity','NameCityCapital','NameVillage'], radius_map]; 
	private _randomLoacation = getPos selectRandom _nearbyLocations; 
	private _nearestRoad = [_randomLoacation, 500] call BIS_fnc_nearestRoad; 
	pos_mision_9 = getPos _nearestRoad; 
	[pos_mision_9] execVM 'Other_mission\mission_9_liberate_city\mission_1.sqf' 
	};  
	}] remoteExec ['call',2];  
	"]; 
	
	Board_1 addAction ["<t color='#ff2e2e'>Уничтожить РЛС</t>", "  
	[[], {  
	0 spawn{  
	private _nearbyLocations = nearestLocations [center_map, ['Name','NameCity','NameCityCapital','NameVillage'],radius_map]; 
	private _select_location = selectRandom _nearbyLocations; 
	private _locationPos = locationPosition _select_location; 
	_locationPos set [2,0]; 
	pos_mision_10 = [_locationPos, 500, 1500, 20, 0, 0.5, 0] call BIS_fnc_findSafePos; 
	[pos_mision_10] execVM 'Other_mission\mission_10_destroy_rls\mission_1.sqf' 
	};  
	}] remoteExec ['call',2];  
	"]; 
	
	Board_1 addAction ["<t color='#ff2e2e'>Спасти заложника</t>", "  
	[[], {  
	0 spawn{  
	private _nearbyLocations = nearestLocations [center_map, ['Name','NameCity','NameCityCapital','NameVillage'], radius_map]; 
	private _select_location = selectRandom _nearbyLocations; 
	private _locationPos = locationPosition _select_location; 
	_locationPos set [2,0]; 
	pos_mision_11 = _locationPos; 
	[ 
	pos_mision_11, 
	arry_class_names_zaloznic, 
	inf_missions_arry, 
	300, 
	pos_base 
	] execVM 'Other_mission\mission_11_reqvest_zaloznic\mission_1.sqf'; 
	};  
	}] remoteExec ['call',2];  
	"]; 
	
	
	Board_1 addAction ["<t color='#ff2e2e'>Захватить офицера</t>", "  
	[[], {  
	0 spawn{  
	private _nearbyLocations = nearestLocations [center_map, ['Name','NameCity','NameCityCapital','NameVillage'], radius_map]; 
	private _select_location = selectRandom _nearbyLocations; 
	private _locationPos = locationPosition _select_location; 
	_locationPos set [2,0]; 
	pos_mision_12 = _locationPos; 
		[ 
			pos_mision_12, 
	arry_class_names_officer, 
			inf_missions_arry, 
			300, 
			pos_base 
		] execVM 'Other_mission\mission_12_capture_officere\mission_1.sqf'; 
	};  
	}] remoteExec ['call',2];  
	"]; 
	
	
	Board_1 addAction ["<t color='#ff2e2e'>Уничтожить хим оружие(На карте должен быть водоем!)</t>", "  
	[[], {  
	0 spawn{ 
	_nearbyLocations = nearestLocations [center_map, ['NameMarine'], radius_map];   
	pos_mision_13 = [0,0,0];  
	waitUntil{  
	_select_location = selectRandom _nearbyLocations;  
	_locationPos = locationPosition _select_location;  
	pos_mision_13 = _locationPos getPos [1000, random 360];  
	pos_mision_13 set [2,0];  
	((ASLToATL pos_mision_13)select 2) >= 10 and ((ASLToATL pos_mision_13)select 2) <= 40  
	}; 
	[pos_mision_13,enemy_side] execVM 'Other_mission\mission_13_recwest_lab_box(water)\mission_1.sqf'; 
	}; 
	
	}] remoteExec ['call',2];  
	"]; 

	Board_1 addAction ["<t color='#ff2e2e'>Обезвредить бомбу в населенном пункте</t>", "  
	[[], {  
	0 spawn{  
	private _nearbyLocations = nearestLocations [center_map, ['Name','NameCity','NameCityCapital','NameVillage'], radius_map]; 
	private _select_location = selectRandom _nearbyLocations; 
	private _locationPos = locationPosition _select_location;
	_find_road = [_locationPos, 500] call BIS_fnc_nearestRoad;
	pos_mision_14 = getPos _find_road; 
		[ 
			pos_mision_14, 
			3600
		] execVM 'Other_mission\mission_14_defuse_bomb\mission_1.sqf'; 
	};  
	}] remoteExec ['call',2];
	"];

	Board_1 addAction ["<t color='#ff2e2e'>Оказать помощь раненой важной особе</t>", "  
	[[], {  
	0 spawn{  
	private _nearbyLocations = nearestLocations [center_map, ['Name','NameCity','NameCityCapital','NameVillage'], radius_map]; 
	private _select_location = selectRandom _nearbyLocations; 
	private _locationPos = locationPosition _select_location;
	_find_road = [_locationPos, 500] call BIS_fnc_nearestRoad;
	pos_mision_14 = getPos _find_road; 
		[ 
			pos_mision_14,
			[
				'C_Man_formal_1_F', 
				'C_Man_formal_2_F', 
				'C_Man_formal_3_F', 
				'C_Man_formal_4_F', 
				'C_Man_smart_casual_1_F', 
				'C_Man_smart_casual_2_F'
			],
			[
				'C_IDAP_Man_Paramedic_01_F',
				'C_Man_Paramedic_01_F'
			]
		] execVM 'Other_mission\mission_15_help_man\mission_1.sqf'; 
	};  
	}] remoteExec ['call',2];
	"]; 

	};
};