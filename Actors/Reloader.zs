/*
Inventory item that provides the owner with instant reloads when picking up ammo.
*/

Class ReloaderGiver: EventHandler
{
    override void WorldThingSpawned (WorldEvent e)
    {
        PlayerPawn player = PlayerPawn(e.Thing);
        if (player)
        {
            e.Thing.GiveInventoryType("Reloader");
        }
    }
}

Class Reloader: Inventory
{
    bool shouldShift;
     override bool HandlePickup (Inventory item)
	{
        if ((item is "Weapon") && owner) shouldShift = true;
        Inventory playerInv = owner.Inv;
        Weapon playerWeapon;
        TryReload(owner.player.ReadyWeapon, item);
        while (playerInv)
        {
            playerWeapon = Weapon(playerInv);
            if (playerWeapon) TryReload(playerWeapon, item);
            playerInv = playerInv.Inv; 
        }
        bool result = Super.HandlePickup(item);
		return result;
	}
    
    override void Tick()
    {
            if (shouldShift)
            {
                //Guarantee that the reloader is earlier in the owner's inventory than any weapons
                //Needed to make sure this HandlePickup gets called before duplicate weapon handling
                Actor tempOwner = owner;
                owner.RemoveInventory(self);
                CallTryPickup(tempOwner);
                shouldShift = false;
            }
            super.Tick();
        }
    
    void TryReload(Weapon weapon, Inventory item)
    {  
        if (!weapon)
            return;
        WeaponReloadInfo currentReloadInfo = WeaponReloadInfoFactoryList.GetWeaponReloadInfo(Weapon);
        if (!currentReloadInfo.unloadedClass || !currentReloadInfo.loadedClass) return;
        Inventory loadedAmmo = owner.FindInventory(currentReloadInfo.loadedClass);
        if (!loadedAmmo) 
            return;
        Inventory unloadedAmmo = owner.FindInventory(currentReloadInfo.unloadedClass);
        ReloadInternal(weapon, currentReloadInfo, loadedAmmo, unloadedAmmo, item);
    }

    //AmmoType2 should be ammo NOT currently loaded
    protected void ReloadInternal(Weapon weapon, WeaponReloadInfo currentReloadInfo, Inventory loadedAmmo, Inventory unloadedAmmo = null, Inventory item = null)
    {
        int ammoLoaded;
        int ammoUntilFull = loadedAmmo.MaxAmount - loadedAmmo.Amount;
        bool pickupHadAmmo = false;
        if (item is currentReloadInfo.unloadedClass) LoadAmmo(currentReloadInfo,loadedAmmo,pickupHadAmmo,item.Amount);
        Weapon weaponPickup = Weapon(item);
        if (weaponPickup)
        {
            if (weaponPickup.AmmoType1 == currentReloadInfo.unloadedClass) LoadAmmo(currentReloadInfo,loadedAmmo,pickupHadAmmo,weaponPickup.AmmoGive1);
            if (weaponPickup.AmmoType2 == currentReloadInfo.unloadedClass) LoadAmmo(currentReloadInfo,loadedAmmo,pickupHadAmmo,weaponPickup.AmmoGive2);
        }
        if (item is "BackpackItem") pickupHadAmmo = true;
        if (pickupHadAmmo && unloadedAmmo) LoadAmmo(currentReloadInfo,loadedAmmo,pickupHadAmmo,unloadedAmmo.Amount);
        /*
        I don't know how to reduce how much ammo a backpack gives.
        I would rather give extra free ammo if the player picks one up while low on ammo than 
        fail to trigger the reload on pickup.
        */
        if (ammoUntilFull && (item is "BackpackItem")) 
        {
            int temp = -1;  //Creating a temp var, because output params do not accept constants
            LoadAmmo(currentReloadInfo,loadedAmmo,pickupHadAmmo, temp);
        }
        if (pickupHadAmmo) 
        {
            if (currentReloadInfo.soundName) A_StartSound(currentReloadInfo.soundName, CHAN_AUTO);
            item.bPickupGood = true;    //Code that should set this later won't run if a weapon's AmmoGive is reduced to 0
        }
    }
    
    protected void LoadAmmo(WeaponReloadInfo currentReloadInfo, Inventory loadedAmmo, out bool pickupHadAmmo, out int unloadedCount)
    {
        int ammoUntilFull = loadedAmmo.MaxAmount - loadedAmmo.Amount;
        if (!ammoUntilFull)
            return;
        int ammoLoaded =  ammoUntilFull;
        if ((unloadedCount >= 0) && (unloadedCount < ammoLoaded)) ammoLoaded = unloadedCount;
        owner.GiveInventory(currentReloadInfo.loadedClass, ammoLoaded);
        if (unloadedCount >= 0) unloadedCount -= ammoLoaded;
        pickupHadAmmo != ammoLoaded;
    }
    
    Default
    {
        +INVENTORY.UNDROPPABLE
        +INVENTORY.UNCLEARABLE
        +INVENTORY.UNTOSSABLE
    }
}