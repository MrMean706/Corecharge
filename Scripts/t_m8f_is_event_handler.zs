/* This code is based on StrongholdEventHandler by Ed the Bat.
 * (https://github.com/Realm667/Re-Releases/blob/master/stronghold/zscript.txt)
 */

class t_m8f_is_EventHandler : StaticEventHandler
{

  override void PlayerEntered(PlayerEvent e)
  {
    if (IsTitleMap()) { return; }

    PlayerInfo player = players[e.playerNumber];
    settings = new("t_m8f_is_Settings").init(player);

    if (!settings.isEnabled) { return; }

    let playerPawn = PlayerPawn(players[e.PlayerNumber].mo);
    ResetInventory  (playerPawn);
    ResetWeapons    (playerPawn);
    ResetAmmo       (playerPawn);
  }

  // private: //////////////////////////////////////////////////////////////////

  /** resets health, armor, and droppable inventory items
   */
  private void ResetInventory(PlayerPawn player)
  {
    // reset health and armor
    player.A_SetHealth(player.GetSpawnHealth());
    player.SetInventory("BasicArmor", 0);
    player.SetInventory("HexenArmor", 1);

    // remove everything that is droppable
    Array<string> items;
    Array<int>    itemAmounts;

    for (let item = player.Inv; item; item = item.Inv)
    {
      if(!item.bUNDROPPABLE)
      {
        items.push(item.GetClassName());
        itemAmounts.push(item.amount);
      }
    }
    int size = items.Size();
    for (int i = 0; i < size; ++i)
    {
      player.A_TakeInventory(items[i], itemAmounts[i]);
    }

    // Restore default things
    DropItem drop = player.GetDropItems();
    if (drop != null)
    {
      for(DropItem di = drop; di != null; di=di.Next)
      {
        if(di.Name == "None") { continue; }

        let weapon = (class<Weapon>)(di.Name);
        if (weapon != null) { continue; }

        let ammo = (class<Ammo>)(di.Name);
        if (ammo != null) { continue; }

        let inv = (class<Inventory>)(di.Name);

        if(inv != null)
        {
          player.A_SetInventory(di.Name, di.Amount);
        }
      }
    }
  }

  /** resets weapons, even if they are undroppable
   * ammo should be reset after resetting weapons.
   */
  private void ResetWeapons(PlayerPawn player)
  {
    DropItem drop = player.GetDropItems();

    // remove weapons even if they are undroppable
    // removing an item invalidates the iterator, so
    // 1. remember weapon classes
    Array<string> weapons;
    for (let item = player.Inv; item; item = item.Inv)
    {
      if (item is "Weapon")
      {
        string weaponClass = item.GetClassName();
        weapons.push(weaponClass);
      }
    }

    // 2. Remove remembered weapon classes
    int size = weapons.Size();
    for (int i = 0; i < size; ++i)
    {
      player.A_TakeInventory(weapons[i]);
    }

    // If the player has any weapons in StartItem, set them here
    string lastStartWeapon = ""; // to set default weapon
    if (drop != null)
    {
      for(DropItem di = drop; di != null; di=di.Next)
      {
        if(di.Name == "None") { continue; }

        let weptype = (class<weapon>)(di.Name);

        if(weptype != null)
        {
          lastStartWeapon = di.Name;
          player.A_SetInventory(di.Name, di.Amount);
        }
      }
    }
    if (lastStartWeapon != "")
    {
      let weaponInInv = player.FindInventory(lastStartWeapon);
      player.UseInventory(weaponInInv);
    }
  }

  private void ResetAmmo(PlayerPawn player)
  {
    DropItem drop = player.GetDropItems();

    // Remove all ammo, except that with the UNDROPPABLE flag
    // 1. Remember ammo classes
    Array<string> ammos;
    for (let item = player.Inv; item; item = item.Inv)
    {
      if(item is "Ammo") { ammos.Push(item.GetClassName()); }
    }
    // 2. Remove
    int size = ammos.Size();
    for (int i = 0; i < size; ++i)
    {
      player.A_TakeInventory(ammos[i]);
    }

    //If the player has any ammo in StartItem, set it here
    if (drop != null)
    {
      for(DropItem di = drop; di != null; di = di.Next)
      {
        if (di.Name == "None") { continue; }

        let ammotype = (class<ammo>)(di.Name);
        if (ammotype != null)
        {
          player.A_SetInventory(di.Name, di.Amount * 1);
        }
      }
    }
  }

  private static bool IsTitlemap()
  {
    bool isTitlemap = (level.mapname == "TITLEMAP");
    return isTitlemap;
  }

  // private: //////////////////////////////////////////////////////////////////

  private t_m8f_is_Settings settings;

} // class t_m8f_is_EventHandler
