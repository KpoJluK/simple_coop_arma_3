while {true} do {
sleep 1200 + random 1200;
//выбор рандомного игрока
_selected_player = selectRandom allPlayers;
// жду пока игрок окажется в 500 метрах от базы и на дороге
	waitUntil {
		sleep 10;
		!((getPos _selected_player) inArea [pos_base, 1000, 1000, 0, false]) and isOnRoad (vehicle _selected_player)
	};
// создаю бомбу
_pos_from_bomb = _selected_player getPos [2,random 360];
_bomb = "R_80mm_HE" createVehicle _pos_from_bomb;
// нанесение урона технике
[[], {vehicle _selected_player setHit ["motor", 1];}] remoteExec ["call"];
// садаю игрокам бессознательное состояние
{[_x, true, 30, false] call ace_medical_fnc_setUnconscious;} forEach ((vehicle _selected_player) call BIS_fnc_listPlayers);
sleep 2;
// вырубаю мотор и убираю скорость
_list = nearestObjects [getPos _selected_player, ["Car", "Tank"], 10];
{_x setHit ["motor", 1]} forEach _list;
{_x setVelocity [0, 0, 0]} forEach _list;
// поиск позиции для группы ботов
_pos_ambush = [getPos _selected_player, 100, 250, 3, 0, 0.9,0] call BIS_fnc_findSafePos;
// создаю группу ботов
_grup_ambush = createGroup [independent, true];
// создаю юнитов
for "_i" from 0 to random [4,8,10] do 
{
	selectRandom[
	"AAFGM_specops_TL", 
	"AAFGM_specops_MG", 
	"AAFGM_specops", 
	"AAFGM_specops_M", 
	"AAFGM_specops_Medic"
] createUnit [_pos_ambush, _grup_ambush];
	sleep 0.5;
};
// бестрашие для ботов
{_x setSkill ["courage", 1]} forEach units _grup_ambush;
// маршрутная точка
_wp =_grup_ambush addWaypoint [_pos_from_bomb, 0];
_wp setWaypointType "HOLD";
sleep 10 + random 15;
{[_x, false] call ace_medical_fnc_setUnconscious} forEach ((vehicle _selected_player) call BIS_fnc_listPlayers);
// жду пока игроков не окажется в зоне
waitUntil{
sleep 10;
_player_in_area = allPlayers inAreaArray [_pos_from_bomb, 500, 500, 100, false];
isNil {_player_in_area select 0}
};
// удаление ботов
{deleteVehicle _x} forEach (units _grup_ambush);
};