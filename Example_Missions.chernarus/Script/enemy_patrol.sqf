if(isNil "Stot_patrol_enemy")then{
	Stot_patrol_enemy = false;
};

_count_vehicle = [];

// все дороги
private _list_road = [];
// поиск дорог которые есть
_list_road = center_map nearRoads radius_map;
// цыкл создания техники
Stot_patrol = true;
// функция поиска дороги
private _nearbyLocations = nearestLocations [center_map, ['Name','NameCity','NameCityCapital','NameVillage'], radius_map];
{
	If((getPos _x) inArea [pos_base, 1500, 1500, 45, false])then{_nearbyLocations = _nearbyLocations - [_x]};
} forEach _nearbyLocations;


waitUntil{
	// выбор техники
	if(count _count_vehicle <= count_enemy_vehicle_patrol)then{		
		_mission_arry_vehicle = [];
		_mission_arry_vehicle append car_mission_arry;
		_mission_arry_vehicle append hevy_vehicle_arry;
		_mission_arry_vehicle append heli_vehecle_arry;
		private _select_vehicle = selectRandom _mission_arry_vehicle;
		// создание техники
		private _select_location = selectRandom _nearbyLocations; 
		private _locationPos = locationPosition _select_location;
		private _pos_from_vehicle = [_locationPos, 100, 500, 15, 0, 0.7, 0] call BIS_fnc_findSafePos;
		
		private _vehicle = [_pos_from_vehicle, 180,_select_vehicle, enemy_side] call BIS_fnc_spawnVehicle;
		
		for "_i" from 0 to ((_vehicle select 0) emptyPositions "cargo") - 1 do 
		{
			_unit = group ((_vehicle select 1)select 0) createUnit [selectRandom inf_missions_arry, [0,0,0], [], 0, "FORM"];
			_unit moveInCargo (_vehicle select 0);
		};

		// добавляю патруль
		[_vehicle select 2, getPos (_vehicle select 0), 500] call BIS_fnc_taskPatrol;

		_count_vehicle pushBack (_vehicle select 0);

		group ((_vehicle select 1)select 0) enableDynamicSimulation true;
	};
	//
	{
		if(!alive _x) then {_count_vehicle = _count_vehicle - [_x]}
	} forEach _count_vehicle;
	sleep 1;
	Stot_patrol_enemy
};