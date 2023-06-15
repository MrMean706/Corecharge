Class SoulOfPain : LostSoul replaces LostSoul
{
    Override void Tick()
    {
        Super.Tick();
        if (target && (random(1,15)==1)) A_SpawnProjectile("DraugrTracer");
    }
    Default
    {
        //$Category Monsters
        //$Color 12
        //$Title "SoulOfPain"
        Tag "Lost Soul";
        DamageFactor "PainElemental", 0.0;
        PainChance "Chaingun", 20;
        Health 150;
        Damage (60);
        +NOBLOOD
    }
	
	States
	{
	Spawn:
		PSKL AB 1 
        {
        if (target)
            return ResolveState("See");
        A_Look();
        return ResolveState(null);
        }
		Loop;
	See:
		PSKL AB 1 A_Chase;
		Loop;
	Missile:
		PSKL C 10 A_FaceTarget;
		PSKL D 4 A_SkullAttack;
		PSKL CD 4;
		Goto Missile+2;
	Pain:
		PSKL E 3;
		PSKL E 3 A_Pain;
		Goto See;
	Death:
		PSKL F 2 A_Scream;
		PSKL G 2 A_NoBlocking;
		TNT1 AAA 0 A_SpawnProjectile("LSpart1", 42, 0, random (0, 360), 2, random (0, 160));
		TNT1 A 0 A_SpawnProjectile("LSpart3", 42, 0, random (0, 360), 2, random (0, 160));
		TNT1 AA 0 A_SpawnProjectile("LSpart2", 42, 0, random (0, 360), 2, random (0, 160));
        PSKL HI 2;
		PSKL JK 4;
		Stop;
	Death.Massacre:
		TNT1 A 0 A_Scream;
		TNT1 A 0 A_NoBlocking;
		Stop;
	}
}