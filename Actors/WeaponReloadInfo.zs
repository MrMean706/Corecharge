

Class WeaponReloadInfo
{
    Class<Inventory> unloadedClass;
    Class<Inventory> loadedClass;
    String soundName;
    
    static protected Class<Inventory> getAmmoClassFromCVar(bool getLoaded, Name weaponClassName)
    {
        String cvarName = String.format("ReloadInfo_%s_%s",getLoaded ? "Loaded" : "Unloaded", weaponClassName);
        CVar ammoVar = CVar.GetCVar(cvarName);
        if (!ammoVar)
            return null;
        return ammoVar.GetString();
    }
}