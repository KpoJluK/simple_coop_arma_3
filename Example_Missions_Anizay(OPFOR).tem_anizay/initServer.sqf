teleport1 = false;
publicVariable "teleport1";

choise_mission = false;
publicVariable "choise_mission";

pos_base = getMarkerPos "Pos_base";

//[] execVM "Script\ambush.sqf";

// add vehicle in fire
[
	true, // будут ли возгоратся машины (true - да false - нет)
    true,   // будут ли возгоратся Танки/БПМ (true - да false - нет)
    false,   // будут ли возгоратся воздушная техника (true - да false - нет) работает не всегда коректно 
    true, // наносить ли урон экипажу в горящей машине
    true,   // убитьвать ли экипаж машины если она сгорает (true - да false - нет)
    [60,90,120] // время за которое машина сгорит минимальное/среднее/максимальное (в сек) 
] execVM "Script\Vehicle_in_fire.sqf";

//add class names 
[] execVM "class_names.sqf";

//				find pos from mission			//

axis_map = worldSize / 2;
center_map = [axis_map, axis_map , 0];
radius_map = sqrt 2 * axis_map;

// init setConvoy

[] execVM "Script\Convoy\ConvoyInit.sqf";

// init MHQ

[] execVM "MHQ\MHQ_script.sqf";

// script convoy

[] execVM "Script\enemy_patrol.sqf";
