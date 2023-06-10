Class BloodGhost: Actor
{
    Default
    {
        Health 20;
        Radius 16;
        Height 56;
        Speed 16;
        PainChance 170;
        Monster;
        DropItem "HealthBonus";
        +FLOAT;
        +NOGRAVITY;
        +DONTFALL;
        +NOICEDEATH;
        AttackSound "wattack";
        SeeSound "wsight";
        PainSound "wpain";
        DeathSound "wdeath";
        ActiveSound "widle";
        Obituary "%o was spooked by a Blood Ghost.";
    }
    States
    {
    Spawn:
        GHST AABB 3 A_Look;
        Loop;
    See:
        GHST AABB 3 A_Chase;
        Loop;
    Missile:
        #### # 0 A_FaceTarget;
        #### # 0 A_Chase(null, null);
        GHST E 6 Bright A_SpawnProjectile("PlasmaZombiePlasmaBall", 32, 8);
        GHST A 4 A_Chase(null, null);
        #### # 0 A_Chase(null, null);
        GHST E 6 Bright A_CustomComboAttack("TangoImpBall", 32, 16, "whit2");
        #### # 0 A_Chase(null, null);
        GHST B 4  A_MonsterRefire(0,"See");
        Goto Missile;
    Pain:
        GHST F 3 Fast;
        GHST F 3 Fast A_Pain;
        Goto See;
    Death:
        GHST F 4;
        GHST G 4 A_ScreamAndUnblock;
        GHST H 4;
        GHST I 4;
        GHST JKLM 4;
        GHST N 4 {bNOGRAVITY = false;}
        GHST O -1;
    Crash:
        GHST P -1 A_SetFloorClip;
        Stop;
    xDeath:
        TNT1 A 1
        {
            A_NoBlocking();
            A_xScream();
            A_SpawnDebris ("GhostBlood",FALSE,random (1,5),random (1,5));
            A_SpawnDebris ("GhostGib1",FALSE,random (1,5),random (1,3));
            A_SpawnDebris ("GhostGib2",FALSE,random (1,5),random (1,3));
            A_SpawnDebris ("GhostGib3",FALSE,random (1,5),random (1,3));
            A_SpawnDebris ("GhostGib4",FALSE,random (1,5),random (1,3));
            A_SpawnDebris ("GhostGib5",FALSE,random (1,5),random (1,3));
            A_SpawnDebris ("GhostGib6",FALSE,random (1,5),random (1,3));
        }
        Stop;
    }
}
    
Class GhostBlood: Actor
{
  Default
  {
    Mass 5;
    +NOBLOCKMAP;
    +NOTELEPORT;
    Health 30;
    +ALLOWPARTICLES;
  }
  
  States
  {
  Spawn:
    GHG2 HIJK 8;
    Stop;
  }
}
Class GhostGib1: Actor
{
    Default
    {
        Mass 5;
        Health 1;
    }
  
    States
    {
        Spawn:
        GHGB ABCDEFGH 8;
        GHGB A -1;
        Stop;
    }
}
Class GhostGib2: Actor
{
    Default
    {
        Mass 5;
        Health 1;
    }
    States
    {
        Spawn:
        GHGB IJ 8;
        GHGB K -1;
        Stop;
    }
}
Class GhostGib3: Actor
{
    Default
    {
        Mass 5;
        Health 1;
    }
    States
    {
        Spawn:
        GHGB LMN 8;
        GHGB O -1;
        Stop;
    }
}
Class GhostGib4: Actor
{
    Default
    {
        Mass 5;
        Health 1;
    }
    States
    {
        Spawn:
        GHGB QRSTUVW 8;
        GHGB Q -1;
        Stop;
    }
}
Class GhostGib5: Actor
{
    Default
    {
        Mass 5;
        Health 1;
    }
    States
    {
        Spawn:
        GHGB XYZ 8;
        GHG2 ABC 8;
        GHG2 C -1;
        Stop;
    }
}
Class GhostGib6: Actor
{
    Default
    {
        Mass 5;
        Health 1;
        +RANDOMIZE;
    }

    States
    {
        Spawn:
        GHG2 D -1;
        GHG2 E -1;
        GHG2 F -1;
        GHG2 G -1;
        Stop;
    }
}
Class GhostHealthBonus : Health
{
   Default
   {
        +COUNTITEM;
        +INVENTORY.ALWAYSPICKUP;
        Inventory.Amount 1;
        Inventory.MaxAmount 200;
   }   
 
    States
    {
        Spawn:
        GHPK ABCDCB 6 bright;
        Loop;
    }
}