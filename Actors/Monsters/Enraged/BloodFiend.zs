Class Bloodfiend : Demon
{
  Default
  {
    Health 75;
    Speed 10;
    Mass 450;
    //Obituary "%o died from the toxic blood of a bloodfiend.";
    HitObituary "%o was eaten by a bloodfiend.";
    SeeSound "Monster/sg2sit";
    AttackSound "Monster/sg2atk";
    PainSound "demon/Pain";
    DeathSound "demon/Death";
    ActiveSound "demon/sg2act";
  }

  States
  {
  Spawn:
    SAR2 AB 5 A_Look();
    Loop;
  See:
    SAR2 AABBCCDD 1 A_Chase();
    Loop;
  Melee:
    SAR2 EF 3 A_FaceTarget();
    SAR2 G 2 A_CustomMeleeAttack(20, "mechademon/attack");
    Goto See;
  Pain:
    SAR2 H 1;
    SAR2 H 1 A_Pain();
    Goto See;
  Death.Massacre:
		TNT1 A 0 A_Scream;
		TNT1 A 0 A_NoBlocking;
		SAR2 N -1;
		Stop;
  Death:
    SAR2 I 8;
    SAR2 J 8 A_Scream();
    SAR2 K 4;
    SAR2 L 4 A_NoBlocking();
    SAR2 M 4;
    SAR2 N -1;
    Stop;
  XDeath:
    SAR2 O 5;
    SAR2 P 5 A_XScream();
    SAR2 Q 5 A_NoBlocking();
    SAR2 RSTUV 5;
    SAR2 W -1;
    Stop;
  Raise:
    SAR2 NMLKJI 5;
    Goto See;
  }
}