Class Blot: Actor
{
	Default
    {
        //$Title Blot
        //$Category Monsters
        //$Angled
        //$Sprite BLOPA0

        Obituary "%o was engulfed by a blot.";
        Health 30;
        Radius 8;
        Height 16;
        Mass 50;
        Speed 0;
        Deathsound "Blot/Death";
        ExplosionDamage 12;
        DamageFactor "Blot", 0;
        ExplosionRadius 40;
        BloodType "None";
        Scale 0.6;
        MONSTER
        -SOLID
        -CANPASS
        +STANDSTILL
        +MISSILEMORE
        +MISSILEEVENMORE
        +DONTHURTSPECIES
        +NODAMAGETHRUST
        +BLOODLESSIMPACT
        +LOWGRAVITY
        +BRIGHT;
    }
  
	
	
	
    States
    {
        Spawn:
            EYES A 5 A_Look;
            Loop;
        IdleSpawn:
            EYES A 1 A_LookEx (LOF_NOSEESOUND, 0, 0, 0, 360);
            EYES AAA 0 A_SpawnItemEx ("BlotSmoke", -4, random (-10, 10), random (-10, 10), 0, random (-1, 1), random (-1, 1));
            Loop;
        See:
            EYES A 1 A_Chase;
            EYES AAA 0 A_SpawnItemEx ("BlotSmoke", -4, random (-10, 10), random (-10, 10), 0, random (-1, 1), random (-1, 1));
            Loop;
        Melee:
        Missile:
            EYES A 0 A_CheckSight ("IdleSpawn");
        LeapSight:
            EYES B 1 A_FaceTarget;
            EYES BBB 0 A_SpawnItemEx ("BlotSmoke", -4, random (-10, 10), random (-10, 10), 0, random (-1, 1), random (-1, 1));
            EYES B 1 ThrustThingZ (0, 13, 0, 0);
            EYES BBB 0 A_SpawnItemEx ("BlotSmoke", -4, random (-10, 10), random (-10, 10), 0, random (-1, 1), random (-1, 1));
            TNT1 B 0 ThrustThing(angle*256/360, 20, 0, 0);
            TNT1 B 0 A_PlaySound ("Blot/Attack");
        MidLeap:
            EYES B 1 A_Explode(ExplosionDamage, ExplosionRadius, XF_NOTMISSILE);//A_SpawnItem ("BlotDamage");
            EYES BBB 0 A_SpawnItemEx ("BlotSmoke", -4, random (-10, 10), random (-10, 10), 0, random (-1, 1), random (-1, 1));
            TNT1 B 0 A_JumpIf (vel.z < 0, "Falling");
            Loop;
        Falling:
            EYES A 1 A_Explode(ExplosionDamage, ExplosionRadius, XF_NOTMISSILE);
            EYES AAA 0 A_SpawnItemEx ("BlotSmoke", -4, random (-10, 10), random (-10, 10), 0, random (-1, 1), random (-1, 1));
            TNT1 A 0 A_CheckFloor ("Land");
            Loop;
        Land:
            EYES A 1 A_Stop;
            EYES AAA 0 A_SpawnItemEx ("BlotSmoke", -4, random (-10, 10), random (-10, 10), 0, random (-1, 1), random (-1, 1));
            EYES A 0 A_ClearTarget;
            Goto IdleSpawn;
        Death:
            TNT1 A 1 A_Stop;
            TNT1 A 0 A_ScreamAndUnblock;
            TNT1 AAAAAAAA 1 A_SpawnItemEx ("BlotSmoke", 0, 0, 0, random (-4, 4), 0, random (-4, 4), random(0, 360));
            Stop;
    }
}

Class BlotSmoke: Actor
{
    Default
    {
        +NOINTERACTION
        +CLIENTSIDEONLY
        RenderStyle "Translucent";
    }
	

    States
    {
        Spawn:
            TNT1 A 0 NoDelay A_Jump (256, "Blot1", "Blot2", "Blot3", "Blot4");
        Blot1:
            BLOT A 2;
            BLOT BCDE 2 A_FadeOut (0.2);
            Stop;
        Blot2:
            BLOT F 2;
            BLOT GHIJ 2 A_FadeOut (0.2);
            Stop;
        Blot3:
            BLOT K 2;
            BLOT LMNO 2 A_FadeOut (0.2);
            Stop;
        Blot4:
            BLOT P 2;
            BLOT QRST 2 A_FadeOut (0.2);
            Stop;
    }
}