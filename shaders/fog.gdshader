shader_type canvas_item;

uniform float fade_speed : hint_range(0.0, 1.0) = 0.01; // Speed at which the fog fades
uniform float time : hint_range(0.0, 1.0) = 0.0; // Time variable

void fragment() {
    COLOR = vec4(0.0, 0.0, 0.0, 1.0 - time);
}
