Class CorechargeReloadInfoFactory: WeaponReloadInfoFactory
{
    Dictionary weaponToSound;
    override void WorldLoaded(WorldEvent e)
    {
        weaponToSound = Dictionary.Create();
        weaponToSound.Insert("TangoPistol","pistol/reload2");
        weaponToSound.Insert("TangoShotgun","weapons/shellin");
        weaponToSound.Insert("TangoScrapgun","weapons/scrapclose");
        weaponToSound.Insert("TangoAssaultRifle","weapons/arleft");
        weaponToSound.Insert("TangoPlasmaRifle","PLREB");
        Super.WorldLoaded(e);
    }
    
     override bool TryGetWeaponReloadInfo(Weapon infoSource, out WeaponReloadInfo output)
     {
        output.soundName = weaponToSound.At(infoSource.GetClassName());
        return super.TryGetWeaponReloadInfo(infoSource,output);
     }
}