//exeple
// [pos_mission,vehicle_to_recwest,vehocle_classname_arry,pos_base] execVM "${somepath\file.sqf}";

	// 	pos_mission - aryy ccordinate
	//	vehicle_to_recwest - vehicle to need destroy
	// 	vehocle_classname_arry - class name vehicle in colonna
	// 	pos_base - pos base to need delivery MHQ

// done example
// [[200,200,0],"rhsusf_m1152_sicps_usarmy_d",["rhsusf_m1025_d_m2", "rhsusf_M1117_D", "rhsusf_m113d_usarmy"],[1000,1000,0]] execVM "modules\spec_other_missions\mission_5\mission_1.sqf";

//param
params ["_pos_mission", "_vehicle_to_recwest", "_vehocle_classname_arry", "_pos_base"];

private _Vehicle = _vehicle_to_recwest createVehicle (_pos_mission getPos [80 + random [-50,0,50],random 360]);

//vehicle
_vehicle_arry = [];

for "_i" from 0 to 3 do 
{
	private _Vehicle = selectRandom _vehocle_classname_arry createVehicle (_pos_mission getPos [80 + random [-50,0,50],random 360]);
	_vehicle_arry pushBack _Vehicle;
	sleep 1;
};

{
	_x setDamage 0.4 + random 0.4;
} forEach _vehicle_arry;

{
	_x setVehicleAmmo random 1;
} forEach _vehicle_arry;

{
	_x setFuel random 1;
} forEach _vehicle_arry;


//marker
private _Marker5 = createMarker ["Marker5", _Vehicle getPos [random 300, random 360]];
"Marker5" setMarkerShape "ELLIPSE";
"Marker5" setMarkerSize [300, 300];
"Marker5" setMarkerColor "ColorBlack";
"Marker5" setMarkerBrush "Cross";

//task
["Task_05", true, ["Уничтожить ценный груз пока он не попал в руки врага","Уничтожить ценный груз","respawn_west"], getMarkerPos _Marker5, "CREATED", 5, true, true, "destroy", true] call BIS_fnc_setTask;
//bot
[
	_Vehicle getPos [30, random 360],	// массив координатов где будет центр здания

	ienemy_side,	// сторона ботов можнт быть: EAST, WEST, independent
	0.8, // уровень скила ботов (значение от 0.1 до 1)
	inf_missions_arry,
	car_mission_arry,
	hevy_vehicle_arry,
	anti_air_vehicle_arry,
	heli_vehecle_arry,
	static_weapon_arry,
	300, // радиус (от центра) размещения статичных орудий(м)
	3 + count allPlayers, // количество статичных орудий
	2 + count allPlayers,	// количество легких машин которые будут патрулировать зону
	1 + count allPlayers,	// количество тяжолой техники которая будует патрулировать зону
	1 + count allPlayers,	// количество самоходных зенитныйх установок которые будут патрулировать зону
	random 1,	//	количество вертолетов которые будут патрулировать зону
	4 + count allPlayers,	// количество групп ботов которые будет охранять зону
	3,	//	количество ботов в группах которые будут охранять зону
	false,	// спаунить ли ботов на крышах домов
	100, // радиус поиска домов внутри которых будут боты(на крышах и внутри)
	30,	// шанс появления бота в здании(на крыше) в % от 0 до 100
	false, // создавать ли ботов внутри зданий
	30, // шанс появления бота в каждой позиции в здании в % от 0 до 100
	3000, // радиус активации игроком
	200,	// радиус патрулирования ботов
	500,	// радиус размещения легких машин которые будут патрулировать зону(чем больше машин тем больше зону лучше сделать)
	600,	// радиус патрулирования всех машин и легких танков
	1000,	// радиус патрулирования вертолетов
	true, // включать ли ботам динамическую симуляцию?
	false	// условик при котром боты будут удалены(УСЛОВИК ДОЛЖНО БЫТЬ ГЛОБАЛЬНО!!!)
] execVM "Other_mission\Shared\fn_other_missions_spawnEnemyBot.sqf";

//wait prp on base or destroid
waitUntil{
sleep 10;
!alive _Vehicle
};

deleteMarker _Marker5;
["Task_05","SUCCEEDED"] call BIS_fnc_taskSetState;
sleep 10;
["Task_05"] call BIS_fnc_deleteTask;



choise_mission = false;
publicVariable "choise_mission";