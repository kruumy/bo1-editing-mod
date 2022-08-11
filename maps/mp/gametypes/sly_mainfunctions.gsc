/*
	S L Y ' S   M V M   M O D
	https://twitter.com/slykuiper
	https://youtube.com/slykuiper
	https://slykuiper.com
*/

#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\gametypes\_hud_util;
	
init()
{
	level.players[0] thread SetupDvars();
	level.players[0] setClientDvar("cg_fov", "90");
	level.players[0] setClientDvar("cg_fovscale", "1.2");
}

SetupDvars()
{
	self endon( "death" );
	self endon("disconnect");
	wait 0.05;
	if (self.admin == true)
	{
		setDvar( "menu_fog_enabled", "0" );
		setDvar( "menu_fog_startdist", "0" );
		setDvar( "menu_fog_halfdist", "0" );
		setDvar( "menu_fog_R", "0" );
		setDvar( "menu_fog_G", "0" );
		setDvar( "menu_fog_B", "0" );
		
		setDvar( "r_filmUseTweaks", "0" );
		setDvar( "r_filmTweakEnable", "0" );
		setDvar( "menu_filmtweaklighttint_R", "0" );
		setDvar( "menu_filmtweaklighttint_G", "0" );
		setDvar( "menu_filmtweaklighttint_B", "0" );
		setDvar( "menu_filmtweakmidtint_R", "0" );
		setDvar( "menu_filmtweakmidtint_G", "0" );
		setDvar( "menu_filmtweakmidtint_B", "0" );
		setDvar( "menu_filmtweakdarktint_R", "0" );
		setDvar( "menu_filmtweakdarktint_G", "0" );
		setDvar( "menu_filmtweakdarktint_B", "0" );
		
		setDvar( "menu_lightTweakSunColor_R", "255" );
		setDvar( "menu_lightTweakSunColor_G", "255" );
		setDvar( "menu_lightTweakSunColor_B", "255" );
		setDvar( "menu_lightTweakSunDirection_X", "-90" );
		setDvar( "menu_lightTweakSunDirection_Y", "0" );
		setDvar( "r_lightTweakSunLight", "4" );
	
		while(1)
		{
			self thread menuSetFog();
			self thread menuSetFilmTweaks();
			self thread menuSetLightTweaks();
			wait 0.05;
		}
	}
}

menuSetFog()
{
	if( getDvar("menu_fog_enabled" ) == "1")
	{
		setDvar( "menu_fog_enabled_text", "On" );
		level.fogstartdist = getDvarFloat( "menu_fog_startdist" );
		level.foghalfdist = getDvarFloat( "menu_fog_halfdist" );
		level.fogcolorR = (getDvarFloat( "menu_fog_R") / 255);
		level.fogcolorG = (getDvarFloat( "menu_fog_G") / 255);
		level.fogcolorB = (getDvarFloat( "menu_fog_B") / 255);
		
		setExpFog( level.fogstartdist, level.foghalfdist, level.fogcolorR, level.fogcolorG, level.fogcolorB, 0 );
		//setVolFog(start_dist, half_dist, half_height, base_height, fog_r, fog_g, fog_b, fog_scale, sun_col_r, sun_col_g, sun_col_b, sun_dir_x, sun_dir_y, sun_dir_z, sun_start_ang, sun_stop_ang, time, max_fog_opacity);
	}
	else
	{
		setDvar( "menu_fog_enabled_text", "Off" );
	}
}

menuSetFilmTweaks()
{
	if( getDvar("r_filmUseTweaks" ) == "1")
	{
		setDvar( "menu_film_enabled_text", "On" );
		LightR = getDvarFloat( "menu_filmtweaklighttint_R" );
		LightG = getDvarFloat( "menu_filmtweaklighttint_G" );
		LightB = getDvarFloat( "menu_filmtweaklighttint_B" );
		
		MediumR = getDvarFloat( "menu_filmtweakmidtint_R" );
		MediumG = getDvarFloat( "menu_filmtweakmidtint_G" );
		MediumB = getDvarFloat( "menu_filmtweakmidtint_B" );
		
		DarkR = getDvarFloat( "menu_filmtweakdarktint_R" );
		DarkG = getDvarFloat( "menu_filmtweakdarktint_G" );
		DarkB = getDvarFloat( "menu_filmtweakdarktint_B" );
		
		setDvar( "r_filmtweaklighttint", (LightR, LightG, LightB) );
		setDvar( "r_filmtweakmidtint", (MediumR, MediumG, MediumB) );
		setDvar( "r_filmtweakdarktint", (DarkR, DarkG, DarkB) );
	}
	else
	{
		setDvar( "menu_film_enabled_text", "Off" );
		setDvar( "r_filmTweakEnable", "0" );
	}
}

menuSetLightTweaks()
{
	SunR = (getDvarFloat( "menu_lightTweakSunColor_R" ) / 255);
	SunG = (getDvarFloat( "menu_lightTweakSunColor_G" ) / 255);
	SunB = (getDvarFloat( "menu_lightTweakSunColor_B" ) / 255);
	
	SunX = getDvarFloat( "menu_lightTweakSunDirection_X" );
	SunY = getDvarFloat( "menu_lightTweakSunDirection_Y" );
	
	setDvar( "r_lighttweaksuncolor", (SunR, SunG, SunB) );
	setDvar( "r_lighttweaksundirection", (SunX, SunY, 0) );
}