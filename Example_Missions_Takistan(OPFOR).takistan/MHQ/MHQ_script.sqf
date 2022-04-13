
// В модуль возрождения теники в параметр при возрождении- []call fnc_if_destroy_MHQ
// В обьект для телепортирования - this addAction ["Teleport", "[]call fnc_teleport"];
// Название кшм - MHQ_1


// MHQ






// deploy_mhq

fnc_add_action_to_mhq = {

	[[], {	removeAllActions MHQ_1	}] remoteExec ["call"];

	[
		MHQ_1,											// object the action is attached to
		"<t color='#2eff5b'>Разложить КШМ</t>",										// Title of the action
		"\a3\data_f_destroyer\data\UI\IGUI\Cfg\holdactions\holdAction_loadVehicle_ca.paa",	// Idle icon shown on screen
		"\a3\data_f_destroyer\data\UI\IGUI\Cfg\holdactions\holdAction_loadVehicle_ca.paa",	// Progress icon shown on screen
		"_this distance _target < 5",						// Condition for the action to be shown
		"_caller distance _target < 5",						// Condition for the action to progress
		{},													// Code executed when action starts
		{},													// Code executed on every progress tick
		{		
			[]call fnc_romove_action_to_mhq;				
			teleport1 = true;
			publicVariable "teleport1";
			[MHQ_1, -1] call ace_cargo_fnc_setSize;
		},				// Code executed on completion
		{},													// Code executed on interrupted
		[],													// Arguments passed to the scripts as _this select 3
		5,													// action duration in seconds
		0,													// priority
		true,												// Remove on completion
		false												// Show in unconscious state
	] remoteExec ["BIS_fnc_holdActionAdd", 0, MHQ_1];	// MP compatible implementation

};

// Remove MHQ

fnc_romove_action_to_mhq = {

	[[], {	removeAllActions MHQ_1	}] remoteExec ["call"];

	[
		MHQ_1,											// object the action is attached to
		"<t color='#ff2e2e'>Сложить КШМ</t>",										// Title of the action
		"\a3\data_f_destroyer\data\UI\IGUI\Cfg\holdactions\holdAction_unloadVehicle_ca.paa",	// Idle icon shown on screen
		"\a3\data_f_destroyer\data\UI\IGUI\Cfg\holdactions\holdAction_unloadVehicle_ca.paa",	// Progress icon shown on screen
		"_this distance _target < 5",						// Condition for the action to be shown
		"_caller distance _target < 5",						// Condition for the action to progress
		{},													// Code executed when action starts
		{},													// Code executed on every progress tick
		{	
			[]call fnc_add_action_to_mhq;
			teleport1 = false;
			publicVariable "teleport1";
			[MHQ_1, 1] call ace_cargo_fnc_setSize;
		},				// Code executed on completion
		{},													// Code executed on interrupted
		[],													// Arguments passed to the scripts as _this select 3
		5,													// action duration in seconds
		0,													// priority
		true,												// Remove on completion
		false												// Show in unconscious state
	] remoteExec ["BIS_fnc_holdActionAdd", 0, MHQ_1];	// MP compatible implementation

};


// teleport to MHQ

fnc_teleport = {

	if (teleport1)then{
		[5, [], {
		player setPos(MHQ_1 getPos [selectRandom [6,7,8,9],45]);
		},
		{["Перемещение отменено", true, 5, 2] call ace_common_fnc_displayText;
		}, "Перемещение к КШМ"] call ace_common_fnc_progressBar;
	}
		else{["КШМ не развернута!", true, 5, 2] call ace_common_fnc_displayText;
	};

};

publicVariable "fnc_add_action_to_mhq";
publicVariable "fnc_romove_action_to_mhq";
publicVariable "fnc_teleport";

Teleport_mhq = True;

0 spawn{
	waitUntil{
		MHQ_1 = "Land_TentDome_F" createVehicle pos_base;
		[MHQ_1, 1] call ace_cargo_fnc_setSize;
		publicVariable "MHQ_1";

		[]call fnc_add_action_to_mhq;

		waitUntil{
			sleep 5;
			!alive MHQ_1 or isNil {MHQ_1}
		};

		deleteVehicle MHQ_1;

		teleport1 = false;
		publicVariable "teleport1";

		!Teleport_mhq
	};
};

