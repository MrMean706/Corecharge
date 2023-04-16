Class TangoPlayer : Doomplayer replaces Doomplayer
{	
    array<ReloadableWeapon> reloadableWeapons;
    void FullReload(Class<Ammo> ammoClass)
    {
        let weapon = player.ReadyWeapon;
        TryReload(weapon, ammoClass);
        for (int i=0; i<reloadableWeapons.Size(); i++) TryReload(reloadableWeapons[i], ammoClass);
    }
    
    void TryReload(Weapon weapon, Class<Ammo> ammoClass)
    {  
        ReloadableWeapon reloadable = ReloadableWeapon(weapon);
        if (reloadable == NULL) return;
        if (!(weapon.AmmoType2 is ammoClass)) return;
        reloadable.InstantReload();
    }
    
    void AddReloadable(ReloadableWeapon reloadable) { reloadableWeapons.Push(reloadable); }
    
    Default
    {
        Player.DisplayName "Default";
        Player.startitem "TangoPistol";
        Player.startitem "TangoFist";
        Player.StartItem "TangoBulletClip", 50;
        Player.StartItem "TangoShell", 0;   //Undeclared ammo types won't work with FullReload
        Player.StartItem "PistolAmmo", 8;
        Player.StartItem "ShotgunAmmo", 8;
        Player.StartItem "AssaultRifleAmmo", 48;
        Player.StartItem "PlasmaRifleAmmo", 40;
        Species "CorechargePlayer";
    }
}