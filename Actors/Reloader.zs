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
        if (ammoUntilFull && (item is currentReloadInfo.unloadedClass))
        {
            [ammoLoaded, ammoUntilFull] = LoadAmmo(ammoUntilFull,item.Amount,currentReloadInfo);
            item.Amount -= ammoLoaded;
            pickupHadAmmo = pickupHadAmmo || (ammoLoaded > 0);
        }
        Weapon weaponPickup = Weapon(item);
        if (weaponPickup)
        {
            if (ammoUntilFull && (weaponPickup.AmmoType1 == currentReloadInfo.unloadedClass))
            {
                [ammoLoaded, ammoUntilFull] = LoadAmmo(ammoUntilFull,weaponPickup.AmmoGive1,currentReloadInfo);
                weaponPickup.AmmoGive1 -= ammoLoaded;
                pickupHadAmmo = pickupHadAmmo || (ammoLoaded > 0);
            }
            if (ammoUntilFull && (weaponPickup.AmmoType2 == currentReloadInfo.unloadedClass))
            {
                [ammoLoaded, ammoUntilFull] = LoadAmmo(ammoUntilFull,weaponPickup.AmmoGive2,currentReloadInfo);
                weaponPickup.AmmoGive2 -= ammoLoaded;
                pickupHadAmmo = pickupHadAmmo || (ammoLoaded > 0);
            }
        }
        if (item is "BackpackItem") pickupHadAmmo = true;
        if (ammoUntilFull && pickupHadAmmo && unloadedAmmo)
        {
            [ammoLoaded, ammoUntilFull] = LoadAmmo(ammoUntilFull,unloadedAmmo.Amount,currentReloadInfo);
            owner.TakeInventory(currentReloadInfo.unloadedClass, ammoLoaded);
            
        }
        if (ammoUntilFull && (item is "BackpackItem"))
        {
            /*
            I don't know how to reduce how much ammo a backpack gives.
            I would rather give extra free ammo if the player picks one up while low on ammo than 
            fail to trigger the reload on pickup.
            */
            [ammoLoaded, ammoUntilFull] = LoadAmmo(ammoUntilFull,ammoUntilFull,currentReloadInfo);
             pickupHadAmmo = pickupHadAmmo || (ammoLoaded > 0);
        }    
        if (pickupHadAmmo) 
        {
            if (currentReloadInfo.soundName) A_StartSound(currentReloadInfo.soundName, CHAN_AUTO);
            item.bPickupGood = true;    //Code that should set this later won't run if a weapon's AmmoGive is reduced to 0
        }
    }
    
    protected int, int LoadAmmo(int ammoUntilFull, int maxLoad, WeaponReloadInfo currentReloadInfo)
    {
        int ammoLoaded =  min(ammoUntilFull, maxLoad);
        owner.GiveInventory(currentReloadInfo.loadedClass, ammoLoaded);
        ammoUntilFull -= ammoLoaded;
        return ammoLoaded, ammoUntilFull;
    }
    
    Default
    {
        +INVENTORY.UNDROPPABLE
        +INVENTORY.UNCLEARABLE
        +INVENTORY.UNTOSSABLE
    }
}