// ConvoyEnd.sqf
// © v.2.2 DECEMBER 2016 - Devastator_cm

private _convoyArray	= _this select 0; // All vehicles which are still in convoy
private _all_groups		= _this select 1; // All groups which are still in convoy
private _ConvoyID		= _this select 2; // In case there are multiple convoys, this parameter can be used to find out which one reached the final marker and do the necessary custom code branch easily
private _LastMarker		= _this select 3; // Last marker which convoy reached

{
	_x setSpeedMode  "NORMAL"; // Used to set the speed mode when convoy reaches last marker
    _x setCombatMode "YELLOW"; // Used to set the combat mode when convoy reaches last marker
    _x setBehaviour  "SAFE";   // Used to set the behaviour when convoy reaches last marker
} 	foreach _all_groups;

// Convoy ID 1 is the support unit. For the convoy with truck (convoy ID 2) there is no entry here as when it reaches to final marker it should simply stop
// If last marker is m_support_3 then it will go back to m_support_2, if it is m_support_2 then go to m_support_3. So it will make an infinite loop between them
if(_ConvoyID == 1  && _LastMarker == "m_support_3") then {_handle = [["m_support_2"],[APC], 50, 800, 1, "NORMAL", "SAFE"] spawn DEVAS_ConvoyMove;};
if(_ConvoyID == 1  && _LastMarker == "m_support_2") then {_handle = [["m_support_3"],[APC], 50, 800, 1, "NORMAL", "SAFE"] spawn DEVAS_ConvoyMove;};