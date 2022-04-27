list_vehicle = getPos Repair_and_rearm nearEntities [["Car","Motorcycle","Tank","Air"], 20];
if(isNil {list_vehicle select 0})exitWith{hint"Техники не найдено!"};
if(count list_vehicle > 1)exitWith{hint"На площадке должно находится не более одной еденицы техники!"};

sleep 1;

[(getDammage (list_vehicle select 0) - 1) * 25, [], {Hint "Ремонт завершон";(list_vehicle select 0) setDamage 0}, {hint "Действие прервано"}, "Ремонт..."] call ace_common_fnc_progressBar;

sleep 1;

[(fuel (list_vehicle select 0) - 1) * 25, [], {Hint "Заправка завершена";(list_vehicle select 0) setFuel 1}, {hint "Действие прервано"}, "Заправка..."] call ace_common_fnc_progressBar;

sleep 1;

[30, [], {Hint "Перевооружение завершено!";(list_vehicle select 0) setVehicleAmmo 1}, {hint "Действие прервано"}, "Перевооружение..."] call ace_common_fnc_progressBar;
