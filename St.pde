/* St: SHAPE TWEENER
 *     smoothly animates between any two arbitrary shapes
 *     like lerp() for shapes (except not necessarily linear, if that's not what you're into)
 *
 * An St takes two Shape instances (which are just nice buckets to toss sequences of vertecies into),
 * and morphs between the two. It does this by mapping each vertex from the start shape onto a vertex in the end
 * shape, and interpolating between them. (If the number of verticies aren't equal, that's the fun part. Some
 * verticies will map to multiple other verticies, based on picking the closest vertex that preserves order.)
 *
 * If morphing isn't your thing, St is still a nice way just to animate stuff moving. Shapes have x, y, rotation, and scaling
 * parameters; just give the same shape for start and end, but change those params.
 *
 * BORING METHODS:
 *		(constructor)    new St(Shape s)
 *		(constructor)    new St(Shape start, Shape end)
 *				void	 start(Shape s) *setter*
 *				void	 end(Shape s)   *setter*
 *				Shape	 start()        *getter*
 *				Shape	 end()          *getter*
 *							 note: the Shape instances you give are just referenced, not copied.
 *							       If you change them later and don't tell anyone, weird stuff will happen.
 *								   Just please don't. That's why we give you getters and setters.
 *							 Also, if you give null as the end shape, it will animate into a single point of nothingness.
 *
 * THE COOLER STUFF:
 *				void	then(Shape next, [float duration, [float delay]])
 *							# animate from the current end shape to this given shape 'next'
 *							# optionally, specify a duration for the animation and delay before it starts (in seconds)
 *
 *				void	draw()
 *							# use this if you've set an animation duration using .then()
 *				void	draw(float t)
 *							# draw the interpolation between the start and end shapes 't' percent of the way
 *							# (t isn't actually a percentage. it should be between 0.0 and 1.0.)
 *							# use this to control animation by something besides time (e.g. mouse position)
 *
 *				void	reverse()
 *							# oops, wrong way!
 *
 *		 Ez.EaseType    ease 	*public attribute*
 *							# set the easing function (e.g. Ez.EaseType.LIN, Ez.EaseType.SIN, Ez.EaseType.CUBIC)
 *
 * SOME TIPS:
 * So the shape morphing is _decent_, but sometimes can look really weird. (Call it interperative modern art.)
 * Weirdness mostly occurs when vertecies cross over each other as they're transitioning.
 * Sometimes this is unavoidable (short of an actually intelligent algorithm), but in general,
 * always sequencing your verticies the same direction around your shapes will help.
 *
 * The built-in ez_shapes all go clockwise from the top (top, then right, then bottom, then left), so stick with that.
 */

public class St {
	public Ez.EaseType ease;
	public void draw() {
		float t = constrain( map(frameCount, startFrame, endFrame, 0, 1) , 0.0, 1.0);
		if (t == 0) start.draw();
		else if (t == 1.0) end.draw();
		else draw(t);
	}
	public float gett(){
		return constrain( map(frameCount, startFrame, endFrame, 0, 1) , 0.0, 1.0);
	}
	public void draw(float t) {
		pushMatrix();
		pushStyle();
		translate( Ez.ease(start.x, end.x, t, ease),
				   Ez.ease(start.y, end.y, t, ease) );
		rotate( Ez.ease(start.rotation, end.rotation, t, ease) );
		scale( Ez.ease(start.scaling, end.scaling, t, ease) );

		//TODO: Ez color tweening?
		stroke( lerpColor(start.stroke, end.stroke, t) );
		fill( lerpColor(start.fill, end.fill, t) );
		strokeWeight( Ez.ease(start.strokeWeight, end.strokeWeight, t, ease) );

		beginShape();
		for (Vt v : tweens) {
			v.make(t);
		}
		endShape(CLOSE);

		popMatrix();
		popStyle();
	}

	public St(Shape s) {
		start = s;
		end = s;
		tweens = new ArrayList<Vt>(end.vertecies.size());
		ease = Ez.EaseType.SIN;
		makeTweens();
	}
	public St(Shape _start, Shape _end) {
		start = _start;
		end = _end;
		tweens = new ArrayList<Vt>( max(start.vertecies.size(), end.vertecies.size()) );
		ease = Ez.EaseType.SIN;
		makeTweens();
	}

	public void then(Shape next, float duration, float delay) {
		then(next);
		startFrame = frameCount + int(delay * frameRate);
		endFrame = startFrame + int(duration * frameRate);
	}
	public void then(Shape next, float duration) {
		then(next);
		startFrame = frameCount;
		endFrame = startFrame + int(duration * frameRate);
	}
	public void then(Shape next) {
		if (next != null || (next == null && end != null)) {
			start = end;
			end = next;
			makeTweens();
		}
	}

	public void start(Shape _start) {
		if (_start != null) {
			start = _start;
			makeTweens();
		}
	}
	public void end(Shape _end) {
		end = _end;
		makeTweens();
	}

	public Shape start() {
		return start;
	}
	public Shape end() {
		return end;
	}

	public void reverse() {
		for (Vt v : tweens) {
			v.reverse();
		}
		Shape temp;
		temp = start;
		start = end;
		end = temp;
	}

	private Shape start;
	private Shape end;
	private int startFrame;
	private int endFrame;
	private ArrayList<Vt> tweens;
	private void makeTweens() {
		tweens.clear();

		if (end == null) {
			end = new Shape(start);
			end.vertecies.clear();
			end.vertecies.add(new Vertex(0, 0));
		}

		boolean growing = end.vertecies.size() > start.vertecies.size();
		ArrayList<Vertex> from = growing ? end.vertecies : start.vertecies;
		ArrayList<Vertex> onto = growing ? start.vertecies : end.vertecies;
		tweens.ensureCapacity(from.size());

		Vertex current_onto = onto.get(0), prev_onto = null;
		Vertex on_tutu_use = null;
		int onto_i = 0;
		int from_remaining = from.size();
		int onto_remaining = onto.size();
		float current_dist, prev_dist;

		for (Vertex v_from : from) {
			// no choice---nothing left to map onto but this
			if (current_onto == null) on_tutu_use = prev_onto;
			else {
				if (prev_onto == null || from_remaining <= onto_remaining)
					// must advance---either no previous option to compare to, or reusing a previous vertex would mean not enough vertecies would be left to map from in order for all in the destination to be mapped onto
					on_tutu_use = current_onto;
				else {
					// choose between the closer of the current and previous
					current_dist = (v_from.x - current_onto.x)*(v_from.x - current_onto.x) + (v_from.y - current_onto.y)*(v_from.y - current_onto.y);
					prev_dist = (v_from.x - prev_onto.x)*(v_from.x - prev_onto.x) + (v_from.y - prev_onto.y)*(v_from.y - prev_onto.y);
					
					on_tutu_use = prev_dist < current_dist ? prev_onto : current_onto;
				}
			}
			if (on_tutu_use == current_onto) {
				onto_remaining--;
				onto_i++;
				prev_onto = current_onto;
				current_onto = onto_remaining > 0 ? onto.get(onto_i) : null;
			}

			from_remaining--;
			Vt tween = growing ? new Vt(on_tutu_use, v_from) : new Vt(v_from, on_tutu_use);
			tween.ease = ease;
			tweens.add(tween);
		}
	}
}