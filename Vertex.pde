public static final int STRAIGHT = 1; //poor man's enum (cause you can't make enums, or static members, in p5 subclasses derp)
public static final int QUADRATIC = 2;
public static final int BEZIER = 3;

public class Vertex {
	int type;
	float x;
	float y;
	float c1_x;
	float c1_y;
	float c2_x;
	float c2_y;

	public Vertex(int _type) {
		if (_type < STRAIGHT || _type > QUADRATIC) {
			println("Unknown vertex type. Use Vertex.STRAIGHT, Vertex.BEZIER, or Vertex.QUADRATIC");
		}
		type = _type;
	}
	public Vertex(float _x, float _y) {
		type = STRAIGHT;
		x = _x;
		y = _y;
	}
	public Vertex(float _x, float _y, float _c1_x, float _c1_y) {
		type = QUADRATIC;
		x = _x;
		y = _y;
		c1_x = _c1_x;
		c1_y = _c1_y;
	}
	public Vertex(float _x, float _y, float _c1_x, float _c1_y, float _c2_x, float _c2_y) {
		type = BEZIER;
		x = _x;
		y = _y;
		c1_x = _c1_x;
		c1_y = _c1_y;
		c2_x = _c2_x;
		c2_y = _c2_y;
	}

	public Vertex(Vertex copyme) {
		type = copyme.type;
		x = copyme.x;
		y = copyme.y;
		c1_x = copyme.c1_x;
		c1_y = copyme.c1_y;
		c2_x = copyme.c2_x;
		c2_y = copyme.c2_y;
	}

	public void make() {
		switch (type) {
			case STRAIGHT:
				vertex(x, y);
				break;
			case QUADRATIC:
				quadraticVertex(c1_x, c1_y, x, y);
				break;
			case BEZIER:
				bezierVertex(c1_x, c1_y, c2_x, c2_y, x, y);
				break;
		};
	}

};
