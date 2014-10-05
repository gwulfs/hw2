St st;

void setup() {
	size(800, 600);

	st = new St( ez_ellipse(400, 200, 400, 300) );
	// st.ease = Ez.EaseType.CUBIC;
}

void draw() {
	background(200);

	st.draw();
	// st.draw( map(mouseX, 30, width-30, 0, 1) );
}

void mouseClicked() {
	Shape next = null;

	if (!keyPressed) {
		int shapeType = (int) random(0, 3);
		switch (shapeType) {
			case 0:
				next = ez_ellipse(mouseX, mouseY, random(100, 200), random(100, 200));
				break;
			case 1:
				next = ez_rect(mouseX, mouseY, random(10, 300), random(10, 300));
				break;
			case 2:
				next = ez_triangle(mouseX, mouseY, random(mouseX+50, mouseX+200),random(mouseY+50, mouseY+200), random(mouseX-50, mouseX-200),random(mouseY+50, mouseY+200) );
				break;
			case 3:
				next = ez_line(mouseX, mouseY, st.end().x, st.end().y);
				break;
		}
		
		next.rotation = random(-PI, PI);
	}

	st.then( next, 0.8 );

}