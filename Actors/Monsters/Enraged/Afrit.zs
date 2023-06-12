Class Afrit : Actor
{
  Default
  {
    Health 500;
    Speed 8;
    Radius 24;
    Height 64;
    PainChance 50;
    Mass 500;
    SeeSound "Baron/Sight";
    PainSound "Baron/Pain";
    DeathSound "Baron/Death";
    ActiveSound "Baron/Active";
    Obituary "%o was scorched by an Afrit";
    HitObituary "%o found the Afrit too hot to handle.";
    DamageFactor "HellFire", 0.0;
    Monster;
    +NoGravity
    +NoBlood
    +Float
    +DontHarmClass
  }

  States
  {
  Spawn:
    FRIT ABCD 5 Bright A_Look();
    Loop;
  See:
    FRIT AABBCCDD random(2,3) Bright A_Chase();
    Loop;
  Missile:
    TNT1 A 0 A_Jump(128, "Missile2");
  Melee:
    FRIT ST 4 Bright A_FaceTarget();
    FRIT U 4 Bright A_CustomComboAttack("AfritBall", 44, 10, "Baron/Melee");
    Goto See;
  Missile2:
    FRIT EF 4 Bright A_FaceTarget();
    FRIT G 4 Bright A_SpawnProjectile("Comet", 44);
    Goto See;
  Pain:
    FRIT H 4 Bright;
    FRIT H 4 Bright A_Pain();
    Goto See;
  Death:
    TNT1 A 0 A_NoGravity();
    FRIT I 6 Bright A_Scream();
    FRIT J 5 Bright A_NoBlocking();
    FRIT KLMNOPQR 4 Bright;
    Stop;
  }
}

Class AfritBall : Actor
{
  Default
  {
    Radius 6;
    Height 8;
    Speed 30;
    DamageFunction 36;
    RenderStyle "Add";
    Alpha 0.8;
    SeeSound "Imp/Attack";
    DeathSound "Imp/ShotX";
    Decal "BaronScorch";
    Projectile;
  }

  States
  {
  Spawn:
    FRTM AB 5 Bright;
    Loop;
  Death:
    FRTM CDE 6 Bright;
    Stop;
  }
}

Class Comet : Actor
{
  Default
  {
    Radius 6;
    Height 8;
    Speed 20;
    DamageFunction 23;
    Scale 0.55;
    SeeSound "Afrit/CometFire";
    DeathSound "Afrit/CometHit";
    Decal "Scorch";
    Projectile;
  }

  States
  {
  Spawn:
    COMT AAAABBBBCCCC 1 Bright A_SpawnItemEx("CometTail", 0, 0, 0, 0, 0, 0, 0, 128);
    Loop;
  Death:
    COMT D 3 Bright A_SpawnItemEx("CometDeathGlow", 0, 0, 0, 0, 0, 0, 0, 128);
    COMT E 3 Bright A_Explode(80, 80, 0);
    TNT1 A 0 A_SpawnItemEx("CometDeath", 0, 0, 0, 0, 0, 0, 0, 128);
    Stop;
  }
}

Class CometTail : Actor
{
  Default
  {
    RenderStyle "Add";
    Alpha 0.4;
    Projectile;
    +NoClip
  }
  States
  {
  Spawn:
    FRTB ABCDEFGHI 1 Bright;
    Stop;
  }
}

Class CometDeathGlow : CometTail
{
  Default
  {
    Scale 2.0;
    Alpha 0.6;
  }

  States
  {
  Spawn:
    FRTB ABCDEFGHI 3 Bright;
    Stop;
  }
}

Class CometDeath : Actor
{
  Default
  {
    RenderStyle "Add";
    Alpha 0.7;
    Projectile;
    +NoClip
  }

  States
  {
  Spawn:
    COMT FGHI 3 Bright;
    Stop;
  }
}

