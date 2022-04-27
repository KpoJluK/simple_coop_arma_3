//exeple
// [pos_mission,heli_classname,side_heli,distanse_patryle] execVM "${somepath\file.sqf}";

	// 	pos_mission - aryy ccordinate
	// 	heli_classname - class name of tant need to destroid
	// 	side_heli - side heli(east west or independent)
	// 	distanse_patryle - radiys patyl heli(m)

// done example
// [[200,200,0],"rhsgref_cdf_Mi24D_early",EAST,1500] execVM "modules\spec_other_missions\mission_2\mission_1.sqf";

//param
params ["_pos_mission", "_heli_classname", "_side_heli","_distanse_patryle"];

//heli
private _Heli_1 = [_pos_mission, 180, _heli_classname, _side_heli] call BIS_fnc_spawnVehicle;
//mission
["Task_02", true, ["Уничтожить вертолет","Уничтожить вертолет","respawn_west"], getPos(_Heli_1 select 0), "ASSIGNED", 5, true, true, "target", true] call BIS_fnc_setTask;
//patrol
[(_Heli_1 select 2), getPos (_Heli_1 select 0), _distanse_patryle] call bis_fnc_taskPatrol;
//marker
private _marker1 = createMarker ["Marker1", getPos (_Heli_1 select 0)];
"Marker1" setMarkerShape "ELLIPSE";
"Marker1" setMarkerSize [_distanse_patryle, _distanse_patryle];
"Marker1" setMarkerColor "ColorBlack";
"Marker1" setMarkerBrush "Cross";
//wait heli desroyd
waitUntil{
	sleep 10;
	!alive (_Heli_1 select 0)
};

["Task_02","SUCCEEDED"] call BIS_fnc_taskSetState;
deleteMarker _marker1;
sleep 10;
["Task_02"] call BIS_fnc_deleteTask;

choise_mission = false;
publicVariable "choise_mission";