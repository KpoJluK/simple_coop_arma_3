sleep 5;
//atack boot
attack_bot_mission_4_true = true;
publicVariable "attack_bot_mission_4_true";
//start download
private _Download = 0;
hint"Для передачи данных вы должны находиться близко к беспилотнику";
waitUntil{
	if((getPos player) inArea [getPos dron_down, 10, 10, 0, false])then{_Download = _Download + 0.5; hintSilent format ["Загружено %1 процент(ов)", _Download];}else{hint "Подойдите ближе к беспилотнику"};

sleep 1;
if(!alive player)exitwith{true};
_Download >= 100
};
if(!alive player)exitwith{
[] call fnc_drone_add_cation;
[[], {hint "Погиб боец который загружал данные"}] remoteExec ["call"];
};

date_download = true;
publicVariable "date_download";
sleep 10;
hint "";