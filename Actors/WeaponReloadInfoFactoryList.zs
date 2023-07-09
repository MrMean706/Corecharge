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
        if (DEBUG_RELOAD_HELPER)
        {
            console.printf("Pushed new factory. Current List: ");
            console.printf(singleton.ToString());
        }
    }
    
    static WeaponReloadInfo GetWeaponReloadInfo(Weapon infoSource)
    {
        WeaponReloadInfoFactoryList singleton = WeaponReloadInfoFactoryList.Get();
        WeaponReloadInfo output = new("WeaponReloadInfo");
        for (int i = 0; i < singleton.factories.Size(); i++)
        {
            if (singleton.factories[i].TryGetWeaponReloadInfo(infoSource, output)) break;
        }
        /*if (DEBUG_RELOAD_HELPER)
        {
            console.printf("Created reload info:");
            if (output) console.printf(output.ToString());
        }*/
        return output;
    }
    
    string ToString()
    {
        String output = String.Format("%p = %s", self, self.GetClassName());
        for (int i = 0; i < factories.Size(); i++)
        {
            output = output .. "\n" .. factories[i].ToString();
        }
        return output;
    }
}

