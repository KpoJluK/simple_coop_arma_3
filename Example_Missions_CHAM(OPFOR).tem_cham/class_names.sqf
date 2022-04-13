// from spawner

inf_missions_arry = 
[
	"gm_ge_army_squadleader_g36a1_p2a1_90_flk", 
	"gm_ge_army_rifleman_g36a1_90_flk", 
	"gm_ge_army_radioman_g36a1_90_flk", 
	"gm_ge_army_engineer_g36a1_90_flk", 
	"gm_ge_army_paratrooper_g36a1_90_flk", 
	"gm_ge_army_marksman_g3a3_90_flk", 
	"gm_ge_army_machinegunner_mg3_90_flk", 
	"gm_ge_army_antitank_g36a1_pzf3_90_flk", 
	"gm_ge_army_antiair_g36a1_fim43_90_flk", 
	"gm_ge_army_grenadier_hk69a1_90_flk", 
	"gm_ge_army_demolition_g36a1_90_flk"
];

car_mission_arry = 
[
	"gm_ge_army_luchsa1", 
	"gm_ge_army_luchsa2", 
	"gm_ge_army_iltis_milan", 
	"gm_ge_army_iltis_mg3",
	"gm_ge_army_fuchsa0_reconnaissance"
];

hevy_vehicle_arry = 
[
	"gm_ge_army_marder1a1plus", 
	"gm_ge_army_marder1a1a", 
	"gm_ge_army_marder1a2", 
	"gm_ge_army_Leopard1a1", 
	"gm_ge_army_Leopard1a1a1", 
	"gm_ge_army_Leopard1a1a2", 
	"gm_ge_army_Leopard1a3", 
	"gm_ge_army_Leopard1a3a1", 
	"gm_ge_army_Leopard1a5"
];

anti_air_vehicle_arry = 
[
	"gm_ge_army_gepard1a1"
];

heli_vehecle_arry = 
[
	"gm_ge_army_bo105p_pah1a1", 
	"gm_ge_army_bo105p_pah1"
];

static_weapon_arry = 
[
	"gm_ge_army_mg3_aatripod"
];

arry_inf_call_help_vdv =[
	"SpecLib_O_R_S_Ratnik_AAT_F", 
    "SpecLib_O_R_S_Ratnik_TL_F", 
    "SpecLib_O_R_S_Ratnik_MG_F", 
    "SpecLib_O_R_S_Ratnik_AR_F", 
    "SpecLib_O_R_S_Ratnik_medic_F", 
    "SpecLib_O_R_S_Ratnik_M_F", 
    "SpecLib_O_R_S_Ratnik_GL_F", 
    "SpecLib_O_R_S_Ratnik_LAT_01_F"
];

// from missions vehicle 
//1
tank_from_first_mission = "gm_ge_army_Leopard1a5"; // танк который нужно уничтожить
//2
Heli_from_second_mission = "gm_ge_army_ch53gs"; //вертолет который нужно уничтожить
//3
frendly_down_heli_from_third_mission = "rhs_mi28n_vvsc"; //подбитый вертолет
side_frendly_pilots = EAST; //сторона пилотов которых нужно эвакуировать
class_name_frendly_pilots = "rhs_pilot_combat_heli"; //класс неймы пилотов которых нужно эвакуировать
//4
class_name_bespilotnik = "O_UAV_02_dynamicLoadout_F"; // класс нейм подбитого беспилотника
class_neme_APC_four_missions = selectRandom hevy_vehicle_arry; // массив класс нейм техники которая будет атаковать игроков 
class_neme_helicopter_four_missions = selectRandom heli_vehecle_arry; // массив класс нейм вертолетов которая будет атаковать игроков 
//5 
arry_class_name_vehicle_frendly = ["rhs_btr80a_forest", "VTN_KAMAZ63501_TRANSPORT_FLR","rhs_tigr_sts_forest"];// массв техники побитой союзной колонны
//6
class_name_heli_pidbity_six_mission = "Mi8Wreck"; // побитый вертолет
class_nsme_box_to_destroy = "CargoNet_01_box_F"; // класс нейм обьектв который нужно эвакуировать на базу
//7
class_name_artilery_to_destroy = "RHS_M119_WD"; // класс нейм артилерии которую нужно уничтожить
//8 
arry_class_name_vehicle_first_in_convoy = [
	"gm_ge_army_fuchsa0_reconnaissance", 
	"gm_ge_army_m113a1g_apc"
]; // класс нейм техники 1-й в колонне
arry_class_name_vehicle_second_in_convoy = [
	"gm_ge_army_m113a1g_command", 
	"gm_ge_army_u1300l_firefighter",
	"gm_ge_army_bibera0"
];
arry_class_name_vehicle_third_in_convoy = [
	"gm_ge_army_kat1_451_reammo", 
	"gm_ge_army_kat1_454_reammo", 
	"gm_ge_army_kat1_463_mlrs", 
	"gm_ge_army_m109g",
	"gm_ge_army_bibera0"
];
arry_class_name_vehicle_four_in_convoy = [
	"gm_ge_army_kat1_451_cargo", 
	"gm_ge_army_u1300l_cargo" 
];
arry_class_name_vehicle_five_in_convoy = [ 
	"gm_ge_army_m113a1g_apc_milan", 
	"gm_ge_army_bpz2a0" 

];
arry_class_name_vehicle_six_in_convoy = [ 
	"gm_ge_army_marder1a2", 
	"gm_ge_army_marder1a1a", 
	"gm_ge_army_marder1a1plus"
];
//9
class_name_zenitka_who_deffend_city = "UK3CB_AAF_I_ZU23"; // класс нейм стационарных зениток для обороны города ботами
//10
Class_name_stacionar_radar_to_destroy = "rhs_prv13"; //радар который нужно уничтожить
//11
arry_class_names_zaloznic = 
[
	"UK3CB_CHC_I_BODYG", 
	"UK3CB_CHC_I_FUNC", 
	"UK3CB_CHC_I_POLITIC", 
	"UK3CB_CHC_I_CAN"
]; // класс неймы заложников которыъ нужно спасти
//12
arry_class_names_officer = [
	"gm_ge_army_officer_p1_90_flk"
];
//13
arry_class_names_boats = [
	"UK3CB_NAP_I_Fishing_Boat_DSHKM", 
	"UK3CB_NAP_I_Fishing_Boat_SPG9", 
	"UK3CB_NAP_I_Fishing_Boat_Zu23_front"
];