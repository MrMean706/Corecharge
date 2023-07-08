Class WeaponReloadInfoFactory: EventHandler abstract
{
    override void WorldLoaded(WorldEvent e)
    {
        WeaponReloadInfoFactoryList.Push(self);
        Super.WorldLoaded(e);
    }
    abstract bool TryGetWeaponReloadInfo(Weapon infoSource, out WeaponReloadInfo output);
}