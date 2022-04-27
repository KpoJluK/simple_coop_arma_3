// ConvoyEnemy.sqf
// © v.2.5 MARCH 2016 - Devastator_cm

private _Enemies 			= _this select 0;
private _Vehicle 			= _this select 1;
private _EnemyRatings 		= [];  //[[Vehicle, Rating, Attack Rating, Type]]
private _Typ 				= "";
private _Rating 			= 0;
private _RatingCoef 		= 0;
private _MaxRating      	= 0;
private _Enemy          	= objNull;
private _SpacingRating      = 0;
private _i 					= 0;
private _RandomEnemy		= objNull;
private _DistanceCoef       = 0;
private _BestEnemy 			= [];

if(_Vehicle isKindOf "Tank") then {_RatingCoef = 40;};
{
	_Typ 				= "unknown";
	_Rating 		 	= 0;
	_DistanceCoef           = 100/(_Vehicle distance _x);
	if(_x isKindOf "LandVehicle") then 
	{	
		_Typ 				= "LandVehicle";
		_Rating 			= 10;
		if (_x isKindOf "Tank") then
		{
			_Typ 				= "Tank";
			_Rating 			= -10 + _RatingCoef;
		};
		if (_x isKindOf "Truck" || _x isKindOf "Truck_F") then
		{
			_Typ = "Truck";
			_Rating = 5;
		};
		if (_x isKindOf "StaticWeapon") then
		{
			_Typ 				= "Static";
			_Rating 			= 4;
		};
	};
	if(_x isKindOf "Man") then 
	{
		_Typ    = "Man";
		_Rating = 1;
	};
	if(_x isKindOf "Air") then 
	{
		_Typ    = "Air";
		_Rating = -15;
	};
	_Rating = _Rating + _DistanceCoef;
	_EnemyRatings pushBack [_x, _Rating, _Rating, _Typ, _DistanceCoef];
}	foreach _Enemies;

{
	_Enemy 			= _x;
	_SpacingRating 	= 0;
	{_SpacingRating = _SpacingRating + (_x select 1);} foreach (_EnemyRatings select {_Enemy distance2D (_x select 0) < 40});

	for "_i" from 0 to (count _EnemyRatings) - 1 step 1 do
	{
		if(_Enemy == _EnemyRatings select _i select 0) exitwith 
		{
			_EnemyRatings select _i set [2, _SpacingRating];
		};
	};	
}	foreach _Enemies;

{if(_x select 2 >  _MaxRating) then {_MaxRating = (_x select 2);};} foreach _EnemyRatings;
{if(_x select 2 == _MaxRating) then {_BestEnemy pushBack (_x select 0)};}	foreach _EnemyRatings;
_RandomEnemy = selectRandom _BestEnemy;

_RandomEnemy