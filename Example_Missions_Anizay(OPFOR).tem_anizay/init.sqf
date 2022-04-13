Board_1 addAction ["<t color='#ff2e2e'>Миссия уничтожить танк</t>", "  
 [[], {  
  0 spawn{  
   private _nearbyLocations = nearestLocations [center_map, ['Name','NameCity','NameCityCapital','NameVillage'], radius_map];  
   private _select_location = selectRandom _nearbyLocations;  
   private _locationPos = locationPosition _select_location;  
   private _list_roads = _locationPos nearRoads 500;  
   private _select_road = selectRandom _list_roads;  
   pos_mision_1 = getPos _select_road;  
   [pos_mision_1,tank_from_first_mission,independent,1500] execVM 'Other_mission\mission_1_destroy_tank'  
  };  
 }] remoteExec ['call',2];  
"]; 
 
 
Board_1 addAction ["<t color='#ff2e2e'>Миссия уничтожить вертолет</t>", "  
 [[], {  
  0 spawn{  
   private _nearbyLocations = nearestLocations [center_map, ['Name','NameCity','NameCityCapital','NameVillage'], radius_map];  
   private _select_location = selectRandom _nearbyLocations;  
   private _locationPos = locationPosition _select_location;  
   private _list_roads = _locationPos nearRoads 500;  
   private _select_road = selectRandom _list_roads;  
   pos_mision_2 = getPos _select_road;  
   [pos_mision_2,Heli_from_second_mission,independent,1500] execVM 'Other_mission\mission_2_destroy_helocopter\mission_1.sqf' 
  };  
 }] remoteExec ['call',2];  
"]; 
 
Board_1 addAction ["<t color='#ff2e2e'>Эвакуировать пилотов сбитого вертолета</t>", "  
 [[], {  
  0 spawn{  
  private _nearbyLocations = nearestLocations [center_map, ['Name','NameCity','NameCityCapital','NameVillage'], radius_map]; 
  private _select_location = selectRandom _nearbyLocations; 
  private _locationPos = locationPosition _select_location; 
  _locationPos set [2,0]; 
  pos_mision_3 = [_locationPos, 500, 1500, 20, 0, 0.5, 0] call BIS_fnc_findSafePos; 
  _select_next_location = nearestLocation [pos_mision_3, 'NameVillage']; 
  pos_mision_3_next = locationPosition _select_next_location; 
  pos_mision_3_next set[2,0]; 
     [pos_mision_3,frendly_down_heli_from_third_mission,pos_mision_3_next,side_frendly_pilots,class_name_frendly_pilots,pos_base] execVM 'Other_mission\mission_3_reqvest_pilots\mission_1.sqf' 
  };  
 }] remoteExec ['call',2];  
"]; 
 
Board_1 addAction ["<t color='#ff2e2e'>Найти сбитый беспилотник</t>", "  
 [[], {  
  0 spawn{  
  private _nearbyLocations = nearestLocations [center_map, ['Name','NameCity','NameCityCapital','NameVillage'], radius_map]; 
  private _select_location = selectRandom _nearbyLocations; 
  private _locationPos = locationPosition _select_location; 
  _locationPos set [2,0]; 
  pos_mision_4 = [_locationPos, 500, 1500, 20, 0, 0.5, 0] call BIS_fnc_findSafePos; 
     [ 
   pos_mision_4, 
            class_name_bespilotnik, 
            class_neme_APC_four_missions, 
            class_neme_helicopter_four_missions, 
            independent, 
            inf_missions_arry 
        ] execVM 'Other_mission\mission_4_find_bespilotnik\mission_1.sqf'; 
  };  
 }] remoteExec ['call',2];  
"]; 
 
 
Board_1 addAction ["<t color='#ff2e2e'>Уничтожить груз</t>", "  
 [[], {  
  0 spawn{  
 private _nearbyLocations = nearestLocations [center_map, ['Name','NameCity','NameCityCapital','NameVillage'], radius_map]; 
 private _select_location = selectRandom _nearbyLocations; 
 private _locationPos = locationPosition _select_location; 
 private _list_roads = _locationPos nearRoads 500; 
 private _select_road = selectRandom _list_roads; 
 pos_mision_5 = getPos _select_road; 
 [pos_mision_5,'Box_NATO_AmmoVeh_F',arry_class_name_vehicle_frendly,pos_base] execVM 'Other_mission\mission_5_destroy_cargo\mission_1.sqf'; 
  };  
 }] remoteExec ['call',2];  
"]; 
 
 
Board_1 addAction ["<t color='#ff2e2e'>Забрать чёрный ящик с упавшего вертолета</t>", "  
 [[], {  
  0 spawn{  
 private _nearbyLocations = nearestLocations [center_map, ['Name','NameCity','NameCityCapital','NameVillage'], radius_map]; 
 private _select_location = selectRandom _nearbyLocations; 
 private _locationPos = locationPosition _select_location; 
 _locationPos set [2,0]; 
 pos_mision_6 = [_locationPos, 500, 1500, 20, 0, 0.5, 0] call BIS_fnc_findSafePos; 
 [pos_mision_6,class_name_heli_pidbity_six_mission,class_nsme_box_to_destroy,pos_base] execVM 'Other_mission\mission_6_reqvest_black_cargo\mission_1.sqf'; 
 };  
 }] remoteExec ['call',2];  
"]; 
 
Board_1 addAction ["<t color='#ff2e2e'>Уничтожить артелерию</t>", "  
 [[], {  
  0 spawn{  
 private _nearbyLocations = nearestLocations [center_map, ['Name','NameCity','NameCityCapital','NameVillage'], radius_map]; 
 private _select_location = selectRandom _nearbyLocations; 
 private _locationPos = locationPosition _select_location; 
 _locationPos set [2,0]; 
 pos_mision_7 = [_locationPos, 500, 1500, 20, 0, 0.5, 0] call BIS_fnc_findSafePos; 
 [pos_mision_7,class_name_artilery_to_destroy,getPos MHQ_1] execVM 'Other_mission\mission_7_destroy_artilery\mission_1.sqf' 
 };  
 }] remoteExec ['call',2];  
"]; 
 
Board_1 addAction ["<t color='#ff2e2e'>Уничтожить колонну</t>", "     
 [[], {     
  0 spawn{
    waitUntil{
    pos_mision_8 = [0,0,0];
    private _nearbyLocations = nearestLocations [center_map, ['Name','NameCity','NameCityCapital','NameVillage'], radius_map];    
   private _randomLoacation = getPos selectRandom _nearbyLocations;   
 pos_mision_8 = [_randomLoacation, 200, 1000, 50, 0, 0.9, 0] call BIS_fnc_findSafePos;
 !(pos_mision_8 inArea [[0,0,0], 1000, 1000, 0, false])
 };       
   [pos_mision_8] execVM 'Other_mission\mission_8_destroy_vehicle_before\mission_1.sqf'    
 };     
 }] remoteExec ['call',2];     
"];   
 
Board_1 addAction ["<t color='#ff2e2e'>Освободить город</t>", "  
 [[], {  
  0 spawn{  
  private _nearbyLocations = nearestLocations [center_map, ['Name','NameCity','NameCityCapital','NameVillage'], radius_map]; 
  private _randomLoacation = getPos selectRandom _nearbyLocations; 
  private _nearestRoad = [_randomLoacation, 500] call BIS_fnc_nearestRoad; 
  pos_mision_9 = getPos _nearestRoad; 
  [pos_mision_9] execVM 'Other_mission\mission_9_liberate_city\mission_1.sqf' 
 };  
 }] remoteExec ['call',2];  
"]; 
 
Board_1 addAction ["<t color='#ff2e2e'>Уничтожить РЛС</t>", "  
 [[], {  
  0 spawn{  
  private _nearbyLocations = nearestLocations [center_map, ['Name','NameCity','NameCityCapital','NameVillage'],radius_map]; 
  private _select_location = selectRandom _nearbyLocations; 
  private _locationPos = locationPosition _select_location; 
  _locationPos set [2,0]; 
  pos_mision_10 = [_locationPos, 500, 1500, 20, 0, 0.5, 0] call BIS_fnc_findSafePos; 
  [pos_mision_10] execVM 'Other_mission\mission_10_destroy_rls\mission_1.sqf' 
 };  
 }] remoteExec ['call',2];  
"]; 
 
Board_1 addAction ["<t color='#ff2e2e'>Спасти заложника</t>", "  
 [[], {  
  0 spawn{  
  private _nearbyLocations = nearestLocations [center_map, ['Name','NameCity','NameCityCapital','NameVillage'], radius_map]; 
  private _select_location = selectRandom _nearbyLocations; 
  private _locationPos = locationPosition _select_location; 
  _locationPos set [2,0]; 
  pos_mision_11 = _locationPos; 
  [ 
   pos_mision_11, 
   arry_class_names_zaloznic, 
   inf_missions_arry, 
   300, 
   pos_base 
  ] execVM 'Other_mission\mission_11_reqvest_zaloznic\mission_1.sqf'; 
 };  
 }] remoteExec ['call',2];  
"]; 
 
 
Board_1 addAction ["<t color='#ff2e2e'>Захватить офицера</t>", "  
 [[], {  
  0 spawn{  
  private _nearbyLocations = nearestLocations [center_map, ['Name','NameCity','NameCityCapital','NameVillage'], radius_map]; 
  private _select_location = selectRandom _nearbyLocations; 
  private _locationPos = locationPosition _select_location; 
  _locationPos set [2,0]; 
  pos_mision_12 = _locationPos; 
       [ 
         pos_mision_12, 
   arry_class_names_officer, 
         inf_missions_arry, 
         300, 
         pos_base 
       ] execVM 'Other_mission\mission_12_capture_officere\mission_1.sqf'; 
 };  
 }] remoteExec ['call',2];  
"]; 
 
 
Board_1 addAction ["<t color='#ff2e2e'>Уничтожить образцы хим оружия</t>", "  
 [[], {  
 0 spawn{ 
  _nearbyLocations = nearestLocations [center_map, ['NameMarine'], radius_map];   
  pos_mision_13 = [0,0,0];  
  waitUntil{  
  _select_location = selectRandom _nearbyLocations;  
  _locationPos = locationPosition _select_location;  
  pos_mision_13 = _locationPos getPos [1000, random 360];  
  pos_mision_13 set [2,0];  
  ((ASLToATL pos_mision_13)select 2) >= 10 and ((ASLToATL pos_mision_13)select 2) <= 40  
 }; 
  [pos_mision_13,independent] execVM 'Other_mission\mission_13_recwest_lab_box(water)\mission_1.sqf'; 
 }; 
 
}] remoteExec ['call',2];  
"]; 
