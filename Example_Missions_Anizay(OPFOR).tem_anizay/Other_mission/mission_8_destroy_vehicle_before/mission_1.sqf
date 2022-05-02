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
_agent allowDamage false;
private _car = "B_Quadbike_01_F" createVehicle getPos _nearestRoad;
_car allowDamage false;
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
BMP_delivery_explousion = selectRandom car_mission_arry createVehicle getmarkerPos "Pos_convoy_45";
createVehicleCrew BMP_delivery_explousion;

BMP_delivery_explousion_2 = selectRandom car_mission_arry createVehicle getmarkerPos "Pos_convoy_42";
createVehicleCrew BMP_delivery_explousion_2;

BMP_delivery_explousion_3 = selectRandom car_mission_arry createVehicle getmarkerPos "Pos_convoy_40";
createVehicleCrew BMP_delivery_explousion_3;

BMP_delivery_explousion_4 = selectRandom car_mission_arry createVehicle getmarkerPos "Pos_convoy_35";
createVehicleCrew BMP_delivery_explousion_4;

BMP_delivery_explousion_5 = selectRandom car_mission_arry createVehicle getmarkerPos "Pos_convoy_25";
createVehicleCrew BMP_delivery_explousion_5;

BMP_delivery_explousion_6 = selectRandom car_mission_arry createVehicle getmarkerPos "Pos_convoy_0";
createVehicleCrew BMP_delivery_explousion_6;


arry_marker_pos deleteRange [0, 50];


for "_i" from 0 to (BMP_delivery_explousion emptyPositions "cargo") - 1 do 
{
	_unit = group(selectRandom(units(BMP_delivery_explousion))) createUnit [selectRandom inf_missions_arry, [0,0,0], [], 0, "FORM"];
	_unit moveInCargo BMP_delivery_explousion;
};

for "_i" from 0 to (BMP_delivery_explousion_2  emptyPositions "cargo") - 1 do 
{
	_unit = group(selectRandom(units(BMP_delivery_explousion_2))) createUnit [selectRandom inf_missions_arry, [0,0,0], [], 0, "FORM"];
	_unit moveInCargo BMP_delivery_explousion_2;
};

for "_i" from 0 to (BMP_delivery_explousion_3  emptyPositions "cargo") - 1 do 
{
	_unit = group(selectRandom(units(BMP_delivery_explousion_3))) createUnit [selectRandom inf_missions_arry, [0,0,0], [], 0, "FORM"];
	_unit moveInCargo BMP_delivery_explousion_3;
};

for "_i" from 0 to (BMP_delivery_explousion_4  emptyPositions "cargo") - 1 do 
{
	_unit = group(selectRandom(units(BMP_delivery_explousion_4))) createUnit [selectRandom inf_missions_arry, [0,0,0], [], 0, "FORM"];
	_unit moveInCargo BMP_delivery_explousion_4;
};

for "_i" from 0 to (BMP_delivery_explousion_5  emptyPositions "cargo") - 1 do 
{
	_unit = group(selectRandom(units(BMP_delivery_explousion_5))) createUnit [selectRandom inf_missions_arry, [0,0,0], [], 0, "FORM"];
	_unit moveInCargo BMP_delivery_explousion_5;
};

for "_i" from 0 to (BMP_delivery_explousion_6  emptyPositions "cargo") - 1 do 
{
	_unit = group(selectRandom(units(BMP_delivery_explousion_6))) createUnit [selectRandom inf_missions_arry, [0,0,0], [], 0, "FORM"];
	_unit moveInCargo BMP_delivery_explousion_6;
};


// script convoy
_handle = [ 
	arry_marker_pos, 
	[
		BMP_delivery_explousion, 
		BMP_delivery_explousion_2,
		BMP_delivery_explousion_3,
		BMP_delivery_explousion_4,
		BMP_delivery_explousion_5,
		BMP_delivery_explousion_6 
	],
	40, 
	200, 
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
	(!alive BMP_delivery_explousion  and
	 !alive BMP_delivery_explousion_2  and
	  !alive BMP_delivery_explousion_3  and
	   !alive BMP_delivery_explousion_4  and
	    !alive BMP_delivery_explousion_5  and
		 !alive BMP_delivery_explousion_6 ) or 
		 getPos BMP_delivery_explousion  inArea [nearestRoad_1, 100, 100, 0, false] or
		  getPos BMP_delivery_explousion_2  inArea [nearestRoad_1, 100, 100, 0, false] or
		   getPos BMP_delivery_explousion_3  inArea [nearestRoad_1, 100, 100, 0, false] or
		    getPos BMP_delivery_explousion_4  inArea [nearestRoad_1, 100, 100, 0, false] or
			 getPos BMP_delivery_explousion_5  inArea [nearestRoad_1, 100, 100, 0, false] or
			  getPos BMP_delivery_explousion_6  inArea [nearestRoad_1, 100, 100, 0, false]
};

// if alive BMP
if(!alive BMP_delivery_explousion  and
	 !alive BMP_delivery_explousion_2  and
	  !alive BMP_delivery_explousion_3  and
	   !alive BMP_delivery_explousion_4  and
	    !alive BMP_delivery_explousion_5  and
		 !alive BMP_delivery_explousion_6 )then{
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


