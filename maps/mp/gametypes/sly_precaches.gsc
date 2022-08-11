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
	game["sly_main"] = "menu_sly_main";
	game["sly_fog"] = "menu_sly_fog";
	game["sly_film1"] = "menu_sly_film1";
	game["sly_light"] = "menu_sly_light";
	game["sly_dof"] = "menu_sly_dof";
	game["sly_bo3"] = "menu_sly_bo3";
	game["class"] = "class";
	
	precacheMenu(game["sly_main"]);
	precacheMenu(game["sly_fog"]);
	precacheMenu(game["sly_film1"]);
	precacheMenu(game["sly_light"]);
	precacheMenu(game["sly_dof"]);
	precacheMenu(game["sly_bo3"]);
	precacheMenu(game["class"]);
}