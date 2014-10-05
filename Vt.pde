public class Vt {
	Vertex start;
	Vertex end;
	Ez.EaseType ease;

	public void make(float t) {
		int numControls = max(start.type, end.type);
		switch (numControls) {
			case STRAIGHT:	// both STRAIGHT
				vertex( Ez.ease(start.x, end.x, t, ease),
						Ez.ease(start.y, end.y, t, ease) );
				break;
			case QUADRATIC: // QUADRATIC, or QUADRATIC and STRAIGHT
				float start_c1_x = start.type == QUADRATIC ? start.c1_x : start.x;
				float start_c1_y = start.type == QUADRATIC ? start.c1_y : start.y;
				float end_c1_x = end.type == QUADRATIC ? end.c1_x : end.x;
				float end_c1_y = end.type == QUADRATIC ? end.c1_y : end.y;

				quadraticVertex( Ez.ease(start_c1_x, end_c1_x, t, ease),
								 Ez.ease(start_c1_y, end_c1_y, t, ease),
								 Ez.ease(start.x, end.x, t, ease),
								 Ez.ease(start.y, end.y, t, ease) );

				break;
			case BEZIER: // BEZIER, or BEZIER and QUADRATIC, or BEZIER and STRAIGHT
					  start_c1_x = start.type == BEZIER || start.type == QUADRATIC ? start.c1_x : start.x;
					  start_c1_y = start.type == BEZIER || start.type == QUADRATIC ? start.c1_y : start.y;
				float start_c2_x = start.type == BEZIER ? start.c2_x : start.x;
				float start_c2_y = start.type == BEZIER ? start.c2_y : start.y;
					  end_c1_x = end.type == BEZIER || start.type == QUADRATIC ? end.c1_x : end.x;
					  end_c1_y = end.type == BEZIER || start.type == QUADRATIC ? end.c1_y : end.y;
				float end_c2_x = end.type == BEZIER ? end.c2_x : end.x;
				float end_c2_y = end.type == BEZIER ? end.c2_y : end.y;

				bezierVertex( Ez.ease(start_c1_x, end_c1_x, t, ease),
							  Ez.ease(start_c1_y, end_c1_y, t, ease),
							  Ez.ease(start_c2_x, end_c2_x, t, ease),
							  Ez.ease(start_c2_y, end_c2_y, t, ease),
							  Ez.ease(start.x, end.x, t, ease),
							  Ez.ease(start.y, end.y, t, ease) );

				break;
		}
	}

	public void reverse() {
		Vertex temp;
		temp = start;
		start = end;
		end = temp;
	}

	public float x(float t) {
		return Ez.ease(start.x, end.x, t, ease);
	}
	public float y(float t) {
		return Ez.ease(start.y, end.y, t, ease);
	}

	public Vt(Vertex v) {
		start = v;
		end = new Vertex(v);
		ease = Ez.EaseType.SIN;
	}
	public Vt(Vertex _start, Vertex _end) {
		start = _start;
		end = _end;
		ease = Ez.EaseType.SIN;
	}

}