// ConvoyMaxSpeed.sqf 
// � v.2.5 MARCH 2016 - Devastator_cm

private _vcl 				= _this select 0;
private _last_marker 		= _this select 1;
private _convoyArray		= _this select 2;
private _c 					= _this select 3;
private _ConvoySearchRange	= _this select 4;
private _vcl_behind 		= objNull;
private _vcl_ahead 			= objNull;
private _destinationEnd 	= getMarkerPos _last_marker;
private _unit 				= objNull;
private _enemySides			= objNull;
private _enemies 			= [];
private _enemySides 		= (driver _vcl) call BIS_fnc_enemySides;

if (isPlayer (driver _vcl)) exitWith {};

if (_c < (count _convoyArray) -1) then {_vcl_behind = _convoyArray select (_c + 1)};
if (_c > 0) then {_vcl_ahead = _convoyArray select (_c - 1)};    		
while {alive _vcl && !(_vcl getVariable "DEVAS_ConvoyAmbush")} do 
{ 	
	if (_vcl distance _destinationEnd < 10 * (_c + 1) && _vcl getVariable "DEVAS_ConvoyCurrentMarker" == _last_marker) then {_vcl setVariable ["DEVAS_ConvoyDestination",true, false];};
	_aliveConvoy	= [];
	{
		_unit 	 	= _x;
		_enemies 	= (_unit neartargets _ConvoySearchRange) apply {_x select 4} select {side _x in _enemySides AND {count crew _x > 0} AND typeOf _x != "Logic" AND !(_x isKindOf "Air")};
		if (canMove _x && _enemies isEqualTo []) then {_aliveConvoy pushBack _x;};
	} forEach _convoyArray;
	if (count _aliveConvoy < count _convoyArray) exitWith {_vcl setVariable ["DEVAS_ConvoyAmbush",true, false]};
	if (!isNull _vcl_behind) then {
		while {_vcl distance _vcl_behind > 60 && _vcl distance [getmarkerpos(_vcl getVariable "DEVAS_ConvoyCurrentMarker") select 0, getmarkerpos(_vcl getVariable "DEVAS_ConvoyCurrentMarker") select 1, 0] <  _vcl_behind distance [getmarkerpos(_vcl getVariable "DEVAS_ConvoyCurrentMarker") select 0, getmarkerpos(_vcl getVariable "DEVAS_ConvoyCurrentMarker") select 1, 0]} do {	
			_dir = getDir _vcl;
			if (_vcl distance _vcl_behind <= 100) then {
				if (((sin _dir) * (velocity _vcl select 0)) > 3) then {_vcl setVelocity [(velocity _vcl select 0) - (1 * (sin _dir)), (velocity _vcl select 1), velocity _vcl select 2]};
				if (((cos _dir) * (velocity _vcl select 1)) > 3) then {_vcl setVelocity [(velocity _vcl select 0), (velocity _vcl select 1) - (1 * (cos _dir)), velocity _vcl select 2]};
			} else {
				if (((sin _dir) * (velocity _vcl select 0)) > 1) then {_vcl setVelocity [(velocity _vcl select 0) - (2 * (sin _dir)), (velocity _vcl select 1), velocity _vcl select 2]};
				if (((cos _dir) * (velocity _vcl select 1)) > 1) then {_vcl setVelocity [(velocity _vcl select 0), (velocity _vcl select 1) - (2 * (cos _dir)), velocity _vcl select 2]};
			};
			sleep 0.1;
		};
	};
	if (!isNull _vcl_ahead) then	{
		while { (_vcl distance _vcl_ahead < 40) || _vcl distance [getmarkerpos(_vcl getVariable "DEVAS_ConvoyCurrentMarker") select 0, getmarkerpos(_vcl getVariable "DEVAS_ConvoyCurrentMarker") select 1, 0] <  _vcl_ahead distance [getmarkerpos(_vcl getVariable "DEVAS_ConvoyCurrentMarker") select 0, getmarkerpos(_vcl getVariable "DEVAS_ConvoyCurrentMarker") select 1, 0]} do {	
			_dir = getDir _vcl;
			if (((sin _dir) * (velocity _vcl select 0)) > 1) then {_vcl setVelocity [(velocity _vcl select 0) - (2 * (sin _dir)), (velocity _vcl select 1), velocity _vcl select 2]};
			if (((cos _dir) * (velocity _vcl select 1)) > 1) then {_vcl setVelocity [(velocity _vcl select 0), (velocity _vcl select 1) - (2 * (cos _dir)), velocity _vcl select 2]};
			sleep 0.1;
		};
	};
	sleep 0.1;
};
_vcl doMove getPos _vcl;