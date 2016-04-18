#ifndef __AVATAR__
#define __AVATAR__

#include "engine/utils/types_3d.h"
#include "engine/render/camera.h"
#include "world.h"

#define GRAVITY 20
#define JUMP_HEIGHT 10
#define MOVEMENTSPEED 10
#define MAXSPEED 15

class NYAvatar
{
public:
	NYVert3Df Velocity;
	NYVert3Df Forward;
	NYVert3Df Right;

	NYVert3Df Position;
	NYVert3Df Speed;

	NYVert3Df MoveDir;
	bool Move;
	bool Jump;
	float Height;
	float Width;
	bool avance;
	bool recule;
	bool gauche;
	bool droite;
	bool Standing;
	bool isGrounded;

	NYCamera * Cam;
	NYWorld * World;

	NYAvatar(NYCamera * cam, NYWorld * world)
	{
		Position = NYVert3Df(25, 25, world->_MatriceHeights[25][25]+5);
		Height = 2;
		Width = 0.5;
		Cam = cam;
		avance = false;
		recule = false;
		gauche = false;
		droite = false;
		Standing = false;
		Jump = false;
		World = world;
		isGrounded = false;
	}


	void render(void)
	{
		glutSolidCube(Width);
	}

	void update(float elapsed)
	{
		// Récupération des vecteurs direction
		Forward = Cam->_Direction;
		Right = Cam->_NormVec;

		// Gravity
		Velocity.Z += -GRAVITY * elapsed;

		// Déplacements
		if (Jump && isGrounded) {
			Velocity.Z += JUMP_HEIGHT;
			Jump = false;
			isGrounded = false;
		}
		else {
			Jump = false;
		}

		if (avance) {
			Velocity.X = Forward.X * MOVEMENTSPEED;
			Velocity.Y = Forward.Y * MOVEMENTSPEED;
		}
		else if (recule) {
			Velocity.X = Forward.X * -MOVEMENTSPEED;
			Velocity.Y = Forward.Y * -MOVEMENTSPEED;
		}
		else if (!avance && !recule) {
			Velocity.X = 0;
			Velocity.Y = 0;
		}

		if (gauche) {
			Velocity.X = Right.X * -MOVEMENTSPEED;
			Velocity.Y = Right.Y * -MOVEMENTSPEED;
		}
		else if (droite) {
			Velocity.X = Right.X * MOVEMENTSPEED;
			Velocity.Y = Right.Y * MOVEMENTSPEED;
		}

		float colMinValue = 0;
		NYAxis axis;
		for (int i = 0; i < 3; i++) {
			axis = World->getMinCol(Position + Velocity * elapsed, Width, Height, colMinValue, i);

			if (axis == NY_AXIS_Z) {
				Velocity.Z = -Velocity.Z * 0.001;
				isGrounded = true;
			}
			if (axis == NY_AXIS_X) {
				Velocity.X = -Velocity.X * 0.001;
			}
			if (axis == NY_AXIS_Y) {
				Velocity.Y = -Velocity.Y * 0.001;
			}
		}

		if (Velocity.getSize() > MAXSPEED) {
			Velocity.normalize();
			Velocity *= MAXSPEED;
		}

		//cout << Velocity.getSize() << endl;

		Position += Velocity * elapsed;
		Cam->moveTo(Position);
	}
};

#endif