If(serverCommandAvailable '#kick')then{
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

	_West_side = [];
	_East_side = [];
	_independent_side = [];


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
		if(((_availableFactionsData select _i) select 3) == 1)then{_West_side pushBack (_availableFactionsData select _i)}
	};

	// east

	for "_i" from 0 to (count _availableFactionsData - 1) do 
	{
		if(((_availableFactionsData select _i) select 3) == 0)then{_East_side pushBack (_availableFactionsData select _i)}
	};

	// independent

	for "_i" from 0 to (count _availableFactionsData - 1) do 
	{
		if(((_availableFactionsData select _i) select 3) == 2)then{_independent_side pushBack (_availableFactionsData select _i)}
	};
	waitUntil{
		alive player
	};
	// add action
	if!(side (selectRandom allPlayers) isEqualTo west)then{
		[
			Board_1,											// object the action is attached to
			"<t color='#0008ff'>Противние синие</t>",										// Title of the action
			"\a3\ui_f\data\IGUI\Cfg\holdactions\holdAction_connect_ca.paa",	// Idle icon shown on screen
			"\a3\ui_f\data\IGUI\Cfg\holdactions\holdAction_connect_ca.paa",	// Progress icon shown on screen
			"_this distance _target < 3",						// Condition for the action to be shown
			"_caller distance _target < 3",						// Condition for the action to progress
			{},													// Code executed when action starts
			{},													// Code executed on every progress tick
			{   side_enemy_select = (_this select 3)select 0;enemy_side =  west; publicVariable "enemy_side"},				// Code executed on completion
			{},													// Code executed on interrupted
			[_West_side],													// Arguments passed to the scripts as _this select 3
			5,													// action duration in seconds
			0,													// priority
			true,												// Remove on completion
			false												// Show in unconscious state
		] call BIS_fnc_holdActionAdd;	// MP compatible implementation
	};

	if!(side (selectRandom allPlayers) isEqualTo EAST)then{
		[
			Board_1,											// object the action is attached to
			"<t color='#ff0d00'>Противние Красные</t>",										// Title of the action
			"\a3\ui_f\data\IGUI\Cfg\holdactions\holdAction_connect_ca.paa",	// Idle icon shown on screen
			"\a3\ui_f\data\IGUI\Cfg\holdactions\holdAction_connect_ca.paa",	// Progress icon shown on screen
			"_this distance _target < 3",						// Condition for the action to be shown
			"_caller distance _target < 3",						// Condition for the action to progress
			{},													// Code executed when action starts
			{},													// Code executed on every progress tick
			{ side_enemy_select = (_this select 3)select 0;enemy_side = EAST; publicVariable "enemy_side"  },				// Code executed on completion
			{},													// Code executed on interrupted
			[_East_side],													// Arguments passed to the scripts as _this select 3
			5,													// action duration in seconds
			0,													// priority
			true,												// Remove on completion
			false												// Show in unconscious state
		] call BIS_fnc_holdActionAdd;	// MP compatible implementation
	};

	if!(side (selectRandom allPlayers) isEqualTo independent)then{
		[
			Board_1,											// object the action is attached to
			"<t color='#00ff22'>Противние Зеленые</t>",										// Title of the action
			"\a3\ui_f\data\IGUI\Cfg\holdactions\holdAction_connect_ca.paa",	// Idle icon shown on screen
			"\a3\ui_f\data\IGUI\Cfg\holdactions\holdAction_connect_ca.paa",	// Progress icon shown on screen
			"_this distance _target < 3",						// Condition for the action to be shown
			"_caller distance _target < 3",						// Condition for the action to progress
			{},													// Code executed when action starts
			{},													// Code executed on every progress tick
			{ side_enemy_select = (_this select 3)select 0;enemy_side = independent; publicVariable "enemy_side" },				// Code executed on completion
			{},													// Code executed on interrupted
			[_independent_side],													// Arguments passed to the scripts as _this select 3
			5,													// action duration in seconds
			0,													// priority
			true,												// Remove on completion
			false												// Show in unconscious state
		] call BIS_fnc_holdActionAdd;	// MP compatible implementation
	};

	waitUntil{
		!isNil{side_enemy_select}
	};

	removeAllActions Board_1;

	{

		private _action = Board_1 addAction [((side_enemy_select select _forEachIndex) select 1), {enemy_fraction = (side_enemy_select select (_this select 3))},_forEachIndex];
		Board_1 setUserActionText [_action , ((side_enemy_select select _forEachIndex) select 1), format ["<img size='4' image='%1'/>", ((side_enemy_select select _forEachIndex) select 2)]];
		
	} forEach side_enemy_select;

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

	_group_x = createGroup [enemy_side, false];  

	{
	_unit = _group_x createUnit [_x, [0,0,0], [], 0, "FORM"];  
	if(isNull _unit)then{inf_missions_arry = inf_missions_arry - [_x]};
	deleteVehicle _unit;
	} forEach inf_missions_arry; 

	//car

	_car_mission_arry_not_redy = "(getText (_x >> 'faction') == enemy_fraction select 0) and (configName _x isKindOf ""Car"")" configClasses (configFile >> "CfgVehicles"); 

	car_mission_arry = [];
	{
		car_mission_arry pushBack (configName _x)
	} forEach _car_mission_arry_not_redy;

	{ 
		_vehicle = _x createVehicle [0,0,0]; 
		if(isNull _vehicle)then{car_mission_arry = car_mission_arry - [_x]}; 
		deleteVehicle _vehicle; 
	} forEach car_mission_arry;


	//tank 

	_hevy_vehicle_arry_not_redy = "(getText (_x >> 'faction') == enemy_fraction select 0) and (configName _x isKindOf ""Tank"")" configClasses (configFile >> "CfgVehicles");

	hevy_vehicle_arry = [];
	{
		hevy_vehicle_arry pushBack (configName _x)
	} forEach _hevy_vehicle_arry_not_redy;

	{ 
		_vehicle = _x createVehicle [0,0,0]; 
		if(isNull _vehicle)then{hevy_vehicle_arry = hevy_vehicle_arry - [_x]}; 
		deleteVehicle _vehicle; 
	} forEach hevy_vehicle_arry;

	//helicopter

	_heli_vehecle_arry_not_redy = "(getText (_x >> 'faction') == enemy_fraction select 0) and (configName _x isKindOf ""Helicopter"")" configClasses (configFile >> "CfgVehicles");

	heli_vehecle_arry = [];
	{
		heli_vehecle_arry pushBack (configName _x)
	} forEach _heli_vehecle_arry_not_redy;

	{ 
		_vehicle = _x createVehicle [0,0,0]; 
		if(isNull _vehicle)then{heli_vehecle_arry = heli_vehecle_arry - [_x]}; 
		deleteVehicle _vehicle; 
	} forEach heli_vehecle_arry;


	//StaticWeapon

	_static_weapon_arry_not_redy = "(getText (_x >> 'faction') == enemy_fraction select 0) and (configName _x isKindOf ""StaticWeapon"")" configClasses (configFile >> "CfgVehicles");

	static_weapon_arry = [];
	{
		static_weapon_arry pushBack (configName _x)
	} forEach _static_weapon_arry_not_redy;

	{ 
		_vehicle = _x createVehicle [0,0,0]; 
		if(isNull _vehicle)then{static_weapon_arry = static_weapon_arry - [_x]}; 
		deleteVehicle _vehicle; 
	} forEach static_weapon_arry;


	anti_air_vehicle_arry = [];
	anti_air_vehicle_arry append hevy_vehicle_arry;
	anti_air_vehicle_arry append car_mission_arry;

	Ready_enemy = true;
	publicVariable "Ready_enemy";

	publicVariable "inf_missions_arry";
	publicVariable "car_mission_arry";
	publicVariable "hevy_vehicle_arry";
	publicVariable "heli_vehecle_arry";
	publicVariable "static_weapon_arry";
	publicVariable "anti_air_vehicle_arry";
};


waitUntil{
	sleep 1;
	!isNil {Ready_enemy}
};



// action to select mission on board
If(serverCommandAvailable '#kick')then{

Board_1 addAction ["<t color='#ff2e2e'>Миссия уничтожить танк</t>", "  
 [[], {  
  0 spawn{  
   private _nearbyLocations = nearestLocations [center_map, ['Name','NameCity','NameCityCapital','NameVillage'], radius_map];  
   private _select_location = selectRandom _nearbyLocations;  
   private _locationPos = locationPosition _select_location;  
   private _list_roads = _locationPos nearRoads 500;  
   private _select_road = selectRandom _list_roads;  
   pos_mision_1 = getPos _select_road;  
   [pos_mision_1,tank_from_first_mission,independent,1500] execVM 'Other_mission\mission_1_destroy_tank\mission_1.sqf'  
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
   [pos_mision_2,Heli_from_second_mission,independent,1500] execVM 'Other_mission\mission_2_destroy_helocopter\mission_1.sqf' 
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
            independent, 
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
 
Board_1 addAction ["<t color='#ff2e2e'>Уничтожить артелерию</t>", "  
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
 
 
Board_1 addAction ["<t color='#ff2e2e'>Уничтожить образцы хим оружия</t>", "  
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
  [pos_mision_13,independent] execVM 'Other_mission\mission_13_recwest_lab_box(water)\mission_1.sqf'; 
 }; 
 
}] remoteExec ['call',2];  
"]; 

};

_action_main = ["TestMain","Поддержка","",{},{true}] call ace_interact_menu_fnc_createAction; 
[player, 1, ["ACE_SelfActions"], _action_main] call ace_interact_menu_fnc_addActionToObject;	

_action_call_help_VDV = ["TestAction_call_help","Запросить поддержку ВДВ","",{[]execVM "Script\call_help_vdv.sqf";},{true}] call ace_interact_menu_fnc_createAction; 
[player, 1, ["ACE_SelfActions","TestMain"], _action_call_help_VDV] call ace_interact_menu_fnc_addActionToObject;	

_action_call_drop_Transport = ["TestAction_call_help","Запросить сброс транспорта","",{[]execVM "Script\call_drop_transport.sqf";},{true}] call ace_interact_menu_fnc_createAction; 
[player, 1, ["ACE_SelfActions","TestMain"], _action_call_drop_Transport] call ace_interact_menu_fnc_addActionToObject;

_action_call_drop_suplise = ["TestAction_call_help","Запросить сброс Припасов","",{[]execVM "Script\Call_drop_supplise.sqf";},{true}] call ace_interact_menu_fnc_createAction; 
[player, 1, ["ACE_SelfActions","TestMain"], _action_call_drop_suplise] call ace_interact_menu_fnc_addActionToObject;

_action_call_air_deffense = ["TestAction_call_help","Запросить зачистку воздушных целей","",{[]execVM "Script\Air_deffense.sqf";},{true}] call ace_interact_menu_fnc_createAction; 
[player, 1, ["ACE_SelfActions","TestMain"], _action_call_air_deffense] call ace_interact_menu_fnc_addActionToObject;

_action_call_vdv_paradrop = ["TestAction_call_help","Запросить помощь ССО","",{[]execVM "Script\call_help_paradrop.sqf";},{true}] call ace_interact_menu_fnc_createAction; 
[player, 1, ["ACE_SelfActions","TestMain"], _action_call_vdv_paradrop] call ace_interact_menu_fnc_addActionToObject;


player addEventHandler [
	"Killed",
	{
		[player, [missionNamespace, "Inventory_on_death"]] call BIS_fnc_saveInventory;

		true
	}
];

player addEventHandler [
	"Respawn",
	{	
		player addAction ["<t color='#00ff22'>Меню игрока</t>",
			"[] spawn{			
				createDialog 'Dialog_Player_general';
				waitUntil{
					ctrlSetText [1908, str (sliderPosition 1900)]; 
					ctrlSetText [1909, str (sliderPosition 1901)]; 
					ctrlSetText [1910, str (sliderPosition 1902)]; 
					!dialog
				};
			}"
		];
		[player, [missionNamespace, "Inventory_on_death"]] call BIS_fnc_loadInventory;
		true
	}
];


// save and load inventory

[
	ammo_1,											// object the action is attached to
	"<t color='#00d5ff'>Сохранить снаряжение</t>",										// Title of the action
	"\a3\ui_f\data\IGUI\Cfg\holdactions\holdAction_loaddevice_ca.paa",	// Idle icon shown on screen
	"\a3\ui_f\data\IGUI\Cfg\holdactions\holdAction_loaddevice_ca.paa",	// Progress icon shown on screen
	"_this distance _target < 10",						// Condition for the action to be shown
	"_caller distance _target < 10",						// Condition for the action to progress
	{},													// Code executed when action starts
	{},													// Code executed on every progress tick
	{ [player, [missionNamespace, "player_saves_Inventory"]] call BIS_fnc_saveInventory; },				// Code executed on completion
	{},													// Code executed on interrupted
	[],													// Arguments passed to the scripts as _this select 3
	3,													// action duration in seconds
	0,													// priority
	false,												// Remove on completion
	false												// Show in unconscious state
] call BIS_fnc_holdActionAdd;	// MP compatible implementation

[
	ammo_1,											// object the action is attached to
	"<t color='#006eff'>Загрузить снаряжение</t>",										// Title of the action
	"\a3\ui_f\data\IGUI\Cfg\holdactions\holdAction_unloaddevice_ca.paa",	// Idle icon shown on screen
	"\a3\ui_f\data\IGUI\Cfg\holdactions\holdAction_unloaddevice_ca.paa",	// Progress icon shown on screen
	"_this distance _target < 10",						// Condition for the action to be shown
	"_caller distance _target < 10",						// Condition for the action to progress
	{},													// Code executed when action starts
	{},													// Code executed on every progress tick
	{ [player, [missionNamespace, "player_saves_Inventory"]] call BIS_fnc_loadInventory; },				// Code executed on completion
	{},													// Code executed on interrupted
	[],													// Arguments passed to the scripts as _this select 3
	3,													// action duration in seconds
	0,													// priority
	false,												// Remove on completion
	false												// Show in unconscious state
] call BIS_fnc_holdActionAdd;	// MP compatible implementation

[
	ammo_2,											// object the action is attached to
	"<t color='#00d5ff'>Сохранить снаряжение</t>",										// Title of the action
	"\a3\ui_f\data\IGUI\Cfg\holdactions\holdAction_loaddevice_ca.paa",	// Idle icon shown on screen
	"\a3\ui_f\data\IGUI\Cfg\holdactions\holdAction_loaddevice_ca.paa",	// Progress icon shown on screen
	"_this distance _target < 10",						// Condition for the action to be shown
	"_caller distance _target < 10",						// Condition for the action to progress
	{},													// Code executed when action starts
	{},													// Code executed on every progress tick
	{ [player, [missionNamespace, "player_saves_Inventory"]] call BIS_fnc_saveInventory; },				// Code executed on completion
	{},													// Code executed on interrupted
	[],													// Arguments passed to the scripts as _this select 3
	3,													// action duration in seconds
	0,													// priority
	false,												// Remove on completion
	false												// Show in unconscious state
] call BIS_fnc_holdActionAdd;	// MP compatible implementation




[
	ammo_2,											// object the action is attached to
	"<t color='#006eff'>Загрузить снаряжение</t>",										// Title of the action
	"\a3\ui_f\data\IGUI\Cfg\holdactions\holdAction_unloaddevice_ca.paa",	// Idle icon shown on screen
	"\a3\ui_f\data\IGUI\Cfg\holdactions\holdAction_unloaddevice_ca.paa",	// Progress icon shown on screen
	"_this distance _target < 10",						// Condition for the action to be shown
	"_caller distance _target < 10",						// Condition for the action to progress
	{},													// Code executed when action starts
	{},													// Code executed on every progress tick
	{ [player, [missionNamespace, "player_saves_Inventory"]] call BIS_fnc_loadInventory; },				// Code executed on completion
	{},													// Code executed on interrupted
	[],													// Arguments passed to the scripts as _this select 3
	3,													// action duration in seconds
	0,													// priority
	false,												// Remove on completion
	false												// Show in unconscious state
] call BIS_fnc_holdActionAdd;	// MP compatible implementation

// arsenal ace

if(isClass (configFile >> "CfgPatches" >> "ace_main"))then{

	[ammo_1, true] call ace_arsenal_fnc_initBox;
	[
	ammo_1,											
	"<t color='#2eff5b'>Arsenal ACE</t>",										
	"\a3\ui_f\data\igui\cfg\actions\reload_ca.paa",	
	"\a3\ui_f\data\igui\cfg\actions\reload_ca.paa",	
	"_this distance _target < 10",						
	"_caller distance _target < 10",						
	{},													
	{},													
	{ [ammo_1, player] call ace_arsenal_fnc_openBox },				
	{},													
	[],													
	1,													
	0,													
	false,												
	false												
	] call BIS_fnc_holdActionAdd;

};

if(isClass (configFile >> "CfgPatches" >> "ace_main"))then{

	[ammo_2, true] call ace_arsenal_fnc_initBox;
	[
	ammo_2,											
	"<t color='#2eff5b'>Arsenal ACE</t>",										
	"\a3\ui_f\data\igui\cfg\actions\reload_ca.paa",	
	"\a3\ui_f\data\igui\cfg\actions\reload_ca.paa",	
	"_this distance _target < 10",						
	"_caller distance _target < 10",						
	{},													
	{},													
	{ [ammo_2, player] call ace_arsenal_fnc_openBox },				
	{},													
	[],													
	1,													
	0,													
	false,												
	false												
	] call BIS_fnc_holdActionAdd;

};


// bis arsenal

[
	ammo_1,											
	"<t color='#ffffff'>Arsenal</t>",										
	"\a3\ui_f\data\igui\cfg\actions\reload_ca.paa",	
	"\a3\ui_f\data\igui\cfg\actions\reload_ca.paa",	
	"_this distance _target < 10",						
	"_caller distance _target < 10",						
	{},													
	{},													
	{ ["Open",true] spawn BIS_fnc_arsenal },				
	{},													
	[],													
	1,													
	0,													
	false,												
	false												
] call BIS_fnc_holdActionAdd;


[
	ammo_2,											
	"<t color='#ffffff'>Arsenal</t>",										
	"\a3\ui_f\data\igui\cfg\actions\reload_ca.paa",	
	"\a3\ui_f\data\igui\cfg\actions\reload_ca.paa",	
	"_this distance _target < 10",						
	"_caller distance _target < 10",						
	{},													
	{},													
	{ ["Open",true] spawn BIS_fnc_arsenal },				
	{},													
	[],													
	1,													
	0,													
	false,												
	false												
] call BIS_fnc_holdActionAdd;
