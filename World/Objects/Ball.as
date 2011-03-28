/*****************************************************************
* This class represents a simple cirular object, ie. a ball.
*****************************************************************/

public class Ball extends MovieClip implements ScopableObject
{
	private var xVelocity;
	private var yVelocity;

	public function Ball(xPos:int, yPos:int, xVel:int = 0, yVel:int = 0)
	{
		x = xPos;
		y = yPos;
		xVelocity = xVel;
		yVelocity = yVel;
	}

	public function onEnterFrame()
	{
		x += xVelocity;
		y += yVelocity;
	}

}
