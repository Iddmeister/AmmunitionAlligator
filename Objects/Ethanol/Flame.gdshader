shader_type canvas_item;

uniform sampler2D noise;
uniform vec4 colour1 : hint_color;
uniform vec4 colour2 : hint_color;


void fragment() {
	
	if (texture(TEXTURE, UV).a > 0.0) {
	
		vec4 new;
		
		vec2 uv = vec2(5.0*TIME-UV.x, UV.y);
		
		float grey = (texture(noise, uv).r+texture(noise, uv).g+texture(noise, uv).b)/3.0;
		
		if (grey < 0.4) {
			new = colour1;
			new.a = grey;
		} else if (grey > 0.5) {
			new = colour1;
		} else if (grey > 0.6) {
			new = colour2;
			new.a = grey;
		} else {
			new = colour2;
		}
		COLOR = new;
		
	} else {
		COLOR = vec4(1, 1, 1, 0);
	}

}