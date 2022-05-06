if(isNil "stop_IED")then{
	stop_IED = false;
};
// find all road

_list_road = list_roads_all_map;

// road colouser base
{
	if(getPos _x inArea [getMarkerPos "Pos_base", 2500, 2500, 45, false])then{_list_road = _list_road - [_x]}
} forEach _list_road;


arry_ied = [];
arry_ied_armred = [];

// create trash on mam
for "_i" from 0 to ((count _list_road) / 100) do 
{
	sleep 0.1;
	_IED = (selectRandom trash_from_ied) createVehicle (selectRandom _list_road) getPos [2 + random 2, random 360];
	arry_ied pushBack _IED;
};

_count_ien_on_map = 20;
if(count arry_ied <= 20) then{_count_ien_on_map = count arry_ied};

waitUntil{

	// select random 20 trash
	waitUntil
	{
		_select_trash = selectRandom arry_ied;
		if!(_select_trash in arry_ied_armred)then{arry_ied_armred pushBack _select_trash};
		count arry_ied_armred >= _count_ien_on_map
	};

	// add bomb to select trash
	{
		[_x]spawn{

			params["_IED"];
			_timer = 600;
			waitUntil{
				
				if(!((allPlayers inAreaArray [getPos _IED, 10, 10, 45, false]) isEqualTo []) or !alive _IED)then{

						_pos = getPos _IED;
						_pos set [2, 3];
					 	_bomb = "Bo_GBU12_LGB" createVehicle getPos _IED;
						hideObjectGlobal _bomb;
					 	arry_ied = arry_ied - [_IED];
						deleteVehicle _IED;
					};
				sleep 5;
				_timer = _timer - 5;
				_timer <= 0
			};

		};	
	} forEach arry_ied_armred;

	sleep 610;

	arry_ied_armred = [];

	stop_IED
};



