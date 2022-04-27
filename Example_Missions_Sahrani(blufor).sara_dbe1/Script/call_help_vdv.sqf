if(isNil "Call_help")then{
	Call_help = false;
	publicVariable "Call_help";
};
if(Call_help)exitWith{hint "Вертолет еще не готов для взлета!"};
[5, [], {
    0 spawn {
    Call_help = true;
    publicVariable "Call_help";
    //Сообщаем о вылете
    _select_player_pos = getPos player;
    player commandChat "Нам нужна немедленная помощь по нашим текущим координатам!";
    // Ищем позицию рядом с игроком
    _find_safe_pos = [position player, 100, 300, 15, 0, 0.3, 0] call BIS_fnc_findSafePos;
    if(isNil "_find_safe_pos")exitWith{hint "Возле вас негде приземлится!"};
    // Создаём невидимую вертолётную площадку, для точной посадки вертолёта
    private _helipad = "Land_HelipadEmpty_F" createVehicle _find_safe_pos;
    // Создаём группу десанта
    private _supgroup = createGroup [EAST,true];
    for "_i" from 0 to 12 do 
    {
    private _unit = _supgroup createUnit [selectRandom arry_inf_call_help_vdv, [0,0,0], [], 0, "FORM"];
    _unit setSkill 0.7;
    sleep 0.5
    };
    // Заводим их в группу для погрузки в вертолёт
    private _unitsCargo = units _supgroup;
    // Создаём вертолёт
    private _heli = createVehicle ["RHS_Mi8mt_vvsc",  [0,0,300], [], 0, "FLY"];
    // Создаём экипаж вертолёта
    createVehicleCrew _heli;
    // Создаём контрмеры для цикличного использования
    private _flares = {
        while {alive driver _this && {!(isTouchingGround _this)}} do {    
            sleep 2,5;
            _this action ["useWeapon", _this, driver _this, 0];
        };
    };
    // Создаём контрмеры для цикличного использования на отходе
    private _flares2 = {
        while {alive driver _this} do {    
            sleep 2,5;
            _this action ["useWeapon", _this, driver _this, 0];
        };
    };
    // Создаём группу в экипаже вертолёта, для отдачи указаний
    private _group = group driver _heli;
    // Объеденяем с переменной _heli для отдачи приказов
    _group addVehicle _heli;
    // Задаём параметр храбрости для экпиажа вертолёта
    {_x setSkill ["courage", 1]} forEach units _group;
    // Пововрачиваем вертолёт при спавне куда нам надо
    _heli setDir 270;
    // Сажаем всех ботов группы десанта в вертолёт
    {_x moveInCargo _heli} forEach _unitsCargo;
    // Приказываем вертолёту двигаться куда надо
    _heli domove getPos _helipad;
    //Сообщаем о вылете
    sleep 10;
    [[], {systemChat "По вашим координатам выслана ГБР ОСН ожидайте!";}] remoteExec ["call"];
    // Задаём высоту полёта
    _heli flyinheight 50;
    // Ждём пока дистанция будет менее 1000 метров - начинаем выпускать ловушки
    waitUntil {
    sleep 1;
    (_heli distance getPos _helipad) < 1000 or !alive _heli
    };
    if(!alive _heli)exitWith{};
    // Откидываем ловушки
    _heli spawn _flares;
    // Ждём пока дистанция будет менее 300 метров - приказываем садиться
    waitUntil {
    (_heli distance getPos _helipad) < 300 or !alive _heli
    };
    if(!alive _heli)exitWith{};
    // Садимся с высадкой десанта
    _heli land "get out";
    // Высота полёта = 0. На всякий случай.
    _heli flyInHeight 0;
    // Ждём пока вертолёт будет стоять на земле
    waitUntil {isTouchingGround _heli or !alive _heli};
    if(!alive _heli)exitWith{};
    // Выкидываем дымы по кругу
    for "_i" from 0 to 5 do 
    {
    _sPos = _heli getPos [10+random 10, random 360];
    _smoke1 = "SmokeShell" createVehicle _sPos;
    };
    // Приказываем группе десанта покинуть борт вертолёта
    _supgroup leaveVehicle _heli;
    // Ждём пока все челны группы десанта покинут вертолёт
    waitUntil {
    sleep 5;
    count (_unitsCargo select {alive _x && (!isNull objectParent _x)}) == 0
    };
    // Добавляем группе вейпоинт для дальнейшего движения
    _wp =_supgroup addWaypoint [position player, 0];
    _wp setWaypointType "HOLD";
    // Приказываем вертолёту уходить на указанные координаты
    if(!alive _heli)exitWith{};
    _heli domove [0,0,0];
    // Задаём высоту полёта
    _heli flyinheight 50;
    // Откидываем ловушки
    _heli spawn _flares2;
    // Ждём пока дистанция будет менее 300 метров - удаляем вертолёт
    waitUntil {
    sleep 1;
    if(!alive _heli)exitWith{};
    (_heli distance [0,0,0]) < 150
    };
    {deleteVehicle _x} forEach ((units group _heli) + [_heli]);
    //Ждем пока в зоне не будет игроков в радиусе 500м
    waitUntil{
    sleep 10;
    _player_in_area = allPlayers inAreaArray [getPos _helipad, 1000, 1000, 100, false];
    isNil {_player_in_area select 0}
    };
    //Удаляем ботов
    {deleteVehicle _x} forEach (units _supgroup);
    sleep 1800;
    Call_help = false;
    publicVariable "Call_help";
};
}, {hint "Передача отменена"}, "Определение и передача координат..."] call ace_common_fnc_progressBar;