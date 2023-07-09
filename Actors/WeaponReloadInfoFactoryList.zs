class WeaponReloadInfoFactoryList : Thinker
{
    array<WeaponReloadInfoFactory> factories;

	WeaponReloadInfoFactoryList Init()
	{
		ChangeStatNum(STAT_INFO);
		return self;
	}
	
	static WeaponReloadInfoFactoryList Get()
	{
		ThinkerIterator it = ThinkerIterator.Create("WeaponReloadInfoFactoryList", STAT_INFO);
		let p = WeaponReloadInfoFactoryList(it.Next());
		if (p == null)
		{
			p = new("WeaponReloadInfoFactoryList").Init();
		}
		return p;
	}
    
    static void Push(WeaponReloadInfoFactory toPush)
    {
        let singleton = WeaponReloadInfoFactoryList.Get();
        singleton.factories.Push(toPush);
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

