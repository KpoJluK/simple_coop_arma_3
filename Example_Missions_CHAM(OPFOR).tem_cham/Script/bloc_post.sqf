if((static_weapon_arry select 0) isEqualTo str objNull)exitWith{};

_arry_select_road = [];
_list_roads = center_map nearRoads radius_map;
waitUntil{
	_select_road = selectRandom _list_roads;
	if(!(getPos _select_road inArea [getMarkerPos "Pos_base", 1000, 1000, 45, false]) and ((surfaceNormal (getPos _select_road)) select 0) < 0.5 and ((surfaceNormal (getPos _select_road)) select 1) < 0.5)then{_arry_select_road pushBack _select_road};
	(count _arry_select_road) == 30
};
// filter from small static
_static_weapon_arry_bloc_post = static_weapon_arry;

for "_i" from 0 to (count static_weapon_arry) - 1 do 
{
	_jeep = static_weapon_arry select _i createVehicle [0,0,0];
	if(((_jeep call BIS_fnc_boundingBoxDimensions) select 0) >= 5 or ((_jeep call BIS_fnc_boundingBoxDimensions) select 1) >= 5 or ((_jeep call BIS_fnc_boundingBoxDimensions) select 2) >= 5)then{_static_weapon_arry_bloc_post = _static_weapon_arry_bloc_post - [static_weapon_arry select _i]};
	deleteVehicle _jeep;
	sleep 1;
};

// if no small static

if(_static_weapon_arry_bloc_post isEqualTo [])then{
	_static_weapon_arry_bloc_post append [str objNull];
};

// композиция обьектов
_obgect_grabber =
[
	["GroundWeaponHolder",[2.3877,0.836914,2.82928],138.464,1,0,[0,-0],"","",true,false], 
	["Land_CzechHedgehog_01_new_F",[4.53906,-2.35059,0],0.00033633,1,0,[-2.15604e-005,-1.53279e-005],"","",true,false], 
	[selectRandom _static_weapon_arry_bloc_post,[3.56543,1.82813,3],323.657,1,0,[1.93819e-005,2.50512e-005],"","",true,false], 
	["Land_CzechHedgehog_01_new_F",[-0.922363,5.84766,0],0.000293727,1,0,[0.0764351,-1.58414e-005],"","",true,false], 
	["Land_BagBunker_Tower_F",[5.26172,2.99316,3.05176e-005],238.154,1,0,[0,0],"","",true,false], 
	["Land_CzechHedgehog_01_new_F",[6.87061,-0.796875,0.000305176],0.0025788,1,0,[0.0425261,0.0215474],"","",true,false], 
	["Land_CzechHedgehog_01_new_F",[1.18848,7.33789,0],0.000228358,1,0,[-1.07258e-005,0.0764713],"","",true,false], 
	["Land_CzechHedgehog_01_new_F",[2.34473,-8.64648,0],0.000958581,1,0,[0.0742306,-6.88562e-005],"","",true,false], 
	["Land_CzechHedgehog_01_new_F",[3.89795,9.06348,3.05176e-005],0.000181889,1,0,[-2.29062e-005,0.076464],"","",true,false], 
	["Land_CzechHedgehog_01_new_F",[-7.68652,8.03125,3.05176e-005],0.000769423,1,0,[-4.47594e-005,0.000286338],"","",true,false]
];
arru_roads_of = [];

// create bloc post
for "_i" from 0 to 29 do 
{
	private _info = getRoadInfo (_arry_select_road select _i);
	private _dir = ((_info select 6) getDir (_info select 7)) + 30;

	[getPos (_arry_select_road select _i), _dir, _obgect_grabber, 0] call BIS_fnc_objectsMapper;
	// find weapin and bilding 
	arru_roads_of  pushBack getPos (_arry_select_road select _i);
	// создаю ботов
	private _group_defend = createGroup [enemy_side, true];
	_group_defend enableDynamicSimulation true;

	_unit = _group_defend createUnit [selectRandom inf_missions_arry, getPos (_arry_select_road select _i), [], 0, "FORM"];
	_unit moveInAny (nearestObjects [getPos (_arry_select_road select _i), ["StaticWeapon"], 10] select 0);
	(nearestObjects [getPos (_arry_select_road select _i), ["StaticWeapon"], 10] select 0) setVehicleLock "LOCKED";
	_unit disableAi "path";
	_unit disableAi "move";
	if(random 100 > 50)then{
		private _group_defend = createGroup [enemy_side, true];
		_group_defend enableDynamicSimulation true;
		private _random_count = round (random 5);
		waitUntil 
		{	
			_unit = _group_defend createUnit [selectRandom inf_missions_arry, getPos (_arry_select_road select _i), [], 0, "FORM"];
			_unit setSkill 0.8;
			_random_count = _random_count - 1;
			_random_count <= 0 
		};
		[_group_defend, getPos (_arry_select_road select _i), 50] call BIS_fnc_taskPatrol;
	};
	sleep 10;
};





