params["_pos_mission"];




_radar_1 = Class_name_stacionar_radar_to_destroy createVehicle _pos_mission;

//marker
private _Marker10 = createMarker ["Marker10", _radar_1 getPos [random 500, random 360]];
"Marker10" setMarkerShape "ELLIPSE";
"Marker10" setMarkerSize [500, 500];
"Marker10" setMarkerColor "ColorBlack";
"Marker10" setMarkerBrush "Cross";

["Task_10", true, ["Уничтожить РЛС","Уничтожить РЛС","respawn_west"], getMarkerPos _Marker10, "CREATED", 5, true, true, "meet", true] call BIS_fnc_setTask;

[
	_radar_1 getPos [30, random 360],	// массив координатов где будет центр здания

	enemy_side,	// сторона ботов можнт быть: EAST, WEST, independent
	0.8, // уровень скила ботов (значение от 0.1 до 1)
	inf_missions_arry,
	car_mission_arry,
	hevy_vehicle_arry,
	anti_air_vehicle_arry,
	heli_vehecle_arry,
	static_weapon_arry,
	300, // радиус (от центра) размещения статичных орудий(м)
	3 * count allPlayers, // количество статичных орудий
	3 * count allPlayers,	// количество легких машин которые будут патрулировать зону
	2 * count allPlayers,	// количество тяжолой техники которая будует патрулировать зону
	2 * count allPlayers,	// количество самоходных зенитныйх установок которые будут патрулировать зону
	random 4,	//	количество вертолетов которые будут патрулировать зону
	4 * count allPlayers,	// количество групп ботов которые будет охранять зону
	3,	//	количество ботов в группах которые будут охранять зону
	false,	// спаунить ли ботов на крышах домов
	100, // радиус поиска домов внутри которых будут боты(на крышах и внутри)
	30,	// шанс появления бота в здании(на крыше) в % от 0 до 100
	false, // создавать ли ботов внутри зданий
	30, // шанс появления бота в каждой позиции в здании в % от 0 до 100
	3000, // радиус активации игроком
	200,	// радиус патрулирования ботов
	500,	// радиус размещения легких машин которые будут патрулировать зону(чем больше машин тем больше зону лучше сделать)
	600,	// радиус патрулирования всех машин и легких танков
	1000,	// радиус патрулирования вертолетов
	true, // включать ли ботам динамическую симуляцию?
	false	// условик при котром боты будут удалены(УСЛОВИК ДОЛЖНО БЫТЬ ГЛОБАЛЬНО!!!)
] execVM "Other_mission\Shared\fn_other_missions_spawnEnemyBot.sqf";

private _Marker10_1 = createMarker ["Marker10_1", _radar_1 getPos [random 500, random 360]];
"Marker10_1" setMarkerShape "ELLIPSE";
"Marker10_1" setMarkerSize [5000, 5000];
"Marker10_1" setMarkerColor "ColorRed";
"Marker10_1" setMarkerBrush "Border";

// air deffense
[_radar_1] spawn {
	params ["_radar_1"];
	waitUntil{

		_target = ASLToAGL getPosASL _radar_1 nearEntities [["Air"], 5000];

		{
			if(side _x isEqualTo enemy_side or ((getPosAtL _x) select 2) < 100 )then{_target = _target - [_x]};
		} forEach _target;


		if(!isNil { _target select 0 })then{

			_count_target = count _target - 1;

			while {_count_target > -1} do
			{
				_pos_missle = _radar_1 getPos [200, 0];
				_pos_missle set [2,500];
				_missile = createVehicle ["ammo_Missile_AA_R77",_pos_missle,[],0,"CAN_COLLIDE"];
				_missile setDir getDir (_target select _count_target);
				_missile setMissileTarget (_target select _count_target);
				_count_target = _count_target - 1;
				sleep 2;
				_missile = createVehicle ["ammo_Missile_AA_R77",_pos_missle,[],0,"CAN_COLLIDE"];
				_missile setDir getDir (_target select _count_target);
				_missile setMissileTarget (_target select _count_target);
				_count_target = _count_target - 1;
			};

		};

		sleep 10;
		!alive _radar_1
	}
};

waitUntil{
	sleep 10;
	!alive _radar_1
};

["Task_10","SUCCEEDED"] call BIS_fnc_taskSetState;
deleteMarker _Marker10;
deleteMarker _Marker10_1;
sleep 10;
["Task_03"] call BIS_fnc_deleteTask;

choise_mission = false;
publicVariable "choise_mission";


