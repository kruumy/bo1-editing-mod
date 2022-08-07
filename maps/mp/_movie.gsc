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