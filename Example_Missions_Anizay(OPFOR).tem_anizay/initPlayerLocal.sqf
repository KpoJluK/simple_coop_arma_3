waitUntil {!isNull (finddisplay 46)};

player addEventHandler [
	"Killed",
	{
		[player, [missionNamespace, "Inventory_on_death"]] call BIS_fnc_saveInventory;
		removeAllActions player;
		true
	}
];

player addEventHandler [
	"Respawn",
	{	
		player addAction
		[
			"<t color='#00ff22'>Меню игрока</t>",	// title
			{			
				createDialog 'Dialog_Player_general';
				waitUntil{
					ctrlSetText [1908, str (sliderPosition 1900)]; 
					ctrlSetText [1909, str (sliderPosition 1901)]; 
					ctrlSetText [1910, str (sliderPosition 1902)]; 
					!dialog
				};
			},
			nil,		// arguments
			1,		// priority
			true,		// showWindow
			false,		// hideOnUse
			"",			// shortcut
			"true", 	// condition
			0,			// radius
			false,		// unconscious
			"",			// selection
			""			// memoryPoint
		];
		if(isNil {[player, [missionNamespace, "player_saves_Inventory"]] call BIS_fnc_loadInventory})then{
			[player, [missionNamespace, "Inventory_on_death"]] call BIS_fnc_loadInventory;
		}else{
			[player, [missionNamespace, "player_saves_Inventory"]] call BIS_fnc_loadInventory;
		};
		true
	}
];


waitUntil{
	!isNil {Ready_enemy}
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
	1,													// action duration in seconds
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
	1,													// action duration in seconds
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
	1,													// action duration in seconds
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
	1,													// action duration in seconds
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
	0.5,													
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
	0.5,													
	0,													
	false,												
	false												
	] call BIS_fnc_holdActionAdd;

};


// bis arsenal
if!(isClass (configFile >> "CfgPatches" >> "ace_main"))then{
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
		0.5,													
		0,													
		false,												
		false												
	] call BIS_fnc_holdActionAdd;
};

if!(isClass (configFile >> "CfgPatches" >> "ace_main"))then{
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
		0.5,													
		0,													
		false,												
		false												
	] call BIS_fnc_holdActionAdd;
};