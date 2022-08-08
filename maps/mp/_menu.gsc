#include maps\mp\_utility;
#include maps\mp\gametypes\_hud_util;
#include common_scripts\utility;

init()
{
	level thread onPlayerConnect();
}
onPlayerConnect()
{
	for(;;)
	{
		level waittill("connecting", player);
		player thread onPlayerSpawned();
	}
}
onPlayerSpawned()
{
	self endon("disconnect");
	for(;;)
	{
		self waittill("spawned_player");
		self iprintlnbold("Press ^2[{+smoke}]^7 To Open Menu");
		self thread BuildMenu();
	}
}

// Start of menu logic

BuildMenu()
{
	self endon("disconnect");
	self endon("death");
	self.MenuOpen = false;
	self.Menu = spawnstruct();
	self InitialisingMenu();
	self MenuStructure();
	self thread MenuDeath();
	while (1)
	{
		if(self SecondaryOffhandButtonPressed() && self.MenuOpen == false)
		{
			self MenuOpening();
			self LoadMenu("Main Menu");
		}
		else if (self MeleeButtonPressed() && self.MenuOpen == true)
		{
			self MenuClosing();
			wait 0.5;
		}
		else if(self FragButtonPressed() && self.MenuOpen == true)
		{
			if(isDefined(self.Menu.System["MenuPrevious"][self.Menu.System["MenuRoot"]]))
			{
				self.Menu.System["MenuCurser"] = 0;
				self SubMenu(self.Menu.System["MenuPrevious"][self.Menu.System["MenuRoot"]]);
				wait 0.3;
			}
		}
		else if (self AdsButtonPressed() && self.MenuOpen == true)
		{
			self.Menu.System["MenuCurser"] -= 1;
			if (self.Menu.System["MenuCurser"] < 0)
			{
				self.Menu.System["MenuCurser"] = self.Menu.System["MenuTexte"][self.Menu.System["MenuRoot"]].size - 1;
			}
			self.Menu.Material["Scrollbar"] elemMoveY(.2, 60 + (self.Menu.System["MenuCurser"] * 15.6));
			wait.1;
		}
		else if (self AttackButtonpressed() && self.MenuOpen == true)
		{
			self.Menu.System["MenuCurser"] += 1;
			if (self.Menu.System["MenuCurser"] >= self.Menu.System["MenuTexte"][self.Menu.System["MenuRoot"]].size)
			{
				self.Menu.System["MenuCurser"] = 0;
			}
			self.Menu.Material["Scrollbar"] elemMoveY(.2, 60 + (self.Menu.System["MenuCurser"] * 15.6));
			wait.1;
		}
		else if(self UseButtonPressed() && self.MenuOpen == true)
		{
		        wait 0.1;
			    if(self.Menu.System["MenuRoot"]=="Clients Menu") self.Menu.System["ClientIndex"]=self.Menu.System["MenuCurser"];
				self thread [[self.Menu.System["MenuFunction"][self.Menu.System["MenuRoot"]][self.Menu.System["MenuCurser"]]]](self.Menu.System["MenuInput"][self.Menu.System["MenuRoot"]][self.Menu.System["MenuCurser"]]);
				wait 0.3;
		}
		wait 0.05;
	}
}	

MenuStructure()
{
    self MainMenu("Main Menu", undefined);
	self MenuOption("Main Menu", 0, "QuickStart", ::QuickStart);
	self MenuOption("Main Menu", 1, "Bots", ::SubMenu, "BotMenu");
	self MenuOption("Main Menu", 2, "Weapons", ::SubMenu,"weapons menu");
	self MenuOption("Main Menu", 3, "Kill Streaks", ::SubMenu, "KillstreakMenu");
	self MenuOption("Main Menu", 4, "Player", ::SubMenu, "PlayerMenu");
	self MenuOption("Main Menu", 5, "Misc", ::SubMenu, "MiscMenu");
	
	self MainMenu("BotMenu", "Main Menu");
	self MenuOption("BotMenu", 0, "Spawn 5 Random Bots", ::SpawnBots,"5");
	self MenuOption("BotMenu", 1, "Spawn 5 Allies Bots", ::SpawnAlliesBots,"5");
	self MenuOption("BotMenu", 2, "Spawn 5 Axis Bots", ::SpawnAxisBots,"5");
	self MenuOption("BotMenu", 3, "Teleport Bots To Crosshair", ::SetupBots);
	self MenuOption("BotMenu", 4, "Freeze Bots", ::FreezeBots);
	self MenuOption("BotMenu", 5, "Clone Self", ::CreateClone);
	
	self MainMenu("KillstreakMenu", "Main Menu");
	self MenuOption("KillstreakMenu", 0, "Radar", ::doKillstreak,"radar_mp");
	self MenuOption("KillstreakMenu", 1, "RCBomb", ::doKillstreak,"rcbomb_mp");
	self MenuOption("KillstreakMenu", 2, "CounterUAV", ::doKillstreak,"counteruav_mp");
	self MenuOption("KillstreakMenu", 3, "Auto Tow", ::doKillstreak,"auto_tow_mp");
	self MenuOption("KillstreakMenu", 4, "Napalm", ::doKillstreak,"napalm_mp");
	self MenuOption("KillstreakMenu", 5, "Autoturret", ::doKillstreak,"autoturret_mp");
	self MenuOption("KillstreakMenu", 6, "Mortar", ::doKillstreak,"mortar_mp");
	self MenuOption("KillstreakMenu", 7, "Comlink", ::doKillstreak,"helicopter_comlink_mp");
	self MenuOption("KillstreakMenu", 8, "M220 Tow", ::doKillstreak,"m220_tow_mp");
	self MenuOption("KillstreakMenu", 9, "Airstrike", ::doKillstreak,"airstrike_mp");
	self MenuOption("KillstreakMenu", 10, "Chopper Gunner", ::doKillstreak,"helicopter_gunner_mp");
	self MenuOption("KillstreakMenu", 11, "Dogs", ::doKillstreak,"dogs_mp");
	self MenuOption("KillstreakMenu", 12, "Helicopter", ::doKillstreak,"helicopter_player_firstperson_mp");
	self MenuOption("KillstreakMenu", 13, "Supply Drop", ::doKillstreak,"supply_drop_mp");
	self MenuOption("KillstreakMenu", 14, "Reaper", ::doKillstreak,"m202_flash_mp");
	self MenuOption("KillstreakMenu", 15, "Stationary Heli", ::SpawnStaticHeli);
	
	self MainMenu("PlayerMenu", "Main Menu");
	self MenuOption("PlayerMenu", 0, "Explosive Bullets", ::EBToggle);
	self MenuOption("PlayerMenu", 1, "Auto Canswap", ::CSToggle);
	self MenuOption("PlayerMenu", 2, "Forge Mode", ::ForgeToggle);
	self MenuOption("PlayerMenu", 3, "All Perks", ::GivePerks);

	self MainMenu("MiscMenu", "Main Menu");
	self MenuOption("MiscMenu", 0, "Spawn Bounce", ::Bounce);
	self MenuOption("MiscMenu", 1, "Clear Bodies", ::ClearBodies);

	self MainMenu("weapons menu", "Main Menu");
    self MenuOption("weapons menu", 0, "submachine gun", ::SubMenu, "submachine guns");
    self MenuOption("weapons menu", 1, "assault rifles", ::SubMenu, "assault rifles");
    self MenuOption("weapons menu", 2, "shotguns", ::SubMenu, "shotguns");
    self MenuOption("weapons menu", 3, "light machine guns", ::SubMenu, "light machine guns");
    self MenuOption("weapons menu", 4, "sniper rifles", ::SubMenu, "snipers");
    self MenuOption("weapons menu", 5, "pistols", ::SubMenu, "pistols");
    self MenuOption("weapons menu", 6, "launchers", ::SubMenu, "launchers");
    self MenuOption("weapons menu", 7, "specials", ::SubMenu, "specials");
    self MenuOption("weapons menu", 8, "super specials", ::SubMenu, "super specials");
    self MenuOption("weapons menu", 9, "Change Camos", ::SubMenu, "camo menu");

	self MainMenu("camo menu", "Main Menu");
    self MenuOption("camo menu", 0, "take camo", ::changeCamo, 0);
    self MenuOption("camo menu", 1, "give random camo", ::randomCamo);
    self MenuOption("camo menu", 2, "dusty", ::changeCamo, 1);
    self MenuOption("camo menu", 3, "ice", ::changeCamo, 2);
    self MenuOption("camo menu", 4, "red", ::changeCamo, 3);
    self MenuOption("camo menu", 5, "olive", ::changeCamo, 4);
    self MenuOption("camo menu", 6, "nevada", ::changeCamo, 5);
    self MenuOption("camo menu", 7, "sahara", ::changeCamo, 6);
    self MenuOption("camo menu", 8, "ERDL", ::changeCamo, 7);
    self MenuOption("camo menu", 9, "tiger", ::changeCamo, 8);
    self MenuOption("camo menu", 10, "berlin", ::changeCamo, 9);
    self MenuOption("camo menu", 11, "warsaw", ::changeCamo, 10);
    self MenuOption("camo menu", 12, "siberia", ::changeCamo, 11);
    self MenuOption("camo menu", 13, "yukon", ::changeCamo, 12);
    self MenuOption("camo menu", 14, "woodland", ::changeCamo, 13);
    self MenuOption("camo menu", 15, "flora", ::changeCamo, 14);
    self MenuOption("camo menu", 16, "gold", ::changeCamo, 15);

	self MainMenu("snipers", "weapons menu");
    self MenuOption("snipers", 0, "dragunov", ::SubMenu, "dragunov");
    self MenuOption("snipers", 1, "wa2000", ::SubMenu, "wa2000");
    self MenuOption("snipers", 2, "l96a1", ::SubMenu, "l96a1");
    self MenuOption("snipers", 3, "psg1", ::SubMenu, "psg1");
    
    self MainMenu("dragunov", "snipers");
    self MenuOption("dragunov", 0, "extended mags", ::GivePlayerWeapon, "dragunov_extclip_mp");
    self MenuOption("dragunov", 1, "acog sight", ::GivePlayerWeapon, "dragunov_acog_mp");
    self MenuOption("dragunov", 2, "infrared sight", ::GivePlayerWeapon, "dragunov_ir_mp");
    self MenuOption("dragunov", 3, "suppressor", ::GivePlayerWeapon, "dragunov_silencer_mp");
    self MenuOption("dragunov", 4, "variable zoom", ::GivePlayerWeapon, "dragunov_vzoom_mp");
    self MenuOption("dragunov", 5, "default", ::GivePlayerWeapon, "dragunov_mp");
    self MenuOption("dragunov", 6, "2 attachments", ::SubMenu, "dragunov 2 attachments");
    
    self MainMenu("dragunov 2 attachments", "dragunov");
    self MenuOption("dragunov 2 attachments", 0, "extended mag x acog sight", ::GivePlayerWeapon, "dragunov_acog_extclip_mp");
    self MenuOption("dragunov 2 attachments", 1, "extended mag x infrared sight", ::GivePlayerWeapon, "dragunov_ir_extclip_mp");
    self MenuOption("dragunov 2 attachments", 2, "extended mag x suppressor", ::GivePlayerWeapon, "dragunov_extclip_silencer_mp");
    self MenuOption("dragunov 2 attachments", 3, "extended mag x variable zoom", ::GivePlayerWeapon, "dragunov_vzoom_extclip_mp");
    self MenuOption("dragunov 2 attachments", 4, "suppressor x acog sight", ::GivePlayerWeapon, "dragunov_acog_silencer_mp");
    self MenuOption("dragunov 2 attachments", 5, "suppressor x infrared sight", ::GivePlayerWeapon, "dragunov_ir_silencer_mp");
    self MenuOption("dragunov 2 attachments", 6, "suppressor x variable zoom", ::GivePlayerWeapon, "dragunov_vzoom_silencer_mp");
    
    self MainMenu("wa2000", "snipers");
    self MenuOption("wa2000", 0, "extended mags", ::GivePlayerWeapon, "wa2000_extclip_mp");
    self MenuOption("wa2000", 1, "acog sight", ::GivePlayerWeapon, "wa2000_acog_mp");
    self MenuOption("wa2000", 2, "infrared sight", ::GivePlayerWeapon, "wa2000_ir_mp");
    self MenuOption("wa2000", 3, "suppressor", ::GivePlayerWeapon, "wa2000_silencer_mp");
    self MenuOption("wa2000", 4, "variable zoom", ::GivePlayerWeapon, "wa2000_vzoom_mp");
    self MenuOption("wa2000", 5, "default", ::GivePlayerWeapon, "wa2000_mp");
    self MenuOption("wa2000", 6, "2 attachments", ::SubMenu, "wa2000 2 attachments");
    
    self MainMenu("wa2000 2 attachments", "wa2000");
    self MenuOption("wa2000 2 attachments", 0, "extended mag x acog sight", ::GivePlayerWeapon, "wa2000_acog_extclip_mp");
    self MenuOption("wa2000 2 attachments", 1, "extended mag x infrared sight", ::GivePlayerWeapon, "wa2000_ir_extclip_mp");
    self MenuOption("wa2000 2 attachments", 2, "extended mag x suppressor", ::GivePlayerWeapon, "wa2000_extclip_silencer_mp");
    self MenuOption("wa2000 2 attachments", 3, "extended mag x variable zoom", ::GivePlayerWeapon, "wa2000_vzoom_extclip_mp");
    self MenuOption("wa2000 2 attachments", 4, "suppressor x acog sight", ::GivePlayerWeapon, "wa2000_acog_silencer_mp");
    self MenuOption("wa2000 2 attachments", 5, "suppressor x infrared sight", ::GivePlayerWeapon, "wa2000_ir_silencer_mp");
    self MenuOption("wa2000 2 attachments", 6, "suppressor x variable zoom", ::GivePlayerWeapon, "wa2000_vzoom_silencer_mp");
    
    self MainMenu("l96a1", "snipers");
    self MenuOption("l96a1", 0, "extended mags", ::GivePlayerWeapon, "l96a1_extclip_mp");
    self MenuOption("l96a1", 1, "acog sight", ::GivePlayerWeapon, "l96a1_acog_mp");
    self MenuOption("l96a1", 2, "infrared sight", ::GivePlayerWeapon, "l96a1_ir_mp");
    self MenuOption("l96a1", 3, "suppressor", ::GivePlayerWeapon, "l96a1_silencer_mp");
    self MenuOption("l96a1", 4, "variable zoom", ::GivePlayerWeapon, "l96a1_vzoom_mp");
    self MenuOption("l96a1", 5, "default", ::GivePlayerWeapon, "l96a1_mp");
    self MenuOption("l96a1", 6, "2 attachments", ::SubMenu, "l96a1 2 attachments");
    
    self MainMenu("l96a1 2 attachments", "l96a1");
    self MenuOption("l96a1 2 attachments", 0, "extended mag x acog sight", ::GivePlayerWeapon, "l96a1_acog_extclip_mp");
    self MenuOption("l96a1 2 attachments", 1, "extended mag x infrared sight", ::GivePlayerWeapon, "l96a1_ir_extclip_mp");
    self MenuOption("l96a1 2 attachments", 2, "extended mag x suppressor", ::GivePlayerWeapon, "l96a1_extclip_silencer_mp");
    self MenuOption("l96a1 2 attachments", 3, "extended mag x variable zoom", ::GivePlayerWeapon, "l96a1_vzoom_extclip_mp");
    self MenuOption("l96a1 2 attachments", 4, "suppressor x acog sight", ::GivePlayerWeapon, "l96a1_acog_silencer_mp");
    self MenuOption("l96a1 2 attachments", 5, "suppressor x infrared sight", ::GivePlayerWeapon, "l96a1_ir_silencer_mp");
    self MenuOption("l96a1 2 attachments", 6, "suppressor x variable zoom", ::GivePlayerWeapon, "l96a1_vzoom_silencer_mp");
    
    self MainMenu("psg1", "snipers");
    self MenuOption("psg1", 0, "extended mags", ::GivePlayerWeapon, "psg1_extclip_mp");
    self MenuOption("psg1", 1, "acog sight", ::GivePlayerWeapon, "psg1_acog_mp");
    self MenuOption("psg1", 2, "infrared sight", ::GivePlayerWeapon, "psg1_ir_mp");
    self MenuOption("psg1", 3, "suppressor", ::GivePlayerWeapon, "psg1_silencer_mp");
    self MenuOption("psg1", 4, "variable zoom", ::GivePlayerWeapon, "psg1_vzoom_mp");
    self MenuOption("psg1", 5, "default", ::GivePlayerWeapon, "psg1_mp");
    self MenuOption("psg1", 6, "2 attachments", ::SubMenu, "psg1 2 attachments");
    
    self MainMenu("psg1 2 attachments", "psg1");
    self MenuOption("psg1 2 attachments", 0, "extended mag x acog sight", ::GivePlayerWeapon, "psg1_acog_extclip_mp");
    self MenuOption("psg1 2 attachments", 1, "extended mag x infrared sight", ::GivePlayerWeapon, "psg1_ir_extclip_mp");
    self MenuOption("psg1 2 attachments", 2, "extended mag x suppressor", ::GivePlayerWeapon, "psg1_extclip_silencer_mp");
    self MenuOption("psg1 2 attachments", 3, "extended mag x variable zoom", ::GivePlayerWeapon, "psg1_vzoom_extclip_mp");
    self MenuOption("psg1 2 attachments", 4, "suppressor x acog sight", ::GivePlayerWeapon, "psg1_acog_silencer_mp");
    self MenuOption("psg1 2 attachments", 5, "suppressor x infrared sight", ::GivePlayerWeapon, "psg1_ir_silencer_mp");
    self MenuOption("psg1 2 attachments", 6, "suppressor x variable zoom", ::GivePlayerWeapon, "psg1_vzoom_silencer_mp");
    
    self MainMenu("shotguns", "weapons menu");
    self MenuOption("shotguns", 0, "olympia", ::GivePlayerWeapon, "rottweil72_mp");
    self MenuOption("shotguns", 1, "stakeout", ::SubMenu, "stakeout");
    self MenuOption("shotguns", 2, "spas-12", ::SubMenu, "spas-12");
    self MenuOption("shotguns", 3, "hs10", ::SubMenu, "hs10");
    
    self MainMenu("stakeout", "shotguns");
    self MenuOption("stakeout", 0, "grip", ::GivePlayerWeapon, "ithaca_grip_mp");
    self MenuOption("stakeout", 1, "default", ::GivePlayerWeapon, "ithaca_mp");
    
    self MainMenu("spas-12", "shotguns");
    self MenuOption("spas-12", 0, "suppressor", ::GivePlayerWeapon, "spas_silencer_mp");
    self MenuOption("spas-12", 1, "default", ::GivePlayerWeapon, "spas_mp");
    
    self MainMenu("hs10", "shotguns");
    self MenuOption("hs10", 0, "dual wield", ::GivePlayerWeapon, "hs10dw_mp");
    self MenuOption("hs10", 1, "dual wield glitched", ::GivePlayerWeapon, "hs10lh_mp");
    self MenuOption("hs10", 2, "default", ::GivePlayerWeapon, "hs10_mp");
    
    self MainMenu("assault rifles", "weapons menu");
    self MenuOption("assault rifles", 0, "m16", ::SubMenu, "m16");
    self MenuOption("assault rifles", 1, "enfield", ::SubMenu, "enfield");
    self MenuOption("assault rifles", 2, "m14", ::SubMenu, "m14");
    self MenuOption("assault rifles", 3, "famas", ::SubMenu, "famas");
    self MenuOption("assault rifles", 4, "galil", ::SubMenu, "galil");
    self MenuOption("assault rifles", 5, "aug", ::SubMenu, "aug");
    self MenuOption("assault rifles", 6, "fnfal", ::SubMenu, "fnfal");
    self MenuOption("assault rifles", 7, "ak47", ::SubMenu, "ak47");
    self MenuOption("assault rifles", 8, "commando", ::SubMenu, "commando");
    self MenuOption("assault rifles", 9, "g11", ::SubMenu, "g11");
    
    self MainMenu("m16", "assault rifles");
    self MenuOption("m16", 0, "extended mag", ::GivePlayerWeapon, "m16_extclip_mp");
    self MenuOption("m16", 1, "dual mag", ::GivePlayerWeapon, "m16_dualclip_mp");
    self MenuOption("m16", 2, "acog sight", ::GivePlayerWeapon, "m16_acog_mp");
    self MenuOption("m16", 3, "red dot sight", ::GivePlayerWeapon, "m16_elbit_mp");
    self MenuOption("m16", 4, "reflex sight", ::GivePlayerWeapon, "m16_reflex_mp");
    self MenuOption("m16", 5, "masterkey", ::GivePlayerWeapon, "m16_mk_mp");
    self MenuOption("m16", 6, "flamethrower", ::GivePlayerWeapon, "m16_ft_mp");
    self MenuOption("m16", 7, "infrared scope", ::GivePlayerWeapon, "m16_ir_mp");
    self MenuOption("m16", 8, "suppressor", ::GivePlayerWeapon, "m16_silencer_mp");
    self MenuOption("m16", 9, "grenade launcher", ::GivePlayerWeapon, "m16_gl_mp");
    self MenuOption("m16", 10, "default", ::GivePlayerWeapon, "m16_mp");
    self MenuOption("m16", 11, "2 attachments", ::SubMenu, "m16 2 attachments");
    
    self MainMenu("m16 2 attachments", "m16");
    self MenuOption("m16 2 attachments", 0, "extended mag", ::SubMenu, "m16 extended mag");
    self MenuOption("m16 2 attachments", 1, "dual mag", ::SubMenu, "m16 dual mag");
    self MenuOption("m16 2 attachments", 2, "masterkey", ::SubMenu, "m16 masterkey");
    self MenuOption("m16 2 attachments", 3, "flamethrower", ::SubMenu, "m16 flamethrower");
    self MenuOption("m16 2 attachments", 4, "grenade launcher", ::SubMenu, "m16 grenade launcher");
    
    self MainMenu("m16 extended mag", "m16 2 attachments");
    self MenuOption("m16 extended mag", 0, "acog sight", ::GivePlayerWeapon, "m16_acog_extclip_mp");
    self MenuOption("m16 extended mag", 1, "red dot sight", ::GivePlayerWeapon, "m16_elbit_extclip_mp");
    self MenuOption("m16 extended mag", 2, "reflex sight", ::GivePlayerWeapon, "m16_reflex_extclip_mp");
    self MenuOption("m16 extended mag", 3, "masterkey", ::GivePlayerWeapon, "m16_mk_extclip_mp");
    self MenuOption("m16 extended mag", 4, "flamethrower", ::GivePlayerWeapon, "m16_ft_extclip_mp");
    self MenuOption("m16 extended mag", 5, "infrared scope", ::GivePlayerWeapon, "m16_ir_extclip_mp");
    self MenuOption("m16 extended mag", 6, "suppressor", ::GivePlayerWeapon, "m16_extclip_silencer_mp");
    self MenuOption("m16 extended mag", 7, "grenade launcher", ::GivePlayerWeapon, "m16_gl_extclip_mp");
    
    self MainMenu("m16 dual mag", "m16 2 attachments");
    self MenuOption("m16 dual mag", 0, "acog sight", ::GivePlayerWeapon, "m16_acog_dualclip_mp");
    self MenuOption("m16 dual mag", 1, "red dot sight", ::GivePlayerWeapon, "m16_elbit_dualclip_mp");
    self MenuOption("m16 dual mag", 2, "reflex sight", ::GivePlayerWeapon, "m16_reflex_dualclip_mp");
    self MenuOption("m16 dual mag", 3, "masterkey", ::GivePlayerWeapon, "m16_mk_dualclip_mp");
    self MenuOption("m16 dual mag", 4, "flamethrower", ::GivePlayerWeapon, "m16_ft_dualclip_mp");
    self MenuOption("m16 dual mag", 5, "infrared scope", ::GivePlayerWeapon, "m16_ir_dualclip_mp");
    self MenuOption("m16 dual mag", 6, "suppressor", ::GivePlayerWeapon, "m16_dualclip_silencer_mp");
    self MenuOption("m16 dual mag", 7, "grenade launcher", ::GivePlayerWeapon, "m16_gl_dualclip_mp");
    
    self MainMenu("m16 masterkey", "m16 2 attachments");
    self MenuOption("m16 masterkey", 0, "extended mag", ::GivePlayerWeapon, "m16_mk_extclip_mp");
    self MenuOption("m16 masterkey", 1, "dual mag", ::GivePlayerWeapon, "m16_mk_dualclip_mp");
    self MenuOption("m16 masterkey", 2, "acog sight", ::GivePlayerWeapon, "m16_acog_mk_mp");
    self MenuOption("m16 masterkey", 3, "red dot sight", ::GivePlayerWeapon, "m16_elbit_mk_mp");
    self MenuOption("m16 masterkey", 4, "reflex sight", ::GivePlayerWeapon, "m16_reflex_mk_mp");
    self MenuOption("m16 masterkey", 5, "infrared scope", ::GivePlayerWeapon, "m16_ir_mk_mp");
    self MenuOption("m16 masterkey", 6, "suppressor", ::GivePlayerWeapon, "m16_mk_silencer_mp");

    self MainMenu("m16 flamethrower", "m16 2 attachments");
    self MenuOption("m16 flamethrower", 0, "extended mag", ::GivePlayerWeapon, "m16_ft_extclip_mp");
    self MenuOption("m16 flamethrower", 1, "dual mag", ::GivePlayerWeapon, "m16_ft_dualclip_mp");
    self MenuOption("m16 flamethrower", 2, "acog sight", ::GivePlayerWeapon, "m16_acog_ft_mp");
    self MenuOption("m16 flamethrower", 3, "red dot sight", ::GivePlayerWeapon, "m16_elbit_ft_mp");
    self MenuOption("m16 flamethrower", 4, "reflex sight", ::GivePlayerWeapon, "m16_reflex_ft_mp");
    self MenuOption("m16 flamethrower", 5, "infrared scope", ::GivePlayerWeapon, "m16_ir_ft_mp");
    self MenuOption("m16 flamethrower", 6, "suppressor", ::GivePlayerWeapon, "m16_ft_silencer_mp");
    
    self MainMenu("m16 grenade launcher", "m16 2 attachments");
    self MenuOption("m16 grenade launcher", 0, "extended mag", ::GivePlayerWeapon, "m16_gl_extclip_mp");
    self MenuOption("m16 grenade launcher", 1, "dual mag", ::GivePlayerWeapon, "m16_gl_dualclip_mp");
    self MenuOption("m16 grenade launcher", 2, "acog sight", ::GivePlayerWeapon, "m16_acog_gl_mp");
    self MenuOption("m16 grenade launcher", 3, "red dot sight", ::GivePlayerWeapon, "m16_elbit_gl_mp");
    self MenuOption("m16 grenade launcher", 4, "reflex sight", ::GivePlayerWeapon, "m16_reflex_gl_mp");
    self MenuOption("m16 grenade launcher", 5, "infrared scope", ::GivePlayerWeapon, "m16_gl_ir_mp");
    self MenuOption("m16 grenade launcher", 6, "suppressor", ::GivePlayerWeapon, "m16_gl_silencer_mp");
    
    self MainMenu("enfield", "assault rifles");
    self MenuOption("enfield", 0, "extended mag", ::GivePlayerWeapon, "enfield_extclip_mp");
    self MenuOption("enfield", 1, "dual mag", ::GivePlayerWeapon, "enfield_dualclip_mp");
    self MenuOption("enfield", 2, "acog sight", ::GivePlayerWeapon, "enfield_acog_mp");
    self MenuOption("enfield", 3, "red dot sight", ::GivePlayerWeapon, "enfield_elbit_mp");
    self MenuOption("enfield", 4, "reflex sight", ::GivePlayerWeapon, "enfield_reflex_mp");
    self MenuOption("enfield", 5, "masterkey", ::GivePlayerWeapon, "enfield_mk_mp");
    self MenuOption("enfield", 6, "flamethrower", ::GivePlayerWeapon, "enfield_ft_mp");
    self MenuOption("enfield", 7, "infrared scope", ::GivePlayerWeapon, "enfield_ir_mp");
    self MenuOption("enfield", 8, "suppressor", ::GivePlayerWeapon, "enfield_silencer_mp");
    self MenuOption("enfield", 9, "grenade launcher", ::GivePlayerWeapon, "enfield_gl_mp");
    self MenuOption("enfield", 10, "default", ::GivePlayerWeapon, "enfield_mp");
    self MenuOption("enfield", 11, "2 attachments", ::SubMenu, "enfield 2 attachments");
    
    self MainMenu("enfield 2 attachments", "enfield");
    self MenuOption("enfield 2 attachments", 0, "extended mag", ::SubMenu, "enfield extended mag");
    self MenuOption("enfield 2 attachments", 1, "dual mag", ::SubMenu, "enfield dual mag");
    self MenuOption("enfield 2 attachments", 2, "masterkey", ::SubMenu, "enfield masterkey");
    self MenuOption("enfield 2 attachments", 3, "flamethrower", ::SubMenu, "enfield flamethrower");
    self MenuOption("enfield 2 attachments", 4, "grenade launcher", ::SubMenu, "enfield grenade launcher");
    
    self MainMenu("enfield extended mag", "enfield 2 attachments");
    self MenuOption("enfield extended mag", 0, "acog sight", ::GivePlayerWeapon, "enfield_acog_extclip_mp");
    self MenuOption("enfield extended mag", 1, "red dot sight", ::GivePlayerWeapon, "enfield_elbit_extclip_mp");
    self MenuOption("enfield extended mag", 2, "reflex sight", ::GivePlayerWeapon, "enfield_reflex_extclip_mp");
    self MenuOption("enfield extended mag", 3, "masterkey", ::GivePlayerWeapon, "enfield_mk_extclip_mp");
    self MenuOption("enfield extended mag", 4, "flamethrower", ::GivePlayerWeapon, "enfield_ft_extclip_mp");
    self MenuOption("enfield extended mag", 5, "infrared scope", ::GivePlayerWeapon, "enfield_ir_extclip_mp");
    self MenuOption("enfield extended mag", 6, "suppressor", ::GivePlayerWeapon, "enfield_extclip_silencer_mp");
    self MenuOption("enfield extended mag", 7, "grenade launcher", ::GivePlayerWeapon, "enfield_gl_extclip_mp");
    
    self MainMenu("enfield dual mag", "enfield 2 attachments");
    self MenuOption("enfield dual mag", 0, "acog sight", ::GivePlayerWeapon, "enfield_acog_dualclip_mp");
    self MenuOption("enfield dual mag", 1, "red dot sight", ::GivePlayerWeapon, "enfield_elbit_dualclip_mp");
    self MenuOption("enfield dual mag", 2, "reflex sight", ::GivePlayerWeapon, "enfield_reflex_dualclip_mp");
    self MenuOption("enfield dual mag", 3, "masterkey", ::GivePlayerWeapon, "enfield_mk_dualclip_mp");
    self MenuOption("enfield dual mag", 4, "flamethrower", ::GivePlayerWeapon, "enfield_ft_dualclip_mp");
    self MenuOption("enfield dual mag", 5, "infrared scope", ::GivePlayerWeapon, "enfield_ir_dualclip_mp");
    self MenuOption("enfield dual mag", 6, "suppressor", ::GivePlayerWeapon, "enfield_dualclip_silencer_mp");
    self MenuOption("enfield dual mag", 7, "grenade launcher", ::GivePlayerWeapon, "enfield_gl_dualclip_mp");
    
    self MainMenu("enfield masterkey", "enfield 2 attachments");
    self MenuOption("enfield masterkey", 0, "extended mag", ::GivePlayerWeapon, "enfield_mk_extclip_mp");
    self MenuOption("enfield masterkey", 1, "dual mag", ::GivePlayerWeapon, "enfield_mk_dualclip_mp");
    self MenuOption("enfield masterkey", 2, "acog sight", ::GivePlayerWeapon, "enfield_acog_mk_mp");
    self MenuOption("enfield masterkey", 3, "red dot sight", ::GivePlayerWeapon, "enfield_elbit_mk_mp");
    self MenuOption("enfield masterkey", 4, "reflex sight", ::GivePlayerWeapon, "enfield_reflex_mk_mp");
    self MenuOption("enfield masterkey", 5, "infrared scope", ::GivePlayerWeapon, "enfield_ir_mk_mp");
    self MenuOption("enfield masterkey", 6, "suppressor", ::GivePlayerWeapon, "enfield_mk_silencer_mp");

    self MainMenu("enfield flamethrower", "enfield 2 attachments");
    self MenuOption("enfield flamethrower", 0, "extended mag", ::GivePlayerWeapon, "enfield_ft_extclip_mp");
    self MenuOption("enfield flamethrower", 1, "dual mag", ::GivePlayerWeapon, "enfield_ft_dualclip_mp");
    self MenuOption("enfield flamethrower", 2, "acog sight", ::GivePlayerWeapon, "enfield_acog_ft_mp");
    self MenuOption("enfield flamethrower", 3, "red dot sight", ::GivePlayerWeapon, "enfield_elbit_ft_mp");
    self MenuOption("enfield flamethrower", 4, "reflex sight", ::GivePlayerWeapon, "enfield_reflex_ft_mp");
    self MenuOption("enfield flamethrower", 5, "infrared scope", ::GivePlayerWeapon, "enfield_ir_ft_mp");
    self MenuOption("enfield flamethrower", 6, "suppressor", ::GivePlayerWeapon, "enfield_ft_silencer_mp");
    
    self MainMenu("enfield grenade launcher", "enfield 2 attachments");
    self MenuOption("enfield grenade launcher", 0, "extended mag", ::GivePlayerWeapon, "enfield_gl_extclip_mp");
    self MenuOption("enfield grenade launcher", 1, "dual mag", ::GivePlayerWeapon, "enfield_gl_dualclip_mp");
    self MenuOption("enfield grenade launcher", 2, "acog sight", ::GivePlayerWeapon, "enfield_acog_gl_mp");
    self MenuOption("enfield grenade launcher", 3, "red dot sight", ::GivePlayerWeapon, "enfield_elbit_gl_mp");
    self MenuOption("enfield grenade launcher", 4, "reflex sight", ::GivePlayerWeapon, "enfield_reflex_gl_mp");
    self MenuOption("enfield grenade launcher", 5, "infrared scope", ::GivePlayerWeapon, "enfield_ir_gl_mp");
    self MenuOption("enfield grenade launcher", 6, "suppressor", ::GivePlayerWeapon, "enfield_gl_silencer_mp");
    
    self MainMenu("m14", "assault rifles");
    self MenuOption("m14", 0, "extended mag", ::GivePlayerWeapon, "m14_extclip_mp");
    self MenuOption("m14", 1, "acog sight", ::GivePlayerWeapon, "m14_acog_mp");
    self MenuOption("m14", 2, "red dot sight", ::GivePlayerWeapon, "m14_elbit_mp");
    self MenuOption("m14", 3, "reflex sight", ::GivePlayerWeapon, "m14_reflex_mp");
    self MenuOption("m14", 4, "masterkey", ::GivePlayerWeapon, "m14_mk_mp");
    self MenuOption("m14", 5, "flamethrower", ::GivePlayerWeapon, "m14_ft_mp");
    self MenuOption("m14", 6, "infrared scope", ::GivePlayerWeapon, "m14_ir_mp");
    self MenuOption("m14", 7, "suppressor", ::GivePlayerWeapon, "m14_silencer_mp");
    self MenuOption("m14", 8, "grenade launcher", ::GivePlayerWeapon, "m14_gl_mp");
    self MenuOption("m14", 9, "default", ::GivePlayerWeapon, "m14_mp");
    self MenuOption("m14", 10, "2 attachments", ::SubMenu, "m14 2 attachments");
    
    self MainMenu("m14 2 attachments", "m14");
    self MenuOption("m14 2 attachments", 0, "extended mag", ::SubMenu, "m14 extended mag");
    self MenuOption("m14 2 attachments", 1, "masterkey", ::SubMenu, "m14 masterkey");
    self MenuOption("m14 2 attachments", 2, "flamethrower", ::SubMenu, "m14 flamethrower");
    self MenuOption("m14 2 attachments", 3, "grenade launcher", ::SubMenu, "m14 grenade launcher");
    
    self MainMenu("m14 extended mag", "m14 2 attachments");
    self MenuOption("m14 extended mag", 0, "acog sight", ::GivePlayerWeapon, "m14_acog_extclip_mp");
    self MenuOption("m14 extended mag", 1, "red dot sight", ::GivePlayerWeapon, "m14_elbit_extclip_mp");
    self MenuOption("m14 extended mag", 2, "reflex sight", ::GivePlayerWeapon, "m14_reflex_extclip_mp");
    self MenuOption("m14 extended mag", 3, "masterkey", ::GivePlayerWeapon, "m14_mk_extclip_mp");
    self MenuOption("m14 extended mag", 4, "flamethrower", ::GivePlayerWeapon, "m14_ft_extclip_mp");
    self MenuOption("m14 extended mag", 5, "infrared scope", ::GivePlayerWeapon, "m14_ir_extclip_mp");
    self MenuOption("m14 extended mag", 6, "suppressor", ::GivePlayerWeapon, "m14_extclip_silencer_mp");
    self MenuOption("m14 extended mag", 7, "grenade launcher", ::GivePlayerWeapon, "m14_gl_extclip_mp");

    self MainMenu("m14 masterkey", "m14 2 attachments");
    self MenuOption("m14 masterkey", 0, "extended mag", ::GivePlayerWeapon, "m14_mk_extclip_mp");
    self MenuOption("m14 masterkey", 1, "acog sight", ::GivePlayerWeapon, "m14_acog_mk_mp");
    self MenuOption("m14 masterkey", 2, "red dot sight", ::GivePlayerWeapon, "m14_elbit_mk_mp");
    self MenuOption("m14 masterkey", 3, "reflex sight", ::GivePlayerWeapon, "m14_reflex_mk_mp");
    self MenuOption("m14 masterkey", 4, "infrared scope", ::GivePlayerWeapon, "m14_ir_mk_mp");
    self MenuOption("m14 masterkey", 5, "suppressor", ::GivePlayerWeapon, "m14_mk_silencer_mp");

    self MainMenu("m14 flamethrower", "m14 2 attachments");
    self MenuOption("m14 flamethrower", 0, "extended mag", ::GivePlayerWeapon, "m14_ft_extclip_mp");
    self MenuOption("m14 flamethrower", 1, "acog sight", ::GivePlayerWeapon, "m14_acog_ft_mp");
    self MenuOption("m14 flamethrower", 2, "red dot sight", ::GivePlayerWeapon, "m14_elbit_ft_mp");
    self MenuOption("m14 flamethrower", 3, "reflex sight", ::GivePlayerWeapon, "m14_reflex_ft_mp");
    self MenuOption("m14 flamethrower", 4, "infrared scope", ::GivePlayerWeapon, "m14_ir_ft_mp");
    self MenuOption("m14 flamethrower", 5, "suppressor", ::GivePlayerWeapon, "m14_ft_silencer_mp");
    
    self MainMenu("m14 grenade launcher", "m14 2 attachments");
    self MenuOption("m14 grenade launcher", 0, "extended mag", ::GivePlayerWeapon, "m14_gl_extclip_mp");
    self MenuOption("m14 grenade launcher", 1, "acog sight", ::GivePlayerWeapon, "m14_acog_gl_mp");
    self MenuOption("m14 grenade launcher", 2, "red dot sight", ::GivePlayerWeapon, "m14_elbit_gl_mp");
    self MenuOption("m14 grenade launcher", 3, "reflex sight", ::GivePlayerWeapon, "m14_reflex_gl_mp");
    self MenuOption("m14 grenade launcher", 4, "infrared scope", ::GivePlayerWeapon, "m14_gl_ir_mp");
    self MenuOption("m14 grenade launcher", 5, "suppressor", ::GivePlayerWeapon, "m14_gl_silencer_mp");
    
    self MainMenu("famas", "assault rifles");
    self MenuOption("famas", 0, "extended mag", ::GivePlayerWeapon, "famas_extclip_mp");
    self MenuOption("famas", 1, "dual mag", ::GivePlayerWeapon, "famas_dualclip_mp");
    self MenuOption("famas", 2, "acog sight", ::GivePlayerWeapon, "famas_acog_mp");
    self MenuOption("famas", 3, "red dot sight", ::GivePlayerWeapon, "famas_elbit_mp");
    self MenuOption("famas", 4, "reflex sight", ::GivePlayerWeapon, "famas_reflex_mp");
    self MenuOption("famas", 5, "masterkey", ::GivePlayerWeapon, "famas_mk_mp");
    self MenuOption("famas", 6, "flamethrower", ::GivePlayerWeapon, "famas_ft_mp");
    self MenuOption("famas", 7, "infrared scope", ::GivePlayerWeapon, "famas_ir_mp");
    self MenuOption("famas", 8, "suppressor", ::GivePlayerWeapon, "famas_silencer_mp");
    self MenuOption("famas", 9, "grenade launcher", ::GivePlayerWeapon, "famas_gl_mp");
    self MenuOption("famas", 10, "default", ::GivePlayerWeapon, "famas_mp");
    self MenuOption("famas", 11, "2 attachments", ::SubMenu, "famas 2 attachments");
    
    self MainMenu("famas 2 attachments", "famas");
    self MenuOption("famas 2 attachments", 0, "extended mag", ::SubMenu, "famas extended mag");
    self MenuOption("famas 2 attachments", 1, "dual mag", ::SubMenu, "famas dual mag");
    self MenuOption("famas 2 attachments", 2, "masterkey", ::SubMenu, "famas masterkey");
    self MenuOption("famas 2 attachments", 3, "flamethrower", ::SubMenu, "famas flamethrower");
    self MenuOption("famas 2 attachments", 4, "grenade launcher", ::SubMenu, "famas grenade launcher");
    
    self MainMenu("famas extended mag", "famas 2 attachments");
    self MenuOption("famas extended mag", 0, "acog sight", ::GivePlayerWeapon, "famas_acog_extclip_mp");
    self MenuOption("famas extended mag", 1, "red dot sight", ::GivePlayerWeapon, "famas_elbit_extclip_mp");
    self MenuOption("famas extended mag", 2, "reflex sight", ::GivePlayerWeapon, "famas_reflex_extclip_mp");
    self MenuOption("famas extended mag", 3, "masterkey", ::GivePlayerWeapon, "famas_mk_extclip_mp");
    self MenuOption("famas extended mag", 4, "flamethrower", ::GivePlayerWeapon, "famas_ft_extclip_mp");
    self MenuOption("famas extended mag", 5, "infrared scope", ::GivePlayerWeapon, "famas_ir_extclip_mp");
    self MenuOption("famas extended mag", 6, "suppressor", ::GivePlayerWeapon, "famas_extclip_silencer_mp");
    self MenuOption("famas extended mag", 7, "grenade launcher", ::GivePlayerWeapon, "famas_gl_extclip_mp");
    
    self MainMenu("famas dual mag", "famas 2 attachments");
    self MenuOption("famas dual mag", 0, "acog sight", ::GivePlayerWeapon, "famas_acog_dualclip_mp");
    self MenuOption("famas dual mag", 1, "red dot sight", ::GivePlayerWeapon, "famas_elbit_dualclip_mp");
    self MenuOption("famas dual mag", 2, "reflex sight", ::GivePlayerWeapon, "famas_reflex_dualclip_mp");
    self MenuOption("famas dual mag", 3, "masterkey", ::GivePlayerWeapon, "famas_mk_dualclip_mp");
    self MenuOption("famas dual mag", 4, "flamethrower", ::GivePlayerWeapon, "famas_ft_dualclip_mp");
    self MenuOption("famas dual mag", 5, "infrared scope", ::GivePlayerWeapon, "famas_ir_dualclip_mp");
    self MenuOption("famas dual mag", 6, "suppressor", ::GivePlayerWeapon, "famas_dualclip_silencer_mp");
    self MenuOption("famas dual mag", 7, "grenade launcher", ::GivePlayerWeapon, "famas_gl_dualclip_mp");
    
    self MainMenu("famas masterkey", "famas 2 attachments");
    self MenuOption("famas masterkey", 0, "extended mag", ::GivePlayerWeapon, "famas_mk_extclip_mp");
    self MenuOption("famas masterkey", 1, "dual mag", ::GivePlayerWeapon, "famas_mk_dualclip_mp");
    self MenuOption("famas masterkey", 2, "acog sight", ::GivePlayerWeapon, "famas_acog_mk_mp");
    self MenuOption("famas masterkey", 3, "red dot sight", ::GivePlayerWeapon, "famas_elbit_mk_mp");
    self MenuOption("famas masterkey", 4, "reflex sight", ::GivePlayerWeapon, "famas_reflex_mk_mp");
    self MenuOption("famas masterkey", 5, "infrared scope", ::GivePlayerWeapon, "famas_ir_mk_mp");
    self MenuOption("famas masterkey", 6, "suppressor", ::GivePlayerWeapon, "famas_mk_silencer_mp");

    self MainMenu("famas flamethrower", "famas 2 attachments");
    self MenuOption("famas flamethrower", 0, "extended mag", ::GivePlayerWeapon, "famas_ft_extclip_mp");
    self MenuOption("famas flamethrower", 1, "dual mag", ::GivePlayerWeapon, "famas_ft_dualclip_mp");
    self MenuOption("famas flamethrower", 2, "acog sight", ::GivePlayerWeapon, "famas_acog_ft_mp");
    self MenuOption("famas flamethrower", 3, "red dot sight", ::GivePlayerWeapon, "famas_elbit_ft_mp");
    self MenuOption("famas flamethrower", 4, "reflex sight", ::GivePlayerWeapon, "famas_reflex_ft_mp");
    self MenuOption("famas flamethrower", 5, "infrared scope", ::GivePlayerWeapon, "famas_ir_ft_mp");
    self MenuOption("famas flamethrower", 6, "suppressor", ::GivePlayerWeapon, "famas_ft_silencer_mp");
    
    self MainMenu("famas grenade launcher", "famas 2 attachments");
    self MenuOption("famas grenade launcher", 0, "extended mag", ::GivePlayerWeapon, "famas_gl_extclip_mp");
    self MenuOption("famas grenade launcher", 1, "dual mag", ::GivePlayerWeapon, "famas_gl_dualclip_mp");
    self MenuOption("famas grenade launcher", 2, "acog sight", ::GivePlayerWeapon, "famas_acog_gl_mp");
    self MenuOption("famas grenade launcher", 3, "red dot sight", ::GivePlayerWeapon, "famas_elbit_gl_mp");
    self MenuOption("famas grenade launcher", 4, "reflex sight", ::GivePlayerWeapon, "famas_reflex_gl_mp");
    self MenuOption("famas grenade launcher", 5, "infrared scope", ::GivePlayerWeapon, "famas_ir_gl_mp");
    self MenuOption("famas grenade launcher", 6, "suppressor", ::GivePlayerWeapon, "famas_gl_silencer_mp");
    
    self MainMenu("galil", "assault rifles");
    self MenuOption("galil", 0, "extended mag", ::GivePlayerWeapon, "galil_extclip_mp");
    self MenuOption("galil", 1, "dual mag", ::GivePlayerWeapon, "galil_dualclip_mp");
    self MenuOption("galil", 2, "acog sight", ::GivePlayerWeapon, "galil_acog_mp");
    self MenuOption("galil", 3, "red dot sight", ::GivePlayerWeapon, "galil_elbit_mp");
    self MenuOption("galil", 4, "reflex sight", ::GivePlayerWeapon, "galil_reflex_mp");
    self MenuOption("galil", 5, "masterkey", ::GivePlayerWeapon, "galil_mk_mp");
    self MenuOption("galil", 6, "flamethrower", ::GivePlayerWeapon, "galil_ft_mp");
    self MenuOption("galil", 7, "infrared scope", ::GivePlayerWeapon, "galil_ir_mp");
    self MenuOption("galil", 8, "suppressor", ::GivePlayerWeapon, "galil_silencer_mp");
    self MenuOption("galil", 9, "grenade launcher", ::GivePlayerWeapon, "galil_gl_mp");
    self MenuOption("galil", 10, "default", ::GivePlayerWeapon, "galil_mp");
    self MenuOption("galil", 11, "2 attachments", ::SubMenu, "galil 2 attachments");
    
    self MainMenu("galil 2 attachments", "galil");
    self MenuOption("galil 2 attachments", 0, "extended mag", ::SubMenu, "galil extended mag");
    self MenuOption("galil 2 attachments", 1, "dual mag", ::SubMenu, "galil dual mag");
    self MenuOption("galil 2 attachments", 2, "masterkey", ::SubMenu, "galil masterkey");
    self MenuOption("galil 2 attachments", 3, "flamethrower", ::SubMenu, "galil flamethrower");
    self MenuOption("galil 2 attachments", 4, "grenade launcher", ::SubMenu, "galil grenade launcher");
    
    self MainMenu("galil extended mag", "galil 2 attachments");
    self MenuOption("galil extended mag", 0, "acog sight", ::GivePlayerWeapon, "galil_acog_extclip_mp");
    self MenuOption("galil extended mag", 1, "red dot sight", ::GivePlayerWeapon, "galil_elbit_extclip_mp");
    self MenuOption("galil extended mag", 2, "reflex sight", ::GivePlayerWeapon, "galil_reflex_extclip_mp");
    self MenuOption("galil extended mag", 3, "masterkey", ::GivePlayerWeapon, "galil_mk_extclip_mp");
    self MenuOption("galil extended mag", 4, "flamethrower", ::GivePlayerWeapon, "galil_ft_extclip_mp");
    self MenuOption("galil extended mag", 5, "infrared scope", ::GivePlayerWeapon, "galil_ir_extclip_mp");
    self MenuOption("galil extended mag", 6, "suppressor", ::GivePlayerWeapon, "galil_extclip_silencer_mp");
    self MenuOption("galil extended mag", 7, "grenade launcher", ::GivePlayerWeapon, "galil_gl_extclip_mp");
    
    self MainMenu("galil dual mag", "galil 2 attachments");
    self MenuOption("galil dual mag", 0, "acog sight", ::GivePlayerWeapon, "galil_acog_dualclip_mp");
    self MenuOption("galil dual mag", 1, "red dot sight", ::GivePlayerWeapon, "galil_elbit_dualclip_mp");
    self MenuOption("galil dual mag", 2, "reflex sight", ::GivePlayerWeapon, "galil_reflex_dualclip_mp");
    self MenuOption("galil dual mag", 3, "masterkey", ::GivePlayerWeapon, "galil_mk_dualclip_mp");
    self MenuOption("galil dual mag", 4, "flamethrower", ::GivePlayerWeapon, "galil_ft_dualclip_mp");
    self MenuOption("galil dual mag", 5, "infrared scope", ::GivePlayerWeapon, "galil_ir_dualclip_mp");
    self MenuOption("galil dual mag", 6, "suppressor", ::GivePlayerWeapon, "galil_dualclip_silencer_mp");
    self MenuOption("galil dual mag", 7, "grenade launcher", ::GivePlayerWeapon, "galil_gl_dualclip_mp");
    
    self MainMenu("galil masterkey", "galil 2 attachments");
    self MenuOption("galil masterkey", 0, "extended mag", ::GivePlayerWeapon, "galil_mk_extclip_mp");
    self MenuOption("galil masterkey", 1, "dual mag", ::GivePlayerWeapon, "galil_mk_dualclip_mp");
    self MenuOption("galil masterkey", 2, "acog sight", ::GivePlayerWeapon, "galil_acog_mk_mp");
    self MenuOption("galil masterkey", 3, "red dot sight", ::GivePlayerWeapon, "galil_elbit_mk_mp");
    self MenuOption("galil masterkey", 4, "reflex sight", ::GivePlayerWeapon, "galil_reflex_mk_mp");
    self MenuOption("galil masterkey", 5, "infrared scope", ::GivePlayerWeapon, "galil_ir_mk_mp");
    self MenuOption("galil masterkey", 6, "suppressor", ::GivePlayerWeapon, "galil_mk_silencer_mp");

    self MainMenu("galil flamethrower", "galil 2 attachments");
    self MenuOption("galil flamethrower", 0, "extended mag", ::GivePlayerWeapon, "galil_ft_extclip_mp");
    self MenuOption("galil flamethrower", 1, "dual mag", ::GivePlayerWeapon, "galil_ft_dualclip_mp");
    self MenuOption("galil flamethrower", 2, "acog sight", ::GivePlayerWeapon, "galil_acog_ft_mp");
    self MenuOption("galil flamethrower", 3, "red dot sight", ::GivePlayerWeapon, "galil_elbit_ft_mp");
    self MenuOption("galil flamethrower", 4, "reflex sight", ::GivePlayerWeapon, "galil_reflex_ft_mp");
    self MenuOption("galil flamethrower", 5, "infrared scope", ::GivePlayerWeapon, "galil_ir_ft_mp");
    self MenuOption("galil flamethrower", 6, "suppressor", ::GivePlayerWeapon, "galil_ft_silencer_mp");
    
    self MainMenu("galil grenade launcher", "galil 2 attachments");
    self MenuOption("galil grenade launcher", 0, "extended mag", ::GivePlayerWeapon, "galil_gl_extclip_mp");
    self MenuOption("galil grenade launcher", 1, "dual mag", ::GivePlayerWeapon, "galil_gl_dualclip_mp");
    self MenuOption("galil grenade launcher", 2, "acog sight", ::GivePlayerWeapon, "galil_acog_gl_mp");
    self MenuOption("galil grenade launcher", 3, "red dot sight", ::GivePlayerWeapon, "galil_elbit_gl_mp");
    self MenuOption("galil grenade launcher", 4, "reflex sight", ::GivePlayerWeapon, "galil_reflex_gl_mp");
    self MenuOption("galil grenade launcher", 5, "infrared scope", ::GivePlayerWeapon, "galil_ir_gl_mp");
    self MenuOption("galil grenade launcher", 6, "suppressor", ::GivePlayerWeapon, "galil_gl_silencer_mp");
    
    self MainMenu("aug", "assault rifles");
    self MenuOption("aug", 0, "extended mag", ::GivePlayerWeapon, "aug_extclip_mp");
    self MenuOption("aug", 1, "dual mag", ::GivePlayerWeapon, "aug_dualclip_mp");
    self MenuOption("aug", 2, "acog sight", ::GivePlayerWeapon, "aug_acog_mp");
    self MenuOption("aug", 3, "red dot sight", ::GivePlayerWeapon, "aug_elbit_mp");
    self MenuOption("aug", 4, "reflex sight", ::GivePlayerWeapon, "aug_reflex_mp");
    self MenuOption("aug", 5, "masterkey", ::GivePlayerWeapon, "aug_mk_mp");
    self MenuOption("aug", 6, "flamethrower", ::GivePlayerWeapon, "aug_ft_mp");
    self MenuOption("aug", 7, "infrared scope", ::GivePlayerWeapon, "aug_ir_mp");
    self MenuOption("aug", 8, "suppressor", ::GivePlayerWeapon, "aug_silencer_mp");
    self MenuOption("aug", 9, "grenade launcher", ::GivePlayerWeapon, "aug_gl_mp");
    self MenuOption("aug", 10, "default", ::GivePlayerWeapon, "aug_mp");
    self MenuOption("aug", 11, "2 attachments", ::SubMenu, "aug 2 attachments");
    
    self MainMenu("aug 2 attachments", "aug");
    self MenuOption("aug 2 attachments", 0, "extended mag", ::SubMenu, "aug extended mag");
    self MenuOption("aug 2 attachments", 1, "dual mag", ::SubMenu, "aug dual mag");
    self MenuOption("aug 2 attachments", 2, "masterkey", ::SubMenu, "aug masterkey");
    self MenuOption("aug 2 attachments", 3, "flamethrower", ::SubMenu, "aug flamethrower");
    self MenuOption("aug 2 attachments", 4, "grenade launcher", ::SubMenu, "aug grenade launcher");
    
    self MainMenu("aug extended mag", "aug 2 attachments");
    self MenuOption("aug extended mag", 0, "acog sight", ::GivePlayerWeapon, "aug_acog_extclip_mp");
    self MenuOption("aug extended mag", 1, "red dot sight", ::GivePlayerWeapon, "aug_elbit_extclip_mp");
    self MenuOption("aug extended mag", 2, "reflex sight", ::GivePlayerWeapon, "aug_reflex_extclip_mp");
    self MenuOption("aug extended mag", 3, "masterkey", ::GivePlayerWeapon, "aug_mk_extclip_mp");
    self MenuOption("aug extended mag", 4, "flamethrower", ::GivePlayerWeapon, "aug_ft_extclip_mp");
    self MenuOption("aug extended mag", 5, "infrared scope", ::GivePlayerWeapon, "aug_ir_extclip_mp");
    self MenuOption("aug extended mag", 6, "suppressor", ::GivePlayerWeapon, "aug_extclip_silencer_mp");
    self MenuOption("aug extended mag", 7, "grenade launcher", ::GivePlayerWeapon, "aug_gl_extclip_mp");
    
    self MainMenu("aug dual mag", "aug 2 attachments");
    self MenuOption("aug dual mag", 0, "acog sight", ::GivePlayerWeapon, "aug_acog_dualclip_mp");
    self MenuOption("aug dual mag", 1, "red dot sight", ::GivePlayerWeapon, "aug_elbit_dualclip_mp");
    self MenuOption("aug dual mag", 2, "reflex sight", ::GivePlayerWeapon, "aug_reflex_dualclip_mp");
    self MenuOption("aug dual mag", 3, "masterkey", ::GivePlayerWeapon, "aug_mk_dualclip_mp");
    self MenuOption("aug dual mag", 4, "flamethrower", ::GivePlayerWeapon, "aug_ft_dualclip_mp");
    self MenuOption("aug dual mag", 5, "infrared scope", ::GivePlayerWeapon, "aug_ir_dualclip_mp");
    self MenuOption("aug dual mag", 6, "suppressor", ::GivePlayerWeapon, "aug_dualclip_silencer_mp");
    self MenuOption("aug dual mag", 7, "grenade launcher", ::GivePlayerWeapon, "aug_gl_dualclip_mp");
    
    self MainMenu("aug masterkey", "aug 2 attachments");
    self MenuOption("aug masterkey", 0, "extended mag", ::GivePlayerWeapon, "aug_mk_extclip_mp");
    self MenuOption("aug masterkey", 1, "dual mag", ::GivePlayerWeapon, "aug_mk_dualclip_mp");
    self MenuOption("aug masterkey", 2, "acog sight", ::GivePlayerWeapon, "aug_acog_mk_mp");
    self MenuOption("aug masterkey", 3, "red dot sight", ::GivePlayerWeapon, "aug_elbit_mk_mp");
    self MenuOption("aug masterkey", 4, "reflex sight", ::GivePlayerWeapon, "aug_reflex_mk_mp");
    self MenuOption("aug masterkey", 5, "infrared scope", ::GivePlayerWeapon, "aug_ir_mk_mp");
    self MenuOption("aug masterkey", 6, "suppressor", ::GivePlayerWeapon, "aug_mk_silencer_mp");

    self MainMenu("aug flamethrower", "aug 2 attachments");
    self MenuOption("aug flamethrower", 0, "extended mag", ::GivePlayerWeapon, "aug_ft_extclip_mp");
    self MenuOption("aug flamethrower", 1, "dual mag", ::GivePlayerWeapon, "aug_ft_dualclip_mp");
    self MenuOption("aug flamethrower", 2, "acog sight", ::GivePlayerWeapon, "aug_acog_ft_mp");
    self MenuOption("aug flamethrower", 3, "red dot sight", ::GivePlayerWeapon, "aug_elbit_ft_mp");
    self MenuOption("aug flamethrower", 4, "reflex sight", ::GivePlayerWeapon, "aug_reflex_ft_mp");
    self MenuOption("aug flamethrower", 5, "infrared scope", ::GivePlayerWeapon, "aug_ir_ft_mp");
    self MenuOption("aug flamethrower", 6, "suppressor", ::GivePlayerWeapon, "aug_ft_silencer_mp");
    
    self MainMenu("aug grenade launcher", "aug 2 attachments");
    self MenuOption("aug grenade launcher", 0, "extended mag", ::GivePlayerWeapon, "aug_gl_extclip_mp");
    self MenuOption("aug grenade launcher", 1, "dual mag", ::GivePlayerWeapon, "aug_gl_dualclip_mp");
    self MenuOption("aug grenade launcher", 2, "acog sight", ::GivePlayerWeapon, "aug_acog_gl_mp");
    self MenuOption("aug grenade launcher", 3, "red dot sight", ::GivePlayerWeapon, "aug_elbit_gl_mp");
    self MenuOption("aug grenade launcher", 4, "reflex sight", ::GivePlayerWeapon, "aug_reflex_gl_mp");
    self MenuOption("aug grenade launcher", 5, "infrared scope", ::GivePlayerWeapon, "aug_ir_gl_mp");
    self MenuOption("aug grenade launcher", 6, "suppressor", ::GivePlayerWeapon, "aug_gl_silencer_mp");
    
    self MainMenu("fnfal", "assault rifles");
    self MenuOption("fnfal", 0, "extended mag", ::GivePlayerWeapon, "fnfal_extclip_mp");
    self MenuOption("fnfal", 1, "dual mag", ::GivePlayerWeapon, "fnfal_dualclip_mp");
    self MenuOption("fnfal", 2, "acog sight", ::GivePlayerWeapon, "fnfal_acog_mp");
    self MenuOption("fnfal", 3, "red dot sight", ::GivePlayerWeapon, "fnfal_elbit_mp");
    self MenuOption("fnfal", 4, "reflex sight", ::GivePlayerWeapon, "fnfal_reflex_mp");
    self MenuOption("fnfal", 5, "masterkey", ::GivePlayerWeapon, "fnfal_mk_mp");
    self MenuOption("fnfal", 6, "flamethrower", ::GivePlayerWeapon, "fnfal_ft_mp");
    self MenuOption("fnfal", 7, "infrared scope", ::GivePlayerWeapon, "fnfal_ir_mp");
    self MenuOption("fnfal", 8, "suppressor", ::GivePlayerWeapon, "fnfal_silencer_mp");
    self MenuOption("fnfal", 9, "grenade launcher", ::GivePlayerWeapon, "fnfal_gl_mp");
    self MenuOption("fnfal", 10, "default", ::GivePlayerWeapon, "fnfal_mp");
    self MenuOption("fnfal", 11, "2 attachments", ::SubMenu, "fnfal 2 attachments");
    
    self MainMenu("fnfal 2 attachments", "fnfal");
    self MenuOption("fnfal 2 attachments", 0, "extended mag", ::SubMenu, "fnfal extended mag");
    self MenuOption("fnfal 2 attachments", 1, "dual mag", ::SubMenu, "fnfal dual mag");
    self MenuOption("fnfal 2 attachments", 2, "masterkey", ::SubMenu, "fnfal masterkey");
    self MenuOption("fnfal 2 attachments", 3, "flamethrower", ::SubMenu, "fnfal flamethrower");
    self MenuOption("fnfal 2 attachments", 4, "grenade launcher", ::SubMenu, "fnfal grenade launcher");
    
    self MainMenu("fnfal extended mag", "fnfal 2 attachments");
    self MenuOption("fnfal extended mag", 0, "acog sight", ::GivePlayerWeapon, "fnfal_acog_extclip_mp");
    self MenuOption("fnfal extended mag", 1, "red dot sight", ::GivePlayerWeapon, "fnfal_elbit_extclip_mp");
    self MenuOption("fnfal extended mag", 2, "reflex sight", ::GivePlayerWeapon, "fnfal_reflex_extclip_mp");
    self MenuOption("fnfal extended mag", 3, "masterkey", ::GivePlayerWeapon, "fnfal_mk_extclip_mp");
    self MenuOption("fnfal extended mag", 4, "flamethrower", ::GivePlayerWeapon, "fnfal_ft_extclip_mp");
    self MenuOption("fnfal extended mag", 5, "infrared scope", ::GivePlayerWeapon, "fnfal_ir_extclip_mp");
    self MenuOption("fnfal extended mag", 6, "suppressor", ::GivePlayerWeapon, "fnfal_extclip_silencer_mp");
    self MenuOption("fnfal extended mag", 7, "grenade launcher", ::GivePlayerWeapon, "fnfal_gl_extclip_mp");
    
    self MainMenu("fnfal dual mag", "fnfal 2 attachments");
    self MenuOption("fnfal dual mag", 0, "acog sight", ::GivePlayerWeapon, "fnfal_acog_dualclip_mp");
    self MenuOption("fnfal dual mag", 1, "red dot sight", ::GivePlayerWeapon, "fnfal_elbit_dualclip_mp");
    self MenuOption("fnfal dual mag", 2, "reflex sight", ::GivePlayerWeapon, "fnfal_reflex_dualclip_mp");
    self MenuOption("fnfal dual mag", 3, "masterkey", ::GivePlayerWeapon, "fnfal_mk_dualclip_mp");
    self MenuOption("fnfal dual mag", 4, "flamethrower", ::GivePlayerWeapon, "fnfal_ft_dualclip_mp");
    self MenuOption("fnfal dual mag", 5, "infrared scope", ::GivePlayerWeapon, "fnfal_ir_dualclip_mp");
    self MenuOption("fnfal dual mag", 6, "suppressor", ::GivePlayerWeapon, "fnfal_dualclip_silencer_mp");
    self MenuOption("fnfal dual mag", 7, "grenade launcher", ::GivePlayerWeapon, "fnfal_gl_dualclip_mp");
    
    self MainMenu("fnfal masterkey", "fnfal 2 attachments");
    self MenuOption("fnfal masterkey", 0, "extended mag", ::GivePlayerWeapon, "fnfal_mk_extclip_mp");
    self MenuOption("fnfal masterkey", 1, "dual mag", ::GivePlayerWeapon, "fnfal_mk_dualclip_mp");
    self MenuOption("fnfal masterkey", 2, "acog sight", ::GivePlayerWeapon, "fnfal_acog_mk_mp");
    self MenuOption("fnfal masterkey", 3, "red dot sight", ::GivePlayerWeapon, "fnfal_elbit_mk_mp");
    self MenuOption("fnfal masterkey", 4, "reflex sight", ::GivePlayerWeapon, "fnfal_reflex_mk_mp");
    self MenuOption("fnfal masterkey", 5, "infrared scope", ::GivePlayerWeapon, "fnfal_ir_mk_mp");
    self MenuOption("fnfal masterkey", 6, "suppressor", ::GivePlayerWeapon, "fnfal_mk_silencer_mp");

    self MainMenu("fnfal flamethrower", "fnfal 2 attachments");
    self MenuOption("fnfal flamethrower", 0, "extended mag", ::GivePlayerWeapon, "fnfal_ft_extclip_mp");
    self MenuOption("fnfal flamethrower", 1, "dual mag", ::GivePlayerWeapon, "fnfal_ft_dualclip_mp");
    self MenuOption("fnfal flamethrower", 2, "acog sight", ::GivePlayerWeapon, "fnfal_acog_ft_mp");
    self MenuOption("fnfal flamethrower", 3, "red dot sight", ::GivePlayerWeapon, "fnfal_elbit_ft_mp");
    self MenuOption("fnfal flamethrower", 4, "reflex sight", ::GivePlayerWeapon, "fnfal_reflex_ft_mp");
    self MenuOption("fnfal flamethrower", 5, "infrared scope", ::GivePlayerWeapon, "fnfal_ir_ft_mp");
    self MenuOption("fnfal flamethrower", 6, "suppressor", ::GivePlayerWeapon, "fnfal_ft_silencer_mp");
    
    self MainMenu("fnfal grenade launcher", "fnfal 2 attachments");
    self MenuOption("fnfal grenade launcher", 0, "extended mag", ::GivePlayerWeapon, "fnfal_gl_extclip_mp");
    self MenuOption("fnfal grenade launcher", 1, "dual mag", ::GivePlayerWeapon, "fnfal_gl_dualclip_mp");
    self MenuOption("fnfal grenade launcher", 2, "acog sight", ::GivePlayerWeapon, "fnfal_acog_gl_mp");
    self MenuOption("fnfal grenade launcher", 3, "red dot sight", ::GivePlayerWeapon, "fnfal_elbit_gl_mp");
    self MenuOption("fnfal grenade launcher", 4, "reflex sight", ::GivePlayerWeapon, "fnfal_reflex_gl_mp");
    self MenuOption("fnfal grenade launcher", 5, "infrared scope", ::GivePlayerWeapon, "fnfal_ir_gl_mp");
    self MenuOption("fnfal grenade launcher", 6, "suppressor", ::GivePlayerWeapon, "fnfal_gl_silencer_mp");
    
    self MainMenu("ak47", "assault rifles");
    self MenuOption("ak47", 0, "extended mag", ::GivePlayerWeapon, "ak47_extclip_mp");
    self MenuOption("ak47", 1, "dual mag", ::GivePlayerWeapon, "ak47_dualclip_mp");
    self MenuOption("ak47", 2, "acog sight", ::GivePlayerWeapon, "ak47_acog_mp");
    self MenuOption("ak47", 3, "red dot sight", ::GivePlayerWeapon, "ak47_elbit_mp");
    self MenuOption("ak47", 4, "reflex sight", ::GivePlayerWeapon, "ak47_reflex_mp");
    self MenuOption("ak47", 5, "masterkey", ::GivePlayerWeapon, "ak47_mk_mp");
    self MenuOption("ak47", 6, "flamethrower", ::GivePlayerWeapon, "ak47_ft_mp");
    self MenuOption("ak47", 7, "infrared scope", ::GivePlayerWeapon, "ak47_ir_mp");
    self MenuOption("ak47", 8, "suppressor", ::GivePlayerWeapon, "ak47_silencer_mp");
    self MenuOption("ak47", 9, "grenade launcher", ::GivePlayerWeapon, "ak47_gl_mp");
    self MenuOption("ak47", 10, "default", ::GivePlayerWeapon, "ak47_mp");
    self MenuOption("ak47", 11, "2 attachments", ::SubMenu, "ak47 2 attachments");
    
    self MainMenu("ak47 2 attachments", "ak47");
    self MenuOption("ak47 2 attachments", 0, "extended mag", ::SubMenu, "ak47 extended mag");
    self MenuOption("ak47 2 attachments", 1, "dual mag", ::SubMenu, "ak47 dual mag");
    self MenuOption("ak47 2 attachments", 2, "masterkey", ::SubMenu, "ak47 masterkey");
    self MenuOption("ak47 2 attachments", 3, "flamethrower", ::SubMenu, "ak47 flamethrower");
    self MenuOption("ak47 2 attachments", 4, "grenade launcher", ::SubMenu, "ak47 grenade launcher");
    
    self MainMenu("ak47 extended mag", "ak47 2 attachments");
    self MenuOption("ak47 extended mag", 0, "acog sight", ::GivePlayerWeapon, "ak47_acog_extclip_mp");
    self MenuOption("ak47 extended mag", 1, "red dot sight", ::GivePlayerWeapon, "ak47_elbit_extclip_mp");
    self MenuOption("ak47 extended mag", 2, "reflex sight", ::GivePlayerWeapon, "ak47_reflex_extclip_mp");
    self MenuOption("ak47 extended mag", 3, "masterkey", ::GivePlayerWeapon, "ak47_mk_extclip_mp");
    self MenuOption("ak47 extended mag", 4, "flamethrower", ::GivePlayerWeapon, "ak47_ft_extclip_mp");
    self MenuOption("ak47 extended mag", 5, "infrared scope", ::GivePlayerWeapon, "ak47_ir_extclip_mp");
    self MenuOption("ak47 extended mag", 6, "suppressor", ::GivePlayerWeapon, "ak47_extclip_silencer_mp");
    self MenuOption("ak47 extended mag", 7, "grenade launcher", ::GivePlayerWeapon, "ak47_gl_extclip_mp");
    
    self MainMenu("ak47 dual mag", "ak47 2 attachments");
    self MenuOption("ak47 dual mag", 0, "acog sight", ::GivePlayerWeapon, "ak47_acog_dualclip_mp");
    self MenuOption("ak47 dual mag", 1, "red dot sight", ::GivePlayerWeapon, "ak47_elbit_dualclip_mp");
    self MenuOption("ak47 dual mag", 2, "reflex sight", ::GivePlayerWeapon, "ak47_reflex_dualclip_mp");
    self MenuOption("ak47 dual mag", 3, "masterkey", ::GivePlayerWeapon, "ak47_mk_dualclip_mp");
    self MenuOption("ak47 dual mag", 4, "flamethrower", ::GivePlayerWeapon, "ak47_ft_dualclip_mp");
    self MenuOption("ak47 dual mag", 5, "infrared scope", ::GivePlayerWeapon, "ak47_ir_dualclip_mp");
    self MenuOption("ak47 dual mag", 6, "suppressor", ::GivePlayerWeapon, "ak47_dualclip_silencer_mp");
    self MenuOption("ak47 dual mag", 7, "grenade launcher", ::GivePlayerWeapon, "ak47_gl_dualclip_mp");
    
    self MainMenu("ak47 masterkey", "ak47 2 attachments");
    self MenuOption("ak47 masterkey", 0, "extended mag", ::GivePlayerWeapon, "ak47_mk_extclip_mp");
    self MenuOption("ak47 masterkey", 1, "dual mag", ::GivePlayerWeapon, "ak47_mk_dualclip_mp");
    self MenuOption("ak47 masterkey", 2, "acog sight", ::GivePlayerWeapon, "ak47_acog_mk_mp");
    self MenuOption("ak47 masterkey", 3, "red dot sight", ::GivePlayerWeapon, "ak47_elbit_mk_mp");
    self MenuOption("ak47 masterkey", 4, "reflex sight", ::GivePlayerWeapon, "ak47_reflex_mk_mp");
    self MenuOption("ak47 masterkey", 5, "infrared scope", ::GivePlayerWeapon, "ak47_ir_mk_mp");
    self MenuOption("ak47 masterkey", 6, "suppressor", ::GivePlayerWeapon, "ak47_mk_silencer_mp");

    self MainMenu("ak47 flamethrower", "ak47 2 attachments");
    self MenuOption("ak47 flamethrower", 0, "extended mag", ::GivePlayerWeapon, "ak47_ft_extclip_mp");
    self MenuOption("ak47 flamethrower", 1, "dual mag", ::GivePlayerWeapon, "ak47_ft_dualclip_mp");
    self MenuOption("ak47 flamethrower", 2, "acog sight", ::GivePlayerWeapon, "ak47_acog_ft_mp");
    self MenuOption("ak47 flamethrower", 3, "red dot sight", ::GivePlayerWeapon, "ak47_elbit_ft_mp");
    self MenuOption("ak47 flamethrower", 4, "reflex sight", ::GivePlayerWeapon, "ak47_reflex_ft_mp");
    self MenuOption("ak47 flamethrower", 5, "infrared scope", ::GivePlayerWeapon, "ak47_ir_ft_mp");
    self MenuOption("ak47 flamethrower", 6, "suppressor", ::GivePlayerWeapon, "ak47_ft_silencer_mp");
    
    self MainMenu("ak47 grenade launcher", "ak47 2 attachments");
    self MenuOption("ak47 grenade launcher", 0, "extended mag", ::GivePlayerWeapon, "ak47_gl_extclip_mp");
    self MenuOption("ak47 grenade launcher", 1, "dual mag", ::GivePlayerWeapon, "ak47_gl_dualclip_mp");
    self MenuOption("ak47 grenade launcher", 2, "acog sight", ::GivePlayerWeapon, "ak47_acog_gl_mp");
    self MenuOption("ak47 grenade launcher", 3, "red dot sight", ::GivePlayerWeapon, "ak47_elbit_gl_mp");
    self MenuOption("ak47 grenade launcher", 4, "reflex sight", ::GivePlayerWeapon, "ak47_reflex_gl_mp");
    self MenuOption("ak47 grenade launcher", 5, "infrared scope", ::GivePlayerWeapon, "ak47_ir_gl_mp");
    self MenuOption("ak47 grenade launcher", 6, "suppressor", ::GivePlayerWeapon, "ak47_gl_silencer_mp");
    
    self MainMenu("commando", "assault rifles");
    self MenuOption("commando", 0, "extended mag", ::GivePlayerWeapon, "commando_extclip_mp");
    self MenuOption("commando", 1, "dual mag", ::GivePlayerWeapon, "commando_dualclip_mp");
    self MenuOption("commando", 2, "acog sight", ::GivePlayerWeapon, "commando_acog_mp");
    self MenuOption("commando", 3, "red dot sight", ::GivePlayerWeapon, "commando_elbit_mp");
    self MenuOption("commando", 4, "reflex sight", ::GivePlayerWeapon, "commando_reflex_mp");
    self MenuOption("commando", 5, "masterkey", ::GivePlayerWeapon, "commando_mk_mp");
    self MenuOption("commando", 6, "flamethrower", ::GivePlayerWeapon, "commando_ft_mp");
    self MenuOption("commando", 7, "infrared scope", ::GivePlayerWeapon, "commando_ir_mp");
    self MenuOption("commando", 8, "suppressor", ::GivePlayerWeapon, "commando_silencer_mp");
    self MenuOption("commando", 9, "grenade launcher", ::GivePlayerWeapon, "commando_gl_mp");
    self MenuOption("commando", 10, "default", ::GivePlayerWeapon, "commando_mp");
    self MenuOption("commando", 11, "2 attachments", ::SubMenu, "commando 2 attachments");
    
    self MainMenu("commando 2 attachments", "commando");
    self MenuOption("commando 2 attachments", 0, "extended mag", ::SubMenu, "commando extended mag");
    self MenuOption("commando 2 attachments", 1, "dual mag", ::SubMenu, "commando dual mag");
    self MenuOption("commando 2 attachments", 2, "masterkey", ::SubMenu, "commando masterkey");
    self MenuOption("commando 2 attachments", 3, "flamethrower", ::SubMenu, "commando flamethrower");
    self MenuOption("commando 2 attachments", 4, "grenade launcher", ::SubMenu, "commando grenade launcher");
    
    self MainMenu("commando extended mag", "commando 2 attachments");
    self MenuOption("commando extended mag", 0, "acog sight", ::GivePlayerWeapon, "commando_acog_extclip_mp");
    self MenuOption("commando extended mag", 1, "red dot sight", ::GivePlayerWeapon, "commando_elbit_extclip_mp");
    self MenuOption("commando extended mag", 2, "reflex sight", ::GivePlayerWeapon, "commando_reflex_extclip_mp");
    self MenuOption("commando extended mag", 3, "masterkey", ::GivePlayerWeapon, "commando_mk_extclip_mp");
    self MenuOption("commando extended mag", 4, "flamethrower", ::GivePlayerWeapon, "commando_ft_extclip_mp");
    self MenuOption("commando extended mag", 5, "infrared scope", ::GivePlayerWeapon, "commando_ir_extclip_mp");
    self MenuOption("commando extended mag", 6, "suppressor", ::GivePlayerWeapon, "commando_extclip_silencer_mp");
    self MenuOption("commando extended mag", 7, "grenade launcher", ::GivePlayerWeapon, "commando_gl_extclip_mp");
    
    self MainMenu("commando dual mag", "commando 2 attachments");
    self MenuOption("commando dual mag", 0, "acog sight", ::GivePlayerWeapon, "commando_acog_dualclip_mp");
    self MenuOption("commando dual mag", 1, "red dot sight", ::GivePlayerWeapon, "commando_elbit_dualclip_mp");
    self MenuOption("commando dual mag", 2, "reflex sight", ::GivePlayerWeapon, "commando_reflex_dualclip_mp");
    self MenuOption("commando dual mag", 3, "masterkey", ::GivePlayerWeapon, "commando_mk_dualclip_mp");
    self MenuOption("commando dual mag", 4, "flamethrower", ::GivePlayerWeapon, "commando_ft_dualclip_mp");
    self MenuOption("commando dual mag", 5, "infrared scope", ::GivePlayerWeapon, "commando_ir_dualclip_mp");
    self MenuOption("commando dual mag", 6, "suppressor", ::GivePlayerWeapon, "commando_dualclip_silencer_mp");
    self MenuOption("commando dual mag", 7, "grenade launcher", ::GivePlayerWeapon, "commando_gl_dualclip_mp");
    
    self MainMenu("commando masterkey", "commando 2 attachments");
    self MenuOption("commando masterkey", 0, "extended mag", ::GivePlayerWeapon, "commando_mk_extclip_mp");
    self MenuOption("commando masterkey", 1, "dual mag", ::GivePlayerWeapon, "commando_mk_dualclip_mp");
    self MenuOption("commando masterkey", 2, "acog sight", ::GivePlayerWeapon, "commando_acog_mk_mp");
    self MenuOption("commando masterkey", 3, "red dot sight", ::GivePlayerWeapon, "commando_elbit_mk_mp");
    self MenuOption("commando masterkey", 4, "reflex sight", ::GivePlayerWeapon, "commando_reflex_mk_mp");
    self MenuOption("commando masterkey", 5, "infrared scope", ::GivePlayerWeapon, "commando_ir_mk_mp");
    self MenuOption("commando masterkey", 6, "suppressor", ::GivePlayerWeapon, "commando_mk_silencer_mp");

    self MainMenu("commando flamethrower", "commando 2 attachments");
    self MenuOption("commando flamethrower", 0, "extended mag", ::GivePlayerWeapon, "commando_ft_extclip_mp");
    self MenuOption("commando flamethrower", 1, "dual mag", ::GivePlayerWeapon, "commando_ft_dualclip_mp");
    self MenuOption("commando flamethrower", 2, "acog sight", ::GivePlayerWeapon, "commando_acog_ft_mp");
    self MenuOption("commando flamethrower", 3, "red dot sight", ::GivePlayerWeapon, "commando_elbit_ft_mp");
    self MenuOption("commando flamethrower", 4, "reflex sight", ::GivePlayerWeapon, "commando_reflex_ft_mp");
    self MenuOption("commando flamethrower", 5, "infrared scope", ::GivePlayerWeapon, "commando_ir_ft_mp");
    self MenuOption("commando flamethrower", 6, "suppressor", ::GivePlayerWeapon, "commando_ft_silencer_mp");
    
    self MainMenu("commando grenade launcher", "commando 2 attachments");
    self MenuOption("commando grenade launcher", 0, "extended mag", ::GivePlayerWeapon, "commando_gl_extclip_mp");
    self MenuOption("commando grenade launcher", 1, "dual mag", ::GivePlayerWeapon, "commando_gl_dualclip_mp");
    self MenuOption("commando grenade launcher", 2, "acog sight", ::GivePlayerWeapon, "commando_acog_gl_mp");
    self MenuOption("commando grenade launcher", 3, "red dot sight", ::GivePlayerWeapon, "commando_elbit_gl_mp");
    self MenuOption("commando grenade launcher", 4, "reflex sight", ::GivePlayerWeapon, "commando_reflex_gl_mp");
    self MenuOption("commando grenade launcher", 5, "infrared scope", ::GivePlayerWeapon, "commando_ir_gl_mp");
    self MenuOption("commando grenade launcher", 6, "suppressor", ::GivePlayerWeapon, "commando_gl_silencer_mp");
    
    self MainMenu("g11", "assault rifles");
    self MenuOption("g11", 0, "low power scoper", ::GivePlayerWeapon, "g11_lps_mp");
    self MenuOption("g11", 1, "variable zoom", ::GivePlayerWeapon, "g11_vzoom_mp");
    self MenuOption("g11", 2, "default", ::GivePlayerWeapon, "g11_mp");
    
    self MainMenu("submachine guns", "weapons menu");
    self MenuOption("submachine guns", 0, "mp5k", ::SubMenu, "mp5k");
    self MenuOption("submachine guns", 1, "skorpion", ::SubMenu, "skorpion");
    self MenuOption("submachine guns", 2, "mac11", ::SubMenu, "mac11");
    self MenuOption("submachine guns", 3, "ak74u", ::SubMenu, "ak74u");
    self MenuOption("submachine guns", 4, "uzi", ::SubMenu, "uzi");
    self MenuOption("submachine guns", 5, "pm63", ::SubMenu, "pm63");
    self MenuOption("submachine guns", 6, "mpl", ::SubMenu, "mpl");
    self MenuOption("submachine guns", 7, "spectre", ::SubMenu, "spectre");
    self MenuOption("submachine guns", 8, "kiparis", ::SubMenu, "kiparis");
    
    self MainMenu("mp5k", "submachine guns");
    self MenuOption("mp5k", 0, "extended mag", ::GivePlayerWeapon, "mp5k_extclip_mp");
    self MenuOption("mp5k", 1, "acog sight", ::GivePlayerWeapon, "mp5k_acog_mp");
    self MenuOption("mp5k", 2, "red dot sight", ::GivePlayerWeapon, "mp5k_elbit_mp");
    self MenuOption("mp5k", 3, "reflex sight", ::GivePlayerWeapon, "mp5k_reflex_mp");
    self MenuOption("mp5k", 4, "suppressor", ::GivePlayerWeapon, "mp5k_silencer_mp");
    self MenuOption("mp5k", 5, "rapid fire", ::GivePlayerWeapon, "mp5k_rf_mp");
    self MenuOption("mp5k", 6, "default", ::GivePlayerWeapon, "mp5k_mp");
    self MenuOption("mp5k", 7, "2 attachments", ::SubMenu, "mp5k 2 attachments");
    
    self MainMenu("mp5k 2 attachments", "mp5k");
    self MenuOption("mp5k 2 attachments", 0, "extended mag x acog sight", ::GivePlayerWeapon, "mp5k_acog_extclip_mp");
    self MenuOption("mp5k 2 attachments", 1, "extended mag x red dot sight", ::GivePlayerWeapon, "mp5k_elbit_extclip_mp");
    self MenuOption("mp5k 2 attachments", 2, "extended mag x reflex sight", ::GivePlayerWeapon, "mp5k_reflex_extclip_mp");
    self MenuOption("mp5k 2 attachments", 3, "extended mag x suppressor", ::GivePlayerWeapon, "mp5k_extclip_silencer_mp");
    self MenuOption("mp5k 2 attachments", 4, "rapid fire x acog sight", ::GivePlayerWeapon, "mp5k_acog_rf_mp");
    self MenuOption("mp5k 2 attachments", 5, "rapid fire x red dot sight", ::GivePlayerWeapon, "mp5k_elbit_rf_mp");
    self MenuOption("mp5k 2 attachments", 6, "rapid fire x reflex sight", ::GivePlayerWeapon, "mp5k_reflex_rf_mp");
    self MenuOption("mp5k 2 attachments", 7, "rapid fire x suppressor", ::GivePlayerWeapon, "mp5k_rf_silencer_mp");
    
    self MainMenu("skorpion", "submachine guns");
    self MenuOption("skorpion", 0, "extended mag", ::GivePlayerWeapon, "skorpion_extclip_mp");
    self MenuOption("skorpion", 1, "grip", ::GivePlayerWeapon, "skorpion_grip_mp");
    self MenuOption("skorpion", 2, "dual wield", ::GivePlayerWeapon, "skorpiondw_mp");
    self MenuOption("skorpion", 3, "suppressor", ::GivePlayerWeapon, "skorpion_silencer_mp");
    self MenuOption("skorpion", 4, "rapid fire", ::GivePlayerWeapon, "skorpion_rf_mp");
    self MenuOption("skorpion", 5, "default", ::GivePlayerWeapon, "skorpion_mp");
    self MenuOption("skorpion", 6, "2 attachments", ::SubMenu, "skorpion 2 attachments");
    
    self MainMenu("skorpion 2 attachments", "skorpion");
    self MenuOption("skorpion 2 attachments", 0, "extended mag x grip", ::GivePlayerWeapon, "skorpion_grip_extclip_mp");
    self MenuOption("skorpion 2 attachments", 1, "extended mag x suppressor", ::GivePlayerWeapon, "skorpion_extclip_silencer_mp");
    self MenuOption("skorpion 2 attachments", 2, "suppressor x grip", ::GivePlayerWeapon, "skorpion_grip_silencer_mp");
    self MenuOption("skorpion 2 attachments", 3, "rapid fire x grip", ::GivePlayerWeapon, "skorpion_grip_rf_mp");
    
    self MainMenu("mac11", "submachine guns");
    self MenuOption("mac11", 0, "extended mag", ::GivePlayerWeapon, "mac11_extclip_mp");
    self MenuOption("mac11", 1, "red dot sight", ::GivePlayerWeapon, "mac11_elbit_mp");
    self MenuOption("mac11", 2, "reflex sight", ::GivePlayerWeapon, "mac11_reflex_mp");
    self MenuOption("mac11", 3, "grip", ::GivePlayerWeapon, "mac11_grip_mp");
    self MenuOption("mac11", 4, "dual wield", ::GivePlayerWeapon, "mac11dw_mp");
    self MenuOption("mac11", 5, "dual wield glitched", ::GivePlayerWeapon, "mac11lh_mp");
    self MenuOption("mac11", 6, "suppressor", ::GivePlayerWeapon, "mac11_silencer_mp");
    self MenuOption("mac11", 7, "rapid fire", ::GivePlayerWeapon, "mac11_rf_mp");
    self MenuOption("mac11", 8, "default", ::GivePlayerWeapon, "mac11_mp");
    self MenuOption("mac11", 9, "2 attachments", ::SubMenu, "mac11 2 attachments");
    
    self MainMenu("mac11 2 attachments", "mac11");
    self MenuOption("mac11 2 attachments", 0, "extended mag x red dot sight", ::GivePlayerWeapon, "mac11_elbit_extclip_mp");
    self MenuOption("mac11 2 attachments", 1, "extended mag x reflex sight", ::GivePlayerWeapon, "mac11_reflex_extclip_mp");
    self MenuOption("mac11 2 attachments", 2, "extended mag x grip", ::GivePlayerWeapon, "mac11_grip_extclip_mp");
    self MenuOption("mac11 2 attachments", 3, "extended mag x suppressor", ::GivePlayerWeapon, "mac11_extclip_silencer_mp");
    self MenuOption("mac11 2 attachments", 4, "suppressor x red dot sight", ::GivePlayerWeapon, "mac11_elbit_silencer_mp");
    self MenuOption("mac11 2 attachments", 5, "suppressor x reflex sight", ::GivePlayerWeapon, "mac11_reflex_silencer_mp");
    self MenuOption("mac11 2 attachments", 6, "suppressor x grip", ::GivePlayerWeapon, "mac11_grip_silencer_mp");
    self MenuOption("mac11 2 attachments", 7, "suppressor x rapid fire", ::GivePlayerWeapon, "mac11_rf_silencer_mp");
    self MenuOption("mac11 2 attachments", 8, "rapid fire x red dot sight", ::GivePlayerWeapon, "mac11_elbit_rf_mp");
    self MenuOption("mac11 2 attachments", 9, "rapid fire x reflex sight", ::GivePlayerWeapon, "mac11_reflex_rf_mp");
    
    self MainMenu("ak74u", "submachine guns");
    self MenuOption("ak74u", 0, "extended mag", ::GivePlayerWeapon, "ak74u_extclip_mp");
    self MenuOption("ak74u", 1, "dual mag", ::GivePlayerWeapon, "ak74u_dualclip_mp");
    self MenuOption("ak74u", 2, "acog sight", ::GivePlayerWeapon, "ak74u_acog_mp");
    self MenuOption("ak74u", 3, "red dot sight", ::GivePlayerWeapon, "ak74u_elbit_mp");
    self MenuOption("ak74u", 4, "reflex sight", ::GivePlayerWeapon, "ak74u_reflex_mp");
    self MenuOption("ak74u", 5, "grip", ::GivePlayerWeapon, "ak74u_grip_mp");
    self MenuOption("ak74u", 6, "suppressor", ::GivePlayerWeapon, "ak74u_silencer_mp");
    self MenuOption("ak74u", 7, "grenade launcher", ::GivePlayerWeapon, "ak74u_gl_mp");
    self MenuOption("ak74u", 8, "rapid fire", ::GivePlayerWeapon, "ak74u_rf_mp");
    self MenuOption("ak74u", 9, "default", ::GivePlayerWeapon, "ak74u_mp");
    self MenuOption("ak74u", 10, "2 attachments", ::SubMenu, "ak74u 2 attachments");
    
    self MainMenu("ak74u 2 attachments", "ak74u");
    self MenuOption("ak74u 2 attachments", 0, "extended mag", ::SubMenu, "ak74u extended mag");
    self MenuOption("ak74u 2 attachments", 1, "dual mag", ::SubMenu, "ak74u dual mag");
    
    self MainMenu("ak74u extended mag", "ak74u 2 attachments");
    self MenuOption("ak74u extended mag", 0, "extended mag x acog sight", ::GivePlayerWeapon, "ak74u_acog_extclip_mp");
    self MenuOption("ak74u extended mag", 1, "extended mag x red dot sight", ::GivePlayerWeapon, "ak74u_elbit_extclip_mp");
    self MenuOption("ak74u extended mag", 2, "extended mag x reflex sight", ::GivePlayerWeapon, "ak74u_reflex_extclip_mp");
    self MenuOption("ak74u extended mag", 3, "extended mag x grip", ::GivePlayerWeapon, "ak74u_grip_extclip_mp");
    self MenuOption("ak74u extended mag", 4, "extended mag x suppressor", ::GivePlayerWeapon, "ak74u_extclip_silencer_mp");
    self MenuOption("ak74u extended mag", 5, "extended mag x grenade launcher", ::GivePlayerWeapon, "ak74u_gl_extclip_mp");
    
    self MainMenu("ak74u dual mag", "ak74u 2 attachments");
    self MenuOption("ak74u dual mag", 0, "dual mag x acog sight", ::GivePlayerWeapon, "ak74u_acog_dualclip_mp");
    self MenuOption("ak74u dual mag", 1, "dual mag x red dot sight", ::GivePlayerWeapon, "ak74u_elbit_dualclip_mp");
    self MenuOption("ak74u dual mag", 2, "dual mag x reflex sight", ::GivePlayerWeapon, "ak74u_reflex_dualclip_mp");
    self MenuOption("ak74u dual mag", 3, "dual mag x grip", ::GivePlayerWeapon, "ak74u_grip_dualclip_mp");
    self MenuOption("ak74u dual mag", 4, "dual mag x suppressor", ::GivePlayerWeapon, "ak74u_dualclip_silencer_mp");
    self MenuOption("ak74u dual mag", 5, "dual mag x grenade launcher", ::GivePlayerWeapon, "ak74u_gl_dualclip_mp");
    
    self MainMenu("uzi", "submachine guns");
    self MenuOption("uzi", 0, "extended mag", ::GivePlayerWeapon, "uzi_extclip_mp");
    self MenuOption("uzi", 1, "acog sight", ::GivePlayerWeapon, "uzi_acog_mp");
    self MenuOption("uzi", 2, "red dot sight", ::GivePlayerWeapon, "uzi_elbit_mp");
    self MenuOption("uzi", 3, "reflex sight", ::GivePlayerWeapon, "uzi_reflex_mp");
    self MenuOption("uzi", 4, "grip", ::GivePlayerWeapon, "uzi_grip_mp");
    self MenuOption("uzi", 5, "suppressor", ::GivePlayerWeapon, "uzi_silencer_mp");
    self MenuOption("uzi", 6, "rapid fire", ::GivePlayerWeapon, "uzi_rf_mp");
    self MenuOption("uzi", 7, "default", ::GivePlayerWeapon, "uzi_mp");
    self MenuOption("uzi", 8, "2 attachments", ::SubMenu, "uzi 2 attachments");
    
    self MainMenu("uzi 2 attachments", "uzi");
    self MenuOption("uzi 2 attachments", 0, "extended mag x red dot sight", ::GivePlayerWeapon, "uzi_elbit_extclip_mp");
    self MenuOption("uzi 2 attachments", 1, "extended mag x reflex sight", ::GivePlayerWeapon, "uzi_reflex_extclip_mp");
    self MenuOption("uzi 2 attachments", 2, "extended mag x grip", ::GivePlayerWeapon, "uzi_grip_extclip_mp");
    self MenuOption("uzi 2 attachments", 3, "extended mag x suppressor", ::GivePlayerWeapon, "uzi_extclip_silencer_mp");
    self MenuOption("uzi 2 attachments", 4, "suppressor x red dot sight", ::GivePlayerWeapon, "uzi_elbit_silencer_mp");
    self MenuOption("uzi 2 attachments", 5, "suppressor x reflex sight", ::GivePlayerWeapon, "uzi_reflex_silencer_mp");
    self MenuOption("uzi 2 attachments", 6, "suppressor x grip", ::GivePlayerWeapon, "uzi_grip_silencer_mp");
    self MenuOption("uzi 2 attachments", 7, "suppressor x rapid fire", ::GivePlayerWeapon, "uzi_rf_silencer_mp");
    self MenuOption("uzi 2 attachments", 8, "rapid fire x red dot sight", ::GivePlayerWeapon, "uzi_elbit_rf_mp");
    self MenuOption("uzi 2 attachments", 9, "rapid fire x reflex sight", ::GivePlayerWeapon, "uzi_reflex_rf_mp");
    
    self MainMenu("pm63", "submachine guns");
    self MenuOption("pm63", 0, "extended mag", ::GivePlayerWeapon, "pm63_extclip_mp");
    self MenuOption("pm63", 1, "grip", ::GivePlayerWeapon, "pm63_grip_mp");
    self MenuOption("pm63", 2, "dual wield", ::GivePlayerWeapon, "pm63dw_mp");
    self MenuOption("pm63", 3, "dual wield glitched", ::GivePlayerWeapon, "pm63lh_mp");
    self MenuOption("pm63", 4, "rapid fire", ::GivePlayerWeapon, "pm63_rf_mp");
    self MenuOption("pm63", 5, "default", ::GivePlayerWeapon, "pm63_mp");
    self MenuOption("pm63", 6, "2 attachments", ::SubMenu, "pm63 2 attachments");
    
    self MainMenu("pm63 2 attachments", "pm63");
    self MenuOption("pm63 2 attachments", 0, "grip x extended mag", ::GivePlayerWeapon, "pm63_grip_extclip_mp");
    self MenuOption("pm63 2 attachments", 1, "grip x rapid fire", ::GivePlayerWeapon, "pm63_grip_rf_mp");
    
    self MainMenu("mpl", "submachine guns");
    self MenuOption("mpl", 0, "dual mag", ::GivePlayerWeapon, "mpl_dualclip_mp");
    self MenuOption("mpl", 1, "acog sight", ::GivePlayerWeapon, "mpl_acog_mp");
    self MenuOption("mpl", 2, "red dot sight", ::GivePlayerWeapon, "mpl_elbit_mp");
    self MenuOption("mpl", 3, "reflex sight", ::GivePlayerWeapon, "mpl_reflex_mp");
    self MenuOption("mpl", 4, "grip", ::GivePlayerWeapon, "mpl_grip_mp");
    self MenuOption("mpl", 5, "suppressor", ::GivePlayerWeapon, "mpl_silencer_mp");
    self MenuOption("mpl", 6, "rapid fire", ::GivePlayerWeapon, "mpl_rf_mp");
    self MenuOption("mpl", 7, "default", ::GivePlayerWeapon, "mpl_mp");
    self MenuOption("mpl", 8, "2 attachments", ::SubMenu, "mpl 2 attachments");
    
    self MainMenu("mpl 2 attachments", "mpl");
    self MenuOption("mpl 2 attachments", 0, "dual mag x acog sight", ::GivePlayerWeapon, "mpl_acog_dualclip_mp");
    self MenuOption("mpl 2 attachments", 1, "dual mag x red dot sight", ::GivePlayerWeapon, "mpl_elbit_dualclip_mp");
    self MenuOption("mpl 2 attachments", 2, "dual mag x reflex sight", ::GivePlayerWeapon, "mpl_reflex_dualclip_mp");
    self MenuOption("mpl 2 attachments", 3, "dual mag x grip", ::GivePlayerWeapon, "mpl_grip_dualclip_mp");
    self MenuOption("mpl 2 attachments", 4, "dual mag x suppressor", ::GivePlayerWeapon, "mpl_dualclip_silencer_mp");
    self MenuOption("mpl 2 attachments", 5, "grip x acog sight", ::GivePlayerWeapon, "mpl_acog_grip_mp");
    self MenuOption("mpl 2 attachments", 6, "grip x red dot sight", ::GivePlayerWeapon, "mpl_elbit_grip_mp");
    self MenuOption("mpl 2 attachments", 7, "grip x reflex sight", ::GivePlayerWeapon, "mpl_reflex_grip_mp");
    self MenuOption("mpl 2 attachments", 8, "grip x suppressor", ::GivePlayerWeapon, "mpl_grip_silencer_mp");
    self MenuOption("mpl 2 attachments", 9, "grip x rapid fire", ::GivePlayerWeapon, "mpl_grip_rf_mp");
    
    self MainMenu("spectre", "submachine guns");
    self MenuOption("spectre", 0, "extended mag", ::GivePlayerWeapon, "spectre_extclip_mp");
    self MenuOption("spectre", 1, "acog sight", ::GivePlayerWeapon, "spectre_acog_mp");
    self MenuOption("spectre", 2, "red dot sight", ::GivePlayerWeapon, "spectre_elbit_mp");
    self MenuOption("spectre", 3, "reflex sight", ::GivePlayerWeapon, "spectre_reflex_mp");
    self MenuOption("spectre", 4, "grip", ::GivePlayerWeapon, "spectre_grip_mp");
    self MenuOption("spectre", 5, "suppressor", ::GivePlayerWeapon, "spectre_silencer_mp");
    self MenuOption("spectre", 6, "rapid fire", ::GivePlayerWeapon, "spectre_rf_mp");
    self MenuOption("spectre", 7, "default", ::GivePlayerWeapon, "spectre_mp");
    self MenuOption("spectre", 8, "2 attachments", ::SubMenu, "spectre 2 attachments");
    
    self MainMenu("spectre 2 attachments", "spectre");
    self MenuOption("spectre 2 attachments", 0, "extended mag x acog sight", ::GivePlayerWeapon, "spectre_acog_extclip_mp");
    self MenuOption("spectre 2 attachments", 1, "extended mag x red dot sight", ::GivePlayerWeapon, "spectre_elbit_extclip_mp");
    self MenuOption("spectre 2 attachments", 2, "extended mag x reflex sight", ::GivePlayerWeapon, "spectre_reflex_extclip_mp");
    self MenuOption("spectre 2 attachments", 3, "extended mag x suppressor", ::GivePlayerWeapon, "spectre_extclip_silencer_mp");
    self MenuOption("spectre 2 attachments", 4, "extended mag x grip", ::GivePlayerWeapon, "spectre_grip_extclip_mp");
    self MenuOption("spectre 2 attachments", 5, "suppressor x acog sight", ::GivePlayerWeapon, "spectre_acog_silencer_mp");
    self MenuOption("spectre 2 attachments", 6, "suppressor x red dot sight", ::GivePlayerWeapon, "spectre_elbit_silencer_mp");
    self MenuOption("spectre 2 attachments", 7, "suppressor x reflex sight", ::GivePlayerWeapon, "spectre_reflex_silencer_mp");
    self MenuOption("spectre 2 attachments", 8, "rapid fire x suppressor", ::GivePlayerWeapon, "spectre_rf_silencer_mp");
    self MenuOption("spectre 2 attachments", 9, "suppressor x grip", ::GivePlayerWeapon, "spectre_grip_silencer_mp");
    
    self MainMenu("kiparis", "submachine guns");
    self MenuOption("kiparis", 0, "extended mag", ::GivePlayerWeapon, "kiparis_extclip_mp");
    self MenuOption("kiparis", 1, "acog sight", ::GivePlayerWeapon, "kiparis_acog_mp");
    self MenuOption("kiparis", 2, "red dot sight", ::GivePlayerWeapon, "kiparis_elbit_mp");
    self MenuOption("kiparis", 3, "reflex sight", ::GivePlayerWeapon, "kiparis_reflex_mp");
    self MenuOption("kiparis", 4, "grip", ::GivePlayerWeapon, "kiparis_grip_mp");
    self MenuOption("kiparis", 5, "Dual Wield", ::GivePlayerWeapon, "kiparisdw_mp");
    self MenuOption("kiparis", 6, "Dual Wield Glitched", ::GivePlayerWeapon, "kiparislh_mp");
    self MenuOption("kiparis", 7, "suppressor", ::GivePlayerWeapon, "kiparis_silencer_mp");
    self MenuOption("kiparis", 8, "rapid fire", ::GivePlayerWeapon, "kiparis_rf_mp");
    self MenuOption("kiparis", 9, "default", ::GivePlayerWeapon, "kiparis_mp");
    self MenuOption("kiparis", 10, "2 attachments", ::SubMenu, "kiparis 2 attachments");
    
    self MainMenu("kiparis 2 attachments", "kiparis");
    self MenuOption("kiparis 2 attachments", 0, "extended mag x acog sight", ::GivePlayerWeapon, "kiparis_acog_extclip_mp");
    self MenuOption("kiparis 2 attachments", 1, "extended mag x red dot sight", ::GivePlayerWeapon, "kiparis_elbit_extclip_mp");
    self MenuOption("kiparis 2 attachments", 2, "extended mag x reflex sight", ::GivePlayerWeapon, "kiparis_reflex_extclip_mp");
    self MenuOption("kiparis 2 attachments", 3, "extended mag x suppressor", ::GivePlayerWeapon, "kiparis_extclip_silencer_mp");
    self MenuOption("kiparis 2 attachments", 4, "extended mag x grip", ::GivePlayerWeapon, "kiparis_grip_extclip_mp");
    self MenuOption("kiparis 2 attachments", 5, "suppressor x acog sight", ::GivePlayerWeapon, "kiparis_acog_silencer_mp");
    self MenuOption("kiparis 2 attachments", 6, "suppressor x red dot sight", ::GivePlayerWeapon, "kiparis_elbit_silencer_mp");
    self MenuOption("kiparis 2 attachments", 7, "suppressor x reflex sight", ::GivePlayerWeapon, "kiparis_reflex_silencer_mp");
    self MenuOption("kiparis 2 attachments", 8, "rapid fire x suppressor", ::GivePlayerWeapon, "kiparis_rf_silencer_mp");
    self MenuOption("kiparis 2 attachments", 9, "suppressor x grip", ::GivePlayerWeapon, "kiparis_grip_silencer_mp");
    
    self MainMenu("light machine guns", "weapons menu");
    self MenuOption("light machine guns", 0, "hk21", ::SubMenu, "hk21");
    self MenuOption("light machine guns", 1, "rpk", ::SubMenu, "rpk");
    self MenuOption("light machine guns", 2, "m60", ::SubMenu, "m60");
    self MenuOption("light machine guns", 3, "stoner63", ::SubMenu, "stoner63");
    
    self MainMenu("hk21", "light machine guns");
    self MenuOption("hk21", 0, "extended mag", ::GivePlayerWeapon, "hk21_extclip_mp");
    self MenuOption("hk21", 1, "acog sight", ::GivePlayerWeapon, "hk21_acog_mp");
    self MenuOption("hk21", 2, "red dot sight", ::GivePlayerWeapon, "hk21_elbit_mp");
    self MenuOption("hk21", 3, "reflex sight", ::GivePlayerWeapon, "hk21_reflex_mp");
    self MenuOption("hk21", 4, "infrared scope", ::GivePlayerWeapon, "hk21_ir_mp");
    self MenuOption("hk21", 5, "default", ::GivePlayerWeapon, "hk21_mp");
    self MenuOption("hk21", 6, "2 attachments", ::SubMenu, "hk21 2 attachments");
    
    self MainMenu("hk21 2 attachments", "hk21");
    self MenuOption("hk21 2 attachments", 0, "extended mag x acog sight", ::GivePlayerWeapon, "hk21_acog_extclip_mp");
    self MenuOption("hk21 2 attachments", 1, "extended mag x red dot sight", ::GivePlayerWeapon, "hk21_elbit_extclip_mp");
    self MenuOption("hk21 2 attachments", 2, "extended mag x reflex sight", ::GivePlayerWeapon, "hk21_reflex_extclip_mp");
    self MenuOption("hk21 2 attachments", 3, "extended mag x infrared scope", ::GivePlayerWeapon, "hk21_ir_extclip_mp");
    
    self MainMenu("rpk", "light machine guns");
    self MenuOption("rpk", 0, "extended mag", ::GivePlayerWeapon, "rpk_extclip_mp");
    self MenuOption("rpk", 1, "dual mag", ::GivePlayerWeapon, "rpk_dualclip_mp");
    self MenuOption("rpk", 2, "acog sight", ::GivePlayerWeapon, "rpk_acog_mp");
    self MenuOption("rpk", 3, "red dot sight", ::GivePlayerWeapon, "rpk_elbit_mp");
    self MenuOption("rpk", 4, "reflex sight", ::GivePlayerWeapon, "rpk_reflex_mp");
    self MenuOption("rpk", 5, "infrared scope", ::GivePlayerWeapon, "rpk_ir_mp");
    self MenuOption("rpk", 6, "default", ::GivePlayerWeapon, "rpk_mp");
    self MenuOption("rpk", 7, "2 attachments", ::SubMenu, "rpk 2 attachments");
    
    self MainMenu("rpk 2 attachments", "rpk");
    self MenuOption("rpk 2 attachments", 0, "extended mag x acog sight", ::GivePlayerWeapon, "rpk_acog_extclip_mp");
    self MenuOption("rpk 2 attachments", 1, "extended mag x red dot sight", ::GivePlayerWeapon, "rpk_elbit_extclip_mp");
    self MenuOption("rpk 2 attachments", 2, "extended mag x reflex sight", ::GivePlayerWeapon, "rpk_reflex_extclip_mp");
    self MenuOption("rpk 2 attachments", 3, "extended mag x infrared scope", ::GivePlayerWeapon, "rpk_ir_extclip_mp");
    self MenuOption("rpk 2 attachments", 4, "dual mag x acog sight", ::GivePlayerWeapon, "rpk_acog_dualclip_mp");
    self MenuOption("rpk 2 attachments", 5, "dual mag x red dot sight", ::GivePlayerWeapon, "rpk_elbit_dualclip_mp");
    self MenuOption("rpk 2 attachments", 6, "dual mag x reflex sight", ::GivePlayerWeapon, "rpk_reflex_dualclip_mp");
    self MenuOption("rpk 2 attachments", 7, "dual mag x infrared scope", ::GivePlayerWeapon, "rpk_ir_dualclip_mp");
    
    self MainMenu("m60", "light machine guns");
    self MenuOption("m60", 0, "extended mag", ::GivePlayerWeapon, "m60_extclip_mp");
    self MenuOption("m60", 1, "acog sight", ::GivePlayerWeapon, "m60_acog_mp");
    self MenuOption("m60", 2, "red dot sight", ::GivePlayerWeapon, "m60_elbit_mp");
    self MenuOption("m60", 3, "reflex sight", ::GivePlayerWeapon, "m60_reflex_mp");
    self MenuOption("m60", 4, "grip", ::GivePlayerWeapon, "m60_grip_mp");
    self MenuOption("m60", 5, "infrared scope", ::GivePlayerWeapon, "m60_ir_mp");
    self MenuOption("m60", 6, "default", ::GivePlayerWeapon, "m60_mp");
    self MenuOption("m60", 7, "2 attachments", ::SubMenu, "m60 2 attachments");
    
    self MainMenu("m60 2 attachments", "m60");
    self MenuOption("m60 2 attachments", 0, "extended mag x acog sight", ::GivePlayerWeapon, "m60_acog_extclip_mp");
    self MenuOption("m60 2 attachments", 1, "extended mag x red dot sight", ::GivePlayerWeapon, "m60_elbit_extclip_mp");
    self MenuOption("m60 2 attachments", 2, "extended mag x reflex sight", ::GivePlayerWeapon, "m60_reflex_extclip_mp");
    self MenuOption("m60 2 attachments", 3, "extended mag x infrared scope", ::GivePlayerWeapon, "m60_ir_extclip_mp");
    self MenuOption("m60 2 attachments", 4, "grip x acog sight", ::GivePlayerWeapon, "m60_acog_grip_mp");
    self MenuOption("m60 2 attachments", 5, "grip x red dot sight", ::GivePlayerWeapon, "m60_elbit_grip_mp");
    self MenuOption("m60 2 attachments", 6, "grip x reflex sight", ::GivePlayerWeapon, "m60_reflex_grip_mp");
    self MenuOption("m60 2 attachments", 7, "grip x infrared scope", ::GivePlayerWeapon, "m60_ir_grip_mp");
    
    self MainMenu("stoner63", "light machine guns");
    self MenuOption("stoner63", 0, "extended mag", ::GivePlayerWeapon, "stoner63_extclip_mp");
    self MenuOption("stoner63", 1, "acog sight", ::GivePlayerWeapon, "stoner63_acog_mp");
    self MenuOption("stoner63", 2, "red dot sight", ::GivePlayerWeapon, "stoner63_elbit_mp");
    self MenuOption("stoner63", 3, "reflex sight", ::GivePlayerWeapon, "stoner63_reflex_mp");
    self MenuOption("stoner63", 4, "infrared scope", ::GivePlayerWeapon, "stoner63_ir_mp");
    self MenuOption("stoner63", 5, "default", ::GivePlayerWeapon, "stoner63_mp");
    self MenuOption("stoner63", 6, "2 attachments", ::SubMenu, "stoner63 2 attachments");
    
    self MainMenu("stoner63 2 attachments", "stoner63");
    self MenuOption("stoner63 2 attachments", 0, "extended mag x acog sight", ::GivePlayerWeapon, "stoner63_acog_extclip_mp");
    self MenuOption("stoner63 2 attachments", 1, "extended mag x red dot sight", ::GivePlayerWeapon, "stoner63_elbit_extclip_mp");
    self MenuOption("stoner63 2 attachments", 2, "extended mag x reflex sight", ::GivePlayerWeapon, "stoner63_reflex_extclip_mp");
    self MenuOption("stoner63 2 attachments", 3, "extended mag x infrared scope", ::GivePlayerWeapon, "stoner63_ir_extclip_mp");

    
    self MainMenu("pistols", "weapons menu");
    self MenuOption("pistols", 0, "asp", ::SubMenu, "asp");
    self MenuOption("pistols", 1, "m1911", ::SubMenu, "m1911");
    self MenuOption("pistols", 2, "makarov", ::SubMenu, "makarov");
    self MenuOption("pistols", 3, "python", ::SubMenu, "python");
    self MenuOption("pistols", 4, "cz75", ::SubMenu, "cz75");
    self MenuOption("pistols", 5, "deagle", ::GivePlayerWeaponCustom, "desert_eagle_silver_mp");
    
    self MainMenu("asp", "pistols");
    self MenuOption("asp", 0, "dual wield", ::GivePlayerWeapon, "aspdw_mp");
    self MenuOption("asp", 1, "dual wield glitched", ::GivePlayerWeapon, "asplh_mp");
    self MenuOption("asp", 2, "default", ::GivePlayerWeapon, "asp_mp");

    self MainMenu("m1911", "pistols");
    self MenuOption("m1911", 0, "upgraded iron sight", ::GivePlayerWeapon, "m1911_upgradesight_mp");
    self MenuOption("m1911", 1, "extended mag", ::GivePlayerWeapon, "m1911_extclip_mp");
    self MenuOption("m1911", 2, "dual wield", ::GivePlayerWeapon, "m1911dw_mp");
    self MenuOption("m1911", 3, "dual wield glitched", ::GivePlayerWeapon, "m1911lh_mp");
    self MenuOption("m1911", 4, "suppressor", ::GivePlayerWeapon, "m1911_silencer_mp");
    self MenuOption("m1911", 5, "default", ::GivePlayerWeapon, "m1911_mp");
    
    self MainMenu("makarov", "pistols");
    self MenuOption("makarov", 0, "upgraded iron sight", ::GivePlayerWeapon, "makarov_upgradesight_mp");
    self MenuOption("makarov", 1, "extended mag", ::GivePlayerWeapon, "makarov_extclip_mp");
    self MenuOption("makarov", 2, "dual wield", ::GivePlayerWeapon, "makarovdw_mp");
    self MenuOption("makarov", 3, "dual wield glitched", ::GivePlayerWeapon, "makarovlh_mp");
    self MenuOption("makarov", 4, "suppressor", ::GivePlayerWeapon, "makarov_silencer_mp");
    self MenuOption("makarov", 5, "default", ::GivePlayerWeapon, "makarov_mp");
    
    self MainMenu("python", "pistols");
    self MenuOption("python", 0, "acog sight", ::GivePlayerWeapon, "python_acog_mp");
    self MenuOption("python", 1, "snub nose", ::GivePlayerWeapon, "python_snub_mp");
    self MenuOption("python", 2, "speed reloader", ::GivePlayerWeapon, "python_speed_mp");
    self MenuOption("python", 3, "dual wield", ::GivePlayerWeapon, "pythondw_mp");
    self MenuOption("python", 4, "dual wield glitched", ::GivePlayerWeapon, "pythonlh_mp");
    self MenuOption("python", 5, "default", ::GivePlayerWeapon, "python_mp");
    
    self MainMenu("cz75", "pistols");
    self MenuOption("cz75", 0, "upgraded iron sight", ::GivePlayerWeapon, "cz75_upgradesight_mp");
    self MenuOption("cz75", 1, "extended mag", ::GivePlayerWeapon, "cz75_extclip_mp");
    self MenuOption("cz75", 2, "dual wield", ::GivePlayerWeapon, "cz75dw_mp");
    self MenuOption("cz75", 3, "dual wield glitched", ::GivePlayerWeapon, "cz75lh_mp");
    self MenuOption("cz75", 4, "suppressor", ::GivePlayerWeapon, "cz75_silencer_mp");
    self MenuOption("cz75", 5, "full auto upgraded", ::GivePlayerWeapon, "cz75_auto_mp");
    self MenuOption("cz75", 6, "default", ::GivePlayerWeapon, "cz75_mp");
    
    self MainMenu("launchers", "weapons menu");
    self MenuOption("launchers", 0, "m72 law", ::GivePlayerWeapon, "m72_law_mp");
    self MenuOption("launchers", 1, "rpg", ::GivePlayerWeapon, "rpg_mp");
    self MenuOption("launchers", 2, "strela-3", ::GivePlayerWeapon, "strela_mp");
    self MenuOption("launchers", 3, "china lake", ::GivePlayerWeapon, "china_lake_mp");
    
    self MainMenu("specials", "weapons menu");
    self MenuOption("specials", 0, "ballistic knife", ::GivePlayerWeapon, "knife_ballistic_mp");
    self MenuOption("specials", 1, "crossbow", ::GivePlayerWeapon, "crossbow_explosive_mp");
    
    self MainMenu("super specials", "weapons menu");
    self MenuOption("super specials", 0, "default weapon", ::GivePlayerWeapon, "defaultweapon_mp");
    self MenuOption("super specials", 1, "syrette", ::GivePlayerWeapon, "syrette_mp");
    self MenuOption("super specials", 2, "carepackage", ::GivePlayerWeapon, "supplydrop_mp");
    self MenuOption("super specials", 3, "minigun", ::GivePlayerWeapon, "minigun_mp");
    self MenuOption("super specials", 4, "claymore", ::GivePlayerWeapon, "claymore_mp");
    self MenuOption("super specials", 5, "scrambler", ::GivePlayerWeapon, "scrambler_mp");
    self MenuOption("super specials", 6, "jammer", ::GivePlayerWeapon, "scavenger_item_mp");
    self MenuOption("super specials", 7, "tac", ::GivePlayerWeapon, "tactical_insertion_mp");
    self MenuOption("super specials", 8, "sensor", ::GivePlayerWeapon, "acoustic_sensor_mp");
    self MenuOption("super specials", 9, "camera", ::GivePlayerWeapon, "camera_spike_mp");
    self MenuOption("super specials", 10, "bomb", ::GivePlayerWeapon, "briefcase_bomb_mp");
    self MenuOption("super specials", 11, "grim reaper", ::GivePlayerWeapon, "m202_flash_mp");
    self MenuOption("super specials", 12, "valkyrie rocket", ::GivePlayerWeapon, "m220_tow_mp");
    self MenuOption("super specials", 13, "rc-xd remote", ::GivePlayerWeapon, "rcbomb_mp");
    self MenuOption("super specials", 14, "what the fuck is this", ::GivePlayerWeapon, "dog_bite_mp");
    self MenuOption("super specials", 15, "blunt", ::GivePlayerWeaponCustom, "dankkush_mp");

}

MainMenu(Menu, Return)
{
	self.Menu.System["GetMenu"] = Menu;
	self.Menu.System["MenuCount"] = 0;
	self.Menu.System["MenuPrevious"][Menu] = Return;
}
MenuOption(Menu, Index, Texte, Function, Input)
{
	self.Menu.System["MenuTexte"][Menu][Index] = Texte;
	self.Menu.System["MenuFunction"][Menu][Index] = Function;
	self.Menu.System["MenuInput"][Menu][Index] = Input;
}
SubMenu(input)
{
	self.Menu.System["MenuCurser"] = 0;
	self.Menu.System["Texte"] fadeovertime(0.05);
	self.Menu.System["Texte"].alpha = 0;
	self.Menu.System["Texte"] destroy();
	self.Menu.System["Title"] destroy();
	self thread LoadMenu(input);
	if(self.Menu.System["MenuRoot"]=="Client Function")
	{
	self.Menu.System["Title"] destroy();
	player = level.players[self.Menu.System["ClientIndex"]];
	self.Menu.System["Title"] = self createFontString("default", 2.0);
	self.Menu.System["Title"] setPoint("LEFT", "TOP", 125, 30);
	self.Menu.System["Title"] setText("[" + player.MyAccess + "^7] " + player.name);
	self.Menu.System["Title"].sort = 3;
	self.Menu.System["Title"].alpha = 1;
	}
}
LoadMenu(menu)
{
	self.Menu.System["MenuCurser"] = 0;
	self.Menu.System["MenuRoot"] = menu;
	self.Menu.System["Title"] = self createFontString("default", 2.0);
	self.Menu.System["Title"] setPoint("LEFT", "TOP", 125, 30);
	self.Menu.System["Title"] setText(menu);
	self.Menu.System["Title"].sort = 3;
	self.Menu.System["Title"].alpha = 1;
	string = "";
	for(i=0;i<self.Menu.System["MenuTexte"][Menu].size;i++) string += self.Menu.System["MenuTexte"][Menu][i] + "\n";
	self.Menu.System["Texte"] = self createFontString("default", 1.3);
	self.Menu.System["Texte"] setPoint("LEFT", "TOP", 125, 60);
	self.Menu.System["Texte"] setText(string);
	self.Menu.System["Texte"].sort = 3;
	self.Menu.System["Texte"].alpha = 1;
	self.Menu.Material["Scrollbar"] elemMoveY(.2, 60 + (self.Menu.System["MenuCurser"] * 15.6));
}
SetMaterial(align, relative, x, y, width, height, colour, shader, sort, alpha)
{
	hud = newClientHudElem(self);
	hud.elemtype = "icon";
	hud.color = colour;
	hud.alpha = alpha;
	hud.sort = sort;
	hud.children = [];
	hud setParent(level.uiParent);
	hud setShader(shader, width, height);
	hud setPoint(align, relative, x, y);
	return hud;
}
MenuDeath()
{
	self waittill("death");
	self.Menu.Material["Background"] destroy();
	self.Menu.Material["Scrollbar"] destroy();
	self.Menu.Material["BorderMiddle"] destroy();
	self.Menu.Material["BorderLeft"] destroy();
	self.Menu.Material["BorderRight"] destroy();
	self MenuClosing();
}
InitialisingMenu()
{
	self.Menu.Material["Background"] = self SetMaterial("LEFT", "TOP", 120, 0, 200, 1000, (1,1,1), "black", 0, 0);
	self.Menu.Material["Scrollbar"] = self SetMaterial("LEFT", "TOP", 120, 60, 200, 15, (0,1,0), "white", 1, 0);
	self.Menu.Material["BorderMiddle"] = self SetMaterial("LEFT", "TOP", 120, 50, 200, 1, (0,1,0), "white", 1, 0);
	self.Menu.Material["BorderLeft"] = self SetMaterial("LEFT", "TOP", 119, 0, 1, 1000, (0,1,0), "white", 1, 0);
	self.Menu.Material["BorderRight"] = self SetMaterial("LEFT", "TOP", 320, 0, 1, 1000, (0,1,0), "white", 1, 0);
}

MenuOpening()
{
	self setclientuivisibilityflag( "hud_visible", 0 );
	self enableInvulnerability();
	self.MenuOpen = true;
	self.Menu.Material["Background"] elemFade(.2, 0.76);
	self.Menu.Material["Scrollbar"] elemFade(.2, 0.6);
	self.Menu.Material["BorderMiddle"] elemFade(.2, 0.6);
	self.Menu.Material["BorderLeft"] elemFade(.2, 0.6);
	self.Menu.Material["BorderRight"] elemFade(.2, 0.6);
}

MenuClosing()
{    
    self setclientuivisibilityflag( "hud_visible", 1 );
	self.Menu.Material["Background"] elemFade(.1, 0);
	self.Menu.Material["Scrollbar"] elemFade(.1, 0);
	self.Menu.Material["BorderMiddle"] elemFade(.1, 0);
	self.Menu.Material["BorderLeft"] elemFade(.1, 0);
	self.Menu.Material["BorderRight"] elemFade(.1, 0);
	self disableInvulnerability();
	self.Menu.System["Title"] destroy();
	self.Menu.System["Texte"] destroy();
	wait 0.05;
	self.MenuOpen = false;
}   

elemMoveY(time, input)
{
	self moveOverTime(time);
	self.y = input;
}

elemMoveX(time, input)
{
	self moveOverTime(time);
	self.x = input;
}

elemFade(time, alpha)
{
	self fadeOverTime(time);
	self.alpha = alpha;
}

AllPlayersKilled()
{
	self Test();
}
Test()
{
}

// FUNCTIONS

QuickStart()
{
	self iPrintLnBold("^5QuickStarted");
	self enableInvulnerability();
	setDvar("g_knockback","0");
	setDvar("cg_fov","95.0");
	setDvar("com_maxfps","165.0");
	setDvar("sv_fps","20");
	setDvar("jump_slowdownEnable","0");
	SpawnBots(12);
    self setPerk( "specialty_unlimitedsprint" );
    self setPerk("specialty_fallheight");
	self setPerk("specialty_movefaster");
	EBToggle();	
	CSToggle();
	GivePlayerWeapon("l96a1_vzoom_mp");

	self MenuClosing();
	wait 0.1;
}

SpawnBots(amount)
{
	self iPrintLnBold("^5Spawnd " + amount + " Bots");
	setDvar("bots_team","autoassign");
	setDvar("bots_manage_add",amount);
}
SpawnAlliesBots(amount)
{
	self iPrintLnBold("^5Spawnd " + amount + " Bots");
	setDvar("bots_team","allies");
	setDvar("bots_manage_add",amount);
}
SpawnAxisBots(amount)
{
	self iPrintLnBold("^5Spawnd " + amount + " Bots");
	setDvar("bots_team","axis");
	setDvar("bots_manage_add",amount);
}
FreezeBots()
{
	if (!isDefined(self.canswap) || self.canswap == false)
		{
			self iPrintLnBold("All Bots Frozon - ^2ON");
			players = level.players;
			for ( i = 0; i < players.size; i++ )
			{   
				player = players[i];
				if(IsDefined(player.pers[ "isBot" ]) && player.pers["isBot"])
				{
					player freezeControls(true);
				}
				self.frozenbots = 1;
				wait .025;
			}
			self.canswap = true;
		}
		else if (self.canswap == true)
		{
			self iPrintLnBold("All Bots Frozon - ^1OFF");
			
			players = level.players;
			for ( i = 0; i < players.size; i++ )
			{   
				player = players[i];
				if(IsDefined(player.pers[ "isBot" ]) && player.pers["isBot"])
				{
					player freezeControls(false);
				}
			}
			
			self.canswap = false;
		}
}
SetupBots()
{
	players = level.players;
		for ( i = 0; i < players.size; i++ )
		{   
			player = players[i];
			if(isDefined(player.pers["isBot"])&& player.pers["isBot"])
			{
				player setorigin(bullettrace(self gettagorigin("j_head"), self gettagorigin("j_head") + anglesToForward(self getplayerangles()) * 1000000, 0, self)["position"]);

			}
		}
	self iPrintLnBold("All Bots ^1Teleported");
}
GivePlayerWeapon(weapon)
{
	if(!isDefined(self.NextDropped))
                {
                    weap = self getCurrentWeapon();
                    self dropitem(weap);
                }
                else
                {
                    weap = self getCurrentWeapon();
                    weap = self getCurrentWeapon();
                    self dropitem(weap);
                    self setSpawnWeapon(self.NextDropped);
                }
    self giveWeapon(weapon);
    
    self switchToWeapon(weapon);
    self giveMaxAmmo(weapon);
    self iPrintln("You have been given: ^2" + weapon);
}
GivePlayerWeaponCustom(weapon){
    self setClientDvar("give",weapon);
}
changeCamo(num)
{
    weap=self getCurrentWeapon();
    myclip=self getWeaponAmmoClip(weap);
    mystock=self getWeaponAmmoStock(weap);  
    self takeWeapon(weap);  
    weaponOptions=self calcWeaponOptions(num,0,0,0,0);  
    self GiveWeapon(weap,0,weaponOptions);  
    self switchToWeapon(weap);  
    self setSpawnWeapon(weap);  
    self setweaponammoclip(weap,myclip);  
    self setweaponammostock(weap,mystock);  
    self.camo=num;  
}
randomCamo()
{
    numEro=randomIntRange(1,16);  
    weap=self getCurrentWeapon();  
    myclip=self getWeaponAmmoClip(weap);  
    mystock=self getWeaponAmmoStock(weap);  
    self takeWeapon(weap);  
    weaponOptions=self calcWeaponOptions(numEro,0,0,0,0);  
    self GiveWeapon(weap,0,weaponOptions);  
    self switchToWeapon(weap);  
    self setSpawnWeapon(weap);  
    self setweaponammoclip(weap,myclip);  
    self setweaponammostock(weap,mystock);  
    self.camo=numEro;  
}
SpawnStaticHeli()
{
	self.DropZone2 = self.origin + (0,0,1150);
	self.DropZoneAngle2 = self.angle;
	self thread maps\mp\gametypes\_supplydrop::NewHeli( self.DropZone2, "bruh", self, self.team);
	self iPrintLnBold("Helicopter Spawned");
}
doKillstreak(killstreak)
{
    self maps\mp\gametypes\_hardpoints::giveKillstreak(killstreak);
    self iPrintLnBold(killstreak + " ^1Given");
}
EBToggle()
{
	if (!isDefined(self.ebclose) || self.ebclose == false)
		{
			self thread ebCloseScript();
			self iPrintLnBold("Close explosive bullets - ^2ON");
			self.ebclose = true;
		}
		else if (self.ebclose == true)
		{
			self notify("eb1off");
			self iPrintLnBold("Close explosive bullets - ^1OFF");
			self.ebclose = false;
		}
}
ebCloseScript()
{
	self endon("eb1off");
	self endon("disconnect");

	while (1)
	{
		self waittill("weapon_fired");
		my = self gettagorigin("j_head");
		trace = bullettrace(my, my + anglestoforward(self getplayerangles()) * 100000, true, self)["position"];
		playfx(level.expbullt, trace);
		dis = distance(self.origin, trace);
		if (dis < 101) RadiusDamage(trace, dis, 200, 50, self);
		RadiusDamage(trace, 100, 800, 50, self);
	}
}
CSToggle()
{
	if (!isDefined(self.canswap) || self.canswap == false)
		{
			self iPrintLnBold("Auto Canswap - ^2ON");
			self thread doInfCan();
			self.canswap = true;
		}
		else if (self.canswap == true)
		{
			self notify("stop_infCanswap");
			self iPrintLnBold("Auto Canswap - ^1OFF");
			self.canswap = false;
		}
}
doInfCan()
{
    self endon("disconnect");
    self endon("stop_infCanswap");
    for(;;)
    {
        self waittill( "weapon_change", currentWeapon );
        currentWeapon = self getCurrentWeapon();
        self.WeapClip    = self getWeaponAmmoClip(currentWeapon);
        self.WeapStock     = self getWeaponAmmoStock(currentWeapon);
        self takeWeapon(currentWeapon);
        waittillframeend;
        self giveweapon(currentWeapon);
        self setweaponammostock(currentWeapon, self.WeapStock);
        self setweaponammoclip(currentWeapon, self.WeapClip);
    }
}
ForgeToggle()
{
	if (!isDefined(self.canswap) || self.canswap == false)
		{
			self iPrintLnBold("Forge Mode ^2On ^7- Hold [{+speed_throw}] to Move Objects");
			self thread forgemodeon();
			self.canswap = true;
		}
		else if (self.canswap == true)
		{
			self iPrintLnBold("Forge Mode ^2Off");
			self notify( "stop_forge" );
			self.canswap = false;
		}
}
forgemodeon()
{
    self endon( "death" );
    self endon( "stop_forge" );
    for(;;)
    {
    while( self adsbuttonpressed() )
    {
        trace=bulletTrace(self GetTagOrigin("j_head"),self GetTagOrigin("j_head")+ anglesToForward(self GetPlayerAngles())* 1000000,true,self);
        while( self adsbuttonpressed() )
        {
            trace[ "entity"] setorigin( self gettagorigin( "j_head" ) + anglestoforward( self getplayerangles() ) * self.ForgeRadii );
            trace["entity"].origin=self GetTagOrigin("j_head")+ anglesToForward(self GetPlayerAngles())* self.ForgeRadii;
            wait 0.05;
        }
    }
    wait 0.05;
    }

}
GivePerks()
{
	if (!isDefined(self.canswap) || self.canswap == false)
		{
			self iPrintLnBold("All Perks - ^2ON");
			self setPerk("specialty_fallheight");
			self setPerk("specialty_movefaster");
			self setPerk( "specialty_extraammo" );
			self setPerk( "specialty_scavenger" );
			self setPerk( "specialty_gpsjammer" );
			self setPerk( "specialty_nottargetedbyai" );
			self setPerk( "specialty_noname" );
			self setPerk( "specialty_flakjacket" );
			self setPerk( "specialty_killstreak" );
			self setPerk( "specialty_gambler" );
			self setPerk( "specialty_fallheight" );
			self setPerk( "specialty_sprintrecovery" );
			self setPerk( "specialty_fastmeleerecovery" );
			self setPerk( "specialty_holdbreath" );
			self setPerk( "specialty_fastweaponswitch" );
			self setPerk( "specialty_fastreload" );
			self setPerk( "specialty_fastads" );
			self setPerk("specialty_twoattach");
			self setPerk("specialty_twogrenades");
			self setPerk( "specialty_longersprint" );
			self setPerk( "specialty_unlimitedsprint" );
			self setPerk( "specialty_quieter" );
			self setPerk( "specialty_loudenemies" );
			self setPerk( "specialty_showenemyequipment" );
			self setPerk( "specialty_detectexplosive" );
			self setPerk( "specialty_disarmexplosive" );
			self setPerk( "specialty_nomotionsensor" );
			self setPerk( "specialty_shades" );
			self setPerk( "specialty_stunprotection" );
			self setPerk( "specialty_pistoldeath" );
			self setPerk( "specialty_finalstand" );
			self.canswap = true;
		}
		else if (self.canswap == true)
		{
			self iPrintLnBold("All Perks - ^1OFF");
			self unsetPerk("specialty_fallheight");
			self unsetPerk("specialty_movefaster");
			self unsetPerk( "specialty_extraammo" );
			self unsetPerk( "specialty_scavenger" );
			self unsetPerk( "specialty_gpsjammer" );
			self unsetPerk( "specialty_nottargetedbyai" );
			self unsetPerk( "specialty_noname" );
			self unsetPerk( "specialty_flakjacket" );
			self unsetPerk( "specialty_killstreak" );
			self unsetPerk( "specialty_gambler" );
			self unsetPerk( "specialty_fallheight" );
			self unsetPerk( "specialty_sprintrecovery" );
			self unsetPerk( "specialty_fastmeleerecovery" );
			self unsetPerk( "specialty_holdbreath" );
			self unsetPerk( "specialty_fastweaponswitch" );
			self unsetPerk( "specialty_fastreload" );
			self unsetPerk( "specialty_fastads" );
			self unsetPerk("specialty_twoattach");
			self unsetPerk("specialty_twogrenades");
			self unsetPerk( "specialty_longersprint" );
			self unsetPerk( "specialty_unlimitedsprint" );
			self unsetPerk( "specialty_quieter" );
			self unsetPerk( "specialty_loudenemies" );
			self unsetPerk( "specialty_showenemyequipment" );
			self unsetPerk( "specialty_detectexplosive" );
			self unsetPerk( "specialty_disarmexplosive" );
			self unsetPerk( "specialty_nomotionsensor" );
			self unsetPerk( "specialty_shades" );
			self unsetPerk( "specialty_stunprotection" );
			self unsetPerk( "specialty_pistoldeath" );
			self unsetPerk( "specialty_finalstand" );
			self.canswap = false;
		}
}
Bounce()
{
	trampoline = spawn( "script_model", self.origin );
		trampoline setmodel( "" );
		self iPrintLnBold( "Spawned A ^2Bounce" );
		self thread monitortrampoline( trampoline );
}
monitortrampoline( model )
{
    self endon( "disconnect" );
    level endon( "game_ended" );
    for(;;)
    {
        if( distance( self.origin, model.origin ) < 85 )
        {
            if( self isonground() )
            {
                self setorigin( self.origin );
            }
            self setvelocity( self getvelocity() + ( 0, 0, 999 ) );
        }
        wait 0.01;
    }
}
ClearBodies(){
	self iPrintLnbold("Cleaning up...");
		for (i = 0; i < 15; i++)
		{
			clone = self ClonePlayer(1);
			clone delete();
			wait .1;
		}
}
CreateClone()
{
	self ClonePlayer(1);
	self iPrintlnbold("Player cloned");
}