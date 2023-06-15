Class Carrionnette: Revenant
{
    Default
    {
        //$Title Carrionnette
        //$Category Monsters
        Health 150;
        Radius 16;
        Height 56;
        Speed 10;
        SeeSound "Lanky/See";
        MeleeSound "Skeleton/Melee";
        ActiveSound "Lanky/Active";
        PainSound "Lanky/Pain";
        DeathSound "Misc/Gibbed";
        Obituary "%o was struck by the gory sight of a Carrionnette";
        HitObituary "%o was clocked upside the head by a Carrionnette";
    }
	
	States
	{
		Spawn:
			LANK AB 5 A_Look;
			Loop;
		See:
			LANK AABBCCDD 1 A_Chase;
			Loop;
		Melee:
			LANK E 6 {A_FaceTarget(); A_SkelWhoosh(); }
			LANK F 6 A_FaceTarget;
			LANK G 6 A_CustomMeleeAttack(28, "skeleton/melee");
			Goto See;
		Missile:
			TNT1 A 0 A_JumpIfCloser (640,"MayLeap");
			LANK EF 4 A_FaceTarget;
			LANK G 2 A_SpawnProjectile ("CarrionnetteShot",48);
			LANK FE 2;
			Goto See;
		MayLeap:
			TNT1 A 0 A_Jump (150,"Leap");
			Goto Missile+1; //Decided against jumping, go back to firing.
		Leap:
			TNT1 A 0 A_PlaySound ("Lanky/Jump",CHAN_VOICE);
			LANK H 3 A_FaceTarget;
			TNT1 A 0 A_ChangeVelocity (16,0,14,CVF_RELATIVE);
			//Intentional fall through to leap check mode.
		LeapLoop:
			LANK I 1 A_JumpIfCloser (MeleeRange,"Melee"); //Target in range, smack 'em.
			TNT1 A 0 A_CheckFloor ("See"); //Hit the ground without getting in range.
			Loop;
		Pain:
			LANK J 4;
			LANK J 4 A_Pain;
			Goto See;
		Death:
			LANK K 6 A_Scream;
			LANK L 6 A_NoBlocking;
			LANK MNOPQ 3;
			LANK Q -1;
			Stop;
		Raise:
			LANK QPONMLKJ 3;
			Goto See;
	}
}

Class CarrionnetteShot: Actor
{
    Default
    {
        Speed 25;
        FastSpeed 35;
        DamageFunction 45;
        Projectile;
        SeeSound "Lanky/Shot";
        DeathSound "Baron/ShotX";
        Decal "RevenantScorch";
    }
	
	States
	{
		Spawn:
			LANK RS 4;
			Loop;
		Death:
			LANK TUV 6;
			Stop;
	}
}