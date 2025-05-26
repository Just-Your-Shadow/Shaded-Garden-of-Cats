#version 150

in vec2 texCoord0;
in vec4 vertexColor;
in float isSelected;

uniform sampler2D Sampler0;
uniform vec2 ScreenSize;
uniform float GuiScale;

out vec4 fragColor;

void main() {
    vec4 texColor = texture(Sampler0, texCoord0);

    if (isSelected > 0.5) {
        // Override with solid red highlight
        fragColor = vec4(1.0, 0.0, 0.0, 1.0);
    } else {
        fragColor = texColor;
    }
}