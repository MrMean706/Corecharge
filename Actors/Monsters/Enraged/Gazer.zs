Class Gazer: Cacodemon
{
    Default
    {
        Speed 11;
        SeeSound    "";
        ActiveSound "enemies/gazer/active";
        PainSound   "enemies/gazer/pain";
        DeathSound  "enemies/gazer/death";
        HitObituary "$DED_OB_GAZER_H";
        Obituary "$DED_OB_GAZER";
    }
    
    States
	{
	Spawn:
		GAZE A 5 A_Look;
		Loop;
	See:
		GAZE A 2 A_Chase;
		Loop;
	Missile:
		GAZE BC 3 A_FaceTarget;
		GAZE D 2 A_CustomComboAttack("GazerEye", 32, 28, "tangocacodemon/bite");
		Goto See;
	Pain:
		GAZE E 3;
		GAZE E 3 A_Pain;
		Goto See;
    Death:
		GAZE G 8;
		GAZE H 8 A_Scream;
		GAZE I 8;
		GAZE J 8;
		GAZE K 8 A_NoBlocking;
		GAZE L -1 A_SetFloorClip;
		Stop;
	Raise:
		GAZE L 8 A_UnSetFloorClip;
		GAZE KJIHG 8;
		Goto See;
	XDeath:
		GAZE M 8;
		GAZE N 0 A_PlaySound("misc/gibbed", CHAN_AUTO);
		GAZE N 8 A_Scream;
		GAZE OP 8;
		GAZE Q 8 A_NoBlocking;
		GAZE R -1 A_SetFloorClip;
		Stop;
	}
}

Class GazerEye: Actor
{
    Default
    {
        Speed 20;
        DamageFunction 24;
        Projectile;
        SeeSound "enemies/gazer/attack";
        DeathSound "enemies/gazer/attackx";
    }
	
	States
	{
	Spawn:
		HEYE ABCDEF 4 Bright;
		Loop;
	Death:
		HEYX ABC 4 Bright;
        Stop;
	}
}
