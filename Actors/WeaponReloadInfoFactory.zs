Class WeaponReloadInfoFactory: EventHandler abstract
{
    override void WorldLoaded(WorldEvent e)
    {
        WeaponReloadInfoFactoryList.Push(self);
    }
    abstract bool TryGetWeaponReloadInfo(Weapon infoSource, out WeaponReloadInfo output);
}