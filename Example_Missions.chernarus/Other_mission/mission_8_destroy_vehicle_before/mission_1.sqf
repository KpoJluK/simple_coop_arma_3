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

// find path
private _agent = createAgent [typeOf player, getPos _nearestRoad, [], 0, "NONE"];
private _car = "B_Quadbike_01_F" createVehicle getPos _nearestRoad;
_car forceFollowRoad true;
_agent moveInDriver _car;
_agent addEventHandler ["PathCalculated",
{ 
	{ 	
			if(_forEachIndex < 50 or (_forEachIndex mod 50 == 0))then{
			private _marker = createMarker ["Pos_convoy_" + str _forEachIndex, _x];
			_marker setMarkerType "mil_dot";
			_marker setMarkerAlpha 0.5;
			arry_marker_pos pushBack _marker;
			};
		
	} 
	forEach (_this select 1);
}];

_agent setDestination [randomLoacation_1, "LEADER PLANNED", true];

sleep 5;

deleteVehicle _agent;
deleteVehicle _car;


//task
["Task_08", true, ["Уничтожить технику пока она не добралась до места назначения","Уничтожить технику пока она не добралась до места назначения","respawn_west"], getmarkerPos "Pos_convoy_45", "CREATED", 5, true, true, "kill", true] call BIS_fnc_setTask;



//Vehicle
private _BMP_delivery_explousion = [getmarkerPos "Pos_convoy_45", 180,selectRandom arry_class_name_vehicle_first_in_convoy, enemy_side] call BIS_fnc_spawnVehicle;

private _BMP_delivery_explousion_2 = [getmarkerPos "Pos_convoy_40", 180,selectRandom arry_class_name_vehicle_second_in_convoy, enemy_side] call BIS_fnc_spawnVehicle;

private _BMP_delivery_explousion_3 = [getmarkerPos "Pos_convoy_35", 180,selectRandom arry_class_name_vehicle_third_in_convoy, enemy_side] call BIS_fnc_spawnVehicle;

private _BMP_delivery_explousion_4 = [getmarkerPos "Pos_convoy_20", 180,selectRandom arry_class_name_vehicle_four_in_convoy, enemy_side] call BIS_fnc_spawnVehicle;

private _BMP_delivery_explousion_5 = [getmarkerPos "Pos_convoy_10", 180,selectRandom arry_class_name_vehicle_five_in_convoy, enemy_side] call BIS_fnc_spawnVehicle;

private _BMP_delivery_explousion_6 = [getmarkerPos "Pos_convoy_0", 180,selectRandom arry_class_name_vehicle_six_in_convoy, enemy_side] call BIS_fnc_spawnVehicle;

arry_marker_pos deleteRange [0, 50];

for "_i" from 0 to ((_BMP_delivery_explousion_2 select 0) emptyPositions "cargo") - 1 do 
{
	_unit = group ((_BMP_delivery_explousion_2 select 1)select 0) createUnit [selectRandom inf_missions_arry, [0,0,0], [], 0, "FORM"];
	_unit moveInAny (_BMP_delivery_explousion_2 select 0);
};

for "_i" from 0 to ((_BMP_delivery_explousion_4 select 0) emptyPositions "cargo") - 1 do 
{
	_unit = group ((_BMP_delivery_explousion_4 select 1)select 0) createUnit [selectRandom inf_missions_arry, [0,0,0], [], 0, "FORM"];
	_unit moveInAny (_BMP_delivery_explousion_4 select 0);
};

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
		  getPos (_BMP_delivery_explousion select 0) inArea [nearestRoad_1, 100, 100, 0, false] or
		   getPos (_BMP_delivery_explousion select 0) inArea [nearestRoad_1, 100, 100, 0, false] or
		    getPos (_BMP_delivery_explousion select 0) inArea [nearestRoad_1, 100, 100, 0, false] or
			 getPos (_BMP_delivery_explousion select 0) inArea [nearestRoad_1, 100, 100, 0, false] or
			  getPos (_BMP_delivery_explousion select 0) inArea [nearestRoad_1, 100, 100, 0, false]
};

// if alive BMP
if(!alive (_BMP_delivery_explousion select 0))then{
["Task_08","SUCCEEDED"] call BIS_fnc_taskSetState;
deleteMarker _Marker8_1;
deleteMarker _Marker8;
sleep 10;
["Task_08"] call BIS_fnc_deleteTask;
choise_mission = false;
publicVariable "choise_mission";
};

//if bmp deliver to marker
if((getPos (_BMP_delivery_explousion select 0)) inArea [nearestRoad_1, 100, 100, 0, false]) then{
["Task_08","SUCCEEDED"] call BIS_fnc_taskSetState;
deleteMarker _Marker8_1;
deleteMarker _Marker8;
sleep 10;
["Task_08"] call BIS_fnc_deleteTask;
deleteVehicle (_BMP_delivery_explousion select 0);
{(_BMP_delivery_explousion select 0) deleteVehicleCrew _x} foreach crew (_BMP_delivery_explousion select 0);
deleteVehicle (_BMP_delivery_explousion_1 select 0);
{(_BMP_delivery_explousion_1 select 0) deleteVehicleCrew _x} foreach crew (_BMP_delivery_explousion_1 select 0);


choise_mission = false;
publicVariable "choise_mission";
};


