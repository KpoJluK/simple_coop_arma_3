if(isNil "Call_drop_transport")then{
	Call_drop_transport = false;
	publicVariable "Call_drop_transport";
};
if(Call_drop_transport)exitWith{hint "Самолет еще не готов для взлета!"};
[5, [], {
	0 spawn {
		Call_drop_transport = true;
		publicVariable "Call_drop_transport";
		[[], {systemChat "По вашим координатам выслан борт припасами, сброс будет по вашим текущим координатм, ожидайте!"}] remoteExec ["call"];
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
				// спауним ящик
				_jeep = "I_E_CargoNet_01_ammo_F" createVehicle [0,0,1000]; // from red - "rhs_tigr_camo"
				_pos_plane = getPosATL (_C_130 select 0);
				sleep 1;
				_jeep setPosATL _pos_plane;
				// Удаляю инвентарь и добавляю новый
				clearMagazineCargoGlobal _jeep;
				clearWeaponCargoGlobal _jeep;
				clearBackpackCargoGlobal _jeep;
				clearItemCargoGlobal _jeep;

				_jeep addItemCargoGlobal ["PiR_bint", 10];
				_jeep addItemCargoGlobal ["ACE_M26_Clacker", 4];
				_jeep addItemCargoGlobal ["ACE_IR_Strobe_Item", 10];

				_jeep addItemCargoGlobal ["ACE_WaterBottle", 10];
				_jeep addItemCargoGlobal ["ACE_MRE_ChickenHerbDumplings", 10];
				_jeep addItemCargoGlobal ["ACE_Flashlight_XL50", 10];
				_jeep addItemCargoGlobal ["ACE_EntrenchingTool", 10];
				_jeep addItemCargoGlobal ["ACE_CableTie", 10];
				_jeep addItemCargoGlobal ["ItemMicroDAGR", 10];
				_jeep addItemCargoGlobal ["ACE_UAVBattery", 10];
				_jeep addItemCargoGlobal ["ACE_wirecutter", 1];

				_jeep addWeaponCargoGlobal ["rhs_weap_rpg26", 6];
				_jeep addWeaponCargoGlobal ["rhs_weap_igla", 2];
				_jeep addWeaponCargoGlobal ["rhs_weap_rpg7", 1];
				
				
				_jeep addMagazineCargoGlobal ["rhs_mag_9k38_rocket", 6];
				_jeep addMagazineCargoGlobal ["rhs_rpg7_PG7VM_mag", 6];
				_jeep addMagazineCargoGlobal ["rhs_VOG25", 30];
				_jeep addMagazineCargoGlobal ["SSOT_545_PMAG_Black_7n22", 30];
				_jeep addMagazineCargoGlobal ["SPEC_30Rnd_762x39_AK47_M", 30];
				_jeep addMagazineCargoGlobal ["rhs_100Rnd_762x54mmR_7BZ3", 30];
				_jeep addMagazineCargoGlobal ["VTN_RDGM", 20];
				_jeep addMagazineCargoGlobal ["rhs_mag_f1", 10];
				_jeep addMagazineCargoGlobal ["rhs_mag_rgd5", 10];
				_jeep addMagazineCargoGlobal ["rhs_mag_rgo", 10];
				_jeep addMagazineCargoGlobal ["rhs_mag_rdg2_white", 20];
				_jeep addMagazineCargoGlobal ["rhssaf_mine_tma4_mag", 10];
				_jeep addMagazineCargoGlobal ["rhs_mag_rdg2_white", 10];
				_jeep addMagazineCargoGlobal ["rhssaf_tm500_mag", 10];
				_jeep addMagazineCargoGlobal ["rhs_mine_ozm72_b_mag", 10];
				_jeep addMagazineCargoGlobal ["rhs_mine_ozm72_c_mag", 10];
				_jeep addMagazineCargoGlobal ["ace_csw_50Rnd_127x108_mag", 4];
				_jeep addMagazineCargoGlobal ["ace_compat_rhs_afrf3_mag_9m133m2", 2];
				
				_jeep addBackpackCargoGlobal ["RHS_Kornet_Gun_Bag", 1];
				_jeep addBackpackCargoGlobal ["RHS_Kornet_Tripod_Bag", 1];
				_jeep addBackpackCargoGlobal ["RHS_Kord_Tripod_Bag", 1];
				_jeep addBackpackCargoGlobal ["RHS_Kord_Gun_Bag", 1];
				

				
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
}, {hint "Передача координат отменена!"}, "Передача координат для припасов..."] call ace_common_fnc_progressBar;


