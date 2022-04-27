if(isNil "Call_vdv_v2")then{
	Call_vdv_v2 = false;
	publicVariable "Call_vdv_v2";
};
if(Call_vdv_v2)exitWith{hint "Самолет еще не готов для взлета!"};


	0 spawn {
		Call_vdv_v2 = true;
		publicVariable "Call_vdv_v2";
		[[], {systemChat "По вашим координатам выслан борт десантом, сброс будет по вашим текущим координатм, ожидайте!"}] remoteExec ["call"];

		//Записуем позицию игрока
		_Position_player = getPos player;
		//спуним вертолет
		_heli = [[0,0,1000], 180, "RHS_UH60M_d", WEST] call BIS_fnc_spawnVehicle;
		{_x setSkill ["courage", 1]} forEach units (_heli select 2);
		
		// маршрутная точка
		private _wp_heli = (_heli select 2) addWaypoint [_Position_player, 0];
		_wp_heli setWaypointSpeed "FULL";
		[(_heli select 2), 0] setWaypointCombatMode "BLUE";
		
		//создаем группу десанта
		private _supgroup = createGroup [EAST,true];

		    for "_i" from 0 to 12 do 
		{
			private _unit = _supgroup createUnit ["SpecLib_O_R_Assault_medic_01_F", [0,0,0], [], 0, "FORM"];
			_unit setSkill 0.7;
			sleep 1;
			_unit moveInCargo (_heli select 0);
		};

		// Создаём контрмеры для цикличного использования
    	private _flares = {
        while {alive driver _this && {!(isTouchingGround _this)}} do {    
            sleep 2,5;
            _this action ["useWeapon", _this, driver _this, 0];
        };
    };
    	// Создаём контрмеры для цикличного использования на отходе
    	private _flares2 = {
        while {alive driver _this} do {    
            sleep 2,5;
            _this action ["useWeapon", _this, driver _this, 0];
        };
    };

	//Сообщаем о вылете
  	[[], {systemChat "По вашим координатам выслана ГБР ОСН ожидайте!";}] remoteExec ["call"];

	// Ждём пока дистанция будет менее 1000 метров - начинаем выпускать ловушки
    waitUntil {
		sleep 1;
		(_heli distance _Position_player) < 1000
    };

	
	// Откидываем ловушки
    _heli spawn _flares;

	waitUntil {
		sleep 1;
		((_heli select 0) distance _Position_player) < 50
    };

		Call_vdv_v2 = false;
		publicVariable "Call_vdv_v2";
	};