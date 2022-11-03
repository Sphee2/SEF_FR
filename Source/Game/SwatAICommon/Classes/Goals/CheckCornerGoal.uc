///////////////////////////////////////////////////////////////////////////////
// MirrorCornerGoal.uc - MirrorCornerGoal class
// this goal is given to a Officer to mirror a corner

class CheckCornerGoal extends OfficerCommandGoal;
///////////////////////////////////////////////////////////////////////////////

///////////////////////////////////////////////////////////////////////////////
// 
// Variables

// copied to our action
var(parameters) Actor TargetMirrorPoint;
var(parameters) vector CommandOrigin;

///////////////////////////////////////////////////////////////////////////////
// 
// Constructors

overloaded function construct( AI_Resource r )
{
    // don't use this constructor
	assert(false);
}

overloaded function construct( AI_Resource r, Actor inTargetMirrorPoint , vector inCommandOrigin )
{
    Super.construct(r);
	 
    assert(inTargetMirrorPoint != None);
    TargetMirrorPoint = inTargetMirrorPoint;
	CommandOrigin = inCommandOrigin;
}

///////////////////////////////////////////////////////////////////////////////
defaultproperties
{
    priority   = 90
    goalName   = "CheckCorner"
}