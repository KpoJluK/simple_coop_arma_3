params ["_pos_mission"];

hint"Подождите идет постоение маршрута для колонны...";

private _nearestRoad = [_pos_mission, 1000] call BIS_fnc_nearestRoad;


// find pos from delivery

_fnc_find_pos_delivery ={
	private _axis = worldSize / 2;
	private _center = [_axis, _axis , 0];
	private _radius = sqrt 2 * _axis;
	nearbyLocations_1 = nearestLocations [_center, ["Name","NameCity","NameCityCapital","NameVillage"], _radius];
	randomLoacation_1 = getPos selectRandom nearbyLocations_1;
	nearestRoad_1 = [randomLoacation_1, 500] call BIS_fnc_nearestRoad;
};

waitUntil{
sleep 0.1;
[] call _fnc_find_pos_delivery;
_pos_mission distance randomLoacation_1 > 4000
};

arry_marker_pos = [];
_arry_marker_pos_fom_delete = [];

// find path
private _agent = createAgent [typeOf player, getPos _nearestRoad, [], 0, "NONE"];
private _car = "B_Quadbike_01_F" createVehicle getPos _nearestRoad;
_agent forceFollowRoad true;
_agent moveInDriver _car;
_agent addEventHandler ["PathCalculated",
{ 
	{ 	
			if(_forEachIndex < 50 or (_forEachIndex mod 50 == 0))then{
			private _marker = createMarker ["Pos_convoy_" + str _forEachIndex, _x];
			_marker setMarkerType "mil_dot";
			_marker setMarkerAlpha 0.5;
			arry_marker_pos pushBack _marker;
			_arry_marker_pos_fom_delete pushBack _marker;
			};
		
	} 
	forEach (_this select 1);
}];

_agent setDestination [randomLoacation_1, "LEADER PLANNED", true];

sleep 5;

deleteVehicle _agent;
deleteVehicle _car;

// hide marker

for "_i" from 0 to 49 do 
{
	(arry_marker_pos select _i) setMarkerAlpha 0;
};



//task
["Task_08", true, ["Уничтожить технику пока она не добралась до места назначения","Уничтожить технику пока она не добралась до места назначения","respawn_west"], getmarkerPos "Pos_convoy_45", "CREATED", 5, true, true, "kill", true] call BIS_fnc_setTask;

_arry_vehicle_convoy = [];

_arry_vehicle_convoy append car_mission_arry;

if!((hevy_vehicle_arry select 0) isEqualTo str objNull)then{

	_arry_vehicle_convoy append hevy_vehicle_arry;

};


//Vehicle
private _BMP_delivery_explousion = [getmarkerPos "Pos_convoy_39", 180,selectRandom car_mission_arry, enemy_side] call BIS_fnc_spawnVehicle;

private _BMP_delivery_explousion_2 = [getmarkerPos "Pos_convoy_37", 180,selectRandom _arry_vehicle_convoy, enemy_side] call BIS_fnc_spawnVehicle;

private _BMP_delivery_explousion_3 = [getmarkerPos "Pos_convoy_35", 180,selectRandom _arry_vehicle_convoy, enemy_side] call BIS_fnc_spawnVehicle;

private _BMP_delivery_explousion_4 = [getmarkerPos "Pos_convoy_30", 180,selectRandom _arry_vehicle_convoy, enemy_side] call BIS_fnc_spawnVehicle;

private _BMP_delivery_explousion_5 = [getmarkerPos "Pos_convoy_25", 180,selectRandom _arry_vehicle_convoy, enemy_side] call BIS_fnc_spawnVehicle;

private _BMP_delivery_explousion_6 = [getmarkerPos "Pos_convoy_0", 180,selectRandom _arry_vehicle_convoy, enemy_side] call BIS_fnc_spawnVehicle;

arry_marker_pos deleteRange [0, 50];

/*
for "_i" from 0 to ((_BMP_delivery_explousion select 0) emptyPositions "cargo") - 1 do 
{
	_unit = group ((_BMP_delivery_explousion select 1)select 0) createUnit [selectRandom inf_missions_arry, [0,0,0], [], 0, "FORM"];
	_unit moveInCargo (_BMP_delivery_explousion select 0);
};

for "_i" from 0 to ((_BMP_delivery_explousion_2 select 0) emptyPositions "cargo") - 1 do 
{
	_unit = group ((_BMP_delivery_explousion_2 select 1)select 0) createUnit [selectRandom inf_missions_arry, [0,0,0], [], 0, "FORM"];
	_unit moveInCargo (_BMP_delivery_explousion_2 select 0);
};

for "_i" from 0 to ((_BMP_delivery_explousion_3 select 0) emptyPositions "cargo") - 1 do 
{
	_unit = group ((_BMP_delivery_explousion_3 select 1)select 0) createUnit [selectRandom inf_missions_arry, [0,0,0], [], 0, "FORM"];
	_unit moveInCargo (_BMP_delivery_explousion_3 select 0);
};

for "_i" from 0 to ((_BMP_delivery_explousion_4 select 0) emptyPositions "cargo") - 1 do 
{
	_unit = group ((_BMP_delivery_explousion_4 select 1)select 0) createUnit [selectRandom inf_missions_arry, [0,0,0], [], 0, "FORM"];
	_unit moveInCargo (_BMP_delivery_explousion_4 select 0);
};

for "_i" from 0 to ((_BMP_delivery_explousion_5 select 0) emptyPositions "cargo") - 1 do 
{
	_unit = group ((_BMP_delivery_explousion_5 select 1)select 0) createUnit [selectRandom inf_missions_arry, [0,0,0], [], 0, "FORM"];
	_unit moveInCargo (_BMP_delivery_explousion_5 select 0);
};

for "_i" from 0 to ((_BMP_delivery_explousion_6 select 0) emptyPositions "cargo") - 1 do 
{
	_unit = group ((_BMP_delivery_explousion_6 select 1)select 0) createUnit [selectRandom inf_missions_arry, [0,0,0], [], 0, "FORM"];
	_unit moveInCargo (_BMP_delivery_explousion_6 select 0);
};
*/

// script convoy
_handle = [ 
	arry_marker_pos, 
	[(_BMP_delivery_explousion select 0), 
	(_BMP_delivery_explousion_2 select 0),
	(_BMP_delivery_explousion_3 select 0),
	(_BMP_delivery_explousion_4 select 0),
	(_BMP_delivery_explousion_5 select 0),
	(_BMP_delivery_explousion_6 select 0)],
	40, 
	500, 
	2, 
	"NORMAL", 
	"CARELESS" 
] spawn DEVAS_ConvoyMove;

//marker from start
private _Marker8 = createMarker ["Marker8", getPos _nearestRoad];
"Marker8" setMarkerShape "Icon";
"Marker8" setMarkerType "hd_start";
"Marker8" setMarkerText "Начальная точка";


//marker from delivery
private _Marker8_1 = createMarker ["Marker8_1", getPos nearestRoad_1];
"Marker8_1" setMarkerShape "Icon";
"Marker8_1" setMarkerType "hd_flag";
"Marker8_1" setMarkerText "Конечная точка техники";


waitUntil{
	sleep 5;
	(!alive (_BMP_delivery_explousion select 0) and
	 !alive (_BMP_delivery_explousion_2 select 0) and
	  !alive (_BMP_delivery_explousion_3 select 0) and
	   !alive (_BMP_delivery_explousion_4 select 0) and
	    !alive (_BMP_delivery_explousion_5 select 0) and
		 !alive (_BMP_delivery_explousion_6 select 0)) or 
		 getPos (_BMP_delivery_explousion select 0) inArea [nearestRoad_1, 100, 100, 0, false] or
		  getPos (_BMP_delivery_explousion_2 select 0) inArea [nearestRoad_1, 100, 100, 0, false] or
		   getPos (_BMP_delivery_explousion_3 select 0) inArea [nearestRoad_1, 100, 100, 0, false] or
		    getPos (_BMP_delivery_explousion_4 select 0) inArea [nearestRoad_1, 100, 100, 0, false] or
			 getPos (_BMP_delivery_explousion_5 select 0) inArea [nearestRoad_1, 100, 100, 0, false] or
			  getPos (_BMP_delivery_explousion_6 select 0) inArea [nearestRoad_1, 100, 100, 0, false]
};

// if alive BMP
if(!alive (_BMP_delivery_explousion select 0) and
	 !alive (_BMP_delivery_explousion_2 select 0) and
	  !alive (_BMP_delivery_explousion_3 select 0) and
	   !alive (_BMP_delivery_explousion_4 select 0) and
	    !alive (_BMP_delivery_explousion_5 select 0) and
		 !alive (_BMP_delivery_explousion_6 select 0))then{
["Task_08","SUCCEEDED"] call BIS_fnc_taskSetState;
deleteMarker _Marker8_1;
deleteMarker _Marker8;
{
	deleteMarker _x
} forEach _arry_marker_pos_fom_delete;
sleep 10;
["Task_08"] call BIS_fnc_deleteTask;
choise_mission = false;
publicVariable "choise_mission";
};

//if bmp deliver to marker

["Task_08","FAILED"] call BIS_fnc_taskSetState;
deleteMarker _Marker8_1;
deleteMarker _Marker8;
{
	deleteMarker _x
} forEach _arry_marker_pos_fom_delete;
sleep 10;
["Task_08"] call BIS_fnc_deleteTask;
choise_mission = false;
publicVariable "choise_mission";


