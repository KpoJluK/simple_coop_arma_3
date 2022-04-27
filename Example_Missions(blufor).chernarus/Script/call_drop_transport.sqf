if(isNil "Call_drop_transport")then{
	Call_drop_transport = false;
	publicVariable "Call_drop_transport";
};
if(Call_drop_transport)exitWith{hint "Самолет еще не готов для взлета!"};
[5, [], {
	0 spawn {
		Call_drop_transport = true;
		publicVariable "Call_drop_transport";
		[[], {systemChat "По вашим координатам выслан борт с танспортом, сброс будет по вашим текущим координатм, ожидайте!"}] remoteExec ["call"];
		// берем позицию игрока
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
			((getPos (_C_130 select 0)) inArea [_Position_player, 150, 150, 0, false])
		};
			[_C_130] spawn {
				params ["_C_130"];
				// спауним джип
				_jeep = "O_LSV_02_unarmed_F" createVehicle [0,0,1000]; // from red - "rhs_tigr_camo"
				_pos_plane = getPosATL (_C_130 select 0);
				sleep 1;
				_jeep setPosATL _pos_plane;
				// Удаляю инвентарь и добавляю новый
				clearMagazineCargoGlobal _jeep;
				clearWeaponCargoGlobal _jeep;
				clearBackpackCargoGlobal _jeep;
				clearItemCargoGlobal _jeep;

				_jeep addItemCargoGlobal ["PiR_bint", 5];
			
				// ждем пока дистанция до земли будет 200 м
				waitUntil{
					_pos_jeep = getPosATl _jeep ;
					(_pos_jeep select 2) <= 100
				};
				//прикрепляю парашут
				_Parachute = createVehicle ["B_Parachute_02_F",GetPosAtl _jeep, [], 0, "FLY"];
				_Parachute disableCollisionWith _jeep;
				_Parachute setPos(getPos _jeep);
				_jeep attachTo [_Parachute, [0, 0, 1.8]];
				//если день тогда добавить дым если ноч ик маяк
				if(daytime <= 6 or daytime >= 20) then{
					_ir_signal = "B_IRStrobe" createVehicle [0,0,0];
					_ir_signal disableCollisionWith _jeep;
					_ir_signal attachTo [_jeep, [0, 0, 0.3]];
				}
				else{
					_smoke = "G_40mm_SmokeGreen" createVehicle [0,0,0];
					_smoke disableCollisionWith _jeep;
					_smoke attachTo [_jeep, [0, 0, 0.3]];
				};
			};

		// возвращаю самолет на позицию 0 и удаляю
		(_C_130 select 0) flyInHeight 4000;
		_C_130 domove [0,0,1000];
		waitUntil{
			sleep 5;
			(getPosATL(_C_130 select 0)select 2) >=3000
		};
		{(_C_130 select 0) deleteVehicleCrew _x } forEach (_C_130 select 1);
		deleteVehicle (_C_130 select 0);
		sleep 600;
		Call_drop_transport = false;
		publicVariable "Call_drop_transport";
	};
}, {hint "Передача координат отменена!"}, "Передача координат для сброса транспорта..."] call ace_common_fnc_progressBar;
