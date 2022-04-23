params ["_pos_mission","_side"];

// create c130
_C_130 = "C130J_wreck_EP1" createVehicle _pos_mission;
// create container
kontainer_for_mission_rabbit = "CBRNContainer_01_closed_yellow_F" createVehicle _pos_mission;
kontainer_for_mission_rabbit attachTo [_C_130, [0, -7, -4]]; 
publicVariable "kontainer_for_mission_rabbit";
// create action
[[], {
	_action_1 = ["TestAction 1","<t color='#ff2e2e'>Уничтожить образцы</t>","",{
		deleteVehicle kontainer_for_mission_rabbit
	},{true}] call ace_interact_menu_fnc_createAction;  
	[kontainer_for_mission_rabbit, 0, ["ACE_MainActions"], _action_1] call ace_interact_menu_fnc_addActionToObject;
}] remoteExec ["call"];

// create task
["Task_13", true, ["Уничтожить образцы хим оружия","Уничтожить образцы хим оружия","respawn_west"], getPos _C_130, "CREATED", 5, true, true, "search", true] call BIS_fnc_setTask;

// create bmk
_pos_mission set [2,0];

private _lodka_1 = [_pos_mission, 180, selectRandom arry_class_names_boats, enemy_side] call BIS_fnc_spawnVehicle;
[group ((_lodka_1 select 1) select 0), getPos (_lodka_1 select 0), 200] call bis_fnc_taskPatrol;

_pos_mission set [0,(_pos_mission select 0) + random [-100,0,100]];
_pos_mission set [1,(_pos_mission select 1) + random [-100,0,100]];

private _lodka_1 = [_pos_mission, 180, selectRandom arry_class_names_boats, enemy_side] call BIS_fnc_spawnVehicle;
[group ((_lodka_1 select 1) select 0), getPos (_lodka_1 select 0), 200] call bis_fnc_taskPatrol;

_pos_mission set [0,(_pos_mission select 0) + random [-100,0,100]];
_pos_mission set [1,(_pos_mission select 1) + random [-100,0,100]];

private _lodka_1 = [_pos_mission, 180, selectRandom arry_class_names_boats, enemy_side] call BIS_fnc_spawnVehicle;
[group ((_lodka_1 select 1) select 0), getPos (_lodka_1 select 0), 200] call bis_fnc_taskPatrol;

waitUntil{
	sleep 5;
	!alive kontainer_for_mission_rabbit
};

["Task_13","SUCCEEDED"] call BIS_fnc_taskSetState;
sleep 10; 
["Task_13"] call BIS_fnc_deleteTask;


choise_mission = false;
publicVariable "choise_mission";

sleep 300;

deleteVehicle _C_130;
