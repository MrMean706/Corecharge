Class Movement
{
    /* 
    Apply full 3D knockback in a specific direction, useful for hitscan
    Velocity added is:
        Negligible when Victim.Mass >> HitMass
        HitVelocity / 2 when Victim.Mass == HitMass
        HitVelocity when Victim.Mass << HitMass
    */
	static play void DoKnockback( Actor Victim, Vector3 HitVelocity, double HitMass)
	{
		if ( !Victim ) return;
		if ( Victim.bDORMANT )	return; // no dormant knockback
		if ( !Victim.bSHOOTABLE && !Victim.bVULNERABLE )return;
		if ( Victim.bDONTTHRUST || (Victim.Mass >= Actor.LARGE_MASS) ) return;
        //Console.Printf("HitVelocity: "..HitVelocity);
		Victim.vel += HitVelocity * HitMass / (HitMass + Victim.Mass);
	}
}