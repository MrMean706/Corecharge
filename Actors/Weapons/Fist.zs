Class TangoFist : Fist
{
    int baitChargeTime;
    
    enum PALayers
    {
        PSP_MFlash      = 1000,
    }
    
    Default
    {
        Weapon.SlotNumber 1;
    } 
    
	States
	{
	Select:
		TNT1 A 0 A_StartSound("fist/select", CHAN_WEAPON);
		PUNG A 0 A_Raise();
		Loop;
	Deselect:
		PUNG A 0 A_Lower();
		Loop;
	Ready:
		PUNG A 1 
        {
        A_WeaponReady();
        invoker.baitChargeTime = 0;
        }
		Loop;
	Fire:
		PKFS LBCD 1;
		PKFS E 2 
        {
            Actor unused;
            int actualDamage;
            FTranslatedLineTarget t;
            double pitch = AimLineAttack(angle, 64, null, 0., ALF_CHECK3D);
            [unused, actualDamage] = LineAttack(angle, 64, pitch, 60, 'Melee', "TangoFistPuff", LAF_ISMELEEATTACK, t);
            
            if ((actualDamage > 0)) A_DamageSelf(min(5,health - 1), 'Melee');
            // Turn to face the hit actor.
            if (t.linetarget)
            {
                angle = t.angleFromSource;
            }
        }
		PKFS FGHI 2;
		PKFS JKL 1;
		PUNG A 5 A_ReFire();
		Goto Ready;
    /*Altfire:
        TNT1 A 2
        {
            invoker.baitChargeTime++;
            A_Overlay(PSP_MFlash, "Flash");
            //TODO: Effects to show current charge level
        }
        JBOX EF 1 A_ReFire();
        JBOX G 1 
        {
        A_StartSound("jackbomb/throw",CHAN_WEAPON);
        //TODO: fire different baits based on charge time.
        A_FireProjectile("JackBox",0,1,8,0);
        invoker.baitChargeTime = 0;
        }
        JBOX HIJKLMNO 1;
        TNT1 A 8;
        //Using A_Jump instead of a goto causes it to resolve at runtime instead of compile time.
        //This allows subclasses to return to their own ready state instead of the fists'
        TNT1 A 0 A_Jump(256,'Ready'); */
    Flash:
        DYNG A 2 Bright
        {
        PSprite psp = player.GetPSprite(OverlayID());
        psp.Frame = max(invoker.baitChargeTime - 1,0);
        }
        #### # 0 
        {
        if (invoker.baitChargeTime <= 0) 
        {
            player.GetPSprite(OverlayID()).Destroy();
            return ResolveState(null);
        }
        return ResolveState("Flash");
        }
        Stop;
	}
}

/*Class JackBox: Actor
{
    override int DoSpecialDamage(Actor victim, int damage, Name damagetype)
    {
        Taunting.TryEnrage(victim,self,target);
        return 0;
    }

    Default
    {
        Speed 20;
        Radius 8;
        Height 8;
        Scale 0.25;
        Damage 20;
        Gravity 0.65;
        PROJECTILE;
        +GRENADETRAIL;
        -NOGRAVITY;
        +EXTREMEDEATH;
        //BounceType "Hexen";
        //+BOUNCEONACTORS;
        //+CANBOUNCEWATER;
        +PAINLESS;
        +NODAMAGETHRUST;
        //BounceFactor 0.4;
        //BounceCount 6;
    }
    
    States
    {
    Spawn:
        TNT1 A 0 ThrustThingZ(0,17,0,1);
    Exist:
        JBTH A 1 Bright ;
        Goto Exist;
    Death:
        TNT1 A 0 A_Explode;
        /*{
            //TODO: Determine whether to burst or play on depending upon charge level
            //TODO: PlaySound
            A_Explode(100,128,0,true,128);
            //A_SpawnItemEx("JackBombProj",0,0,0,0,0,0,0,32,0)
        }
        Stop;
    }
}*/