Class WeaponReloadInfoFactory: EventHandler abstract
{
    override void WorldLoaded(WorldEvent e)
    {
        WeaponReloadInfoFactoryList.Push(self);
        Super.WorldLoaded(e);
    }
    override bool TryGetWeaponReloadInfo(Weapon infoSource, out WeaponReloadInfo output)
    {
        if(!infoSource.AmmoType1 || !infoSource.AmmoType2)
            return false;
        output.loadedClass = infoSource.AmmoType1;
        output.unloadedClass = infoSource.AmmoType2;
        return true;
    }
}