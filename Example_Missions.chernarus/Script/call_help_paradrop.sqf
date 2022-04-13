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
			((getPos (_C_130 select 0)) inArea [_Position_player, 150, 150, 0, false])
		};
		// создаю группу десанта
		private _group_desant = createGroup [EAST, true];
		_pos_C_130 = getPosATL (_C_130 select 0);
		for "_i" from 0 to 8 do 
		{
			_pos_X = (_pos_C_130 select 0) + random [-100,0,100];
			_pos_Y = (_pos_C_130 select 1) + random [-100,0,100];
			_pos_Z = (_pos_C_130 select 2) + random [-100,0,100];

			_unit_desant = _group_desant createUnit ["SpecLib_O_R_S_Ratnik_medic_F",[_pos_X, _pos_Y, _pos_Z], [], 0, "FORM"];
			_unit_desant setSkill 1;
			_unit_desant setSkill ["courage", 1];


			comment "Remove existing items";
			removeAllWeapons _unit_desant;
			removeAllItems _unit_desant;
			removeAllAssignedItems _unit_desant;
			removeUniform _unit_desant;
			removeVest _unit_desant;
			removeBackpack _unit_desant;
			removeHeadgear _unit_desant;
			removeGoggles _unit_desant;

			comment "Add weapons";
			_unit_desant addWeapon "rhs_weap_ak74mr";
			_unit_desant addPrimaryWeaponItem "rhs_acc_ak5";
			_unit_desant addPrimaryWeaponItem "rhs_acc_perst3_2dp_h";
			_unit_desant addPrimaryWeaponItem "rhsusf_acc_su230a";
			_unit_desant addPrimaryWeaponItem "rhs_30Rnd_545x39_7N22_AK";
			_unit_desant addPrimaryWeaponItem "rhs_acc_grip_rk6";
			_unit_desant addWeapon "rhs_weap_rpg26";
			_unit_desant addWeapon "rhs_weap_pya";
			_unit_desant addHandgunItem "rhs_mag_9x19_17";

			comment "Add containers";
			_unit_desant forceAddUniform "TFN_L9_Gen3_fs_or_cb_NFlag_uniform";
			_unit_desant addVest "AK_LBT";
			_unit_desant addBackpack "B_Parachute";

			comment "Add items to containers";
			_unit_desant addItemToUniform "ACE_IR_Strobe_Item";
			_unit_desant addItemToUniform "PiR_bint";
			for "_i" from 1 to 2 do {_unit_desant addItemToUniform "ACE_Chemlight_HiRed";};
			for "_i" from 1 to 2 do {_unit_desant addItemToUniform "ACE_Chemlight_IR";};
			for "_i" from 1 to 2 do {_unit_desant addItemToUniform "ACE_Chemlight_HiWhite";};
			_unit_desant addItemToUniform "MS_Strobe_Mag_2";
			for "_i" from 1 to 2 do {_unit_desant addItemToVest "PiR_bint";};
			for "_i" from 1 to 4 do {_unit_desant addItemToVest "ACE_CableTie";};
			for "_i" from 1 to 6 do {_unit_desant addItemToVest "rhs_30Rnd_545x39_7N22_AK";};
			for "_i" from 1 to 2 do {_unit_desant addItemToVest "rhs_mag_rgd5";};
			for "_i" from 1 to 2 do {_unit_desant addItemToVest "rhs_mag_9x19_17";};
			_unit_desant addHeadgear "lshzmc2";
			_unit_desant addGoggles "YuEBalaklava2mc";

			comment "Add items";
			_unit_desant linkItem "ItemMap";
			_unit_desant linkItem "ItemCompass";
			_unit_desant linkItem "ACE_Altimeter";
			_unit_desant linkItem "ItemRadio";
			_unit_desant linkItem "ItemGPS";
			_unit_desant linkItem "Louetta_PVS31A_2";

			comment "Set identity";
			[_unit_desant,"WhiteHead_13","male02rus"] call BIS_fnc_setIdentity;


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