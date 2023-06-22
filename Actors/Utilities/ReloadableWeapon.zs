Class ReloadableWeapon : Weapon
{
    bool shouldRecoil()
    {
        return CVar.GetCVar("cl_tango_enable_recoil", owner.player).GetBool();
    }

    bool shouldScreenShake()
    {
        return CVar.GetCVar("cl_tango_enable_screen_shake", owner.player).GetBool();
    }
    

    override bool HandlePickup (Inventory item)
	{
        TangoPlayer tangoOwner = TangoPlayer(Owner);
        /*
        Attempting full reload both before and after pickup is needed to handle both
        picking up ammo when completely out and picking up ammo when carried ammo is at
        capacity but the magazine is not full.
        */
        if (shouldFullReload(item, tangoOwner)) tangoOwner.FullReload(AmmoType2, item);
        bool result = Super.HandlePickup(item);
        if (shouldFullReload(item, tangoOwner)) tangoOwner.FullReload(AmmoType2, item);
		return result;
	}
    //AmmoType2 should be ammo NOT currently loaded
    void InstantReload(Inventory ammunition = null)
    {
        int AmmoToTake;
        Inventory loadedAmmo = owner.FindInventory(AmmoType1);
        if (loadedAmmo == null) return;
        Inventory unloadedAmmo = owner.FindInventory(AmmoType2);
        if (unloadedAmmo == null) return;
        int ammoUntilFull = loadedAmmo.MaxAmount - loadedAmmo.Amount;
        int ammoToLoad =  (unloadedAmmo.Amount > ammoUntilFull) ? ammoUntilFull : unloadedAmmo.Amount;
        if (ammunition && (ammoToLoad < ammoUntilFull))
        {
            int ammoToTake = min(ammoUntilFull - ammoToLoad,ammunition.Amount);
            owner.GiveInventory(AmmoType1, ammoToTake);
            ammunition.Amount -= AmmoToTake;
        }
        console.printf("\nCalled InstantReload::ReloadableWeapon.zs");
        console.printf("Calling weapon: %s",self.GetClassName());
        console.printf("Magazine size: %d",loadedAmmo.MaxAmount);
        console.printf("Amount loaded: %d",loadedAmmo.Amount);
        console.printf("Amount unloaded: %d",unloadedAmmo.Amount);
        console.printf("ammoUntilFull: %d",ammoUntilFull);
        console.printf("ammoToLoad: %d",ammoToLoad);
        owner.GiveInventory(AmmoType1, ammoToLoad);
        owner.TakeInventory(AmmoType2, ammoToLoad);
    }
    
    bool shouldFullReload(Inventory item, TangoPlayer tangoOwner)
    {
        if (item.GetClassName() == "TangoBulletBox") console.printf("Checking Bullet Box");
        if (tangoOwner == null) return false;
        if (item is AmmoType2) return true;
        if ((item is "ReloadableWeapon") && (ReloadableWeapon(item).AmmoType2 == AmmoType2)) return true;
        if ((item is "Weapon")&&(Weapon(item).AmmoType1 == AmmoType2)) return true; //EX. Auto-reload normal shotgun when picking up SSG
        if (item is "BackpackItem") return true;
        return false;
    }
    
    override void AttachToOwner(Actor other)
    {
        Super.AttachToOwner(other);
        TangoPlayer castedother = TangoPlayer(other);
        if (castedother != null) castedother.AddReloadable(self);
    }
}