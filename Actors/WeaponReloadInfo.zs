

Class WeaponReloadInfo
{
    Class<Inventory> unloadedClass;
    Class<Inventory> loadedClass;

    static WeaponReloadInfo Get(Name weaponClassName)
    {
        Class<Inventory> unloadedAmmo = WeaponReloadInfo.getAmmoClassFromCVar(false, weaponClassName);
        if (!unloadedAmmo) 
            return null;
        Class<Inventory> loadedAmmo = WeaponReloadInfo.getAmmoClassFromCVar(true, weaponClassName);
        if (!loadedAmmo)
            return null;
        WeaponReloadInfo newInfo = new("WeaponReloadInfo");
        newInfo.unloadedClass = unloadedAmmo;
        newInfo.loadedClass =  loadedAmmo;
        return newInfo;
    }
    
    static protected Class<Inventory> getAmmoClassFromCVar(bool getLoaded, Name weaponClassName)
    {
        String cvarName = String.format("ReloadInfo_%s_%s",getLoaded ? "Loaded" : "Unloaded", weaponClassName);
        CVar ammoVar = CVar.GetCVar(cvarName);
        if (!ammoVar)
            return null;
        return ammoVar.GetString();
    }
}