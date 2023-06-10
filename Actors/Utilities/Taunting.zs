Class Taunting
{
    static play void TryEnrage(Actor victim, Actor inflictor, Actor source)
    {
        Actor enraged;
        name victimSpecies = victim.GetSpecies();
        Console.printf("victimSpecies: %s",victimSpecies);
        Switch (victimSpecies)
        {
            case 'ZombieMan':
            case 'ShotgunGuy':
            case 'ChaingunGuy':
            case 'DoomImp':
                Enrage(victim,"BloodGhost", inflictor, source);
                break;
        }
    }
    static play void Enrage(Actor victim, class<Actor> enraged, Actor inflictor, Actor source)
    {
        int health = victim.health;
        vector3 pos = victim.pos;
        Actor newVictim;
        
        victim.A_DamageSelf(victim.health + abs(victim.GetGibHealth()) + 1, "Normal", DMSS_NOPROTECT | DMSS_NOFACTOR);   //Gib the victim
        newVictim = Actor.Spawn(enraged,pos);
        newVictim.damageMobj(inflictor, source, newVictim.health - (health / 2), "Normal", DMG_NO_ARMOR | DMG_FORCED | DMG_NO_FACTOR | DMG_NO_PROTECT | DMG_NO_ENHANCE);
        newVictim.target = source;
    }
}