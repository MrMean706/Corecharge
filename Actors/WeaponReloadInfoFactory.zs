Class WeaponReloadInfoFactory: EventHandler abstract
{
    override void WorldLoaded(WorldEvent e)
    {
        WeaponReloadInfoFactory.Push(self);
    }
    abstract bool TryGetWeaponReloadInfo(Name infoSource, out WeaponReloadInfo output);
}