if(isNil "Call_help_paradrop")then{
	Call_help_paradrop = false;
	publicVariable "Call_help_paradrop";
};
if(Call_help_paradrop)exitWith{hint "Самолет еще не готов для взлета!"};
[5, [], {

	0 spawn {
		Call_help_paradrop = true;
		publicVariable "Call_help_paradrop";
		[[], {systemChat "По вашим координатам выслан борт с десантом, сброс будет по вашим текущим координатм, ожидайте!"}] remoteExec ["call"];
		//Записуем позицию игрока
		_Position_player = getPos player;
		//спуним самолет
		_C_130 = [[0,0,1000], 180, "RHS_C130J_Cargo", WEST] call BIS_fnc_spawnVehicle;
		{_x setSkill ["courage", 1]} forEach units (_C_130 select 2);
		// Приказываем самолету двигаться куда над
		private _wp_C_130 = (_C_130 select 2) addWaypoint [_Position_player, 0];
		_wp_C_130 setWaypointType "MOVE";
		_wp_C_130 setWaypointSpeed "FULL";
		[(_C_130 select 2), 0] setWaypointCombatMode "BLUE";

		(_C_130 select 0) flyInHeight 1000;
		// жду пока самолет булет над точкой
		waitUntil{
			sleep 1;
			((getPos (_C_130 select 0)) inArea [_Position_player, 150, 150, 0, false]) or !alive (_C_130 select 0)
		};
		if(!alive (_C_130 select 0))exitWith{};
		// создаю группу десанта
		private _group_desant = createGroup [side (selectRandom allPlayers), true];
		_pos_C_130 = getPosATL (_C_130 select 0);
		for "_i" from 0 to 8 do 
		{
			_pos_X = (_pos_C_130 select 0) + random [-200,0,200];
			_pos_Y = (_pos_C_130 select 1) + random [-200,0,200];
			_pos_Z = (_pos_C_130 select 2);

			_unit_desant = _group_desant createUnit [selectRandom arry_inf_call_help_vdv,[_pos_X, _pos_Y, _pos_Z], [], 0, "FORM"];
			_unit_desant setSkill 1;
			_unit_desant setSkill ["courage", 1];

			[_unit_desant]call fnc_Eqvip_desant;

			sleep 1;
		};
		_group_desant enableGunLights "ForceOn";
		// группе ботов охранять зону игрока
 		_wp = _group_desant addWaypoint [_Position_player, 0];
   		_wp setWaypointType "HOLD";
		//ждать пока игроков не будет для удаления группы
		[_group_desant, _Position_player] spawn{
			params ["_group_desant","_Position_player"];
			waitUntil{
				sleep 600;
				_player_in_area = allPlayers inAreaArray [_Position_player, 1500, 1500, 100, false];
    			isNil {_player_in_area select 0}
			};
			{deleteVehicle _x} forEach (units _group_desant);
		};
		// удаляю С 130
		(_C_130 select 0) flyInHeight 4000;
		sleep 60;
		{
			deleteVehicle _x
		} forEach (_C_130 select 1);
		deleteVehicle (_C_130 select 0);
		sleep 2400;
		Call_help_paradrop = false;
		publicVariable "Call_help_paradrop";

	};
}, {hint "Отмена передачи"}, "Определение и передача координат..."] call ace_common_fnc_progressBar;