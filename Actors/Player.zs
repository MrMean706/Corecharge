Class TangoPlayer : Doomplayer
{	
    array<ReloadableWeapon> reloadableWeapons;
    void FullReload(Class<Ammo> ammoClass, Inventory ammunition)
    {
        let weapon = player.ReadyWeapon;
        TryReload(weapon, ammoClass, ammunition);
        for (int i=0; i<reloadableWeapons.Size(); i++) TryReload(reloadableWeapons[i], ammoClass, ammunition);
    }
    
    void TryReload(Weapon weapon, Class<Ammo> ammoClass, Inventory ammunition)
    {  
        ReloadableWeapon reloadable = ReloadableWeapon(weapon);
        if (reloadable == NULL) return;
        if (!(weapon.AmmoType2 is ammoClass)) return;
        reloadable.InstantReload(ammunition);
    }
    
    void AddReloadable(ReloadableWeapon reloadable) { reloadableWeapons.Push(reloadable); }
    
    Default
    {
        Player.DisplayName "Default";
        Player.startitem "TangoPistol";
        Player.startitem "TangoFist";
        Player.StartItem "TangoBulletClip", 24;
        Player.StartItem "TangoShell", 0;   //Undeclared ammo types won't work with FullReload
        Player.StartItem "PistolAmmo", 0;
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