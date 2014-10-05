class Ez {

	public enum EaseType {
		LIN, SIN, CUBIC
	};

	public static float ease(float from, float to, float amt, EaseType type) {
		switch (type) {
			case LIN:
			default:
				return from + (to - from) * amt;
			case SIN:
				return from + (to - from) * (float)Math.sin(amt * Math.PI/2);
			case CUBIC:
				// TODO: this is just cubic-in, implement cubic-both (or at least cubic-out) instead
				return from + ((to - from) * amt * amt * amt);
		}
	}

};