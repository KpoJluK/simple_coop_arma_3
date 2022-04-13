class Dialog_Player_general
{
	idd=-1;
	movingenable=false;
	
	class controls 
	{
		class Slider_view_distanse
		{
			type = 43;
			idc = 1900;
			sliderRange[] = {200,12000};
			sliderStep = 0.1;
			sliderPosition = viewDistance;
			x = safeZoneX + safeZoneW * 0.19625;
			y = safeZoneY + safeZoneH * 0.32333334;
			w = safeZoneW * 0.411875;
			h = safeZoneH * 0.05555556;
			style = 1024;
			arrowEmpty = "\A3\ui_f\data\GUI\Cfg\Slider\arrowEmpty_ca.paa";
			arrowFull = "\A3\ui_f\data\GUI\Cfg\Slider\arrowFull_ca.paa";
			border = "\A3\ui_f\data\GUI\Cfg\Slider\border_ca.paa";
			color[] = {0.4,0.6,0.4,1};
			colorActive[] = {0,0.2,0,1};
			thumb = "\A3\ui_f\data\GUI\Cfg\Slider\thumb_ca.paa";
			
		};
		class Slider_overcast
		{
			type = 43;
			idc = 1901;
			sliderRange[] = {0,1};
			sliderStep = 0.1;
			sliderPosition = overcast;
			x = safeZoneX + safeZoneW * 0.19625;
			y = safeZoneY + safeZoneH * 0.51888889;
			w = safeZoneW * 0.411875;
			h = safeZoneH * 0.05555556;
			style = 1024;
			arrowEmpty = "\A3\ui_f\data\GUI\Cfg\Slider\arrowEmpty_ca.paa";
			arrowFull = "\A3\ui_f\data\GUI\Cfg\Slider\arrowFull_ca.paa";
			border = "\A3\ui_f\data\GUI\Cfg\Slider\border_ca.paa";
			color[] = {0.4,0.6,0.4,1};
			colorActive[] = {0,0.2,0,1};
			thumb = "\A3\ui_f\data\GUI\Cfg\Slider\thumb_ca.paa";
			
		};
		class Slider_view_time
		{
			type = 43;
			idc = 1902;
			sliderRange[] = {0,24};
			sliderStep = 0.1;
			sliderPosition = dayTime;
			x = safeZoneX + safeZoneW * 0.19625;
			y = safeZoneY + safeZoneH * 0.71555556;
			w = safeZoneW * 0.411875;
			h = safeZoneH * 0.05555556;
			style = 1024;
			arrowEmpty = "\A3\ui_f\data\GUI\Cfg\Slider\arrowEmpty_ca.paa";
			arrowFull = "\A3\ui_f\data\GUI\Cfg\Slider\arrowFull_ca.paa";
			border = "\A3\ui_f\data\GUI\Cfg\Slider\border_ca.paa";
			color[] = {0.4,0.6,0.4,1};
			colorActive[] = {0,0.2,0,1};
			thumb = "\A3\ui_f\data\GUI\Cfg\Slider\thumb_ca.paa";
			
		};
		class Text_view_distanse
		{
			type = 0;
			idc = 1904;
			x = safeZoneX + safeZoneW * 0.354375;
			y = safeZoneY + safeZoneH * 0.22444445;
			w = safeZoneW * 0.293125;
			h = safeZoneH * 0.06111112;
			style = 0+2;
			text = "Дальность прорисовки от 200 до 12000";
			colorBackground[] = {0.4,0.6,0.4,1};
			colorText[] = {0,0,0,1};
			font = "PuristaMedium";
			sizeEx = (((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 1);
			
		};
		class Text_Overcast
		{
			type = 0;
			idc = 1905;
			x = safeZoneX + safeZoneW * 0.354375;
			y = safeZoneY + safeZoneH * 0.42;
			w = safeZoneW * 0.29375;
			h = safeZoneH * 0.06111112;
			style = 0+2;
			text = "Погода от 0 до 1(только для администратора)";
			colorBackground[] = {0.4,0.6,0.4,1};
			colorText[] = {0,0,0,1};
			font = "PuristaMedium";
			sizeEx = (((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 1);
			
		};
		class Text_Overcast_copy1
		{
			type = 0;
			idc = 1906;
			x = safeZoneX + safeZoneW * 0.354375;
			y = safeZoneY + safeZoneH * 0.61555556;
			w = safeZoneW * 0.29375;
			h = safeZoneH * 0.06111112;
			style = 0+2;
			text = "Время суток от 0 до 24(только для администратора)";
			colorBackground[] = {0.4,0.6,0.4,1};
			colorText[] = {0,0,0,1};
			font = "PuristaMedium";
			sizeEx = (((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 1);
			
		};
		class General_Text
		{
			type = 0;
			idc = 1907;
			x = safeZoneX + safeZoneW * 0.29375;
			y = safeZoneY + safeZoneH * 0.10222223;
			w = safeZoneW * 0.4125;
			h = safeZoneH * 0.08555556;
			style = 0+2;
			text = "Меню игрока";
			colorBackground[] = {0.4,0.6,0.4,1};
			colorText[] = {0,0,0,1};
			font = "PuristaMedium";
			sizeEx = (((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 1);
			
		};
		class Edit_view_distanse
		{
			type = 2;
			idc = 1908;
			x = safeZoneX + safeZoneW * 0.62125;
			y = safeZoneY + safeZoneH * 0.32333334;
			w = safeZoneW * 0.088125;
			h = safeZoneH * 0.06111112;
			style = 0;
			text = "";
			autocomplete = "";
			colorBackground[] = {0.4,0.6,0.4,1};
			colorDisabled[] = {0.2,0.2,0.2,1};
			colorSelection[] = {0,0.2,0,1};
			colorText[] = {0,0,0,1};
			font = "PuristaMedium";
			sizeEx = (((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 1);
			canModify = true;
			maxChars = 5;
			
		};
		class Edit_overcast
		{
			type = 2;
			idc = 1909;
			x = safeZoneX + safeZoneW * 0.62125;
			y = safeZoneY + safeZoneH * 0.51777778;
			w = safeZoneW * 0.088125;
			h = safeZoneH * 0.06111112;
			style = 0;
			text = "";
			autocomplete = "";
			colorBackground[] = {0.4,0.6,0.4,1};
			colorDisabled[] = {0.2,0.2,0.2,1};
			colorSelection[] = {0,0.2,0,1};
			colorText[] = {0,0,0,1};
			font = "PuristaMedium";
			sizeEx = (((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 1);
			canModify = true;
			maxChars = 3;
			
		};
		class Edit_time
		{
			type = 2;
			idc = 1910;
			x = safeZoneX + safeZoneW * 0.62125;
			y = safeZoneY + safeZoneH * 0.71333334;
			w = safeZoneW * 0.088125;
			h = safeZoneH * 0.06111112;
			style = 0;
			text = "";
			autocomplete = "";
			colorBackground[] = {0.4,0.6,0.4,1};
			colorDisabled[] = {0.2,0.2,0.2,1};
			colorSelection[] = {0,0.2,0,1};
			colorText[] = {0,0,0,1};
			font = "PuristaMedium";
			sizeEx = (((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 1);
			canModify = true;
			maxChars = 2;
			
		};
		class Control1827551605
		{
			type = 1;
			idc = 1911;
			x = safeZoneX + safeZoneW * 0.71875;
			y = safeZoneY + safeZoneH * 0.32222223;
			w = safeZoneW * 0.0875;
			h = safeZoneH * 0.06111112;
			style = 0+2;
			text = "Применить";
			borderSize = 0;
			colorBackground[] = {0.4,0.6,0.4,1};
			colorBackgroundActive[] = {0,0.2,0,1};
			colorBackgroundDisabled[] = {0.2,0.2,0.2,1};
			colorBorder[] = {0,0,0,0};
			colorDisabled[] = {0.2,0.2,0.2,1};
			colorFocused[] = {0.2,0.2,0.2,1};
			colorShadow[] = {0,0,0,1};
			colorText[] = {0,0,0,1};
			font = "PuristaMedium";
			offsetPressedX = 0.01;
			offsetPressedY = 0.01;
			offsetX = 0.01;
			offsetY = 0.01;
			sizeEx = (((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 1);
			soundClick[] = {"\A3\ui_f\data\sound\RscButton\soundClick",0.09,1.0};
			soundEnter[] = {"\A3\ui_f\data\sound\RscButton\soundEnter",0.09,1.0};
			soundEscape[] = {"\A3\ui_f\data\sound\RscButton\soundEscape",0.09,1.0};
			soundPush[] = {"\A3\ui_f\data\sound\RscButton\soundPush",0.09,1.0};
			action = "setViewDistance sliderPosition 1900;";
			
		};
		class Control1827551605_copy1
		{
			type = 1;
			idc = 1912;
			x = safeZoneX + safeZoneW * 0.71875;
			y = safeZoneY + safeZoneH * 0.51777778;
			w = safeZoneW * 0.0875;
			h = safeZoneH * 0.06111112;
			style = 0+2;
			text = "Применить";
			borderSize = 0;
			colorBackground[] = {0.4,0.6,0.4,1};
			colorBackgroundActive[] = {0,0.2,0,1};
			colorBackgroundDisabled[] = {0.2,0.2,0.2,1};
			colorBorder[] = {0,0,0,0};
			colorDisabled[] = {0.2,0.2,0.2,1};
			colorFocused[] = {0.2,0.2,0.2,1};
			colorShadow[] = {0,0,0,1};
			colorText[] = {0,0,0,1};
			font = "PuristaMedium";
			offsetPressedX = 0.01;
			offsetPressedY = 0.01;
			offsetX = 0.01;
			offsetY = 0.01;
			sizeEx = (((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 1);
			soundClick[] = {"\A3\ui_f\data\sound\RscButton\soundClick",0.09,1.0};
			soundEnter[] = {"\A3\ui_f\data\sound\RscButton\soundEnter",0.09,1.0};
			soundEscape[] = {"\A3\ui_f\data\sound\RscButton\soundEscape",0.09,1.0};
			soundPush[] = {"\A3\ui_f\data\sound\RscButton\soundPush",0.09,1.0};
			action = "if(serverCommandAvailable '#kick')then{[[], {0 setOvercast sliderPosition 1901;}] remoteExec ['call',0];}else{hint'У вас нет прав администратора'}";
			
		};
		class Control1827551605_copy1_copy1
		{
			type = 1;
			idc = 1913;
			x = safeZoneX + safeZoneW * 0.71875;
			y = safeZoneY + safeZoneH * 0.71333334;
			w = safeZoneW * 0.0875;
			h = safeZoneH * 0.06111112;
			style = 0+2;
			text = "Применить";
			borderSize = 0;
			colorBackground[] = {0.4,0.6,0.4,1};
			colorBackgroundActive[] = {0,0.2,0,1};
			colorBackgroundDisabled[] = {0.2,0.2,0.2,1};
			colorBorder[] = {0,0,0,0};
			colorDisabled[] = {0.2,0.2,0.2,1};
			colorFocused[] = {0.2,0.2,0.2,1};
			colorShadow[] = {0,0,0,1};
			colorText[] = {0,0,0,1};
			font = "PuristaMedium";
			offsetPressedX = 0.01;
			offsetPressedY = 0.01;
			offsetX = 0.01;
			offsetY = 0.01;
			sizeEx = (((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 1);
			soundClick[] = {"\A3\ui_f\data\sound\RscButton\soundClick",0.09,1.0};
			soundEnter[] = {"\A3\ui_f\data\sound\RscButton\soundEnter",0.09,1.0};
			soundEscape[] = {"\A3\ui_f\data\sound\RscButton\soundEscape",0.09,1.0};
			soundPush[] = {"\A3\ui_f\data\sound\RscButton\soundPush",0.09,1.0};
			action = "if(serverCommandAvailable '#kick')then{[[], {skipTime ((sliderPosition 1902 - dayTime + 24) % 24);}] remoteExec ['call',0];}else{hint'У вас нет прав администратора'}";
			
		};
	};
};



