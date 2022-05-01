if(isNil "stop_IED")then{
	stop_IED = false;
};

waitUntil{
	{
		[_x]spawn{
			params["_player"];
			_random_pos = _player getPos [300 + random 700, random 360];
			_nearest_road = [_random_pos, 1500] call BIS_fnc_nearestRoad;
			_IED = (selectRandom trash_from__IED) createVehicle (_nearest_road getPos [random 5, random 360]);
			_timer = 600;
			waitUntil{
				sleep 5;
				_timer <= 0 or _player inArea [getPos _IED, 10, 10, 45, false] or !alive _IED
			};
			if((random 100 > 50 and _player inArea [getPos _IED, 10, 10, 45, false]) or !alive _IED)then{bomb="Bo_GBU12_LGB" createVehicle (_IED getPos [2,random 360])};
		};
	} forEach allPlayers;
	sleep 610;
	stop_IED
};
