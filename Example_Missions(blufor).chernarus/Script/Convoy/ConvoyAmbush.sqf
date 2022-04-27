// ConvoyAmbush.sqf
// © v.2.5 MARCH 2016 - Devastator_cm

private _markerArray  		= _this select 0;
private _convoyArray  		= _this select 1;
private _groups		  		= _this select 2;
private _arm_groups     	= _this select 3;
private _ConvoySpeedLimit	= _this select 4;
private _ConvoySearchRange	= _this select 5;
private _ConvoyID			= _this select 6;
private _ConvoySpeedMode	= _this select 7;
private _ConvoyBehaviour	= _this select 8;
private _arm_vehicles		= _this select 9;
private _all_units     	 	= [];
private _enemy_found 		= true;
private _stop_search    	= false;
private _enemy 				= objNull;
private _d					= 1;
private _groupsNotNull		= [];
private _aliveConvoy		= [];
private _posEnemy   		= [];
private _units				= [];
private _all_enemies    	= [];
private _Enemy_Eval      	= [];
private _inf_units			= [];
private _side 				= side (_groups select 0);
private _group 				= objNull;
private _enemies 			= [];
private _random_enemy 		= objNull;
private _enemySides			= [];
private _unit 				= objNull;
private _vehicle 			= objNull;
private _i                  = 0;
private _enemySides 		= leader (_groups select 0) call BIS_fnc_enemySides;

while {!_stop_search} do 
{ 	
	if(!_enemy_found && !_stop_search) then {sleep random [15, 25, 40];_stop_search = true;};
    _enemy_found = false;
    _Enemy_Eval = [];
    _Enemy_Eval = +(_all_enemies select {alive _x});
    _all_enemies = [];
	for "_i" from 0 to (count _groups) - 1 step 1 do
	{
	    _group  = _groups select _i;
	    _units  = units _group;
		{	
		    _enemies 	= [];
		    _unit 	 	= _x;
		    _vehicle 	= vehicle _unit;
			_enemies 	= (_unit neartargets _ConvoySearchRange) apply {_x select 4} select {side _x in _enemySides AND {count crew _x > 0} AND typeOf _x != "Logic" AND !(_x isKindOf "Air")};
			if(!(_enemies isEqualTo [])) then 
			{
				{_all_enemies pushBackUnique _x;} 	foreach _enemies;
				_enemy_found  = true;
			   	_stop_search  = false;
			};

			if (!(_Enemy_Eval isEqualTo []) && ((_group in _arm_groups) && (_vehicle != _unit) && ((driver _vehicle) == _unit) && _d == 3)) then
			{ 
		    	_random_enemy 	= [_Enemy_Eval, _vehicle] call DEVAS_ConvoyEnemy;
		    	if (isnil "_random_enemy") exitwith {};
				_posEnemy   	= (_random_enemy getRelPos [random [1,4,8] * 10, random 360]) findEmptyPosition [0,50, typeOf _vehicle];
				while {(count (waypoints _group)) > 0} do {	deleteWaypoint ((waypoints  _group) select 0);};
				if([objNull, "IFIRE"] checkVisibility [eyePos gunner _vehicle, eyePos _random_enemy] < 0.6) then
				{
					// Following lines are for debug. It is to see to which position vehicle will move for the SaD waypoint
					//_vclPosMrkr = createMarkerLocal [format ["mrkr_%1_%2", _vehicle,_e], _posEnemy];
					//_vclPosMrkr setMarkerTextLocal format["_%1_%2", _vehicle, _e];
					//_vclPosMrkr setMarkerTypeLocal "hd_destroy"; 

					_wp =_group addWaypoint 		[_posEnemy, 0];
					_wp setWaypointBehaviour 		"COMBAT";
					_wp setWaypointCombatMode 		"RED";
					_wp setWaypointType 			"SAD";
					_wp setWaypointSpeed 			"LIMITED";
					_wp setWaypointCompletionRadius 10;
				};
			};
		}   foreach _units;
	};

	{
		if(isnull (gunner _x) || !alive (gunner _x)) then
		{
			_x limitSpeed 1;
			while {speed _x > 2} do {sleep 0.5};
			if(!isnull (Commander _x) && alive (Commander _x)) then{(Commander _x) assignAsGunner _x;};
			if(!isnull (Driver _x) && alive (Driver _x)) then{(Driver _x) assignAsGunner _x;};
			_x limitSpeed 10000;
		};
	}	foreach _arm_vehicles; 

    if (_enemy_found) then 
    {  
    	_all_units 	= [];
    	{_all_units append (units _x);} foreach _groups;
        { 
            _enemy 			 = _x;
            _max_knows_about = 0;
            {
             _knows_about_tmp = _x knowsAbout _enemy;
             if (_knows_about_tmp > _max_knows_about) then {_max_knows_about = _knows_about_tmp;};
            } foreach _all_units;
            {_x reveal [_enemy, _max_knows_about];} foreach _all_units;
        }   foreach _all_enemies; 
    };
	if (_d == 9) then {_d = 1};
	_d = _d + 1;
	sleep 5;
};

{if (alive _x && canMove _x && (side _x == _side || !(alive driver _x))) then {_aliveConvoy pushBack _x;}} forEach _convoyArray;

_groupsNotNull = (_groups select {_x != grpNull});
{_inf_units append (units _x select {alive _x});} foreach _groupsNotNull;

[_markerArray, _aliveConvoy, _groupsNotNull, _inf_units, _ConvoySpeedLimit, _ConvoySearchRange, _ConvoyID, _ConvoySpeedMode, _ConvoyBehaviour, _arm_vehicles] spawn DEVAS_ConvoyRestart;