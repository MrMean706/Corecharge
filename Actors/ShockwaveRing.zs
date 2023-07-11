//Code taken from Bullet Eye
Class ShockwaveRing
{
    static play void Spawn(Actor other, bool small = false, int damage = 64, int radius = 150, int fullRadius = 75)
	{
		for (int i = 0; i < 360; ++i)
		{
			other.A_SpawnItemEx(small ? 'ShotwavePumpFXSmall' : 'ShotwavePumpFX', 0, 0, 0, 15, 0, 0, i, SXF_NOCHECKPOSITION);
		}

		if (damage > 0)
		{
			other.A_Explode(damage, radius, other.bMissile ? 0 : XF_NOTMISSILE, 1, fullRadius);
		}
	}
}

class ShotwavePumpFX : Actor // Aesthetic. Deals no damage.
{
	Default
	{
		RenderStyle "Stencil";
		StencilColor "White";
		Alpha 1.0;
		Scale 0.2;
		+BRIGHT
		+NOINTERACTION
	}
   
	States
	{
		Spawn:
			TQFX AA 1;
			TQFX AA 3 A_SetScale(0.5, 0.1);
			TQFX A 2 A_SetScale(0.6, 0.05);
		Death:
			TQFX A 1 A_FadeOut(0.1);
			Loop;
	}
}

class ShotwavePumpFXSmall : ShotwavePumpFX // L3 Effect
{
	States
	{
		Spawn:
			TQFX A 1;
			TQFX A 2 A_SetScale(0.5, 0.1);
			TQFX A 2 A_SetScale(0.6, 0.05);
		Death:
			TQFX A 1;
			TQFX A 0 A_FadeOut(0.1);
			Loop;
	}
}