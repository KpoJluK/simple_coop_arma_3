if(isNil "Call_air_deffense")then{
	Call_air_deffense = false;
	publicVariable "Call_air_deffense";
};

if(Call_air_deffense)exitWith{hint "Самолет еще не готов для взлета!"};

_target = ASLToAGL getPosASL player nearEntities [["Air"], 1000];

// проверка не являются ли цели союзними
{
	if(side _x isEqualTo side player)then{_target = _target - [_x]};
} forEach _target;



[[], {systemChat "Это Сокол 1, начинаю поиск воздушных целей в вашем квадранте..."}] remoteExec ["call"];

sleep 10;

if(isNil { _target select 0 })exitWith{

	[[], {systemChat "Это Сокол 1, воздушных целей рядом с Вами не нашел возвращаюсь на базу!"}] remoteExec ["call"];
	0 spawn{
		sleep 120;
		Call_air_deffense = false;
		publicVariable "Call_air_deffense";	
	};

};

_count_target = count _target - 1;

[[], {systemChat "Цели определены, ракеты пошли!"}] remoteExec ["call"];

Call_air_deffense = true;
publicVariable "Call_air_deffense";

	while {_count_target > -1} do
	{
		_pos_missle = (_target select _count_target) getPos [2000 + random 500, 0];
		_pos_missle set [2,2000];
		_missile = createVehicle ["ammo_Missile_AA_R77",_pos_missle,[],0,"CAN_COLLIDE"];
		_missile setDir getDir (_target select _count_target);
		_missile setMissileTarget (_target select _count_target);
		_count_target = _count_target - 1;
		sleep 2;
	};

0 spawn{
	sleep 1200;
	Call_air_deffense = false;
	publicVariable "Call_air_deffense";	
};

