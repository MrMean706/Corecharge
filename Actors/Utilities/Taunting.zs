Class Taunting
{
    static play void TryEnrage(Actor victim, Actor inflictor, Actor source)
    {
        name victimSpecies = victim.GetSpecies();
        Console.printf("victimSpecies: %s",victimSpecies);
        class<Actor> enrageTo;
        Switch (victimSpecies)
        {
            case 'ZombieMan':
            case 'ShotgunGuy':
            case 'ChaingunGuy':
            case 'DoomImp':
                enrageTo = "BloodGhost";
                break;
            case 'Demon':
                enrageTo = "BloodFiend";
                break;
            case 'Caco':
                enrageTo = "Gazer";
                break;
        }
        if (victim is enrageTo)
            return;
        if (enrageTo) Enrage(victim, enrageTo, inflictor, source);    
    }
    static play void Enrage(Actor victim, class<Actor> enraged, Actor inflictor, Actor source)
    {
        int health = victim.health;
        vector3 pos = victim.pos;
        Actor newVictim;
        
        victim.A_DamageSelf(victim.health + abs(victim.GetGibHealth()) + 1, "Normal", DMSS_NOPROTECT | DMSS_NOFACTOR);   //Gib the victim
        if(!enraged)
            return;
        newVictim = Actor.Spawn(enraged,pos);
        newVictim.damageMobj(inflictor, source, newVictim.health - (health / 2), "Normal", DMG_NO_ARMOR | DMG_FORCED | DMG_NO_FACTOR | DMG_NO_PROTECT | DMG_NO_ENHANCE);
        inflictor.A_AlertMonsters();
        Console.printf("Enraged enemy health: %d",newVictim.health);
        newVictim.target = source;
    }
}