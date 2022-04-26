/*
[
    true, // будут ли возгоратся машины (true - да false - нет)
    true,   // будут ли возгоратся Танки/БПМ (true - да false - нет)
    false,   // будут ли возгоратся воздушная техника (true - да false - нет) работает не всегда коректно 
    true, // наносить ли урон экипажу в горящей машине
    true,   // убитьвать ли экипаж машины если она сгорает (true - да false - нет)
    [60,90,120] // время за которое машина сгорит минимальное/среднее/максимальное (в сек) 
]execVM "Vehicle_in_fire.sqf";
*/

params 
[
    ["_car_burn",true],
    ["_Tank_burn",true],
    ["_Air_burn",true],
    ["_damage_crew",true],
    ["_kill_crew",true],
    ["_time_to_burn_osnova",[60,90,120]]
];

_arry_type_vehilce = [];

if(_car_burn isEqualTo true)then{_arry_type_vehilce append ["Car","Motorcycle"]};
if(_Tank_burn isEqualTo true)then{_arry_type_vehilce append ["Tank"]};
if(_Air_burn isEqualTo true)then{_arry_type_vehilce append ["Air"]};


// arry vehicle in fire
vehicle_on_fire = [];

if(isNil "STOP_burning_vehicle_car")then{STOP_burning_vehicle_car = true};

while {STOP_burning_vehicle_car} do {
    // all vehicle
    _vehicle = entities [_arry_type_vehilce, [], false, true];;
        { if(_x getHitPointDamage "hitEngine" >= 0.91) then{
            if(_x in vehicle_on_fire or !alive _x)exitWith{};
            vehicle_on_fire pushBack _x;
            [_x,_time_to_burn_osnova,_damage_crew,_kill_crew] spawn {
                params ["_vehicle_select","_time_to_burn_osnova","_damage_crew","_kill_crew"];
                // add action
                [
                    _vehicle_select,											// Object the action is attached to
                    "Потушить машину",										// Title of the action
                    "\a3\ui_f_oldman\data\IGUI\Cfg\holdactions\repair_ca.paa",	// Idle icon shown on screen
                    "\a3\ui_f_oldman\data\IGUI\Cfg\holdactions\repair_ca.paa",	// Progress icon shown on screen
                    "_this distance _target < 5",						// Condition for the action to be shown
                    "_caller distance _target < 5",						// Condition for the action to progress
                    {},													// Code executed when action starts
                    {},													// Code executed on every progress tick
                    {   
                        (_this select 0) setHitPointDamage ["hitEngine", 0.7];
                        [[], {[ (_this select 0),0 ] call BIS_fnc_holdActionRemove;}] remoteExec ["call",0];
                    },				// Code executed on completion
                    {},													// Code executed on interrupted
                    [_vehicle_select],													// Arguments passed to the scripts as _this select 3
                    10,													// Action duration in seconds
                    0,													// Priority
                    true,												// Remove on completion
                    false												// Show in unconscious state
                ] remoteExec ["BIS_fnc_holdActionAdd", 0, _vehicle_select];	// MP compatible implementation


                //find engine
                _pos_fire_in_vehicle = [0, 1.5, -0.7];
                if(_vehicle_select selectionPosition "hit_engine" isNotEqualTo [0,0,0])then{
                    _pos_fire_in_vehicle = _vehicle_select selectionPosition "hit_engine";
                    _pos_fire_in_vehicle set [0,0];
                };
                if(_vehicle_select selectionPosition "motor" isNotEqualTo [0,0,0])then{
                    _pos_fire_in_vehicle = _vehicle_select selectionPosition "motor";
                    _pos_fire_in_vehicle set [0,0];
                };
                // create fire
                _Fire = "#particlesource" createVehicle [0,0,0]; 
                _Fire setParticleClass "MediumDestructionFire"; 
                _Fire attachTo [_vehicle_select, _pos_fire_in_vehicle];
                // create smoke
                _Smoke = "#particlesource" createVehicle [0,0,0]; 
                _Smoke setParticleClass "MediumDestructionSmoke"; 
                _Smoke attachTo [_vehicle_select, _pos_fire_in_vehicle];
                // create light
                _light = createVehicle ["#lightpoint", [0,0,0], [], 0, "CAN_COLLIDE"];
                _light attachTo [_vehicle_select, _pos_fire_in_vehicle];
                _light setLightBrightness 1.0;
                _light setLightColor [1,0.85,0.6];
                _light setLightAmbient [1,0.3,0];
                _light setLightIntensity 400;
                _light setLightAttenuation [0,0,0,2];
                _light setLightDayLight true;
                // time to destroid
                _time_to_destroid = random _time_to_burn_osnova;
                // talk about vehicle in fine
                [[], {
                    hint(parseText "<t color='#ff0000'><t size='2.0'>Машина горит!!!</t></t>");
                    sleep 10;
                    hint "";
                }] remoteExec ["spawn",crew _vehicle_select];
                // add sound 

                [_Fire]spawn{
                    waitUntil{
                        playSound3D ["A3\Sounds_F\sfx\fire1_loop.wss", (_this select 0)];
                        sleep 8;
                    !alive (_this select 0)
                    };
                };
                // wait until !alive vehicle or "hitEngine" <= 0.9
                waitUntil{
                    sleep 1;
                    _time_to_destroid = _time_to_destroid - 1;
                    if(_damage_crew isEqualTo true)then{{_x setDamage (getDammage _x + 0.0020)} forEach crew _vehicle_select;};
                    !alive _vehicle_select or _vehicle_select getHitPointDamage "hitEngine" <= 0.9 or _time_to_destroid <= 0;
                };
                if(_time_to_destroid <=0)then{
                    _vehicle_select setDamage 1;
                    if(_kill_crew isEqualTo true)then{{_x setDamage 1} forEach crew _vehicle_select};
                };
                deleteVehicle _Fire;
                deleteVehicle _Smoke;
                deleteVehicle _light;
                vehicle_on_fire = vehicle_on_fire - [_vehicle_select];
                [_vehicle_select,10 ] call BIS_fnc_holdActionRemove;
            }
        }
    } forEach _vehicle;
    sleep 15;
};