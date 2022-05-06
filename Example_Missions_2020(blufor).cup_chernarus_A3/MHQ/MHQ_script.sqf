
/*
вставлять в инит передмета на базе для телепортации на кшм!(с 4 сточки по 20 включительно! )
[ 
 this,            
 "<t color='#ff2e2e'>Переместиться к КШМ</t>",           
 "\a3\ui_f\data\IGUI\Cfg\holdactions\holdAction_connect_ca.paa",  
 "\a3\ui_f\data\IGUI\Cfg\holdactions\holdAction_connect_ca.paa",  
 "_this distance _target < 3",       
 "_caller distance _target < 3",       
 {},              
 {},              
 { []spawn fnc_teleport },     
 {},              
 [],              
 1,              
 0,              
 false,             
 false             
] call BIS_fnc_holdActionAdd;
 
*/ 


params[["_mhq_1", "B_MRAP_01_F"],["_arry_pos", getPos Player]];


// teleport to MHQ

fnc_teleport = {

	if (teleport1)then{
		player setPos(MHQ_1 getPos [selectRandom [6,8,10],random 360]);
	}else{
		hint"КШМ не развернута!";
		sleep 5;
		hint"";
	};

};

publicVariable "fnc_teleport";

Teleport_mhq = True;

[_mhq_1,_arry_pos] spawn{
	params["_class_name_mhq_1","_arry_pos"];
	waitUntil{
		MHQ_1 = _class_name_mhq_1 createVehicle _arry_pos;
		publicVariable "MHQ_1";

		waitUntil{
			sleep 5;
			!alive MHQ_1 or isNil {MHQ_1}
		};

		deleteVehicle MHQ_1;

		teleport1 = false;
		publicVariable "teleport1";

		!Teleport_mhq
	};
};

sleep 5;

waitUntil{
	if(speed MHQ_1 > 0 or !alive MHQ_1 or isNil {MHQ_1})then{
		teleport1 = false;
		publicVariable "teleport1";
	}else{
		teleport1 = true;
		publicVariable "teleport1";
	};
	sleep 5;
	!Teleport_mhq
};