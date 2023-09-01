Class Axe : TangoFist
{   
     Default
    {
        Weapon.SlotNumber 1;
        Inventory.Icon "AXEPA0";
        Tag "Axe";
        Obituary "%k butchered %o with his axe!";
        Inventory.PickupMessage "$TANGO_BERSERK";
    }
	
	States
	{
	Spawn:
        AXEP AAAA 0 A_SpawnItemEx("Medikit", 0, 0, 0, frandom(-1, 1), frandom(-1, 1));
		AXEP A -1;
		Stop;
	Select:
        TNT1 A 0 A_StartSound("fist/select", CHAN_WEAPON);
		AXEG H 0 A_Raise();
		Loop;
	Deselect:
		AXEG H 0 A_Lower();
		Wait;
	Ready:
		AXEG H 1 A_WeaponReady();
		Loop;
	Fire:
        AXEG G 2;
        AXEG HI 1 A_StartSound("weapons/axeswing", CHAN_WEAPON);
		AXEG J 2 
        {
            FTranslatedLineTarget t;
            double pitch = AimLineAttack(angle, 64, null, 0., ALF_CHECK3D);
            LineAttack(angle, 64, pitch, 120, 'Melee', "TangoFistPuff", LAF_ISMELEEATTACK, t);
            
            // Turn to face the hit actor.
            if (t.linetarget) angle = t.angleFromSource;
        }
        AXEG K 2;
        TNT1 A 6;
        AXEG K 2;
        AXEG JIH 1;
        AXEG G 1;
        AXEG F 1;
        AXEG F 5 A_ReFire();
        Goto Ready;
	}
}