shader_type canvas_item;

// World position of the reveal area center
uniform vec2 reveal_world_position = vec2(0.0, 0.0);
// World position of this sprite (the cover)
uniform vec2 cover_world_position = vec2(0.0, 0.0);

// Size of the reveal area in world units (pixels)
uniform vec2 reveal_size = vec2(100.0, 100.0);

// Feather/smoothness of the reveal edge
uniform float feather : hint_range(0.0, 50.0) = 10.0;

// Choose reveal mode: 0 = circular, 1 = rectangular
uniform int reveal_mode : hint_range(0, 1) = 0;

void fragment() {
    vec4 original_color = texture(TEXTURE, UV);

    // Calculate world position of current fragment
    // VERTEX is in local space, we need to offset by the sprite's world position
    vec2 world_pos = VERTEX + cover_world_position;

    float reveal_amount = 0.0;

    if (reveal_mode == 0) {
        // Circular reveal
        vec2 diff = world_pos - reveal_world_position;
        float dist = length(diff);
        float radius = reveal_size.x * 0.5; // Use half of size as radius
        reveal_amount = 1.0 - smoothstep(radius - feather, radius + feather, dist);

    } else {
        // Rectangular reveal
        vec2 half_size = reveal_size * 0.5;
        vec2 diff = abs(world_pos - reveal_world_position);

        // Check if inside rectangle with feathering
        float edge_x = smoothstep(half_size.x + feather, half_size.x - feather, diff.x);
        float edge_y = smoothstep(half_size.y + feather, half_size.y - feather, diff.y);
        reveal_amount = edge_x * edge_y;
    }

    // Apply the reveal: make transparent where revealed
    COLOR = original_color;
    COLOR.a *= (1.0 - reveal_amount);
}