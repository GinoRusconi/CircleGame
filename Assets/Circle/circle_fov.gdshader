shader_type canvas_item;

uniform float speed = 1.0;      // Velocidad de rotación
uniform float cone_width = -2.5; // Ancho del cono en radianes
uniform float inner_radius = 0.0;
uniform float outer_radius = 1.0;

void fragment() {
    vec2 uv = UV * 2.0 - 1.0; // UV en [-1, 1]

    float r = length(uv);
    float angle = atan(uv.y, uv.x);

    // Ángulo rotado automáticamente con el tiempo
    float rotation_angle = TIME * speed;

    // Normalizar diferencia angular
    float diff = abs(angle - rotation_angle);
    diff = mod(diff + 3.14159, 6.28318) - 3.14159;

    // Corte por cono
    if (diff > cone_width) {
        discard;
    }

    // Corte radial
    if (r < inner_radius || r > outer_radius) {
        discard;
    }

    COLOR = texture(TEXTURE, UV);
}
