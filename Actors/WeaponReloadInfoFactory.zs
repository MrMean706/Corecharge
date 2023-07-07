Class WeaponReloadInfoFactory: EventHandler abstract
{
    override void WorldLoaded(WorldEvent e)
    {
        WeaponReloadInfoFactory.Push(self);
    }
    abstract bool TryGetWeaponReloadInfo(Weapon infoSource, out WeaponReloadInfo output);
}