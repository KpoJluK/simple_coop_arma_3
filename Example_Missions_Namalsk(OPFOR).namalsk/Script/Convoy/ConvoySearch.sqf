// ConvoySearch.sqf
// © v.2.5 MARCH 2016 - Devastator_cm

private _enemySides = _this select 0;
private _units      = _this select 1;
private _found      = false;
private _enemies 	= [];

{
	_enemies 	= (_x neartargets _ConvoySearchRange) apply {_x select 4} select {side _x in _enemySides AND {count crew _x > 0} AND typeOf _x != "Logic" AND !(_x isKindOf "Air")};
	if (!(_enemies isEqualTo [])) exitwith {_found = true;};
} foreach _units;

_found