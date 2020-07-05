/* 			
		Tutorial pri registraciji koji zapravo ima pricu

		Uradio : V01D
		Vreme izrade : Oko 1-2h
		Credits : GordoN ( IDEJA ), Neki Stranac ( MAPA BOLNICE )
		Komentar : Pise sve vec, ima snimak gde mozete pogledati o cemu se radi, mislim da je ovo
				   jako cool za server posto nije nigde vidjeno, makar nije kada sam ja radio
*/
#define FILTERSCRIPT
//====================================== [ POTREBNI INCOVI ] ==========================================//
#include <a_samp>
#include <YSI\y_va>
#include <YSI\y_timers>
#include <streamer>
#include <Pawn.CMD>

#if defined FILTERSCRIPT
//====================================== [ VARIJABLE ] ==========================================//

static MetaActor;
static DoktorActor;
static bool:UTutorialu[MAX_PLAYERS char];
static OverLordTimer[MAX_PLAYERS char];
static TutorialCP[MAX_PLAYERS char];
static bool:UpucaoMetu[MAX_PLAYERS char];
static KadaJePao[MAX_PLAYERS char];
static DoktorVarijabla[MAX_PLAYERS char];
static bool:ProveraVojnik[MAX_PLAYERS char];
static AvionObjekat;
static Text:CrniTD;
static Text:TeksticTD;

//====================================== [ PRELOAD ANIMACIJA ] ==================================//

static const _AnimsEnum[][] =
{
    "AIRPORT",      "Attractors",   "BAR",          "BASEBALL",     "BD_FIRE",
    "BEACH",        "benchpress",   "BF_injection", "BIKED",        "BIKEH",
    "BIKELEAP",     "BIKES",        "BIKEV",        "BIKE_DBZ",     "BLOWJOBZ",
    "BMX",          "BOMBER",       "BOX",          "BSKTBALL",     "BUDDY",
    "BUS",          "CAMERA",       "CAR",          "CARRY",        "CAR_CHAT",
    "CASINO",       "CHAINSAW",     "CHOPPA",       "CLOTHES",      "COACH",
    "COLT45",       "COP_AMBIENT",  "COP_DVBYZ",    "CRACK",        "CRIB",
    "DAM_JUMP",     "DANCING",      "DEALER",       "DILDO",        "DODGE",
    "DOZER",        "DRIVEBYS",     "FAT",          "FIGHT_B",      "FIGHT_C",
    "FIGHT_D",      "FIGHT_E",      "FINALE",       "FINALE2",      "FLAME",
    "Flowers",      "FOOD",         "Freeweights",  "GANGS",        "GHANDS",
    "GHETTO_DB",    "goggles",      "GRAFFITI",     "GRAVEYARD",    "GRENADE",
    "GYMNASIUM",    "HAIRCUTS",     "HEIST9",       "INT_HOUSE",    "INT_OFFICE",
    "INT_SHOP",     "JST_BUISNESS", "KART",         "KISSING",      "KNIFE",
    "LAPDAN1",      "LAPDAN2",      "LAPDAN3",      "LOWRIDER",     "MD_CHASE",
    "MD_END",       "MEDIC",        "MISC",         "MTB",          "MUSCULAR",
    "NEVADA",       "ON_LOOKERS",   "OTB",          "PARACHUTE",    "PARK",
    "PAULNMAC",     "ped",          "PLAYER_DVBYS", "PLAYIDLES",    "POLICE",
    "POOL",         "POOR",         "PYTHON",       "QUAD",         "QUAD_DBZ",
    "RAPPING",      "RIFLE",        "RIOT",         "ROB_BANK",     "ROCKET",
    "RUSTLER",      "RYDER",        "SCRATCHING",   "SHAMAL",       "SHOP",
    "SHOTGUN",      "SILENCED",     "SKATE",        "SMOKING",      "SNIPER",
    "SPRAYCAN",     "STRIP",        "SUNBATHE",     "SWAT",         "SWEET",
    "SWIM",         "SWORD",        "TANK",         "TATTOOS",      "TEC",
    "TRAIN",        "TRUCK",        "UZI",          "VAN",          "VENDING",
    "VORTEX",       "WAYFARER",     "WEAPONS",      "WUZI"
};

//====================================== [ BITNO !!!!!!!!! ] ====================================//

//Kada igrac zavrsi registraciju, obavezno postaviti varijablu UTutorialu{playerid} na false pre nego sto se spawna

//====================================== [ OVO TI JE NESTO ZANIMLJIVO ] =========================//

#define TutorialMessage(%0,%1)       SendClientMessage(%0, 0xF81414FF, "(Tutorial) | {FFFFFF}"%1)

//====================================== [ CALLBACKS ] ==========================================//

public OnPlayerConnect(playerid)
{
	for(new anims = 0; anims < sizeof(_AnimsEnum); anims ++) //Preload Animacija
    {
        ApplyAnimation(playerid, _AnimsEnum[anims], "null", 4.0, 0, 0, 0, 0, 0, 1);
    }

	OcistiChatIgracu(playerid); //Cisti chat igracu

	//Ovde napravite onu klasicnu proveru da li ima acc, ako nema acc, onda se pokrece ovo ispod
    UTutorialu{playerid} = true; //OVO TI JE JAKO BITNO PRI SPAWNU IGRACAA!!!
    Tutorial(playerid); //Funckija za pokretanje tutoriala
	
	return 1;
}

public OnPlayerKeyStateChange(playerid, newkeys, oldkeys)
{
	if(newkeys == KEY_CROUCH)
	{
		if(ProveraVojnik{playerid})
		{
			if(IsPlayerInRangeOfPoint(playerid, 2.0, -1651.7321,-2423.4563,98.3168))
			{
				OverLordTimer{playerid} = 5;
				defer OverLordPricaTimer(playerid);
				TogglePlayerControllable(playerid, 0);
				InterpolateCameraPos(playerid, -1631.916503, -2409.057861, 105.050163, -1581.658203, -2477.567626, 95.099815, 7000);
				InterpolateCameraLookAt(playerid, -1635.094848, -2412.736328, 103.881393, -1584.443359, -2481.658447, 94.387405, 7000);
				return 1;
			}
		}
	}
	return 1;
}

public OnPlayerSpawn(playerid)
{
	if(UTutorialu{playerid}) //Kada se spawna, ako mu je UTutorialu podeseno na true, pokrece tutorial, ako nije ide dalje na login
	{
		SetPlayerPos(playerid, -1651.7321,-2423.4563,98.3168);
		SetPlayerFacingAngle(playerid, 231.6063);
		OcistiChatIgracu(playerid);
		SetCameraBehindPlayer(playerid);
		ProveraVojnik{playerid} = true;
		GivePlayerWeapon(playerid, 34, 10);
		TutorialMessage(playerid, "Cucni da bi se pritajio!");
		TogglePlayerControllable(playerid, 1);
		return 1;
	}
	else
	{
		//Ovde postaviti kada se igrac spawna i kada izadje iz tuta
		return 1;
	}
}

public OnPlayerEnterCheckpoint(playerid) //Kada udje na checkpoint
{
	switch(TutorialCP{playerid})
	{
		case 1: //Ovo je kada udje u za dokumenta
		{
			DisablePlayerCheckpoint(playerid);
			OcistiChatIgracu(playerid);
			ApplyAnimation(playerid, "BOMBER", "BOM_Plant_Loop", 4.1, 1, 1, 1, 0, 0, 1);
			defer TraziDokumenta(playerid);
			return 1;
		}
		case 2: //Kada ti naprave zasedu
		{
			DisablePlayerCheckpoint(playerid);
			OcistiChatIgracu(playerid);
			SetPlayerHealth(playerid, 10.0);
			ResetPlayerWeapons(playerid);
			ApplyAnimation(playerid, "CRACK", "crckdeth2", 4.1, 1, 1, 1, 0, 0, 1);
			KadaJePao{playerid} = 4;
			defer KadaJePaoTimer(playerid);
			return 1;
		}
	}
	return 1;
}

public OnFilterScriptInit()
{

	MetaActor = CreateActor(304, -1590.4241,-2490.7925,92.7669,141.3889);
	ApplyActorAnimation(MetaActor, "DEALER", "DEALER_IDLE", 4.0, 1, 1, 1, 1, 0);
	SetActorInvulnerable(MetaActor, 0); 

	DoktorActor = CreateActor(70, -16.4110,150.5183,999.0519,130.6887);
	ApplyActorAnimation(DoktorActor, "DEALER", "DEALER_IDLE", 4.0, 1, 1, 1, 1, 0);

	CreateDynamicObject(18259, -1578.69653, -2490.81006, 91.68095,   0.00000, 0.00000, 313.51682); //Kuca

	MapicaBolnicaInterijer();

	CrniTD = TextDrawCreate(-33.200031, -26.035589, "box"); //Ovo je TD gde je ceo ekran crn
	TextDrawLetterSize(CrniTD, 0.000000, 61.519996);
	TextDrawTextSize(CrniTD, 743.000000, 0.000000);
	TextDrawAlignment(CrniTD, 1);
	TextDrawColor(CrniTD, -1);
	TextDrawUseBox(CrniTD, 1);
	//TextDrawBoxColor(CrniTD, 255);
	TextDrawBoxColor(CrniTD, 0x000000FF);
	TextDrawSetShadow(CrniTD, 0);
	TextDrawBackgroundColor(CrniTD, 255);
	TextDrawFont(CrniTD, 1);
	TextDrawSetProportional(CrniTD, 0);
	TextDrawSetSelectable(CrniTD, true);

	TeksticTD = TextDrawCreate(214.400115, 189.004425, "Par meseci kasnije.."); //Ovo je TD za text
	TextDrawLetterSize(TeksticTD, 0.681600, 2.565689);
	TextDrawTextSize(TeksticTD, 536.000000, 0.000000);
	TextDrawAlignment(TeksticTD, 1);
	TextDrawColor(TeksticTD, -1);
	TextDrawSetShadow(TeksticTD, 0);
	TextDrawBackgroundColor(TeksticTD, 255);
	TextDrawFont(TeksticTD, 3);
	TextDrawSetProportional(TeksticTD, 1);
	return 1;
}

public OnPlayerGiveDamageActor(playerid, damaged_actorid, Float:amount, weaponid, bodypart) //Jako bitno!!
{
	if(damaged_actorid == MetaActor) //Ako igrac upuca Metu
	{
		if(UpucaoMetu{playerid}) return 1; //Ovo je jedna provera da ga ne puca 2 puta
		ApplyActorAnimation(MetaActor, "CRACK", "crckdeth2", 4.0, 1, 0, 0, 0, 0 );
		ApplyActorAnimation(MetaActor, "CRACK", "crckdeth2", 4.0, 1, 0, 0, 0, 0 );
		ApplyActorAnimation(MetaActor, "CRACK", "crckdeth2", 4.0, 1, 0, 0, 0, 0 );
		ApplyActorAnimation(MetaActor, "CRACK", "crckdeth2", 4.0, 1, 0, 0, 0, 0 );
		OcistiChatIgracu(playerid);
		UpucaoMetu{playerid} = true;
		SetPlayerCheckpoint(playerid, -1590.4241,-2490.7925,92.7669, 2.0);
		TutorialMessage(playerid, "OverLord: Bravo-Six meta je upucana, idem po dokumenta!");
		TutorialCP{playerid} = 1;
		return 1;
	}
	return 1;
}

//========================================== [ TIMERI ] =========================================//

timer OverLordPricaTimer[5000](playerid) 
{
	switch(OverLordTimer{playerid})
	{
		case 5:
		{
			TutorialMessage(playerid, "OverLord: Bravo-Six ovde OverLord, prijem!");
			OverLordTimer{playerid}--;
			defer OverLordPricaTimer(playerid);
			return 1;
		}
		case 4:
		{
			TutorialMessage(playerid, "OverLord: Imam metu na vidiku, prijem!");
			OverLordTimer{playerid}--;
			TogglePlayerControllable(playerid, 0);
			defer OverLordPricaTimer(playerid);
			return 1;
		}
		case 3:
		{
			TutorialMessage(playerid, "OverLord: Trazim dozvolu za pucanje, prijem!");
			OverLordTimer{playerid}--;
			defer OverLordPricaTimer(playerid);
			return 1;
		}
		case 2:
		{
			TutorialMessage(playerid, "Bravo-Six: OverLord ovde Bravo-Six, prijem!");
			OverLordTimer{playerid}--;
			defer OverLordPricaTimer(playerid);
			return 1;
		}
		case 1:
		{
			TutorialMessage(playerid, "Bravo-Six: Odobravamo pucanje! Ne zaboravi da pokupis dokumenta, prijem!");
			OverLordTimer{playerid}--;
			defer OverLordPricaTimer(playerid);
			return 1;
		}
		case 0:
		{
			TogglePlayerControllable(playerid, 1);
			TutorialMessage(playerid, "Dobio si dozvolu za pucanje, upucaj metu!");
			SetCameraBehindPlayer(playerid);
			return 1;
		}
	}
	return 1;
}

timer KadaJePaoTimer[5000](playerid)
{
	switch(KadaJePao{playerid})
	{
		case 4:
		{
			TutorialMessage(playerid, "OverLord: Bravo-Six...");
			//TextDrawShowForPlayer(playerid, CrniTD);
			//TextDrawBoxColor(CrniTD, 0xFFFFFF15);
			KadaJePao{playerid}--;
			defer KadaJePaoTimer(playerid);
			return 1;
		}
		case 3:
		{
			TutorialMessage(playerid, "OverLord: Zaseda..");
			//TextDrawBoxColor(CrniTD, 0xFFFFFF30);
			KadaJePao{playerid}--;
			defer KadaJePaoTimer(playerid);
			return 1;
		}
		case 2:
		{
			TutorialMessage(playerid, "Bravo-Six: OverLorde ovde Bravo-Six, ponovi, prijem!");
			//TextDrawBoxColor(CrniTD, 0xFFFFFF70);
			KadaJePao{playerid}--;
			defer KadaJePaoTimer(playerid);
			return 1;
		}
		case 1:
		{
			TutorialMessage(playerid, "Bravo-Six: SVE RASPOLOZIVE JEDINICE NEKA KRENU I IZVUKU DOKUMENTA!");
			//TextDrawBoxColor(CrniTD, 0xFFFFFFFF);
			KadaJePao{playerid}--;
			defer KadaJePaoTimer(playerid);
			return 1;
		}
		case 0:
		{
			TextDrawShowForPlayer(playerid, CrniTD);
			TextDrawShowForPlayer(playerid, TeksticTD);
			OcistiChatIgracu(playerid);
			TextDrawSetString(TeksticTD, "Nakon par dana..");
			defer IdeUBolnicuTimer(playerid);
			return 1;
		}
	}
	return 1;
}

timer DoktorPricaTimer[5000](playerid)
{
	switch(DoktorVarijabla{playerid})
	{
		case 6:
		{
			TutorialMessage(playerid, "Doktor: Znaci napokon si se probudio? Kako se osecas?");
			DoktorVarijabla{playerid}--;
			defer DoktorPricaTimer(playerid);
			return 1;
		}
		case 5:
		{
			TutorialMessage(playerid, "Igrac: Gde sam ja? Sta se desilo?");
			DoktorVarijabla{playerid}--;
			defer DoktorPricaTimer(playerid);
			return 1;
		}
		case 4:
		{
			TutorialMessage(playerid, "Doktor: Ne secas se nicega? Bio si na misiji..");
			DoktorVarijabla{playerid}--;
			defer DoktorPricaTimer(playerid);
			return 1;
		}
		case 3:
		{
			TutorialMessage(playerid, "Doktor: Jedva su ti izvukli zivu glavu i sada si u bolnici!");
			DoktorVarijabla{playerid}--;
			defer DoktorPricaTimer(playerid);
			return 1;
		}
		case 2:
		{
			TutorialMessage(playerid, "Igrac: Moram da se vratim na duznost! Sigurno cekaju da im dam informacija!");
			DoktorVarijabla{playerid}--;
			defer DoktorPricaTimer(playerid);
			return 1;
		}
		case 1:
		{
			TutorialMessage(playerid, "Doktor: Karijera za tebe je gotova vojnice! Hvala ti za tvoje sluzenje drzavi!");
			DoktorVarijabla{playerid}--;
			defer DoktorPricaTimer(playerid);
			return 1;
		}
		case 0:
		{
			TextDrawShowForPlayer(playerid, CrniTD);
			TextDrawShowForPlayer(playerid, TeksticTD);
			OcistiChatIgracu(playerid);
			TextDrawSetString(TeksticTD, "Nakon par dana..");
			defer MiniTimer2(playerid);
			defer AvionCameraTimer(playerid);
			return 1;
		}
	}
	return 1;
}

timer AvionCameraTimer[4000](playerid)
{
	TextDrawHideForPlayer(playerid, CrniTD);
	TextDrawHideForPlayer(playerid, TeksticTD);
	TutorialMessage(playerid, "Posle toliko vremena se vracam kuci..");
	return 1;
}

timer MiniTimer2[1000](playerid)
{
	OcistiChatIgracu(playerid);
	AvionObjekat = CreateObject(1683, 1271.54041, -2504.38257, 75.75632, 0.00000, 0.00000, 0.00000);
	MoveObject(AvionObjekat, 1434.30933, -2492.58838, 46.92192, 15.0, 0.00000, 0.00000, 0.00000);
	InterpolateCameraPos(playerid, 1219.551879, -2566.706054, 105.591659, 1383.610229, -2540.452392, 80.651908, 15000);
	InterpolateCameraLookAt(playerid, 1222.711181, -2563.105224, 104.158905, 1387.464477, -2537.912597, 78.730026, 15000);
	defer KrajInterpolacija(playerid);
}

timer KrajInterpolacija[8000](playerid)
{
	DestroyObject(AvionObjekat);
	UTutorialu{playerid} = false;
	SpawnPlayer(playerid);
	return 1;
}

timer IdeUBolnicuTimer[7000](playerid)
{
	SetPlayerPos(playerid, -17.1350,149.5108,999.7769);
	SetPlayerFacingAngle(playerid, 264.1465);
	SetPlayerCameraPos(playerid, -12.819087, 147.464614, 1001.360839);
	SetPlayerCameraLookAt(playerid, -17.118209, 149.420379, 999.719970, CAMERA_CUT);
	ApplyAnimation(playerid, "BEACH", "bather", 4.0, 1, 0, 0, 0, 0);
	defer MiniTimer(playerid);
	return 1;
}

timer TraziDokumenta[5000](playerid)
{
	ClearAnimations(playerid);
	TogglePlayerControllable(playerid, 1);
	TutorialMessage(playerid, "OverLord: Bravo-Six nasao sam dokumenta! Vracam se nazad!");
	SetPlayerCheckpoint(playerid, -1600.1713,-2461.2832,90.6270, 2.0);
	TutorialCP{playerid} = 2;
	return 1;
}

timer MiniTimer[2000](playerid)
{
	TextDrawHideForPlayer(playerid, CrniTD);
	TextDrawHideForPlayer(playerid, TeksticTD);
	DoktorVarijabla{playerid} = 6;
	defer DoktorPricaTimer(playerid);
}

//================================================ [ FUNCKIJE ] ======================================//

Tutorial(playerid) // Ovo je funckija za tutorial, da mu se podesi spawn info i da ga spawnuje
{
	SetSpawnInfo(playerid, 0, 287, -1651.7321,-2423.4563,98.3168,231.6063, 0, 0, 0, 0, 0, 0);
	SpawnPlayer(playerid);
}

MapicaBolnicaInterijer()
{
	CreateDynamicObject(14593, -13.63000, 148.85001, 1000.38000,   0.00000, 0.00000, -90.00000);
	CreateDynamicObject(14532, -17.94000, 150.61900, 999.03900,   0.00000, 0.00000, -90.00000);
	CreateDynamicObject(14532, -17.90900, 148.52000, 999.03900,   0.00000, 0.00000, -90.00000);
	CreateDynamicObject(14532, -17.96900, 146.49001, 999.03900,   0.00000, 0.00000, -90.00000);
	CreateDynamicObject(14532, -17.98900, 144.42900, 999.03900,   0.00000, 0.00000, -90.00000);
	CreateDynamicObject(14532, -7.05000, 151.38901, 999.03900,   0.00000, 0.00000, -33.00000);
	CreateDynamicObject(2146, -3.65000, 149.27000, 998.54901,   0.00000, 0.00000, 177.36000);
	CreateDynamicObject(2146, -4.86000, 148.55901, 998.54901,   0.00000, 0.00000, 188.75900);
	CreateDynamicObject(14532, -13.85900, 154.88901, 999.03900,   0.00000, 0.00000, -180.00000);
	CreateDynamicObject(14532, -12.02000, 154.88901, 999.03900,   0.00000, 0.00000, -180.00000);
	CreateDynamicObject(3578, -15.14000, 142.00900, 997.28003,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(3578, -10.23900, 147.41000, 997.28003,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(18001, -27.00000, 7680.00000, 151.00000,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19325, -27.00000, 2976.00000, 158.00000,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(2002, -28.00000, 8249.00000, 137.00000,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1997, -17.43000, 145.47900, 998.03900,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(1997, -17.35000, 147.52000, 998.03900,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(1997, -17.40900, 149.52901, 998.03900,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(1997, -17.42000, 151.64900, 998.03900,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(14693, -16.26000, 151.69000, 998.47900,   0.00000, 0.00000, 17.76000);
	CreateDynamicObject(14693, -16.25000, 149.50000, 998.47900,   0.00000, 0.00000, 17.76000);
	CreateDynamicObject(14693, -16.19000, 147.50900, 998.47900,   0.00000, 0.00000, 17.76000);
	CreateDynamicObject(14693, -16.25000, 145.44000, 998.47900,   0.00000, 0.00000, 17.76000);
	CreateDynamicObject(18084, -17.09000, 142.85001, 999.73901,   0.00000, 0.00000, 180.00000);
	CreateDynamicObject(18084, -17.09000, 142.85001, 997.30902,   0.00000, 0.00000, 180.00000);
	CreateDynamicObject(18084, -14.47900, 142.85001, 999.73901,   0.00000, 0.00000, 180.00000);
	CreateDynamicObject(18084, -14.47900, 142.85001, 997.29901,   0.00000, 0.00000, 180.00000);
	CreateDynamicObject(18084, -12.77000, 142.86000, 997.29901,   0.00000, 0.00000, 180.00000);
	CreateDynamicObject(18084, -12.77000, 142.85001, 999.73901,   0.00000, 0.00000, 180.00000);
	CreateDynamicObject(18084, -7.69000, 142.86000, 997.29901,   0.00000, 0.00000, 180.00000);
	CreateDynamicObject(18084, -7.69000, 142.88000, 999.73901,   0.00000, 0.00000, 180.00000);
	CreateDynamicObject(18084, -5.07900, 142.86000, 997.29901,   0.00000, 0.00000, 180.00000);
	CreateDynamicObject(18084, -5.07900, 142.86900, 999.73901,   0.00000, 0.00000, 180.00000);
	CreateDynamicObject(18084, -4.19000, 142.86900, 997.29901,   0.00000, 0.00000, 180.00000);
	CreateDynamicObject(18084, -4.11000, 142.88000, 999.73901,   0.00000, 0.00000, 180.00000);
	CreateDynamicObject(18084, -1.95000, 147.64900, 999.73901,   0.00000, 0.00000, 270.00000);
	CreateDynamicObject(18084, -1.96000, 147.63901, 997.29901,   0.00000, 0.00000, 270.00000);
	CreateDynamicObject(18084, -1.95000, 150.22900, 999.73901,   0.00000, 0.00000, 270.00000);
	CreateDynamicObject(18084, -1.96000, 150.22900, 997.29901,   0.00000, 0.00000, 270.00000);
	CreateDynamicObject(18084, -1.96000, 152.83900, 999.73901,   0.00000, 0.00000, 270.00000);
	CreateDynamicObject(18084, -1.96000, 152.83900, 997.29901,   0.00000, 0.00000, 270.00000);
	CreateDynamicObject(18084, -1.97000, 154.11000, 997.29901,   0.00000, 0.00000, 270.00000);
	CreateDynamicObject(18084, -1.96000, 154.13000, 999.73901,   0.00000, 0.00000, 270.00000);
	CreateDynamicObject(18084, -4.28000, 156.30901, 999.73901,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(18084, -4.28900, 156.32001, 997.29901,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(18084, -6.88000, 156.30901, 999.73901,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(18084, -7.80000, 156.30901, 999.73901,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(18084, -6.88000, 156.32001, 997.29901,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(18084, -7.73900, 156.32001, 997.29901,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(18084, -13.02000, 156.32001, 997.29901,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(18084, -13.00000, 156.32001, 999.73901,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(18084, -15.60000, 156.30901, 997.29901,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(18084, -15.60000, 156.33000, 999.73901,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(18084, -17.12900, 156.32001, 999.73901,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(18084, -17.20900, 156.30901, 997.29901,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(18084, -19.42000, 151.25000, 999.73901,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(18084, -19.42000, 148.66901, 999.73901,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(18084, -19.42000, 146.08900, 999.73901,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(18084, -19.40900, 145.00900, 999.73901,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(18084, -19.43000, 151.33000, 997.29901,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(18084, -19.44000, 148.74001, 997.29901,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(18084, -19.43000, 146.16000, 997.29901,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(18084, -19.43000, 145.05901, 997.29901,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(3383, -5.96000, 153.47900, 997.86902,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(3394, -3.58900, 153.41901, 998.04901,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(2690, -10.30000, 139.94000, 999.40900,   0.00000, 0.00000, 180.00000);
	CreateDynamicObject(1997, -12.89000, 154.32001, 998.03900,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1997, -14.72900, 154.33900, 998.03900,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1502, -21.21900, 142.91000, 998.04901,   0.00000, 0.00000, -90.00000);
}

OcistiChatIgracu(playerid) //Ciscenje chata
{
    for(new i; i < 100 ; i++)
    {
        SendClientMessage(playerid, -1, " ");
    }
}
#endif