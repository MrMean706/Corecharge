Class TangoPlayer : Doomplayer
{	
      Default
    {
        Player.DisplayName "Default";
        Player.startitem "TangoPistol";
        Player.startitem "TangoFist";
        Player.StartItem "TangoBulletClip", 24;
        Player.StartItem "ShotgunAmmo", 8;
        Player.StartItem "AssaultRifleAmmo", 48;
        Player.StartItem "PlasmaRifleAmmo", 40;
        Species "CorechargePlayer";
    }
    
    bool shouldRecoil()
    {
        return CVar.GetCVar("cl_tango_enable_recoil", player).GetBool();
    }

    bool shouldScreenShake()
    {
        return CVar.GetCVar("cl_tango_enable_screen_shake", player).GetBool();
    }
}