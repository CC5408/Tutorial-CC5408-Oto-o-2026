shader_type canvas_item;

uniform vec4 color: source_color = vec4(1.0, 1.0, 1.0, 1.0);
uniform int size = 1;

void fragment() {
	vec2 texel_size = TEXTURE_PIXEL_SIZE * float(size);
	vec4 left = texture(TEXTURE, vec2(UV.x - texel_size.x, UV.y));
	vec4 right = texture(TEXTURE, vec2(UV.x + texel_size.x, UV.y));
	vec4 up = texture(TEXTURE, vec2(UV.x, UV.y - texel_size.y));
	vec4 down = texture(TEXTURE, vec2(UV.x, UV.y + texel_size.y));
	vec4 texture_color = texture(TEXTURE, UV);
	
	float horizontal = max(left.a, right.a);
	float vertical = max(up.a, down.a);
	
	float value = max(horizontal, vertical) * (1.0 - texture_color.a);
	
	COLOR = mix(texture_color, color, value);
}

