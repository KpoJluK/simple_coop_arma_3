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




_arry_vehicle_convoy = [];

_arry_vehicle_convoy append car_mission_arry;

if!((hevy_vehicle_arry select 0) isEqualTo str objNull)then{

	_arry_vehicle_convoy append hevy_vehicle_arry;

};

//Vehicle
_Vehicle_name_arry = [];
_vehicle_convoy = selectRandom car_mission_arry;
_vehicle_convoy_2 = selectRandom _arry_vehicle_convoy;
_vehicle_convoy_3 = selectRandom _arry_vehicle_convoy;
_vehicle_convoy_4 = selectRandom _arry_vehicle_convoy;
_vehicle_convoy_5 = selectRandom _arry_vehicle_convoy;
_vehicle_convoy_6 = selectRandom _arry_vehicle_convoy;

_Vehicle_name_arry append [_vehicle_convoy];
_Vehicle_name_arry append [_vehicle_convoy_2];
_Vehicle_name_arry append [_vehicle_convoy_3];
_Vehicle_name_arry append [_vehicle_convoy_4];
_Vehicle_name_arry append [_vehicle_convoy_5];
_Vehicle_name_arry append [_vehicle_convoy_6];

BMP_delivery_explousion = _vehicle_convoy createVehicle getmarkerPos "Pos_convoy_50";
createVehicleCrew BMP_delivery_explousion;

BMP_delivery_explousion_2 = _vehicle_convoy_2 createVehicle getmarkerPos "Pos_convoy_46";
createVehicleCrew BMP_delivery_explousion_2;

BMP_delivery_explousion_3 = _vehicle_convoy_3 createVehicle getmarkerPos "Pos_convoy_42";
createVehicleCrew BMP_delivery_explousion_3;

BMP_delivery_explousion_4 = _vehicle_convoy_4 createVehicle getmarkerPos "Pos_convoy_30";
createVehicleCrew BMP_delivery_explousion_4;

BMP_delivery_explousion_5 = _vehicle_convoy_5 createVehicle getmarkerPos "Pos_convoy_20";
createVehicleCrew BMP_delivery_explousion_5;

BMP_delivery_explousion_6 = _vehicle_convoy_6 createVehicle getmarkerPos "Pos_convoy_0";
createVehicleCrew BMP_delivery_explousion_6;

// add desant

for "_i" from 0 to floor(BMP_delivery_explousion emptyPositions "cargo") /2 do 
{
	_unit = group(selectRandom(units(BMP_delivery_explousion))) createUnit [selectRandom inf_missions_arry, [0,0,0], [], 0, "FORM"];
	_unit moveInCargo BMP_delivery_explousion;
};

for "_i" from 0 to floor(BMP_delivery_explousion_2  emptyPositions "cargo") /2 do 
{
	_unit = group(selectRandom(units(BMP_delivery_explousion_2))) createUnit [selectRandom inf_missions_arry, [0,0,0], [], 0, "FORM"];
	_unit moveInCargo BMP_delivery_explousion_2;
};

for "_i" from 0 to floor(BMP_delivery_explousion_3  emptyPositions "cargo") /2 do 
{
	_unit = group(selectRandom(units(BMP_delivery_explousion_3))) createUnit [selectRandom inf_missions_arry, [0,0,0], [], 0, "FORM"];
	_unit moveInCargo BMP_delivery_explousion_3;
};

for "_i" from 0 to floor(BMP_delivery_explousion_4  emptyPositions "cargo") /2 do 
{
	_unit = group(selectRandom(units(BMP_delivery_explousion_4))) createUnit [selectRandom inf_missions_arry, [0,0,0], [], 0, "FORM"];
	_unit moveInCargo BMP_delivery_explousion_4;
};

for "_i" from 0 to floor(BMP_delivery_explousion_5  emptyPositions "cargo") /2 do 
{
	_unit = group(selectRandom(units(BMP_delivery_explousion_5))) createUnit [selectRandom inf_missions_arry, [0,0,0], [], 0, "FORM"];
	_unit moveInCargo BMP_delivery_explousion_5;
};

for "_i" from 0 to floor(BMP_delivery_explousion_6  emptyPositions "cargo") /2 do 
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
	300, 
	120, 
	"NORMAL", 
	"CARELESS" 
] spawn DEVAS_ConvoyMove;

// if car not move

_pos = getPos BMP_delivery_explousion;
_pos_2 = getPos BMP_delivery_explousion_2;
_pos_3 = getPos BMP_delivery_explousion_3;
_pos_4 = getPos BMP_delivery_explousion_4;
_pos_5 = getPos BMP_delivery_explousion_5;
_pos_6 = getPos BMP_delivery_explousion_6;
sleep 20;
if(getPos BMP_delivery_explousion inArea [_pos, 5, 5, 45, false])then{_Vehicle_name_arry - [_vehicle_convoy]};
if(getPos BMP_delivery_explousion_2 inArea [_pos_2, 5, 5, 45, false])then{_Vehicle_name_arry - [_vehicle_convoy_2]};
if(getPos BMP_delivery_explousion_3 inArea [_pos_3, 5, 5, 45, false])then{_Vehicle_name_arry - [_vehicle_convoy_3]};
if(getPos BMP_delivery_explousion_4 inArea [_pos_4, 5, 5, 45, false])then{_Vehicle_name_arry - [_vehicle_convoy_4]};
if(getPos BMP_delivery_explousion_5 inArea [_pos_5, 5, 5, 45, false])then{_Vehicle_name_arry - [_vehicle_convoy_5]};
if(getPos BMP_delivery_explousion_6 inArea [_pos_6, 5, 5, 45, false])then{_Vehicle_name_arry - [_vehicle_convoy_6]};

sleep 2;
deleteVehicleCrew BMP_delivery_explousion;
deleteVehicleCrew BMP_delivery_explousion_2;
deleteVehicleCrew BMP_delivery_explousion_3;
deleteVehicleCrew BMP_delivery_explousion_4;
deleteVehicleCrew BMP_delivery_explousion_5;
deleteVehicleCrew BMP_delivery_explousion_6;
deleteVehicle BMP_delivery_explousion;
deleteVehicle BMP_delivery_explousion_2;
deleteVehicle BMP_delivery_explousion_3;
deleteVehicle BMP_delivery_explousion_4;
deleteVehicle BMP_delivery_explousion_5;
deleteVehicle BMP_delivery_explousion_6;

sleep 5;

// restart convoy


BMP_delivery_explousion = selectRandom _Vehicle_name_arry createVehicle getmarkerPos "Pos_convoy_50";
createVehicleCrew BMP_delivery_explousion;

BMP_delivery_explousion_2 = selectRandom _Vehicle_name_arry createVehicle getmarkerPos "Pos_convoy_46";
createVehicleCrew BMP_delivery_explousion_2;

BMP_delivery_explousion_3 = selectRandom _Vehicle_name_arry createVehicle getmarkerPos "Pos_convoy_42";
createVehicleCrew BMP_delivery_explousion_3;

BMP_delivery_explousion_4 = selectRandom _Vehicle_name_arry createVehicle getmarkerPos "Pos_convoy_30";
createVehicleCrew BMP_delivery_explousion_4;

BMP_delivery_explousion_5 = selectRandom _Vehicle_name_arry createVehicle getmarkerPos "Pos_convoy_20";
createVehicleCrew BMP_delivery_explousion_5;

BMP_delivery_explousion_6 = selectRandom _Vehicle_name_arry createVehicle getmarkerPos "Pos_convoy_0";
createVehicleCrew BMP_delivery_explousion_6;


for "_i" from 0 to floor(BMP_delivery_explousion emptyPositions "cargo") /2 do 
{
	_unit = group(selectRandom(units(BMP_delivery_explousion))) createUnit [selectRandom inf_missions_arry, [0,0,0], [], 0, "FORM"];
	_unit moveInCargo BMP_delivery_explousion;
};

for "_i" from 0 to floor(BMP_delivery_explousion_2  emptyPositions "cargo") /2 do 
{
	_unit = group(selectRandom(units(BMP_delivery_explousion_2))) createUnit [selectRandom inf_missions_arry, [0,0,0], [], 0, "FORM"];
	_unit moveInCargo BMP_delivery_explousion_2;
};

for "_i" from 0 to floor(BMP_delivery_explousion_3  emptyPositions "cargo") /2 do 
{
	_unit = group(selectRandom(units(BMP_delivery_explousion_3))) createUnit [selectRandom inf_missions_arry, [0,0,0], [], 0, "FORM"];
	_unit moveInCargo BMP_delivery_explousion_3;
};

for "_i" from 0 to floor(BMP_delivery_explousion_4  emptyPositions "cargo") /2 do 
{
	_unit = group(selectRandom(units(BMP_delivery_explousion_4))) createUnit [selectRandom inf_missions_arry, [0,0,0], [], 0, "FORM"];
	_unit moveInCargo BMP_delivery_explousion_4;
};

for "_i" from 0 to floor(BMP_delivery_explousion_5  emptyPositions "cargo") /2 do 
{
	_unit = group(selectRandom(units(BMP_delivery_explousion_5))) createUnit [selectRandom inf_missions_arry, [0,0,0], [], 0, "FORM"];
	_unit moveInCargo BMP_delivery_explousion_5;
};

for "_i" from 0 to floor(BMP_delivery_explousion_6  emptyPositions "cargo") /2 do 
{
	_unit = group(selectRandom(units(BMP_delivery_explousion_6))) createUnit [selectRandom inf_missions_arry, [0,0,0], [], 0, "FORM"];
	_unit moveInCargo BMP_delivery_explousion_6;
};

for "_i" from 0 to 49 do 
{
deleteMarker (arry_marker_pos select _i);
};
arry_marker_pos deleteRange [0, 50];

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
	300, 
	120, 
	"NORMAL", 
	"CARELESS" 
] spawn DEVAS_ConvoyMove;

//task
["Task_08", true, ["Уничтожить технику пока она не добралась до места назначения","Уничтожить технику пока она не добралась до места назначения","respawn_west"], getmarkerPos "Pos_convoy_45", "CREATED", 5, true, true, "kill", true] call BIS_fnc_setTask;


[]spawn{
	waitUntil{
		_pos_mission = [];
		if(alive BMP_delivery_explousion)then{_pos_mission = getPos BMP_delivery_explousion}else{
			if(alive BMP_delivery_explousion_2)then{_pos_mission = getPos BMP_delivery_explousion_2}else{
				if(alive BMP_delivery_explousion_3)then{_pos_mission = getPos BMP_delivery_explousion_3}else{
					if(alive BMP_delivery_explousion_4)then{_pos_mission = getPos BMP_delivery_explousion_4}else{
						if(alive BMP_delivery_explousion_5)then{_pos_mission = getPos BMP_delivery_explousion_5}else{
							if(alive BMP_delivery_explousion_6)then{_pos_mission = getPos BMP_delivery_explousion_6}
						};
					};
				};
			};
		};
		[
			"Task_08",
			_pos_mission
		] call BIS_fnc_taskSetDestination;
		sleep 5;
		["Task_08"] call BIS_fnc_taskState isEqualTo ""
	}
};

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


