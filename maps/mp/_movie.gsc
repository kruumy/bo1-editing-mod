#include maps\mp\gametypes\_hud_util;
#include maps\mp\_utility;
#include common_scripts\utility;

movie()
{
	level thread MovieConnect();
}

MovieConnect()
{
	for (;;)
	{
		level waittill("connected", player);
		
		player thread MovieSpawn();
	}
}

MovieSpawn()
{
	self endon("disconnect");
	for(;;)
	{
		self waittill("spawned_player");
		
		// Grenade cam reset
		setDvar("cg_thirdperson", "0");
		
		// Regeneration
		thread RegenAmmo();
		thread RegenEquip();
		thread RegenSpec();
		
		thread EBClose();
		thread InfCanswap();
		thread SpawnBounce();
		thread SpawnHeli();
		thread GivePerks();
		thread TPBots();
		thread FreezeBots();
		thread ForgeMode();
		thread SetPlayerScore();
		
		
		// Killstreak
		setDvar("mvm_killstreak_NAME","");
		thread GiveRadar();
		thread GiveRC();
		thread GiveCounter();
		thread GiveSam();
		thread GiveCarePackage();
		thread GiveNapalm();
		thread GiveSentry();
		thread GiveHeli();
		thread GiveRockets();
		thread GiveAirstrike();
		thread GiveChopper();
		thread GiveDogs();
		thread GiveGunShip();
		thread GiveReaper();
	}
}

RegenAmmo()
{
	for (;;)
	{
		self notifyOnPlayerCommand("reload", "+reload");
		self waittill("reload");
		wait 1;
		if (self.pers["rAmmo"] == "true")
		{
			currentWeapon = self getCurrentWeapon();
			self giveMaxAmmo(currentWeapon);
		}
	}
}

RegenEquip()
{
	for (;;)
	{
		self notifyOnPlayerCommand("frag", "+frag");
		self waittill("frag");
		currentOffhand = self GetCurrentOffhand();
		self.pers["equ"] = currentOffhand;
		wait 1;
		if (self.pers["rEquip"] == "true")
		{
			self setWeaponAmmoClip(currentOffhand, 9999);
			self GiveMaxAmmo(currentOffhand);
		}
	}
}

RegenSpec()
{
	for (;;)
	{
		self notifyOnPlayerCommand("smoke", "+smoke");
		self waittill("smoke");
		currentOffhand = self GetCurrentOffhand();
		self.pers["equSpec"] = currentOffhand;
		wait 1;
		if (self.pers["rSpec"] == "true")
		{
			self giveWeapon(self.pers["equSpec"]);
			self giveMaxAmmo(currentOffhand);
			self setWeaponAmmoClip(currentOffhand, 9999);
		}
	}
}

EBClose()
{
	self endon("death");
	self endon("disconnect");
	self notifyOnPlayerCommand("mvm_eb_close", "mvm_eb_close");
	for (;;)
	{
		self waittill("mvm_eb_close");

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

InfCanswap()
{
	self endon("death");
	self endon("disconnect");
	self notifyOnPlayerCommand("mvm_canswap", "mvm_canswap");
	for (;;)
	{
		self waittill("mvm_canswap");

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

GiveRadar()
{
	self endon("death");
	self endon("disconnect");
	self notifyOnPlayerCommand("mvm_killstreak_radar", "mvm_killstreak_radar");
	for (;;)
	{
		self waittill("mvm_killstreak_radar");
		doKillstreak("radar_mp");
	}
}

GiveRC()
{
	self endon("death");
	self endon("disconnect");
	self notifyOnPlayerCommand("mvm_killstreak_rcbomb", "mvm_killstreak_rcbomb");
	for (;;)
	{
		self waittill("mvm_killstreak_rcbomb");
		doKillstreak("rcbomb_mp");
	}
}

GiveCounter()
{
	self endon("death");
	self endon("disconnect");
	self notifyOnPlayerCommand("mvm_killstreak_counteruav", "mvm_killstreak_counteruav");
	for (;;)
	{
		self waittill("mvm_killstreak_counteruav");
		doKillstreak("counteruav_mp");
	}
}

GiveSam()
{
	self endon("death");
	self endon("disconnect");
	self notifyOnPlayerCommand("mvm_killstreak_auto_tow", "mvm_killstreak_auto_tow");
	for (;;)
	{
		self waittill("mvm_killstreak_auto_tow");
		doKillstreak("auto_tow_mp");
	}
}
GiveCarePackage()
{
	self endon("death");
	self endon("disconnect");
	self notifyOnPlayerCommand("mvm_killstreak_supply_drop", "mvm_killstreak_supply_drop");
	for (;;)
	{
		self waittill("mvm_killstreak_supply_drop");
		doKillstreak("supply_drop_mp");
	}
}
GiveNapalm()
{
	self endon("death");
	self endon("disconnect");
	self notifyOnPlayerCommand("mvm_killstreak_napalm", "mvm_killstreak_napalm");
	for (;;)
	{
		self waittill("mvm_killstreak_napalm");
		doKillstreak("napalm_mp");
	}
}
GiveSentry()
{
	self endon("death");
	self endon("disconnect");
	self notifyOnPlayerCommand("mvm_killstreak_autoturret", "mvm_killstreak_autoturret");
	for (;;)
	{
		self waittill("mvm_killstreak_autoturret");
		doKillstreak("autoturret_mp");
	}
}
GiveMortar()
{
	self endon("death");
	self endon("disconnect");
	self notifyOnPlayerCommand("mvm_killstreak_mortar", "mvm_killstreak_mortar");
	for (;;)
	{
		self waittill("mvm_killstreak_mortar");
		doKillstreak("mortar_mp");
	}
}
GiveHeli()
{
	self endon("death");
	self endon("disconnect");
	self notifyOnPlayerCommand("mvm_killstreak_helicopter_comlink", "mvm_killstreak_helicopter_comlink");
	for (;;)
	{
		self waittill("mvm_killstreak_helicopter_comlink");
		doKillstreak("helicopter_comlink_mp");
	}
}
GiveRockets()
{
	self endon("death");
	self endon("disconnect");
	self notifyOnPlayerCommand("mvm_killstreak_m220_tow", "mvm_killstreak_m220_tow");
	for (;;)
	{
		self waittill("mvm_killstreak_m220_tow");
		doKillstreak("m220_tow_mp");
	}
}
GiveAirstrike()
{
	self endon("death");
	self endon("disconnect");
	self notifyOnPlayerCommand("mvm_killstreak_airstrike", "mvm_killstreak_airstrike");
	for (;;)
	{
		self waittill("mvm_killstreak_airstrike");
		doKillstreak("airstrike_mp");
	}
}
GiveChopper()
{
	self endon("death");
	self endon("disconnect");
	self notifyOnPlayerCommand("mvm_killstreak_helicopter_gunner", "mvm_killstreak_helicopter_gunner");
	for (;;)
	{
		self waittill("mvm_killstreak_helicopter_gunner");
		doKillstreak("helicopter_gunner_mp");
	}
}
GiveDogs()
{
	self endon("death");
	self endon("disconnect");
	self notifyOnPlayerCommand("mvm_killstreak_dogs", "mvm_killstreak_dogs");
	for (;;)
	{
		self waittill("mvm_killstreak_dogs");
		doKillstreak("dogs_mp");
	}
}
GiveGunShip()
{
	self endon("death");
	self endon("disconnect");
	self notifyOnPlayerCommand("mvm_killstreak_helicopter_player_firstperson", "mvm_killstreak_helicopter_player_firstperson");
	for (;;)
	{
		self waittill("mvm_killstreak_helicopter_player_firstperson");
		doKillstreak("helicopter_player_firstperson_mp");
	}
}
GiveReaper()
{
	self endon("death");
	self endon("disconnect");
	self notifyOnPlayerCommand("mvm_killstreak_m202_flash", "mvm_killstreak_m202_flash");
	for (;;)
	{
		self waittill("mvm_killstreak_m202_flash");
		doKillstreak("m202_flash_mp");
	}
}

doKillstreak(killstreak)
{
    self maps\mp\gametypes\_hardpoints::giveKillstreak(killstreak);
    self iPrintLnBold(killstreak + " ^1Given");
}

SpawnBounce()
{
	self endon("death");
	self endon("disconnect");
	self notifyOnPlayerCommand("mvm_spawn_bounce", "mvm_spawn_bounce");
	for (;;)
	{
		self waittill("mvm_spawn_bounce");
		
		trampoline = spawn( "script_model", self.origin );
		trampoline setmodel( "" );
		self iPrintLnBold( "Spawned A ^2Bounce" );
		self thread monitortrampoline( trampoline );
	}
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

SpawnHeli()
{
	self endon("death");
	self endon("disconnect");
	self notifyOnPlayerCommand("mvm_spawn_heli", "mvm_spawn_heli");
	for (;;)
	{
		self waittill("mvm_spawn_heli");
		
		self.DropZone2 = self.origin + (0,0,1150);
		self.DropZoneAngle2 = self.angle;
		self thread maps\mp\gametypes\_supplydrop::NewHeli( self.DropZone2, "bruh", self, self.team);
		self iPrintLnBold("Helicopter Spawned");
	}
}

TPBots()
{
	self endon("death");
	self endon("disconnect");
	self notifyOnPlayerCommand("mvm_bots_setup", "mvm_bots_setup");
	for (;;)
	{
		self waittill("mvm_bots_setup");
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
}

GivePerks()
{
	self endon("death");
	self endon("disconnect");
	self notifyOnPlayerCommand("mvm_perks", "mvm_perks");
	for (;;)
	{
		self waittill("mvm_perks");
		
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
}
SetPlayerScore()
{
	self endon("death");
	self endon("disconnect");
	
	self notifyOnPlayerCommand("mvm_score", "mvm_score");
	for (;;)
	{
		self waittill("mvm_score");
		setDvar("mvm_score", getDvar("mvm_score"));
		wait 0.05;
		maps\mp\gametypes\_rank::registerScoreInfo( "kill",  int(getDvarInt("mvm_score")));
		
		if ( isSubStr(getDvar("mvm_score"), "Change") || getDvarInt("mvm_score") >= 50 )
		{
			maps\mp\gametypes\_rank::registerScoreInfo( "kill", 100 );
			maps\mp\gametypes\_rank::registerScoreInfo( "headshot", 100 );
			maps\mp\gametypes\_rank::registerScoreInfo( "assist_75", 80 );
			maps\mp\gametypes\_rank::registerScoreInfo( "assist_50", 60 );
			maps\mp\gametypes\_rank::registerScoreInfo( "assist_25", 40 );
			maps\mp\gametypes\_rank::registerScoreInfo( "assist", 20 );
			maps\mp\gametypes\_rank::registerScoreInfo( "suicide", 0 );
			maps\mp\gametypes\_rank::registerScoreInfo( "teamkill", 0 );
			maps\mp\gametypes\_rank::registerScoreInfo( "dogkill", 30 );
			maps\mp\gametypes\_rank::registerScoreInfo( "dogassist", 10 );
			maps\mp\gametypes\_rank::registerScoreInfo( "helicopterkill", 200 );
			maps\mp\gametypes\_rank::registerScoreInfo( "helicopterassist", 50 );
			maps\mp\gametypes\_rank::registerScoreInfo( "helicopterassist_75", 150 );
			maps\mp\gametypes\_rank::registerScoreInfo( "helicopterassist_50", 100 );
			maps\mp\gametypes\_rank::registerScoreInfo( "helicopterassist_25", 50 );
			maps\mp\gametypes\_rank::registerScoreInfo( "spyplanekill", 100 );
			maps\mp\gametypes\_rank::registerScoreInfo( "spyplaneassist", 50 );
			maps\mp\gametypes\_rank::registerScoreInfo( "rcbombdestroy", 50 );
		}
		else
		{
			maps\mp\gametypes\_rank::registerScoreInfo( "kill", 0 );
			maps\mp\gametypes\_rank::registerScoreInfo( "headshot", 0 );
			maps\mp\gametypes\_rank::registerScoreInfo( "assist_75", 0 );
			maps\mp\gametypes\_rank::registerScoreInfo( "assist_50", 0 );
			maps\mp\gametypes\_rank::registerScoreInfo( "assist_25", 0 );
			maps\mp\gametypes\_rank::registerScoreInfo( "assist", 0 );
			maps\mp\gametypes\_rank::registerScoreInfo( "suicide", 0 );
			maps\mp\gametypes\_rank::registerScoreInfo( "teamkill", 0 );
			maps\mp\gametypes\_rank::registerScoreInfo( "dogkill", 0 );
			maps\mp\gametypes\_rank::registerScoreInfo( "dogassist", 0 );
			maps\mp\gametypes\_rank::registerScoreInfo( "helicopterkill", 0 );
			maps\mp\gametypes\_rank::registerScoreInfo( "helicopterassist", 0 );
			maps\mp\gametypes\_rank::registerScoreInfo( "helicopterassist_75", 0 );
			maps\mp\gametypes\_rank::registerScoreInfo( "helicopterassist_50", 0 );
			maps\mp\gametypes\_rank::registerScoreInfo( "helicopterassist_25", 0 );
			maps\mp\gametypes\_rank::registerScoreInfo( "spyplanekill", 0 );
			maps\mp\gametypes\_rank::registerScoreInfo( "spyplaneassist", 0 );
			maps\mp\gametypes\_rank::registerScoreInfo( "rcbombdestroy", 0 );
		}
	}
}

FreezeBots()
{
	self endon("death");
	self endon("disconnect");
	self notifyOnPlayerCommand("mvm_bots_freeze", "mvm_bots_freeze");
	for (;;)
	{
		self waittill("mvm_bots_freeze");
		
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
}

ForgeMode()
{
	self endon("death");
	self endon("disconnect");
	self notifyOnPlayerCommand("mvm_forge", "mvm_forge");
	for (;;)
	{
		self waittill("mvm_forge");
		
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