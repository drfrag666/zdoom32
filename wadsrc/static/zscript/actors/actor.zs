struct FCheckPosition
{
	// in
	native Actor		thing;
	native Vector3		pos;

	// out
	native Sector		cursector;
	native double		floorz;
	native double		ceilingz;
	native double		dropoffz;
	native TextureID	floorpic;
	native int			floorterrain;
	native Sector		floorsector;
	native TextureID	ceilingpic;
	native Sector		ceilingsector;
	native bool			touchmidtex;
	native bool			abovemidtex;
	native bool			floatok;
	native bool			FromPMove;
	native line			ceilingline;
	native Actor		stepthing;
	native bool			DoRipping;
	native bool			portalstep;
	native int			portalgroup;

	native int			PushTime;
	
	native void ClearLastRipped();
}

struct LinkContext
{
	voidptr sector_list;	// really msecnode but that's not exported yet.
	voidptr render_list;
}


class Actor : Thinker native
{
	const DEFAULT_HEALTH = 1000;
	const ONFLOORZ = -2147483648.0;
	const ONCEILINGZ = 2147483647.0;
	const FLOATRANDZ = ONCEILINGZ-1;
	const TELEFRAG_DAMAGE = 1000000;
	const MinVel = 1./65536;
	const LARGE_MASS = 10000000;	// not INT_MAX on purpose


	// flags are not defined here, the native fields for those get synthesized from the internal tables.
	
	// for some comments on these fields, see their native representations in actor.h.
	native readonly Actor snext;	// next in sector list.
	native PlayerInfo Player;
	native readonly vector3 Pos;
	native vector3 Prev;
	native double spriteAngle;
	native double spriteRotation;
	native double VisibleStartAngle;
	native double VisibleStartPitch;
	native double VisibleEndAngle;
	native double VisibleEndPitch;
	native double Angle;
	native double Pitch;
	native double Roll;
	native vector3 Vel;
	native double Speed;
	native double FloatSpeed;
	native SpriteID sprite;
	native uint8 frame;
	native vector2 Scale;
	native TextureID picnum;
	native double Alpha;
	native readonly color fillcolor;	// must be set with SetShade to initialize correctly.
	native Sector CurSector;
	native double CeilingZ;
	native double FloorZ;
	native double DropoffZ;
	native Sector floorsector;
	native TextureID floorpic;
	native int floorterrain;
	native Sector ceilingsector;
	native TextureID ceilingpic;
	native double Height;
	native readonly double Radius;
    native readonly double RenderRadius;
	native double projectilepassheight;
	native int tics;
	native readonly State CurState;
	native readonly int Damage;
	native int projectilekickback;
	native int special1;
	native int special2;
	native double specialf1;
	native double specialf2;
	native int weaponspecial;
	native int Health;
	native uint8 movedir;
	native int8 visdir;
	native int16 movecount;
	native int16 strafecount;
	native Actor Target;
	native Actor Master;
	native Actor Tracer;
	native Actor LastHeard;
	native Actor LastEnemy;
	native Actor LastLookActor;
	native int ReactionTime;
	native int Threshold;
	native readonly int DefThreshold;
	native vector3 SpawnPoint;
	native uint16 SpawnAngle;
	native int StartHealth;
	native uint8 WeaveIndexXY;
	native uint8 WeaveIndexZ;
	native int skillrespawncount;
	native int Args[5];
	native int Mass;
	native int Special;
	native readonly int TID;
	native readonly int TIDtoHate;
	native readonly int WaterLevel;
	native int Score;
	native int Accuracy;
	native int Stamina;
	native double MeleeRange;
	native int PainThreshold;
	native double Gravity;
	native double FloorClip;
	native name DamageType;
	native name DamageTypeReceived;
	native uint8 FloatBobPhase;
	native int RipperLevel;
	native int RipLevelMin;
	native int RipLevelMax;
	native name Species;
	native Actor Alternative;
	native Actor goal;
	native uint8 MinMissileChance;
	native int8 LastLookPlayerNumber;
	native uint SpawnFlags;
	native double meleethreshold;
	native double maxtargetrange;
	native double bouncefactor;
	native double wallbouncefactor;
	native int bouncecount;
	native double friction;
	native int FastChaseStrafeCount;
	native double pushfactor;
	native int lastpush;
	native int activationtype;
	native int lastbump;
	native int DesignatedTeam;
	native Actor BlockingMobj;
	native Line BlockingLine;
	native int PoisonDamage;
	native name PoisonDamageType;
	native int PoisonDuration;
	native int PoisonPeriod;
	native int PoisonDamageReceived;
	native name PoisonDamageTypeReceived;
	native int PoisonDurationReceived;
	native int PoisonPeriodReceived;
	native Actor Poisoner;
	native Inventory Inv;
	native uint8 smokecounter;
	native uint8 FriendPlayer;
	native uint Translation;
	native sound AttackSound;
	native sound DeathSound;
	native sound SeeSound;
	native sound PainSound;
	native sound ActiveSound;
	native sound UseSound;
	native sound BounceSound;
	native sound WallBounceSound;
	native sound CrushPainSound;
	native double MaxDropoffHeight;
	native double MaxStepHeight;
	native int16 PainChance;
	native name PainType;
	native name DeathType;
	native double DamageFactor;
	native double DamageMultiply;
	native Class<Actor> TelefogSourceType;
	native Class<Actor> TelefogDestType;
	native readonly State SpawnState;
	native readonly State SeeState;
	native State MeleeState;
	native State MissileState;
	native voidptr /*DecalBase*/ DecalGenerator;
	native uint8 fountaincolor;
	native double CameraHeight;	// Height of camera when used as such
	native double RadiusDamageFactor;		// Radius damage factor
	native double SelfDamageFactor;
	native double StealthAlpha;
	native int WoundHealth;		// Health needed to enter wound state
	native readonly color BloodColor;
	native readonly int BloodTranslation;

	meta String Obituary;		// Player was killed by this actor
	meta String HitObituary;		// Player was killed by this actor in melee
	meta double DeathHeight;	// Height on normal death
	meta double BurnHeight;		// Height on burning death
	meta int GibHealth;			// Negative health below which this monster dies an extreme death
	meta Sound HowlSound;		// Sound being played when electrocuted or poisoned
	meta Name BloodType;		// Blood replacement type
	meta Name BloodType2;		// Bloopsplatter replacement type
	meta Name BloodType3;		// AxeBlood replacement type
	meta bool DontHurtShooter;
	meta int ExplosionRadius;
	meta int ExplosionDamage;
	meta int MeleeDamage;
	meta Sound MeleeSound;
	meta double MissileHeight;
	meta Name MissileName;
	meta double FastSpeed;		// speed in fast mode

	Property prefix: none;
	Property Obituary: Obituary;
	Property HitObituary: HitObituary;
	Property MeleeDamage: MeleeDamage;
	Property MeleeSound: MeleeSound;
	Property MissileHeight: MissileHeight;
	Property MissileType: MissileName;
	Property DontHurtShooter: DontHurtShooter;
	Property ExplosionRadius: ExplosionRadius;
	Property ExplosionDamage: ExplosionDamage;
	//Property BloodType: BloodType, BloodType2, BloodType3;
	Property FastSpeed: FastSpeed;
	Property HowlSound: HowlSound;
	Property GibHealth: GibHealth;
	Property DeathHeight: DeathHeight;
	Property BurnHeight: BurnHeight;
	
	// need some definition work first
	//FRenderStyle RenderStyle;
	//int ConversationRoot; // THe root of the current dialogue

	// deprecated things.
	native readonly deprecated("2.3") double X;
	native readonly deprecated("2.3") double Y;
	native readonly deprecated("2.3") double Z;
	native readonly deprecated("2.3") double VelX;
	native readonly deprecated("2.3") double VelY;
	native readonly deprecated("2.3") double VelZ;
	native readonly deprecated("2.3") double MomX;
	native readonly deprecated("2.3") double MomY;
	native readonly deprecated("2.3") double MomZ;
	native deprecated("2.3") double ScaleX;
	native deprecated("2.3") double ScaleY;

	//FStrifeDialogueNode *Conversation; // [RH] The dialogue to show when this actor is used.;
	
	
	Default
	{
		Scale 1;
		Health DEFAULT_HEALTH;
		Reactiontime 8;
		Radius 20;
		RenderRadius 0;
		Height 16;
		Mass 100;
		RenderStyle 'Normal';
		Alpha 1;
		MinMissileChance 200;
		MeleeRange 64 - 20;
		MaxDropoffHeight 24;
		MaxStepHeight 24;
		BounceFactor 0.7;
		WallBounceFactor 0.75;
		BounceCount -1;
		FloatSpeed 4;
		FloatBobPhase -1;	// randomly initialize by default
		Gravity 1;
		Friction 1;
		DamageFactor 1.0;		// damage multiplier as target of damage.
		DamageMultiply 1.0;		// damage multiplier as source of damage.
		PushFactor 0.25;
		WeaveIndexXY 0;
		WeaveIndexZ 16;
		DesignatedTeam 255;
		PainType "Normal";
		DeathType "Normal";
		TeleFogSourceType "TeleportFog";
		TeleFogDestType 'TeleportFog';
		RipperLevel 0;
		RipLevelMin 0;
		RipLevelMax 0;
		DefThreshold 100;
		BloodType "Blood", "BloodSplatter", "AxeBlood";
		ExplosionDamage 128;
		ExplosionRadius -1;	// i.e. use ExplosionDamage value
		MissileHeight 32;
		SpriteAngle 0;
		SpriteRotation 0;
		StencilColor "00 00 00";
		VisibleAngles 0, 0;
		VisiblePitch 0, 0;
		DefaultStateUsage SUF_ACTOR|SUF_OVERLAY;
		CameraHeight int.min;
		FastSpeed -1;
		RadiusDamageFactor 1;
		SelfDamageFactor 1;
		StealthAlpha 0;
		WoundHealth 6;
		GibHealth int.min;
		DeathHeight -1;
		BurnHeight -1;
	}
	
	// Functions

	// 'parked' global functions.
	native static double deltaangle(double ang1, double ang2);
	native static double absangle(double ang1, double ang2);
	native static Vector2 AngleToVector(double angle, double length = 1);
	native static Vector2 RotateVector(Vector2 vec, double angle);
	native static double Normalize180(double ang);
	

	bool IsPointerEqual(int ptr_select1, int ptr_select2)
	{
		return GetPointer(ptr_select1) == GetPointer(ptr_select2);
	}
	
	static double BobSin(double fb)
	{
		return sin(fb * (180./32)) * 8;
	}

	virtual native void BeginPlay();
	virtual native void Activate(Actor activator);
	virtual native void Deactivate(Actor activator);
	virtual native int DoSpecialDamage (Actor target, int damage, Name damagetype);
	virtual native int TakeSpecialDamage (Actor inflictor, Actor source, int damage, Name damagetype);
	virtual native void Die(Actor source, Actor inflictor, int dmgflags = 0);
	virtual native bool Slam(Actor victim);
	virtual native void Touch(Actor toucher);
	virtual native void MarkPrecacheSounds();

	// Called by PIT_CheckThing to check if two actors actually can collide.
	virtual bool CanCollideWith(Actor other, bool passive)
	{
		return true;
	}

	// Called when an actor is to be reflected by a disc of repulsion.
	// Returns true to continue normal blast processing.
	virtual bool SpecialBlastHandling (Actor source, double strength)
	{
		return true;
	}

	// This is called before a missile gets exploded.
	virtual int SpecialMissileHit (Actor victim)
	{
		return -1;
	}

	// Called when the player presses 'use' and an actor is found
	virtual bool Used(Actor user)
	{
		return false;
	}
	
	virtual class<Actor> GetBloodType(int type)
	{
		Class<Actor> bloodcls;
		if (type == 0)
		{
			bloodcls = BloodType;
		}
		else if (type == 1)
		{
			bloodcls = BloodType2;
		}
		else if (type == 2)
		{
			bloodcls = BloodType3;
		}
		else
		{
			return NULL;
		}

		if (bloodcls != NULL)
		{
			bloodcls = GetReplacement(bloodcls);
		}
		return bloodcls;
	}
	
	virtual int GetGibHealth()
	{
		if (GibHealth != int.min)
		{
			return -abs(GibHealth);
		}
		else
		{
			return -int(GetSpawnHealth() * gameinfo.gibfactor);
		}
	}
	
	virtual double GetDeathHeight()
	{
		// [RH] Allow the death height to be overridden using metadata.
		double metaheight = -1;
		if (DamageType == 'Fire')
		{
			metaheight = BurnHeight;
		}
		if (metaheight < 0)
		{
			metaheight = DeathHeight;
		}
		if (metaheight < 0)
		{
			return Height * 0.25;
		}
		else
		{
			return MAX(metaheight, 0);
		}
	}
	
	virtual String GetObituary(Actor victim, Actor inflictor, Name mod, bool playerattack)
	{
		if (mod == 'Telefrag')
		{
			return "$OB_MONTELEFRAG";
		}
		else if (mod == 'Melee' && HitObituary.Length() > 0)
		{
			return HitObituary;
		}
		return Obituary;
	}
	

	native static class<Actor> GetReplacement(class<Actor> cls);
	native static class<Actor> GetReplacee(class<Actor> cls);
	native static int GetSpriteIndex(name sprt);
	native static double GetDefaultSpeed(class<Actor> type);
	native static class<Actor> GetSpawnableType(int spawnnum);
	native static int ApplyDamageFactors(class<Inventory> itemcls, Name damagetype, int damage, int defdamage);
	native void RemoveFromHash();
	native void ChangeTid(int newtid);
	native static int FindUniqueTid(int start = 0, int limit = 0);
	native void SetShade(color col);
	native clearscope int GetRenderStyle() const;
		
	native clearscope string GetTag(string defstr = "") const;
	native void SetTag(string defstr = "");
	native double GetBobOffset(double frac = 0);
	native void ClearCounters();
	native bool GiveBody (int num, int max=0);
	native bool HitFloor();
	native clearscope bool isTeammate(Actor other) const;
	native int PlayerNumber();
	native void SetFriendPlayer(PlayerInfo player);
	native void SoundAlert(Actor target, bool splash = false, double maxdist = 0);
	native void DaggerAlert(Actor target);
	native void ClearBounce();
	native TerrainDef GetFloorTerrain();
	native bool CheckLocalView(int consoleplayer);
	native bool CheckNoDelay();
	native bool UpdateWaterLevel (bool splash = true);
	native bool IsZeroDamage();
	native void ClearInterpolation();
	native clearscope Vector3 PosRelative(sector sec) const;
		
	native void HandleSpawnFlags();
	native void ExplodeMissile(line lin = null, Actor target = null, bool onsky = false);
	native void RestoreDamage();
	native clearscope int SpawnHealth() const;
	native void SetDamage(int dmg);
	native clearscope double Distance2D(Actor other) const;
	native clearscope double Distance3D(Actor other) const;
	native void SetOrigin(vector3 newpos, bool moving);
	native void SetXYZ(vector3 newpos);
	native Actor GetPointer(int aaptr);
	native double BulletSlope(out FTranslatedLineTarget pLineTarget = null, int aimflags = 0);
	
	native bool CheckMissileSpawn(double maxdist);
	native bool CheckPosition(Vector2 pos, bool actorsonly = false, FCheckPosition tm = null);
	native bool TestMobjLocation();
	native static Actor Spawn(class<Actor> type, vector3 pos = (0,0,0), int replace = NO_REPLACE);
	native Actor SpawnMissile(Actor dest, class<Actor> type, Actor owner = null);
	native Actor SpawnMissileXYZ(Vector3 pos, Actor dest, Class<Actor> type, bool checkspawn = true, Actor owner = null);
	native Actor SpawnMissileZ (double z, Actor dest, class<Actor> type);
	native Actor SpawnMissileAngleZSpeed (double z, class<Actor> type, double angle, double vz, double speed, Actor owner = null, bool checkspawn = true);
	native Actor SpawnMissileZAimed (double z, Actor dest, Class<Actor> type);
	native Actor SpawnSubMissile(Class<Actor> type, Actor target);
	native Actor, Actor SpawnPlayerMissile(class<Actor> type, double angle = 0, double x = 0, double y = 0, double z = 0, out FTranslatedLineTarget pLineTarget = null, bool nofreeaim = false, bool noautoaim = false, int aimflags = 0);
	native void SpawnTeleportFog(Vector3 pos, bool beforeTele, bool setTarget);
	native Actor RoughMonsterSearch(int distance, bool onlyseekable = false, bool frontonly = false);
	native int ApplyDamageFactor(Name damagetype, int damage);
	native int GetModifiedDamage(Name damagetype, int damage, bool passive);
	native bool CheckBossDeath();

	void A_Light(int extralight) { if (player) player.extralight = clamp(extralight, -20, 20); }
	void A_Light0() { if (player) player.extralight = 0; }
	void A_Light1() { if (player) player.extralight = 1; }
	void A_Light2() { if (player) player.extralight = 2; }
	void A_LightInverse() { if (player) player.extralight = 0x80000000; }
	
	native Actor OldSpawnMissile(Actor dest, class<Actor> type, Actor owner = null);
	native Actor SpawnPuff(class<Actor> pufftype, vector3 pos, double hitdir, double particledir, int updown, int flags = 0, Actor victim = null);
	native void SpawnBlood (Vector3 pos1, double dir, int damage);
	native void BloodSplatter (Vector3 pos, double hitangle, bool axe = false);
	native bool HitWater (sector sec, Vector3 pos, bool checkabove = false, bool alert = true, bool force = false);
	native void PlaySpawnSound(Actor missile);
	native clearscope bool CountsAsKill() const;
	
	native bool Teleport(Vector3 pos, double angle, int flags);
	native void TraceBleed(int damage, Actor missile);
	native void TraceBleedAngle(int damage, double angle, double pitch);

	native void SetIdle(bool nofunction = false);
	native bool CheckMeleeRange();
	native bool CheckMeleeRange2();
	native virtual int DamageMobj(Actor inflictor, Actor source, int damage, Name mod, int flags = 0, double angle = 0);
	native void PoisonMobj (Actor inflictor, Actor source, int damage, int duration, int period, Name type);
	native double AimLineAttack(double angle, double distance, out FTranslatedLineTarget pLineTarget = null, double vrange = 0., int flags = 0, Actor target = null, Actor friender = null);
	native Actor, int LineAttack(double angle, double distance, double pitch, int damage, Name damageType, class<Actor> pufftype, int flags = 0, out FTranslatedLineTarget victim = null);
	native bool CheckSight(Actor target, int flags = 0);
	native bool IsVisible(Actor other, bool allaround, LookExParams params = null);
	native bool HitFriend();
	native bool MonsterMove();
	
	native SeqNode StartSoundSequenceID (int sequence, int type, int modenum, bool nostop = false);
	native SeqNode StartSoundSequence (Name seqname, int modenum);
	native void StopSoundSequence();

	native void FindFloorCeiling(int flags = 0);
	native double, double GetFriction();
	native bool, Actor TestMobjZ(bool quick = false);
	native bool InStateSequence(State newstate, State basestate);
	
	bool TryWalk ()
	{
		if (!MonsterMove ())
		{
			return false;
		}
		movecount = random[TryWalk](0, 15);
		return true;
	}
	
	native bool TryMove(vector2 newpos, int dropoff, bool missilecheck = false, FCheckPosition tm = null);
	native void NewChaseDir();
	native void RandomChaseDir();
	native bool CheckMissileRange();
	native bool SetState(state st, bool nofunction = false);
	native state FindState(statelabel st, bool exact = false);
	bool SetStateLabel(statelabel st, bool nofunction = false) { return SetState(FindState(st), nofunction); }
	native action state ResolveState(statelabel st);	// this one, unlike FindState, is context aware.
	native void LinkToWorld(LinkContext ctx = null);
	native void UnlinkFromWorld(out LinkContext ctx = null);
	native bool CanSeek(Actor target);
	native clearscope double AngleTo(Actor target, bool absolute = false) const;
	native void AddZ(double zadd, bool moving = true);
	native void SetZ(double z);
	native clearscope vector2 Vec2To(Actor other) const;
	native clearscope vector3 Vec3To(Actor other) const;
	native clearscope vector3 Vec3Offset(double x, double y, double z, bool absolute = false) const;
	native clearscope vector3 Vec3Angle(double length, double angle, double z = 0, bool absolute = false) const;
	native clearscope vector2 Vec2Angle(double length, double angle, bool absolute = false) const;
	native clearscope vector2 Vec2Offset(double x, double y, bool absolute = false) const;
	native clearscope vector3 Vec2OffsetZ(double x, double y, double atz, bool absolute = false) const;
	native void VelFromAngle(double speed = 0, double angle = 0);
	native void Vel3DFromAngle(double speed, double angle, double pitch);
	native void Thrust(double speed = 0, double angle = 0);
	native clearscope bool isFriend(Actor other) const;
	native clearscope bool isHostile(Actor other) const;
	native void AdjustFloorClip();
	native DropItem GetDropItems();
	native void CopyFriendliness (Actor other, bool changeTarget, bool resetHealth = true);
	native bool LookForMonsters();
	native bool LookForTid(bool allaround, LookExParams params = null);
	native bool LookForEnemies(bool allaround, LookExParams params = null);
	native bool LookForPlayers(bool allaround, LookExParams params = null);
	native bool TeleportMove(Vector3 pos, bool telefrag, bool modifyactor = true);
	native double DistanceBySpeed(Actor other, double speed);
	native name GetSpecies();
	native void PlayActiveSound();
	native void Howl();
	native void DrawSplash (int count, double angle, int kind);
	native void GiveSecret(bool printmsg = true, bool playsound = true);
	native clearscope double GetCameraHeight() const;
	native clearscope double GetGravity() const;

	native bool CheckClass(class<Actor> checkclass, int ptr_select = AAPTR_DEFAULT, bool match_superclass = false);
	native void AddInventory(Inventory inv);
	native void RemoveInventory(Inventory inv);
	native void ClearInventory();
	native bool GiveInventory(class<Inventory> type, int amount, bool givecheat = false);
	native bool TakeInventory(class<Inventory> itemclass, int amount, bool fromdecorate = false, bool notakeinfinite = false);
	native clearscope Inventory FindInventory(class<Inventory> itemtype, bool subclass = false) const;
	native Inventory GiveInventoryType(class<Inventory> itemtype);
	native Inventory DropInventory (Inventory item, int amt = -1);
	native bool UseInventory(Inventory item);
	native void ObtainInventory(Actor other);
	native bool GiveAmmo (Class<Ammo> type, int amount);
	native bool UsePuzzleItem(int PuzzleItemType);
	native float AccuracyFactor();
	native bool MorphMonster (Class<Actor> spawntype, int duration, int style, Class<Actor> enter_flash, Class<Actor> exit_flash);
	action native void SetCamera(Actor cam, bool revert = false);

	// DECORATE compatible functions
	native clearscope int CountInv(class<Inventory> itemtype, int ptr_select = AAPTR_DEFAULT) const;
	native double GetDistance(bool checkz, int ptr = AAPTR_TARGET) const;
	native double GetAngle(int flags, int ptr = AAPTR_TARGET) const;
	native double GetZAt(double px = 0, double py = 0, double angle = 0, int flags = 0, int pick_pointer = AAPTR_DEFAULT);
	native clearscope int GetSpawnHealth() const;
	native double GetCrouchFactor(int ptr = AAPTR_PLAYER1);
	native double GetCVar(string cvar);
	native int GetPlayerInput(int inputnum, int ptr = AAPTR_DEFAULT);
	native int CountProximity(class<Actor> classname, double distance, int flags = 0, int ptr = AAPTR_DEFAULT);
	native double GetSpriteAngle(int ptr = AAPTR_DEFAULT);
	native double GetSpriteRotation(int ptr = AAPTR_DEFAULT);
	native int GetMissileDamage(int mask, int add, int ptr = AAPTR_DEFAULT);
	action native int OverlayID();
	action native double OverlayX(int layer = 0);
	action native double OverlayY(int layer = 0);

	// DECORATE setters - it probably makes more sense to set these values directly now...
	void A_SetMass(int newmass) { mass = newmass; }
	void A_SetInvulnerable() { bInvulnerable = true; }
	void A_UnSetInvulnerable() { bInvulnerable = false; }
	void A_SetReflective() { bReflective = true; }
	void A_UnSetReflective() { bReflective = false; }
	void A_SetReflectiveInvulnerable() { bInvulnerable = true; bReflective = true; }
	void A_UnSetReflectiveInvulnerable() { bInvulnerable = false; bReflective = false; }
	void A_SetShootable() { bShootable = true; bNonShootable = false; }
	void A_UnSetShootable() { bShootable = false; bNonShootable = true; }
	void A_NoGravity() { bNoGravity = true; }
	void A_Gravity() { bNoGravity = false; Gravity = 1; }
	void A_LowGravity() { bNoGravity = false; Gravity = 0.125; }
	void A_SetGravity(double newgravity) { gravity = clamp(newgravity, 0., 10.); }
	void A_SetFloorClip() { bFloorClip = true; AdjustFloorClip(); }
	void A_UnSetFloorClip() { bFloorClip = false;  FloorClip = 0; }
	void A_HideThing() { bInvisible = true; }
	void A_UnHideThing() { bInvisible = false; }
	void A_SetArg(int arg, int val) { if (arg >= 0 && arg < 5) args[arg] = val;	}
	void A_Turn(double turn = 0) { angle += turn; }
	void A_SetDamageType(name newdamagetype) { damagetype = newdamagetype; }
	void A_SetSolid() { bSolid = true; }
	void A_UnsetSolid() { bSolid = false; }
	void A_SetFloat() { bFloat = true; }
	void A_UnsetFloat() { bFloat = false; }
	void A_SetFloatBobPhase(int bob) { if (bob >= 0 && bob <= 63) FloatBobPhase = bob; }
	void A_SetRipperLevel(int level) { RipperLevel = level; }
	void A_SetRipMin(int minimum) { RipLevelMin = minimum; }
	void A_SetRipMax(int maximum) { RipLevelMax = maximum; }
	void A_ScreamAndUnblock() { A_Scream(); A_NoBlocking(); }
	void A_ActiveAndUnblock() { A_ActiveSound(); A_NoBlocking(); }
	
	//---------------------------------------------------------------------------
	//
	// FUNC P_SpawnMissileAngle
	//
	// Returns NULL if the missile exploded immediately, otherwise returns
	// a mobj_t pointer to the missile.
	//
	//---------------------------------------------------------------------------

	Actor SpawnMissileAngle (class<Actor> type, double angle, double vz)
	{
		return SpawnMissileAngleZSpeed (pos.z + 32 + GetBobOffset(), type, angle, vz, GetDefaultSpeed (type));
	}

	Actor SpawnMissileAngleZ (double z, class<Actor> type, double angle, double vz)
	{
		return SpawnMissileAngleZSpeed (z, type, angle, vz, GetDefaultSpeed (type));
	}
	

	void A_SetScale(double scalex, double scaley = 0, int ptr = AAPTR_DEFAULT, bool usezero = false)
	{
		Actor aptr = GetPointer(ptr);
		if (aptr)
		{
			aptr.Scale.X = scalex;
			aptr.Scale.Y = scaley != 0 || usezero? scaley : scalex;	// use scalex here, too, if only one parameter.
		}
	}
	void A_SetSpeed(double speed, int ptr = AAPTR_DEFAULT)
	{
		Actor aptr = GetPointer(ptr);
		if (aptr) aptr.Speed = speed;
	}
	void A_SetFloatSpeed(double speed, int ptr = AAPTR_DEFAULT)
	{
		Actor aptr = GetPointer(ptr);
		if (aptr) aptr.FloatSpeed = speed;
	}
	void A_SetPainThreshold(int threshold, int ptr = AAPTR_DEFAULT)
	{
		Actor aptr = GetPointer(ptr);
		if (aptr) aptr.PainThreshold = threshold;
	}
	bool A_SetSpriteAngle(double angle = 0, int ptr = AAPTR_DEFAULT)
	{
		Actor aptr = GetPointer(ptr);
		if (!aptr) return false;
		aptr.SpriteAngle = angle;
		return true;
	}
	bool A_SetSpriteRotation(double angle = 0, int ptr = AAPTR_DEFAULT)
	{
		Actor aptr = GetPointer(ptr);
		if (!aptr) return false;
		aptr.SpriteRotation = angle;
		return true;
	}

	deprecated("2.3") void A_FaceConsolePlayer(double MaxTurnAngle = 0) {}

	void A_SetSpecial(int spec, int arg0 = 0, int arg1 = 0, int arg2 = 0, int arg3 = 0, int arg4 = 0)
	{
		special = spec;
		args[0] = arg0;
		args[1] = arg1;
		args[2] = arg2;
		args[3] = arg3;
		args[4] = arg4;
	}

	void A_ClearTarget()
	{
		target = null;
		lastheard = null;
		lastenemy = null;
	}

	void A_ChangeLinkFlags(int blockmap = FLAG_NO_CHANGE, int sector = FLAG_NO_CHANGE)
	{	
		UnlinkFromWorld();
		if (blockmap != FLAG_NO_CHANGE) bNoBlockmap = blockmap;
		if (sector != FLAG_NO_CHANGE) bNoSector = sector;
		LinkToWorld();
	}

	// killough 11/98: kill an object
	void A_Die(name damagetype = "none")
	{
		DamageMobj(null, null, health, damagetype, DMG_FORCED);
	}

	void SpawnDirt (double radius)
	{
		static const class<Actor> chunks[] = { "Dirt1", "Dirt2", "Dirt3", "Dirt4", "Dirt5", "Dirt6" };
		double zo = random[Dirt]() / 128. + 1;
		Vector3 pos = Vec3Angle(radius, random[Dirt]() * (360./256), zo);

		Actor mo = Spawn (chunks[random[Dirt](0, 5)], pos, ALLOW_REPLACE);
		if (mo)
		{
			mo.Vel.Z = random[Dirt]() / 64.;
		}
	}
	
	//
	// A_SinkMobj
	// Sink a mobj incrementally into the floor
	//

	bool SinkMobj (double speed)
	{
		if (Floorclip < Height)
		{
			Floorclip += speed;
			return false;
		}
		return true;
	}

	//
	// A_RaiseMobj
	// Raise a mobj incrementally from the floor to 
	// 

	bool RaiseMobj (double speed)
	{
		// Raise a mobj from the ground
		if (Floorclip > 0)
		{
			Floorclip -= speed;
			if (Floorclip <= 0)
			{
				Floorclip = 0;
				return true;
			}
			else
			{
				return false;
			}
		}
		return true;
	}
	
	Actor AimTarget()
	{
		FTranslatedLineTarget t;
		BulletSlope(t, ALF_PORTALRESTRICT);
		return t.linetarget;
	}

	native void A_Face(Actor faceto, double max_turn = 0, double max_pitch = 270, double ang_offset = 0, double pitch_offset = 0, int flags = 0, double z_ofs = 0);

	void A_FaceTarget(double max_turn = 0, double max_pitch = 270, double ang_offset = 0, double pitch_offset = 0, int flags = 0, double z_ofs = 0)
	{
		A_Face(target, max_turn, max_pitch, ang_offset, pitch_offset, flags, z_ofs);
	}
	void A_FaceTracer(double max_turn = 0, double max_pitch = 270, double ang_offset = 0, double pitch_offset = 0, int flags = 0, double z_ofs = 0)
	{
		A_Face(tracer, max_turn, max_pitch, ang_offset, pitch_offset, flags, z_ofs);
	}
	void A_FaceMaster(double max_turn = 0, double max_pitch = 270, double ang_offset = 0, double pitch_offset = 0, int flags = 0, double z_ofs = 0)
	{
		A_Face(master, max_turn, max_pitch, ang_offset, pitch_offset, flags, z_ofs);
	}

	// Action functions
	// Meh, MBF redundant functions. Only for DeHackEd support.
	native bool A_LineEffect(int boomspecial = 0, int tag = 0);
	// End of MBF redundant functions.
	

	//==========================================================================
	//
	// old customizable attack functions which use actor parameters.
	//
	//==========================================================================
	
	private void DoAttack (bool domelee, bool domissile, int MeleeDamage, Sound MeleeSound, Class<Actor> MissileType,double MissileHeight)
	{
		let targ = target;
		if (targ == NULL) return;

		A_FaceTarget ();
		if (domelee && MeleeDamage>0 && CheckMeleeRange ())
		{
			int damage = random[CustomMelee](1, 8) * MeleeDamage;
			if (MeleeSound) A_PlaySound (MeleeSound, CHAN_WEAPON);
			int newdam = targ.DamageMobj (self, self, damage, 'Melee');
			targ.TraceBleed (newdam > 0 ? newdam : damage, self);
		}
		else if (domissile && MissileType != NULL)
		{
			// This seemingly senseless code is needed for proper aiming.
			double add = MissileHeight + GetBobOffset() - 32;
			AddZ(add);
			Actor missile = SpawnMissileXYZ (Pos + (0, 0, 32), targ, MissileType, false);
			AddZ(-add);

			if (missile)
			{
				// automatic handling of seeker missiles
				if (missile.bSeekerMissile)
				{
					missile.tracer = targ;
				}
				missile.CheckMissileSpawn(radius);
			}
		}
	}

	deprecated("2.3") void A_MeleeAttack()
	{
		DoAttack(true, false, MeleeDamage, MeleeSound, NULL, 0);
	}

	deprecated("2.3") void A_MissileAttack()
	{
		Class<Actor> MissileType = MissileName;
		DoAttack(false, true, 0, 0, MissileType, MissileHeight);
	}

	deprecated("2.3") void A_ComboAttack()
	{
		Class<Actor> MissileType = MissileName;
		DoAttack(true, true, MeleeDamage, MeleeSound, MissileType, MissileHeight);
	}

	void A_BasicAttack(int melee_damage, sound melee_sound, class<actor> missile_type, double missile_height)
	{
		DoAttack(true, true, melee_damage, melee_sound, missile_type, missile_height);
	}


	native void A_MonsterRail();
	native void A_Pain();
	native void A_NoBlocking(bool drop = true);
	void A_Fall() { A_NoBlocking(); }
	native void A_XScream();
	native void A_Look();
	native void A_Chase(statelabel melee = null, statelabel missile = null, int flags = 0);
	native void A_Scream();
	native void A_VileChase();
	native void A_BossDeath();
	native void A_Detonate();
	bool A_CallSpecial(int special, int arg1=0, int arg2=0, int arg3=0, int arg4=0, int arg5=0)
	{
		return Level.ExecuteSpecial(special, self, null, false, arg1, arg2, arg3, arg4, arg5);
	}


	native void A_ActiveSound();

	native void A_FastChase();
	native void A_PlayerScream();
	native void A_SkullPop(class<PlayerChunk> skulltype = "BloodySkull");
	native void A_CheckPlayerDone();
	native void A_CheckTerrain();

	native void A_Wander(int flags = 0);
	native void A_Look2();

	deprecated("2.3") native void A_BulletAttack();
	native void A_WolfAttack(int flags = 0, sound whattoplay = "weapons/pistol", double snipe = 1.0, int maxdamage = 64, int blocksize = 128, int pointblank = 2, int longrange = 4, double runspeed = 160.0, class<Actor> pufftype = "BulletPuff");
	native void A_PlaySound(sound whattoplay = "weapons/pistol", int slot = CHAN_BODY, double volume = 1.0, bool looping = false, double attenuation = ATTN_NORM, bool local = false);
	deprecated("2.3") void A_PlayWeaponSound(sound whattoplay) { A_PlaySound(whattoplay, CHAN_WEAPON); }
	native void A_StopSound(int slot = CHAN_VOICE);	// Bad default but that's what is originally was...
	deprecated("2.3") native void A_PlaySoundEx(sound whattoplay, name slot, bool looping = false, int attenuation = 0);
	deprecated("2.3") native void A_StopSoundEx(name slot);
	native void A_SeekerMissile(int threshold, int turnmax, int flags = 0, int chance = 50, int distance = 10);
	native action state A_Jump(int chance, statelabel label, ...);
	native Actor A_SpawnProjectile(class<Actor> missiletype, double spawnheight = 32, double spawnofs_xy = 0, double angle = 0, int flags = 0, double pitch = 0, int ptr = AAPTR_TARGET);
	native void A_CustomBulletAttack(double spread_xy, double spread_z, int numbullets, int damageperbullet, class<Actor> pufftype = "BulletPuff", double range = 0, int flags = 0, int ptr = AAPTR_TARGET, class<Actor> missile = null, double Spawnheight = 32, double Spawnofs_xy = 0);
	native void A_CustomRailgun(int damage, int spawnofs_xy = 0, color color1 = 0, color color2 = 0, int flags = 0, int aim = 0, double maxdiff = 0, class<Actor> pufftype = "BulletPuff", double spread_xy = 0, double spread_z = 0, double range = 0, int duration = 0, double sparsity = 1.0, double driftspeed = 1.0, class<Actor> spawnclass = null, double spawnofs_z = 0, int spiraloffset = 270, int limit = 0, double veleffect = 3);
	native bool A_SetInventory(class<Inventory> itemtype, int amount, int ptr = AAPTR_DEFAULT, bool beyondMax = false);
	native bool A_GiveInventory(class<Inventory> itemtype, int amount = 0, int giveto = AAPTR_DEFAULT);
	native bool A_TakeInventory(class<Inventory> itemtype, int amount = 0, int flags = 0, int giveto = AAPTR_DEFAULT);
	action native bool, Actor A_SpawnItem(class<Actor> itemtype = "Unknown", double distance = 0, double zheight = 0, bool useammo = true, bool transfer_translation = false);
	native bool, Actor A_SpawnItemEx(class<Actor> itemtype, double xofs = 0, double yofs = 0, double zofs = 0, double xvel = 0, double yvel = 0, double zvel = 0, double angle = 0, int flags = 0, int failchance = 0, int tid=0);
	native void A_Print(string whattoprint, double time = 0, name fontname = "none");
	native void A_PrintBold(string whattoprint, double time = 0, name fontname = "none");
	native void A_Log(string whattoprint, bool local = false);
	native void A_LogInt(int whattoprint, bool local = false);
	native void A_LogFloat(double whattoprint, bool local = false);
	native void A_SetTranslucent(double alpha, int style = 0);
	native void A_SetRenderStyle(double alpha, int style);
	native void A_FadeIn(double reduce = 0.1, int flags = 0);
	native void A_FadeOut(double reduce = 0.1, int flags = 1); //bool remove == true
	native void A_FadeTo(double target, double amount = 0.1, int flags = 0);
	native void A_SpawnDebris(class<Actor> spawntype, bool transfer_translation = false, double mult_h = 1, double mult_v = 1);
	native void A_SpawnParticle(color color1, int flags = 0, int lifetime = 35, double size = 1, double angle = 0, double xoff = 0, double yoff = 0, double zoff = 0, double velx = 0, double vely = 0, double velz = 0, double accelx = 0, double accely = 0, double accelz = 0, double startalphaf = 1, double fadestepf = -1, double sizestep = 0);
	native void A_ExtChase(bool usemelee, bool usemissile, bool playactive = true, bool nightmarefast = false);
	native void A_DropInventory(class<Inventory> itemtype, int amount = -1);
	native void A_SetBlend(color color1, double alpha, int tics, color color2 = 0);
	deprecated("2.3") native void A_ChangeFlag(string flagname, bool value);
	native void A_ChangeCountFlags(int kill = FLAG_NO_CHANGE, int item = FLAG_NO_CHANGE, int secret = FLAG_NO_CHANGE);
	native void A_RaiseMaster(int flags = 0);
	native void A_RaiseChildren(int flags = 0);
	native void A_RaiseSiblings(int flags = 0);
	action native bool, Actor A_ThrowGrenade(class<Actor> itemtype, double zheight = 0, double xyvel = 0, double zvel = 0, bool useammo = true);
	native void A_Weave(int xspeed, int yspeed, double xdist, double ydist);
	native bool A_Morph(class<Actor> type, int duration = 0, int flags = 0, class<Actor> enter_flash = null, class<Actor> exit_flash = null);


	action native state, bool A_Teleport(statelabel teleportstate = null, class<SpecialSpot> targettype = "BossSpot", class<Actor> fogtype = "TeleportFog", int flags = 0, double mindist = 128, double maxdist = 0, int ptr = AAPTR_DEFAULT);
	action native state, bool A_Warp(int ptr_destination, double xofs = 0, double yofs = 0, double zofs = 0, double angle = 0, int flags = 0, statelabel success_state = null, double heightoffset = 0, double radiusoffset = 0, double pitch = 0);
	native void A_CountdownArg(int argnum, statelabel targstate = null);
	native state A_MonsterRefire(int chance, statelabel label);
	native void A_LookEx(int flags = 0, double minseedist = 0, double maxseedist = 0, double maxheardist = 0, double fov = 0, statelabel label = null);
	
	native void A_Recoil(double xyvel);
	native bool A_GiveToTarget(class<Inventory> itemtype, int amount = 0, int forward_ptr = AAPTR_DEFAULT);
	native bool A_TakeFromTarget(class<Inventory> itemtype, int amount = 0, int flags = 0, int forward_ptr = AAPTR_DEFAULT);
	native int A_RadiusGive(class<Inventory> itemtype, double distance, int flags, int amount = 0, class<Actor> filter = null, name species = "None", double mindist = 0, int limit = 0);
	native void A_CustomMeleeAttack(int damage = 0, sound meleesound = "", sound misssound = "", name damagetype = "none", bool bleed = true);
	native void A_CustomComboAttack(class<Actor> missiletype, double spawnheight, int damage, sound meleesound = "", name damagetype = "none", bool bleed = true);
	native void A_Burst(class<Actor> chunktype);
	native void A_RadiusThrust(int force = 128, int distance = -1, int flags = RTF_AFFECTSOURCE, int fullthrustdistance = 0);
	native void A_RadiusDamageSelf(int damage = 128, double distance = 128, int flags = 0, class<Actor> flashtype = null);
	native int A_Explode(int damage = -1, int distance = -1, int flags = XF_HURTSOURCE, bool alert = false, int fulldamagedistance = 0, int nails = 0, int naildamage = 10, class<Actor> pufftype = "BulletPuff", name damagetype = "none");
	native void A_Stop();
	native void A_Respawn(int flags = 1);
	native void A_RestoreSpecialPosition();
	native void A_QueueCorpse();
	native void A_DeQueueCorpse();
	native void A_ClearLastHeard();
	native bool A_SelectWeapon(class<Weapon> whichweapon, int flags = 0);
	native void A_ClassBossHealth();
	native void A_SetAngle(double angle = 0, int flags = 0, int ptr = AAPTR_DEFAULT);
	native void A_SetPitch(double pitch, int flags = 0, int ptr = AAPTR_DEFAULT);
	native void A_SetRoll(double roll, int flags = 0, int ptr = AAPTR_DEFAULT);
	native void A_ScaleVelocity(double scale, int ptr = AAPTR_DEFAULT);
	native void A_ChangeVelocity(double x = 0, double y = 0, double z = 0, int flags = 0, int ptr = AAPTR_DEFAULT);
	deprecated("2.3") native void A_SetUserVar(name varname, int value);
	deprecated("2.3") native void A_SetUserArray(name varname, int index, int value);
	deprecated("2.3") native void A_SetUserVarFloat(name varname, double value);
	deprecated("2.3") native void A_SetUserArrayFloat(name varname, int index, double value);
	native void A_Quake(int intensity, int duration, int damrad, int tremrad, sound sfx = "world/quake");
	native void A_QuakeEx(int intensityX, int intensityY, int intensityZ, int duration, int damrad, int tremrad, sound sfx = "world/quake", int flags = 0, double mulWaveX = 1, double mulWaveY = 1, double mulWaveZ = 1, int falloff = 0, int highpoint = 0, double rollIntensity = 0, double rollWave = 0);
	action native void A_SetTics(int tics);
	native void A_DropItem(class<Actor> item, int dropamount = -1, int chance = 256);
	native void A_DamageSelf(int amount, name damagetype = "none", int flags = 0, class<Actor> filter = null, name species = "None", int src = AAPTR_DEFAULT, int inflict = AAPTR_DEFAULT);
	native void A_DamageTarget(int amount, name damagetype = "none", int flags = 0, class<Actor> filter = null, name species = "None", int src = AAPTR_DEFAULT, int inflict = AAPTR_DEFAULT);
	native void A_DamageMaster(int amount, name damagetype = "none", int flags = 0, class<Actor> filter = null, name species = "None", int src = AAPTR_DEFAULT, int inflict = AAPTR_DEFAULT);
	native void A_DamageTracer(int amount, name damagetype = "none", int flags = 0, class<Actor> filter = null, name species = "None", int src = AAPTR_DEFAULT, int inflict = AAPTR_DEFAULT);
	native void A_DamageChildren(int amount, name damagetype = "none", int flags = 0, class<Actor> filter = null, name species = "None", int src = AAPTR_DEFAULT, int inflict = AAPTR_DEFAULT);
	native void A_DamageSiblings(int amount, name damagetype = "none", int flags = 0, class<Actor> filter = null, name species = "None", int src = AAPTR_DEFAULT, int inflict = AAPTR_DEFAULT);
	native void A_KillTarget(name damagetype = "none", int flags = 0, class<Actor> filter = null, name species = "None", int src = AAPTR_DEFAULT, int inflict = AAPTR_DEFAULT);
	native void A_KillMaster(name damagetype = "none", int flags = 0, class<Actor> filter = null, name species = "None", int src = AAPTR_DEFAULT, int inflict = AAPTR_DEFAULT);
	native void A_KillTracer(name damagetype = "none", int flags = 0, class<Actor> filter = null, name species = "None", int src = AAPTR_DEFAULT, int inflict = AAPTR_DEFAULT);
	native void A_KillChildren(name damagetype = "none", int flags = 0, class<Actor> filter = null, name species = "None", int src = AAPTR_DEFAULT, int inflict = AAPTR_DEFAULT);
	native void A_KillSiblings(name damagetype = "none", int flags = 0, class<Actor> filter = null, name species = "None", int src = AAPTR_DEFAULT, int inflict = AAPTR_DEFAULT);
	native void A_RemoveTarget(int flags = 0, class<Actor> filter = null, name species = "None");
	native void A_RemoveMaster(int flags = 0, class<Actor> filter = null, name species = "None");
	native void A_RemoveTracer(int flags = 0, class<Actor> filter = null, name species = "None");
	native void A_RemoveChildren(bool removeall = false, int flags = 0, class<Actor> filter = null, name species = "None");
	native void A_RemoveSiblings(bool removeall = false, int flags = 0, class<Actor> filter = null, name species = "None");
	native void A_Remove(int removee, int flags = 0, class<Actor> filter = null, name species = "None");
	native int A_GiveToChildren(class<Inventory> itemtype, int amount = 0);
	native int A_GiveToSiblings(class<Inventory> itemtype, int amount = 0);
	native int A_TakeFromChildren(class<Inventory> itemtype, int amount = 0);
	native int A_TakeFromSiblings(class<Inventory> itemtype, int amount = 0);
	native void A_SetTeleFog(class<Actor> oldpos, class<Actor> newpos);
	native void A_SwapTeleFog();
	native void A_SetHealth(int health, int ptr = AAPTR_DEFAULT);
	native void A_ResetHealth(int ptr = AAPTR_DEFAULT);
	native void A_SetSpecies(name species, int ptr = AAPTR_DEFAULT);
	native void A_SetChaseThreshold(int threshold, bool def = false, int ptr = AAPTR_DEFAULT);
	native bool A_FaceMovementDirection(double offset = 0, double anglelimit = 0, double pitchlimit = 0, int flags = 0, int ptr = AAPTR_DEFAULT);
	native int A_ClearOverlays(int sstart = 0, int sstop = 0, bool safety = true);
	native bool A_CopySpriteFrame(int from, int to, int flags = 0);
	native bool A_SetVisibleRotation(double anglestart = 0, double angleend = 0, double pitchstart = 0, double pitchend = 0, int flags = 0, int ptr = AAPTR_DEFAULT);
	native void A_SetTranslation(name transname);
	native bool A_SetSize(double newradius, double newheight = -1, bool testpos = false);
	native void A_SprayDecal(String name);
	native void A_SetMugshotState(String name);

	native void A_RearrangePointers(int newtarget, int newmaster = AAPTR_DEFAULT, int newtracer = AAPTR_DEFAULT, int flags=0);
	native void A_TransferPointer(int ptr_source, int ptr_recipient, int sourcefield, int recipientfield=AAPTR_DEFAULT, int flags=0);
	native void A_CopyFriendliness(int ptr_source = AAPTR_MASTER);

	action native bool A_Overlay(int layer, statelabel start = null, bool nooverride = false);
	native void A_WeaponOffset(double wx = 0, double wy = 32, int flags = 0);
	action native void A_OverlayOffset(int layer = PSP_WEAPON, double wx = 0, double wy = 32, int flags = 0);
	action native void A_OverlayFlags(int layer, int flags, bool set);

	int ACS_NamedExecute(name script, int mapnum=0, int arg1=0, int arg2=0, int arg3=0)
	{
		return ACS_Execute(-int(script), mapnum, arg1, arg2, arg3);
	}
	int ACS_NamedSuspend(name script, int mapnum=0)
	{
		return ACS_Suspend(-int(script), mapnum);
	}
	int ACS_NamedTerminate(name script, int mapnum=0)
	{
		return ACS_Terminate(-int(script), mapnum);
	}
	int ACS_NamedLockedExecute(name script, int mapnum=0, int arg1=0, int arg2=0, int lock=0)
	{
		return ACS_LockedExecute(-int(script), mapnum, arg1, arg2, lock);
	}
	int ACS_NamedLockedExecuteDoor(name script, int mapnum=0, int arg1=0, int arg2=0, int lock=0)
	{
		return ACS_LockedExecuteDoor(-int(script), mapnum, arg1, arg2, lock);
	}
	int ACS_NamedExecuteWithResult(name script, int arg1=0, int arg2=0, int arg3=0, int arg4=0)
	{
		return ACS_ExecuteWithResult(-int(script), arg1, arg2, arg3, arg4);
	}
	int ACS_NamedExecuteAlways(name script, int mapnum=0, int arg1=0, int arg2=0, int arg3=0)
	{
		return ACS_ExecuteAlways(-int(script), mapnum, arg1, arg2, arg3);
	}
	int ACS_ScriptCall(name script, int arg1=0, int arg2=0, int arg3=0, int arg4=0)
	{
		return ACS_ExecuteWithResult(-int(script), arg1, arg2, arg3, arg4);
	}
	
	States(Actor, Overlay, Weapon, Item)
	{
	Spawn:
		TNT1 A -1;
		Stop;
	Null:
		TNT1 A 1;
		Stop;
	GenericFreezeDeath:
		// Generic freeze death frames. Woo!
		#### # 5 A_GenericFreezeDeath;
		---- A 1 A_FreezeDeathChunks;
		Wait;
	GenericCrush:
		POL5 A -1;
		Stop;
	}

	// Internal functions
	deprecated("2.3") private native int __decorate_internal_int__(int i);
	deprecated("2.3") private native bool __decorate_internal_bool__(bool b);
	deprecated("2.3") private native double __decorate_internal_float__(double f);
}
