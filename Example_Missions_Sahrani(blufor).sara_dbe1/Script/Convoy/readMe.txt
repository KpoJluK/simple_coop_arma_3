// © November 2016 - Devastator_cm
// Tested with Development Build 1.64.138732


Thanks to Norrin for the initial scripts and idea which I used as base for my version

To use: 

1. Copy the convoy folder into your mission directory
2. Create a convoy of AI vehicles, not grouped. Make sure each vehicle is named in the editor
3. Add markers on the map that you want the convoy to move through
4. Call "convoy\convoyInit.sqf" from your init.sqf to initialize the scripts (this must occour before step 5)
5. Add the code (see below) either to your init.sqf (which will start the convoy right away when mission starts) or to a trigger to start the convoy
6. convoy\ConvoyEnd.sqf is called automatically when convoy reaches the final marker. Any further actions which convoy needs to take can be coded in this file by user.
   Check ConvoyEnd.sqf file for further information.

Code:
if (isServer) then 
{
	_handle = [["pos_1","pos_2","pos_3","pos_4"],[v_1,v_2,v_3], 35, 500, 120, 1, "NORMAL", "CARELESS"] spawn DEVAS_ConvoyMove; 
};


The code parameters in the script-call are:

1. An array of moveTo Markers for the convoy eg. ["pos1","pos2","pos3","pos4"]
2. An array that contains the names of the vehicles in the convoy eg. [c1,c2,c3,c4,c5,c6]. This array should not have any " symbol
3. Speed limit for convoy. I tested it with 35. This value can be time to time less due to speed corrections
4. Enemy search range. Enemies in this range will be considered as danger. Minimum value for this parameter is 300.
5. Convoy restart delay in seconds, after an ambush. 
6. Convoy ID. It provides the ability to the user to branch the code in ConvoyEnd.sqf based on the given ID in case there are multiple convoys in map
7. Speed mode of convoy. I suggest to use Normal. It should match to speed limit which is given.
8. Behaviour. For a convoy careless is suggested behaviour so it can follow the roads without a problem.



License:  These scripts are not to be altered or used for commercial or military purposes without the author's prior consent.
