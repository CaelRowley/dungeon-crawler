shader_type canvas_item;

uniform bool active = false;

void fragment() {
	vec4 previous_color = texture(TEXTURE, UV);
	// vec4 white_color = vec4(1.0, 1.0, 1.0, previous_color.a);
	vec4 white_color = vec4(
		previous_color.r <= 0.1 ? 1.0 : previous_color.r * 3.0, 
		previous_color.g <= 0.1 ? 1.0 : previous_color.g * 3.0, 
		previous_color.b <= 0.1 ? 1.0 : previous_color.b * 3.0, 
		previous_color.a
	);
	vec4 new_color = previous_color;
	if (active) {
		new_color = white_color
	}
	COLOR = new_color;
}