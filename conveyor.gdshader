shader_type canvas_item;

uniform float offset_x = 0.0;

void fragment() {
    vec2 uv2 = UV;
    uv2.x += offset_x;
    uv2 = fract(uv2); // makes perfect tiling
    COLOR = texture(TEXTURE, uv2);
}
