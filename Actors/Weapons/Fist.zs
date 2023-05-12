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
	}
}