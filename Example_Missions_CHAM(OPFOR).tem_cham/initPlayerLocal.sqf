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
		[player, [missionNamespace, "playerInventory"]] call BIS_fnc_saveInventory;
		true
	}
];

player addEventHandler [
	"Respawn",
	{	
		player addAction ["<t color='#00ff22'>Меню игрока</t>",
			"0 spawn{ 
			createDialog 'Dialog_Player_general'; 
			while {dialog} do { 
			ctrlSetText [1908, str (sliderPosition 1900)]; 
			ctrlSetText [1909, str (sliderPosition 1901)]; 
			ctrlSetText [1910, str (sliderPosition 1902)]; 
			sleep 1; 
			};
			};"
			];
		[player, [missionNamespace, "playerInventory"]] call BIS_fnc_loadInventory;
		true
	}
];

