

params["_pos_mission"];

//marker
private _Marker9 = createMarker ["Marker9", _pos_mission];
"Marker9" setMarkerShape "ELLIPSE";
"Marker9" setMarkerSize [300, 300];
"Marker9" setMarkerColor "ColorBlack";
"Marker9" setMarkerBrush "Cross";

//task
["Task_09", true, ["Освободить город","Освободить город","respawn_west"], getMarkerPos _Marker9, "ASSIGNED", 5, true, true, "attack", true] call BIS_fnc_setTask;

//bot from defend gorod
[
	_pos_mission,	// массив координатов где будет центр здания

	enemy_side,	// сторона ботов можнт быть: EAST, WEST, enemy_side
	inf_missions_arry,
	car_mission_arry,
	hevy_vehicle_arry,
	anti_air_vehicle_arry,
	heli_vehecle_arry,
	static_weapon_arry,
	300, // радиус (от центра) размещения статичных орудий(м)
	0, // количество статичных орудий
	3,	// количество легких машин которые будут патрулировать зону
	2,	// количество тяжолой техники которая будует патрулировать зону
	2,	// количество самоходных зенитныйх установок которые будут патрулировать зону
	1,	//	количество вертолетов которые будут патрулировать зону
	5,	// количество групп ботов которые будет охранять зону
	4,	//	количество ботов в группах которые будут охранять зону
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


//find pos from zenitki
private _find_pos_from_zenitki = [_pos_mission, 10, 150, 10, 0, 0.9, 0] call BIS_fnc_findSafePos;
private _find_pos_from_zenitki_1 = [_pos_mission, 10, 150, 10, 0, 0.9, 0] call BIS_fnc_findSafePos;
private _find_pos_from_zenitki_2 = [_pos_mission, 10, 150, 10, 0, 0.9, 0] call BIS_fnc_findSafePos;
//find pos from vuhka
private _find_pos_from_vuhka = [_pos_mission, 50, 300, 10, 0, 0.9, 0] call BIS_fnc_findSafePos;

//spawn zenitki
zenitka_goroda = [_find_pos_from_zenitki, 180, class_name_zenitka_who_deffend_city, enemy_side] call BIS_fnc_spawnVehicle;
zenitka_goroda_1 = [_find_pos_from_zenitki_1, 180, class_name_zenitka_who_deffend_city, enemy_side] call BIS_fnc_spawnVehicle;
zenitka_goroda_2 = [_find_pos_from_zenitki_2, 180, class_name_zenitka_who_deffend_city, enemy_side] call BIS_fnc_spawnVehicle;

//bot from defend zenitki


//task destroin zenitki
["Task_09_1", true, ["Уничтожить зенитные установки","Уничтожить зенитные установки","respawn_west"], getMarkerPos _Marker9, "CREATED", 5, true, true, "destroy", true] call BIS_fnc_setTask;

//create vuhka
vuhka = "Land_Vysilac_FM" createVehicle _find_pos_from_vuhka;

//task destroin vshka
["Task_09_2", true, ["Уничтожить вышку","Уничтожить вышку","respawn_west"], getMarkerPos _Marker9, "CREATED", 5, true, true, "destroy", true] call BIS_fnc_setTask;

//find pos from sklad boepripasow
private _find_pos_from_sklad_boepripasow = [_pos_mission, 50, 300, 10, 0, 0.9, 0] call BIS_fnc_findSafePos;

//spawn sklad boepripasow
sklad_boepripasow = "Box_EAF_AmmoVeh_F" createVehicle _find_pos_from_vuhka;
private _sklad_boepripasow_1 = "Box_EAF_AmmoVeh_F" createVehicle getPos sklad_boepripasow;
private _sklad_boepripasow_2 = "Box_EAF_AmmoVeh_F" createVehicle getPos sklad_boepripasow;

//task destroin vshka
["Task_09_3", true, ["Уничтожить склад боеприпасов","Уничтожить склад боеприпасов","respawn_west"], getMarkerPos _Marker9, "CREATED", 5, true, true, "destroy", true] call BIS_fnc_setTask;

//wait complite zadaniya
private _zadanie_zenitka_complite = false;
private _zadanie_vuhka_complite = false;
private _zadanie_vuhka_complite = false;

waitUntil{
	if(!alive (zenitka_goroda select 0) && !alive (zenitka_goroda_1 select 0) && !alive (zenitka_goroda_2 select 0))then{_zadanie_zenitka_complite = true; ["Task_09_1","SUCCEEDED"] call BIS_fnc_taskSetState;};
	if(!alive vuhka)then{_zadanie_vuhka_complite = true;["Task_09_2","SUCCEEDED"] call BIS_fnc_taskSetState;};
	if(!alive sklad_boepripasow && !alive _sklad_boepripasow_1 && !alive _sklad_boepripasow_2)then{_zadanie_vuhka_complite = true;["Task_09_3","SUCCEEDED"] call BIS_fnc_taskSetState;};
	sleep 20;
	_zadanie_zenitka_complite && _zadanie_vuhka_complite && _zadanie_vuhka_complite
};

["Task_09","SUCCEEDED"] call BIS_fnc_taskSetState;
deleteMarker _Marker9;
sleep 10;
["Task_09"] call BIS_fnc_deleteTask;
["Task_09_1"] call BIS_fnc_deleteTask;
["Task_09_2"] call BIS_fnc_deleteTask;
["Task_09_3"] call BIS_fnc_deleteTask;


choise_mission = false;
publicVariable "choise_mission";