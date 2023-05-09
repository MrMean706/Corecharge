Class TangoFist : Fist replaces Fist
{
    Default
    {
        Weapon.SlotNumber 1;
    } 
    
	States
	{
	Select:
		TNT1 A 0 A_PlaySound("fist/select", CHAN_WEAPON);
		PUNG A 0 A_Raise();
		Loop;
	Deselect:
		PUNG A 0 A_Lower();
		Loop;
	Ready:
		PUNG A 1 A_WeaponReady();
		Loop;
	Fire:
		PKFS LBCD 1;
		PKFS E 2 A_CustomPunch(30, true, 0, "TangoFistPuff", 64);
		Goto PunchFinish;
	PunchFinish:
		PKFS FGHI 2;
		PKFS JKL 1;
		PUNG A 5 A_ReFire();
		Goto Ready;
	}
}