if((_this select 0) == 1)then{
	if(isNil "Stot_Fast_night")then{
		Stot_Fast_night = false;
	};
	waitUntil{
		if(dayTime > 19 or dayTime < 7)then{setTimeMultiplier 120}else{setTimeMultiplier acc_time_mission};
		sleep 60;
		Stot_Fast_night
	};
};