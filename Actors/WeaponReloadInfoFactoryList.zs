class WeaponReloadInfoFactoryList : Thinker
{
    array<WeaponReloadInfoFactory> factories;

	MyGlobalVariables Init()
	{
		SetStatNum(STAT_INFO);	// this is merely to let the thinker iterator find it quicker.
		return self;
	}
	
	static MyGlobalVariables Get()
	{
		ThinkerIterator it = ThinkerIterator.Create("WeaponReloadInfoFactoryList");
		let p = WeaponReloadInfoFactoryList(it.Next());
		if (p == null)
		{
			p = new("WeaponReloadInfoFactoryList").Init();
		}
		return p;
	}
    
    static void Add(WeaponReloadInfoFactory toAdd)
    {
        //TODO, remember that this is static
    }
    
    static WeaponReloadInfo GetWeaponReloadInfo(Weapon infoSource)
    {
        //TODO
    }
}

