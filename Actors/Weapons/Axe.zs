Class Axe : TangoFist
{   
    override void AttachToOwner(Actor other)
    {
        other.TakeInventory("TangoFist", 1);
        if (other.health < 100) other.health = 100;
        super.AttachToOwner(other);
    }

     Default
    {
        Weapon.SlotNumber 1;
        Inventory.Icon "AXEPA0";
        Inventory.PickupMessage "You claimed yourself a powerful axe!";
        Tag "Axe";
        Obituary "%k butchered %o with his axe!";
    }
	
	States
	{
	Spawn:
		AXEP A -1;
		Stop;
	Select:
        TNT1 A 0 A_PlaySound("fist/select", CHAN_WEAPON);
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
        AXEG HI 1 A_PlaySound("weapons/axeswing", CHAN_WEAPON);
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