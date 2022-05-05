// init param

[] execVM "Param_mision\Param_mision.sqf";

// init MHQ

[] execVM "MHQ\MHQ_script.sqf";


// add vehicle in fire
[
	true, // будут ли возгоратся машины (true - да false - нет)
    true,   // будут ли возгоратся Танки/БПМ (true - да false - нет)
    false,   // будут ли возгоратся воздушная техника (true - да false - нет) работает не всегда коректно 
    true, // наносить ли урон экипажу в горящей машине
    true,   // убитьвать ли экипаж машины если она сгорает (true - да false - нет)
    [60,90,120] // время за которое машина сгорит минимальное/среднее/максимальное (в сек) 
] execVM "Script\Vehicle_in_fire.sqf";

teleport1 = false;
publicVariable "teleport1";



pos_base = getMarkerPos "Pos_base";



//				find pos from mission			//

axis_map = worldSize / 2;
center_map = [axis_map, axis_map , 0];
radius_map = sqrt 2 * axis_map;


waitUntil{
	!isNil {Ready_enemy}
};

// script convoy

if!((car_mission_arry select 0) isEqualTo str objNull)then{
    [] execVM "Script\enemy_patrol.sqf";
};


//add class names 
[] execVM "class_names.sqf";


// init setConvoy
if!((car_mission_arry select 0) isEqualTo str objNull)then{
    [] execVM "Script\Convoy\ConvoyInit.sqf";
};

sleep 20;
// init bloc post
if!((static_weapon_bloc_post select 0) isEqualTo str objNull)then{
    [] execVM "Script\bloc_post.sqf";
};


if!(trash_from_ied isEqualTo [])then{
    [] execVM "Script\IED.sqf";
};

if!(vehicle_vivilian_arry isEqualTo [])then{
    [] execVM "Script\civilian_ambient.sqf";
};



//choise_mission = false;
//publicVariable "choise_mission";

//[] execVM "Script\ambush.sqf";



