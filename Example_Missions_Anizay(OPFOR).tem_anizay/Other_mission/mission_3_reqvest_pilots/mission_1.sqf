
//exeple
// [pos_mission,heli_classname,second_mission,side_pilot,pilot_classname,pos_base_to_delivery] execVM "${somepath\file.sqf}";

	// 	pos_mission - aryy coordinate mission
	// 	heli_classname - class name of heli need to find
	// 	second_mission - arry coordinate next mission
	// 	side_pilot - side pilot who need to recwest
	//	pilot_classname - classname pilots who need to recwest
	//  pos_base_to_delivery - arry coordinate base need to go pilots

// done example
// [[200,200,0],"RHS_AH64D",[300,300,0],EAST,"rhsusf_army_ocp_ah64_pilot",[1000,1000,0]] execVM "modules\spec_other_missions\mission_3\mission_1.sqf";

//param
params ["_pos_mission", "_heli_classname", "_second_mission","_side_pilot", "_pilot_classname", "_pos_base_to_delivery"];

//heli
private _heli_down = _heli_classname createVehicle _pos_mission;
_heli_down setDamage 0.5;
_heli_down setVehicleAmmo 0;
_heli_down setFuel 0;
_heli_down enableSimulationGlobal false;
private _voronka1 = "CraterLong" createVehicle (getPos _heli_down);
_voronka1 setPos(getPos _heli_down);


//marker
private _Marker3 = createMarker ["Marker3", _heli_down getPos [random 300, random 360]];
"Marker3" setMarkerShape "ELLIPSE";
"Marker3" setMarkerSize [300, 300];
"Marker3" setMarkerColor "ColorBlack";
"Marker3" setMarkerBrush "Cross";
//mission
["Task_03_1", true, ["Эвакуировать пилотов сбитого вертолета","Эвакуировать пилотов сбитого вертолета","respawn_west"], getMarkerPos _Marker3, "CREATED", 5, true, true, "meet", true] call BIS_fnc_setTask;
sleep 3;
["Task_03", true, ["Уничтожить подбитый МИ-28","Уничтожить подбитый МИ-28","respawn_west"], getMarkerPos _Marker3, "ASSIGNED", 5, true, true, "destroy", true] call BIS_fnc_setTask;
//smoke
private _smoke1 = "test_EmptyObjectForSmoke" createVehicle getPos _heli_down;
_smoke1 setPos(getPos _heli_down);
//bot
private _find_pos_bot = _heli_down getPos [random 50, random 360];
//создание ботов 
[
	_find_pos_bot,	// массив координатов где будет центр здания

	independent,	// сторона ботов можнт быть: EAST, WEST, independent
inf_missions_arry,
car_mission_arry,
hevy_vehicle_arry,
anti_air_vehicle_arry,
heli_vehecle_arry,
static_weapon_arry,
	300, // радиус (от центра) размещения статичных орудий(м)
	0, // количество статичных орудий
	2,	// количество легких машин которые будут патрулировать зону
	0,	// количество тяжолой техники которая будует патрулировать зону
	0,	// количество самоходных зенитныйх установок которые будут патрулировать зону
	0,	//	количество вертолетов которые будут патрулировать зону
	2,	// количество групп ботов которые будет охранять зону
	3,	//	количество ботов в группах которые будут охранять зону
	false,	// спаунить ли ботов на крышах домов
	100, // радиус поиска домов внутри которых будут боты(на крышах и внутри)
	30,	// шанс появления бота в здании(на крыше) в % от 0 до 100
	false, // создавать ли ботов внутри зданий
	30, // шанс появления бота в каждой позиции в здании в % от 0 до 100
	3000, // радиус активации игроком
	100,	// радиус патрулирования ботов
	500,	// радиус размещения легких машин которые будут патрулировать зону(чем больше машин тем больше зону лучше сделать)
	600,	// радиус патрулирования всех машин и легких танков
	1000,	// радиус патрулирования вертолетов
	false	// условик при котром боты будут удалены(УСЛОВИК ДОЛЖНО БЫТЬ ГЛОБАЛЬНО!!!)
] execVM "Other_mission\Shared\fn_other_missions_spawnEnemyBot.sqf";
//wait tank desroyd
waitUntil{
	sleep 10;
	!alive _heli_down
};
//hint "tell about situation"
[[], {hint "Мы обнаружили пилотов их увезли в другой город! Передаем вам координаты..."}] remoteExec ["call"];
sleep 5;
[[], {hint ""}] remoteExec ["call"];
//delete task and smone and marker
["Task_03","SUCCEEDED"] call BIS_fnc_taskSetState;
deleteMarker _Marker3;
deleteVehicle _smoke1;

//move mision
["Task_03_1",_second_mission] call BIS_fnc_taskSetDestination;
//create pilot adn grup pilit
private _group_pilot = createGroup [_side_pilot, true];
_pilot1 = _group_pilot createUnit [_pilot_classname, _second_mission, [], 0, "FORM"];
_pilot2 = _group_pilot createUnit [_pilot_classname, _second_mission, [], 0, "FORM"];
[_pilot1, true] call ACE_captives_fnc_setHandcuffed;
[_pilot2, true] call ACE_captives_fnc_setHandcuffed;
//bot
[
	_second_mission,	// массив координатов где будет центр здания

	independent,	// сторона ботов можнт быть: EAST, WEST, independent
	inf_missions_arry,
	car_mission_arry,
	hevy_vehicle_arry,
	anti_air_vehicle_arry,
	heli_vehecle_arry,
	static_weapon_arry,
	300, // радиус (от центра) размещения статичных орудий(м)
	3, // количество статичных орудий
	2,	// количество легких машин которые будут патрулировать зону
	1,	// количество тяжолой техники которая будует патрулировать зону
	1,	// количество самоходных зенитныйх установок которые будут патрулировать зону
	0,	//	количество вертолетов которые будут патрулировать зону
	4,	// количество групп ботов которые будет охранять зону
	3,	//	количество ботов в группах которые будут охранять зону
	true,	// спаунить ли ботов на крышах домов
	100, // радиус поиска домов внутри которых будут боты(на крышах и внутри)
	30,	// шанс появления бота в здании(на крыше) в % от 0 до 100
	true, // создавать ли ботов внутри зданий
	30, // шанс появления бота в каждой позиции в здании в % от 0 до 100
	3000, // радиус активации игроком
	200,	// радиус патрулирования ботов
	500,	// радиус размещения легких машин которые будут патрулировать зону(чем больше машин тем больше зону лучше сделать)
	600,	// радиус патрулирования всех машин и легких танков
	1000,	// радиус патрулирования вертолетов
	false	// условик при котром боты будут удалены(УСЛОВИК ДОЛЖНО БЫТЬ ГЛОБАЛЬНО!!!)
] execVM "Other_mission\Shared\fn_other_missions_spawnEnemyBot.sqf";

//wait pilot delivery on base or hes die
waitUntil{
	sleep 10;
	((getPos _pilot1) inArea [_pos_base_to_delivery, 100, 100, 0, false] or !alive _pilot1) && ((getPos _pilot2) inArea [getMarkerpos "Base", 100, 100, 0, false] or !alive _pilot2)
 };
//set task state
if(alive _pilot1 and alive _pilot2)then{
	["Task_03_1","SUCCEEDED"] call BIS_fnc_taskSetState;
	credit_commander = credit_commander + 35;
	publicVariable "credit_commander";
	}else{
		["Task_03_1","FAILED"] call BIS_fnc_taskSetState;
		};
//delete task
sleep 10;
deleteVehicle _pilot1;
deleteVehicle _pilot2;
["Task_03"] call BIS_fnc_deleteTask;
["Task_03_1"] call BIS_fnc_deleteTask;

choise_mission = false;
publicVariable "choise_mission";


