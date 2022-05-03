
_arry_select_road = [];
_list_roads = center_map nearRoads radius_map;
{
	_select_road = _x;
	pos_road = getPos _select_road;
	pos_x_plus = (pos_road select 0) + 10;
	pos_x_minus = (pos_road select 0) - 10;
	pos_y_plus = (pos_road select 1) + 10;
	pos_y_minus = (pos_road select 1) - 10;
	if(
		!(getPos _select_road inArea [getMarkerPos "Pos_base", 2500, 2500, 45, false]) and 
		(getRoadInfo _select_road) select 8 isEqualTo false and
		((surfaceNormal [pos_x_plus,pos_road select 1,0]) select 0 < 0.4) and 
		((surfaceNormal [pos_x_minus,pos_road select 1,0])select 0 < 0.4) and
		((surfaceNormal [pos_road select 0,pos_y_plus,0])select 0 < 0.4) and 
		((surfaceNormal [pos_road select 0,pos_y_minus,0])select 0 < 0.4) and
		((nearestObjects [(getPos _select_road), ["house"], 50]) isEqualTo []) and 
		((nearestTerrainObjects [(getPos _select_road), ["Tree"], 15]) isEqualTo [])
	)then{_arry_select_road pushBack _select_road};
} forEach _list_roads;
// filter from static Mortar

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
	["Land_DragonsTeeth_01_1x1_old_F",[-2.17578,-4.54492,0],299.592,1,0,[0,0],"","",true,false], 
	["Land_DragonsTeeth_01_1x1_old_F",[4.99707,-0.621094,3.05176e-005],318.345,1,0,[-0.0553037,0.0491963],"","",true,false], 
	["Land_DragonsTeeth_01_1x1_old_F",[1.63184,5.32422,0],0,1,0,[0,0],"","",true,false], 
	["Land_DragonsTeeth_01_1x1_old_F",[-5.85938,1.375,0],0,1,0,[-0.0740187,0],"","",true,false], 
	[selectRandom static_weapon_bloc_post,[5.25977,3.68164,3.2],323.741,1,0,[-1.94478,0.2354],"","",true,false], 
	["Land_DragonsTeeth_01_1x1_old_F",[-2.7998,-7.33301,0],294.645,1,0,[0,0],"","",true,false], 
	[selectRandom static_weapon_bloc_post,[-6.59619,-2.86523,3.2],146.238,1,0,[-1.94481,0.235079],"","",true,false], 
	["Land_BagBunker_Tower_F",[6.90332,4.33984,0],241.678,1,0,[0,0],"","",true,false], 
	["Land_DragonsTeeth_01_1x1_old_F",[2.36914,8.26953,0],0,1,0,[-0.0740187,0],"","",true,false], 
	["Land_DragonsTeeth_01_1x1_old_F",[8.71094,1.53223,0],172.937,1,0,[0,-0],"","",true,false], 
	["Land_DragonsTeeth_01_1x1_old_F",[-8.98193,-0.798828,3.05176e-005],116.454,1,0,[0.0662687,0.0329733],"","",true,false], 
	["Land_BagBunker_Tower_F",[-7.84277,-3.96777,3.05176e-005],59.325,1,0,[0,0],"","",true,false], 
	["Land_DragonsTeeth_01_1x1_old_F",[-5.24951,-9.17676,-3.05176e-005],54.3008,1,0,[-0.0431922,-0.06011],"","",true,false], 
	["Land_DragonsTeeth_01_1x1_old_F",[4.82959,9.58105,0],0,1,0,[-0.0740187,0],"","",true,false], 
	["Land_DragonsTeeth_01_1x1_old_F",[11.9995,3.29492,0.000152588],185.402,1,0,[-0.416314,0.344408],"","",true,false], 
	["Land_DragonsTeeth_01_1x1_old_F",[8.9082,9.27734,9.15527e-005],243.729,1,0,[-0.308688,0.237812],"","",true,false], 
	["Land_DragonsTeeth_01_1x1_old_F",[-9.43115,-8.93652,0],168.758,1,0,[0,-0],"","",true,false], 
	["Land_DragonsTeeth_01_1x1_old_F",[-12.6851,-3.04102,0],0,1,0,[-0.0740187,0],"","",true,false]
];
arru_roads_of = [];
_selected_road = [];
// create bloc post
_count_bloc_post = count_bloc_post_on_map;
if(_count_bloc_post >= count _list_roads)then{_count_bloc_post = count _list_roads - 1};
for "_i" from 0 to _count_bloc_post do 
{
	waitUntil{
		_selected_road = selectRandom _list_roads;
		getPos _selected_road nearObjects ["Land_BagBunker_Tower_F", 250] isEqualTo []
	};
	
	private _info = getRoadInfo _selected_road;
	private _dir = ((_info select 6) getDir (_info select 7)) + 30;

	[getPos _selected_road, _dir, _obgect_grabber, 0] call BIS_fnc_objectsMapper;
	// find weapin and bilding 
	arru_roads_of  pushBack getPos _selected_road;
	// создаю ботов
	private _group_defend = createGroup [enemy_side, true];
	_group_defend enableDynamicSimulation true;

	_unit = _group_defend createUnit [selectRandom inf_missions_arry, getPos _selected_road, [], 0, "FORM"];
	_unit moveInAny (nearestObjects [getPos _selected_road, ["StaticWeapon"], 10] select 0);
	(nearestObjects [getPos _selected_road, ["StaticWeapon"], 10] select 0) setVehicleLock "LOCKED";
	_unit disableAi "path";
	_unit disableAi "move";
	sleep 0.1;
	_unit = _group_defend createUnit [selectRandom inf_missions_arry, getPos _selected_road, [], 0, "FORM"];
	_unit moveInAny (nearestObjects [getPos _selected_road, ["StaticWeapon"], 10] select 1);
	(nearestObjects [getPos _selected_road, ["StaticWeapon"], 10] select 1) setVehicleLock "LOCKED";
	_unit disableAi "path";
	_unit disableAi "move";

	private _group_defend = createGroup [enemy_side, true];
	_group_defend enableDynamicSimulation true;
	private _random_count = round (random 5);
	waitUntil 
	{	
		_unit = _group_defend createUnit [selectRandom inf_missions_arry, getPos _selected_road, [], 0, "FORM"];
		_unit setSkill 0.8;
		_random_count = _random_count - 1;
		_random_count <= 0 
	};
	[_group_defend, getPos _selected_road, 50] call BIS_fnc_taskPatrol;

	sleep 10;
};





