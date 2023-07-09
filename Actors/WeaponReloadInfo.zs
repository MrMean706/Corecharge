

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
    
    string ToString()
    {
        return String.Format("%p = %s (unloadedClass: %s, loadedClass: %s, soundName: %s)", self, GetClassName(), TryGetClassName(unloadedClass), TryGetClassName(loadedClass), soundName);
    }
    
    string TryGetClassName(Class<Actor> actor)
    {
        if (actor)
            return actor.GetClassName();
        return "null";
    }
}