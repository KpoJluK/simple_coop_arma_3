mhq_class_name = "rhs_tigr_sts_forest";

heli_civilian_arry = [
	"RHS_Mi8t_civilian", 
	"RHS_Mi8amt_civilian", 
	"C_Heli_Light_01_civil_F"
];

vehicle_vivilian_arry = [
	"C_Hatchback_01_sport_F", 
	"C_Offroad_01_F", 
	"C_Offroad_01_repair_F", 
	"C_SUV_01_F", 
	"C_Van_01_transport_F", 
	"C_Van_01_box_F"
];

trash_from_ied = 
[
	"Land_GarbageWashingMachine_F", 
	"Land_Garbage_square5_F", 
	"Land_GarbageBarrel_01_F", 
	"Land_GarbageHeap_01_F", 
	"Land_Tyre_F", 
	"Land_JunkPile_F", 
	"Land_Tyres_F", 
	"Land_GarbageHeap_04_F", 
	"Land_GarbageHeap_03_F", 
	"Land_GarbageHeap_02_F", 
	"Land_GarbageBarrel_02_F", 
	"Land_Sack_F", 
	"Land_Sacks_heap_F", 
	"Land_FishingGear_02_F", 
	"Land_CrabCages_F", 
	"Land_BarrelSand_F", 
	"Land_BarrelSand_grey_F", 
	"Land_BarrelTrash_F", 
	"Land_BarrelTrash_grey_F",
	"Land_TrailerCistern_wreck_F", 
	"Land_Wreck_HMMWV_F", 
	"Land_Wreck_Skodovka_F", 
	"Land_Wreck_Truck_F", 
	"Land_Wreck_Car2_F", 
	"Land_Wreck_Car_F", 
	"UK3CB_Lada_Wreck", 
	"Land_Wreck_Van_F", 
	"Land_Wreck_Offroad_F", 
	"Land_Wreck_Offroad2_F", 
	"Land_Wreck_UAZ_F", 
	"Land_Wreck_Truck_dropside_F", 
	"Land_V3S_wreck_F"
];

arry_class_names_zaloznic = 
[
	"UK3CB_CHC_I_BODYG", 
	"UK3CB_CHC_I_FUNC", 
	"UK3CB_CHC_I_POLITIC", 
	"UK3CB_CHC_I_CAN"
]; // класс неймы заложников которыъ нужно спасти
//12
arry_class_names_officer = [
	"UK3CB_CHD_I_COM"
]; //класс неймы офицеров которых нужно убить/захватить
//13
arry_class_names_boats = [
	"UK3CB_NAP_I_Fishing_Boat_DSHKM", 
	"UK3CB_NAP_I_Fishing_Boat_SPG9", 
	"UK3CB_NAP_I_Fishing_Boat_Zu23_front"
];

// во что будет одет союзный десант(спецназ) обязательно должен быть ПАРАШУТ

fnc_Eqvip_desant = {
		params["_unit"];
			comment "Remove existing items";
			removeAllWeapons _unit;
			removeAllItems _unit;
			removeAllAssignedItems _unit;
			removeUniform _unit;
			removeVest _unit;
			removeBackpack _unit;
			removeHeadgear _unit;
			removeGoggles _unit;

			comment "Add weapons";
			_unit addWeapon "rhs_weap_ak74mr";
			_unit addPrimaryWeaponItem "rhs_acc_ak5";
			_unit addPrimaryWeaponItem "rhs_acc_perst3_2dp_h";
			_unit addPrimaryWeaponItem "rhsusf_acc_su230a";
			_unit addPrimaryWeaponItem "rhs_30Rnd_545x39_7N22_AK";
			_unit addPrimaryWeaponItem "rhs_acc_grip_rk6";
			_unit addWeapon "rhs_weap_rpg26";
			_unit addWeapon "rhs_weap_pya";
			_unit addHandgunItem "rhs_mag_9x19_17";

			comment "Add containers";
			_unit forceAddUniform "TFN_L9_Gen3_fs_or_cb_NFlag_uniform";
			_unit addVest "AK_LBT";
			_unit addBackpack "B_Parachute";

			comment "Add items to containers";
			_unit addItemToUniform "ACE_IR_Strobe_Item";
			_unit addItemToUniform "PiR_bint";
			for "_i" from 1 to 2 do {_unit addItemToUniform "ACE_Chemlight_HiRed";};
			for "_i" from 1 to 2 do {_unit addItemToUniform "ACE_Chemlight_IR";};
			for "_i" from 1 to 2 do {_unit addItemToUniform "ACE_Chemlight_HiWhite";};
			_unit addItemToUniform "MS_Strobe_Mag_2";
			for "_i" from 1 to 2 do {_unit addItemToVest "PiR_bint";};
			for "_i" from 1 to 4 do {_unit addItemToVest "ACE_CableTie";};
			for "_i" from 1 to 6 do {_unit addItemToVest "rhs_30Rnd_545x39_7N22_AK";};
			for "_i" from 1 to 2 do {_unit addItemToVest "rhs_mag_rgd5";};
			for "_i" from 1 to 2 do {_unit addItemToVest "rhs_mag_9x19_17";};
			_unit addHeadgear "lshzmc2";
			_unit addGoggles "YuEBalaklava2mc";

			comment "Add items";
			_unit linkItem "ItemMap";
			_unit linkItem "ItemCompass";
			_unit linkItem "ACE_Altimeter";
			_unit linkItem "ItemRadio";
			_unit linkItem "ItemGPS";
			_unit linkItem "Louetta_PVS31A_2";

			comment "Set identity";
			[_unit,"WhiteHead_13","male02rus"] call BIS_fnc_setIdentity;
};

publicVariable "fnc_Eqvip_desant";

waitUntil{
	sleep 1;
	!isNil {Ready_enemy}
};

// боты которые прилетают на поддержку игрока
_sleltct_faction_count = [selectRandom allPlayers] call BIS_fnc_getFactions;
_player_faction = ([] call BIS_fnc_getFactions select _sleltct_faction_count);

_arry_inf_call_help_vdv_not_redy = "(getText (_x >> 'faction') == _player_faction) and (configName _x isKindOf ""Man"")" configClasses (configFile >> "CfgVehicles"); 

arry_inf_call_help_vdv = [];

{
	arry_inf_call_help_vdv pushBack (configName _x)
} forEach _arry_inf_call_help_vdv_not_redy;

{
	if(getNumber (configFile >> "CfgVehicles" >> _x >> "scope") < 1)then{arry_inf_call_help_vdv = arry_inf_call_help_vdv - [_x]};
} forEach arry_inf_call_help_vdv;

{
	if((getUnitLoadout _x select 0) isEqualTo [])then{arry_inf_call_help_vdv = arry_inf_call_help_vdv - [_x]};
} forEach arry_inf_call_help_vdv; 


// from missions vehicle 
//1
tank_from_first_mission = selectRandom hevy_vehicle_arry; // танк который нужно уничтожить(не менять)
//2
Heli_from_second_mission = selectRandom heli_vehecle_arry; //вертолет который нужно уничтожить(не менять)
//3
frendly_down_heli_from_third_mission = "rhs_mi28n_vvsc"; //союзный подбитый вертолет
side_frendly_pilots = side (selectRandom allPlayers); //сторона пилотов которых нужно эвакуировать(не менять)
class_name_frendly_pilots = "rhs_pilot_combat_heli"; //класс неймы союзных пилотов которых нужно эвакуировать
//4
class_name_bespilotnik = "O_UAV_02_dynamicLoadout_F"; // класс нейм подбитого беспилотника(не менять)
class_neme_APC_four_missions = selectRandom hevy_vehicle_arry; // массив класс нейм техники которая будет атаковать игроков (не менять)
class_neme_helicopter_four_missions = selectRandom heli_vehecle_arry; // массив класс нейм вертолетов которая будет атаковать игроков (не менять)
//5 
arry_class_name_vehicle_frendly = car_mission_arry;// массв техники побитой союзной колонны(не менять)
//6
class_name_heli_pidbity_six_mission = "Mi8Wreck"; // союзный транспортный побитый вертолет
class_nsme_box_to_destroy = "CargoNet_01_box_F"; // класс нейм обьектв который нужно эвакуировать на базу(не менять)
//7
class_name_artilery_to_destroy = "UK3CB_AAF_I_D30"; // класс нейм артилерии которую нужно уничтожить
//9
class_name_zenitka_who_deffend_city = "UK3CB_AAF_I_ZU23"; // класс нейм стационарных зениток для обороны города ботами
//10
Class_name_stacionar_radar_to_destroy = "rhs_prv13"; //радар который нужно уничтожить