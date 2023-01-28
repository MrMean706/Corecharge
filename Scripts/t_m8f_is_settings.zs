class t_m8f_is_Settings
{

  // public: ///////////////////////////////////////////////////////////////////

  t_m8f_is_Settings init(PlayerInfo player)
  {
    read(player);

    return self;
  }

  void read(PlayerInfo player)
  {
    isEnabled = CVar.GetCVar("t_m8f_wm_PistolStart", player).GetBool();
  }

  // public: ///////////////////////////////////////////////////////////////////

  bool   isEnabled;

} // class t_m8f_is_Settings
