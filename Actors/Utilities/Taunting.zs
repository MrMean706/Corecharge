Class Taunting
{
    void TryEnrage(Actor victim)
    {
        Actor enraged;
        name victimSpecies;
        Switch (victim.GetSpecies())
        {
            case ("ZombieMan"):
            case ("ShotgunGuy"):
            case ("ChaingunGuy"):
                Enrage(victim,"BloodGhost");
                break;
        }
    }
    void Enrage(Actor victim, class<Actor> enraged)
    {
        int health = victim.health;
        vector3 pos = victim.pos;
        Actor newVictim;
        
        victim.A_DamageSelf(victim.health + victim.GetGibHealth() + 1, "Normal", DMSS_NOPROTECT | DMSS_NOFACTOR);   //Gib the victim
        newVictim = Spawn(enraged,pos);
        newVictim.health = health / 2;
        
    }
}