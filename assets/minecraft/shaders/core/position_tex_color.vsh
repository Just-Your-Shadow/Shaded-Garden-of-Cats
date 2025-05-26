#version 150

in vec3 Position;
in vec2 UV0;
in vec4 Color;

uniform sampler2D Sampler0;
uniform mat4 ModelViewMat;
uniform mat4 ProjMat;
uniform vec2 ScreenSize;
uniform float GuiScale;

out vec2 texCoord0;
out vec4 vertexColor;
out float isSelected;

void main() {
    vec3 finalPos = Position;

    float guiScale = ScreenSize.x * 0.5 * ProjMat[0][0];
    vec2 anchor2D = vec2(ScreenSize.x * 0.5, ScreenSize.y) / guiScale;
    vec3 anchor3D = vec3(anchor2D, 0.0);

    // World-space bounds for the fuckit region
    vec3 fuckit1 = vec3(-1000.0, -1000.0, 400);
    vec3 fuckit2 = vec3(1000.0, 1000, 400);

    vec3 relative3D = Position - anchor3D;

    isSelected = 0.0;

    // ---- UV bounds for XP/jump bar elements on a 1024x1024 atlas ----
    bool isXPElement =
        // experience_bar_background
        (UV0.x >= 728.0 / 1024.0 && UV0.x <= (728.0 + 182.0) / 1024.0 &&
         UV0.y >= 552.0 / 1024.0 && UV0.y <= (552.0 + 6.0) / 1024.0) ||

        // experience_bar_progress
        (UV0.x >= 728.0 / 1024.0 && UV0.x <= (728.0 + 182.0) / 1024.0 &&
         UV0.y >= 562.0 / 1024.0 && UV0.y <= (562.0 + 6.0) / 1024.0) ||

        // jump_bar_background
        (UV0.x >= 728.0 / 1024.0 && UV0.x <= (728.0 + 182.0) / 1024.0 &&
         UV0.y >= 592.0 / 1024.0 && UV0.y <= (592.0 + 5.0) / 1024.0) ||

        // jump_bar_cooldown
        (UV0.x >= 364.0 / 1024.0 && UV0.x <= (364.0 + 182.0) / 1024.0 &&
         UV0.y >= 597.0 / 1024.0 && UV0.y <= (597.0 + 5.0) / 1024.0) ||

        // jump_bar_progress
        (UV0.x >= 546.0 / 1024.0 && UV0.x <= (546.0 + 182.0) / 1024.0 &&
         UV0.y >= 597.0 / 1024.0 && UV0.y <= (597.0 + 5.0) / 1024.0);

    // Step 1: move XP/jump bar elements
    if (isXPElement) {
        finalPos.y += 1.9;
    }

    // Step 2: re-evaluate 3D position after movement
    vec3 moved3D = finalPos - anchor3D;

    // Step 3: apply fuckit offset if in region and not an XP element
    bool inFuckit = all(greaterThanEqual(moved3D, fuckit1)) &&
                    all(lessThanEqual(moved3D, fuckit2));

    if (inFuckit && !isXPElement) {
        finalPos.y += 2.9;
        isSelected = 0.0;
    }

    gl_Position = ProjMat * ModelViewMat * vec4(finalPos, 1.0);
    texCoord0 = UV0;
    vertexColor = mix(Color, vec4(1.0, 0.0, 0.0, 1.0), isSelected);
}
