waitUntil{time >0};

count_civilian_vehicle = (paramsArray select 0); // civilan

count_enemy_vehicle_patrol = (paramsArray select 1); // enemy patrol

count_bloc_post_on_map = (paramsArray select 2); // bloc post

setViewDistance (paramsArray select 4); setObjectViewDistance (paramsArray select 4); // view distanse

acc_time_mission = (paramsArray select 5); // acc time
setTimeMultiplier acc_time_mission;

if((paramsArray select 6) > 0)then{		// fast night

	if(isNil "Stot_Fast_night")then{

		Stot_Fast_night = false;
		
	};

	waitUntil{

		if(dayTime > 19 or dayTime < 7)then{setTimeMultiplier (paramsArray select 6)}else{setTimeMultiplier acc_time_mission};
		sleep 60;
		Stot_Fast_night

	};

};

if(paramsArray select 8 > 0)then{
	[((paramsArray select 8) / 100)] call BIS_fnc_paramWeather; // wather
}else{
	[0] call BIS_fnc_paramWeather;
};

