shader_type canvas_item;

uniform vec2 player_position = vec2(0.0, 0.0); // Player's position
uniform float max_distance : hint_range(1.0, 500.0) = 100.0; // Maximum distance for full transparency

void fragment() {
    // Calculate the distance from the player
    float distance = distance(player_position, SCREEN_UV);

    // Calculate the alpha (transparency) based on the distance
    float alpha = 1.0 - smoothstep(0.0, max_distance, distance);

    // Set the color with adjusted alpha
    COLOR = vec4(0.0, 0.0, 0.0, alpha);
}
