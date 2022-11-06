shader_type canvas_item;

uniform bool hit = false;

void fragment() {
	if (hit) {
		COLOR = vec4(1, 1, 1, texture(TEXTURE, UV).a)
	} else {
		COLOR = texture(TEXTURE, UV);
	}
}