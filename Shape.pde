/* SHAPE: pretty much what it sounds like.
 *
 * A Shape holds everything you need to draw something in once nice, object-oriented place.
 * It's a list of verticies (which can be straight or curved), a position and rotation, and some pretty colors.
 *
 * PUBLIC ATTRIBUTES:
 *		ArrayList<Vertex>	vertecies
 * 					float	x, y
 *								# Note: the coordinates of each vertex are **relative to this x and y, not the global coordinate system!**
 *					color	stroke, fill
 *					float	strokeWeight
 *					float	scaling (1.0 == no change), rotation (radians)
 * METHODS:
 *					void	draw()
 *  	(copy constructor)	Shape(Shape copyme)
 *
 * Because drawing your own shapes vertex-by-vertex is a total pain, there are some primitive
 * shape factory functions that parallel the ones included with Processing:
 *
 *					Shape	ez_line(float x1, float y1, float x2, float y2)
 *					Shape	ez_triangle(float x1, float y1, float x2, float y2, float x3, float y3)
 *					Shape	ez_rect(float center_x, float center_y, float w, float h)
 *					Shape	ez_ellipse(float center_x, float center_y, float w, float h)
 *
 *					(eventually we should make ez_ellipse, but Bezier math sucks.
 *					 well it's not even that bad, I just didn't want to do it after
 *					 how long it took to make a damn circle.)
 *
 * Oh, and also, any two Shapes can be tweened between each other using St. So that's pretty neat.
 */

public class Shape {
	public float x, y;
	public color stroke;
	public color fill;
	public float strokeWeight;
	public float scaling, rotation;

	public ArrayList<Vertex> vertecies;

	public void draw() {
		pushMatrix();
		pushStyle();

		translate(x, y);
		rotate(rotation);
		scale(scaling);

		stroke(stroke);
		fill(fill);
		strokeWeight(strokeWeight);

		beginShape();
		for (Vertex v : vertecies) {
			v.make();
		}
		endShape(CLOSE);

		popMatrix();
		popStyle();
	}

	public Shape() {
		stroke = color(80);
		fill = color(240);
		strokeWeight = 1;
		scaling = 1.0;
		rotation = 0.0;
		vertecies = new ArrayList<Vertex>();
	}
	public Shape(Shape copyme) {
		x = copyme.x;
		y = copyme.y;
		stroke = copyme.stroke;
		fill = copyme.fill;
		strokeWeight = copyme.strokeWeight;
		scaling = copyme.scaling;
		rotation = copyme.rotation;
		vertecies = new ArrayList<Vertex>(copyme.vertecies.size());
		for (Vertex v : copyme.vertecies) {
			vertecies.add( new Vertex(v) );
		}
	}
};

public Shape ez_rect(float center_x, float center_y, float w, float h) {
		Shape s = new Shape();
		s.x = center_x;
		s.y = center_y;
		s.vertecies.add( new Vertex(-w/2.0, -h/2.0) );
		s.vertecies.add( new Vertex(w/2.0, -h/2.0) );
		s.vertecies.add( new Vertex(w/2.0, h/2.0) );
		s.vertecies.add( new Vertex(-w/2.0, h/2.0) );

		return s;
}
public Shape ez_rect(float center_x, float center_y, float w, float h, color col) {
		Shape s = new Shape();
		s.x = center_x;
		s.y = center_y;
		s.fill = col;
		s.vertecies.add( new Vertex(-w/2.0, -h/2.0) );
		s.vertecies.add( new Vertex(w/2.0, -h/2.0) );
		s.vertecies.add( new Vertex(w/2.0, h/2.0) );
		s.vertecies.add( new Vertex(-w/2.0, h/2.0) );

		return s;
}

public Shape ez_ellipse(float center_x, float center_y, float w, float h) {
	// Approximating a circle using Bezier curves: http://www.whizkidtech.redprince.net/bezier/circle/
	Shape s = new Shape();
	s.x = center_x;
	s.y = center_y;

	float kappa = 0.5522847498;
	float h_rad = h/2.0, w_rad = w/2.0;
	float horiz_controlPointDist = kappa * h_rad;
	float vert_controlPointDist  = kappa * w_rad;

	// top
	s.vertecies.add( new Vertex(0, -h_rad));
	// top-right
	s.vertecies.add( new Vertex(w_rad,0, horiz_controlPointDist,-h_rad, w_rad,-vert_controlPointDist) );
	// bottom-right
	s.vertecies.add( new Vertex(0,h_rad, w_rad,vert_controlPointDist, horiz_controlPointDist,h_rad) );
	// bottom-left
	s.vertecies.add( new Vertex(-w_rad,0, -horiz_controlPointDist,h_rad, -w_rad,vert_controlPointDist) );
	// top-left
	s.vertecies.add( new Vertex(0,-h_rad, -w_rad,-vert_controlPointDist, -horiz_controlPointDist,-h_rad) );

	return s;
}

public Shape ez_ellipse(float center_x, float center_y, float w, float h, color col) {
	// Approximating a circle using Bezier curves: http://www.whizkidtech.redprince.net/bezier/circle/
	Shape s = new Shape();
	s.x = center_x;
	s.y = center_y;
	s.fill = col;
	float kappa = 0.5522847498;
	float h_rad = h/2.0, w_rad = w/2.0;
	float horiz_controlPointDist = kappa * h_rad;
	float vert_controlPointDist  = kappa * w_rad;

	// top
	s.vertecies.add( new Vertex(0, -h_rad));
	// top-right
	s.vertecies.add( new Vertex(w_rad,0, horiz_controlPointDist,-h_rad, w_rad,-vert_controlPointDist) );
	// bottom-right
	s.vertecies.add( new Vertex(0,h_rad, w_rad,vert_controlPointDist, horiz_controlPointDist,h_rad) );
	// bottom-left
	s.vertecies.add( new Vertex(-w_rad,0, -horiz_controlPointDist,h_rad, -w_rad,vert_controlPointDist) );
	// top-left
	s.vertecies.add( new Vertex(0,-h_rad, -w_rad,-vert_controlPointDist, -horiz_controlPointDist,-h_rad) );

	return s;
}

/* TODO:
Shape ez_arc(float center_x, center_y, float w, float h, float startAngle, float stopAngle) {
	// Approximating an arc using Bezier curves: http://hansmuller-flex.blogspot.com/2011/04/approximating-circular-arc-with-cubic.html
}
*/

public Shape ez_line(float x1, float y1, float x2, float y2) {
	Shape s = new Shape();
	s.x = x1;
	s.y = y1;
	s.vertecies.add( new Vertex(0, 0) );
	s.vertecies.add( new Vertex(x2-x1, y2-y1) );

	return s;
}

public Shape ez_triangle(float x1, float y1, float x2, float y2, float x3, float y3) {
	Shape s = new Shape();
	s.x = x1;
	s.y = y1;
	s.vertecies.add( new Vertex(0, 0) );
	s.vertecies.add( new Vertex(x2-x1, y2-y1) );
	s.vertecies.add( new Vertex(x3-x1, y3-y1) );

	return s;
}