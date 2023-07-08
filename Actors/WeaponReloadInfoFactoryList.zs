class WeaponReloadInfoFactoryList : Thinker
{
    array<WeaponReloadInfoFactory> factories;

	WeaponReloadInfoFactoryList Init()
	{
		ChangeStatNum(STAT_INFO);	// this is merely to let the thinker iterator find it quicker.
		return self;
	}
	
	static WeaponReloadInfoFactoryList Get()
	{
		ThinkerIterator it = ThinkerIterator.Create("WeaponReloadInfoFactoryList");
		let p = WeaponReloadInfoFactoryList(it.Next());
		if (p == null)
		{
			p = new("WeaponReloadInfoFactoryList").Init();
		}
		return p;
	}
    
    static void Push(WeaponReloadInfoFactory toPush)
    {
        WeaponReloadInfoFactoryList.Get().factories.Push(toPush);
    }
    
    static WeaponReloadInfo GetWeaponReloadInfo(Weapon infoSource)
    {
        WeaponReloadInfoFactoryList singleton = WeaponReloadInfoFactoryList.Get();
        WeaponReloadInfo output = new("WeaponReloadInfo");
        
        for (int i = 0; i < singleton.factories.Size(); i++)
        {
            if (singleton.factories[i].TryGetWeaponReloadInfo(infoSource, output)) break;
        }
        return output;
    }
}

