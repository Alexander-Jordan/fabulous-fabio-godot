shader_type canvas_item;

uniform sampler2D screen_texture: hint_screen_texture;
uniform float alpha_value = 0.0;
uniform float scale_value = 0.0;

void vertex() {
	VERTEX *= scale_value;
}

void fragment() {
	COLOR = texture(screen_texture, SCREEN_UV);
	COLOR.a = texture(TEXTURE, UV).a * alpha_value;
	COLOR.rgb += vec3(-0.05, -0.05, -0.05);
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
