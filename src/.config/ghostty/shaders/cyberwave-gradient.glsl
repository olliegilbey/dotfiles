// CyberWave Gradient Shader for Ghostty
// Vertical gradient from dark teal to black
// Colors: #0B2430 (top) → #000000 (bottom)

void mainImage(out vec4 fragColor, in vec2 fragCoord)
{
    // Normalize coordinates to 0.0-1.0 range
    vec2 uv = fragCoord.xy / iResolution.xy;

    // Define gradient colors (RGB normalized to 0.0-1.0)
    vec3 topColor = vec3(0.0, 0.0, 0.0);          // #000000 (black)
    vec3 bottomColor = vec3(0.043, 0.141, 0.188); // #0B2430 (dark teal)

    // Vertical gradient (uv.y = 0.0 at bottom, 1.0 at top)
    vec3 gradientColor = mix(bottomColor, topColor, uv.y);

    // Sample original terminal content
    vec4 terminalColor = texture(iChannel0, uv);

    // Create mask: darker terminal pixels get more gradient
    float mask = 1.0 - step(0.1, dot(terminalColor.rgb, vec3(1.0)));

    // Blend gradient with terminal content
    vec3 blendedColor = mix(terminalColor.rgb, gradientColor, mask);

    // Preserve original alpha channel
    fragColor = vec4(blendedColor, terminalColor.a);
}
