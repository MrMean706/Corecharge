Class Axe : Fist Replaces Berserk
{
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
		AXEG A 0 A_Raise();
		Loop;
	Deselect:
		AXEG A 0 A_Lower();
		Wait;
	Ready:
		AXEG A 1 A_WeaponReady();
		Loop;
	Fire:
		AXEG ABCDE 3;
		TNT1 A 4;
		AXEG I 2 A_PlaySound("weapons/axeswing", CHAN_WEAPON);
		AXEG J 2 A_CustomPunch(110, 1, 0, "AxeHitPuff");
		AXEG K 2;
		TNT1 A 4;
		AXEG EDCBA 2;
		AXEG A 6;
		Goto Ready;
	}
}