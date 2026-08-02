varying vec2 v_vTexcoord;
varying vec4 v_vColour;

uniform float u_time;
uniform float u_intensity;

void main()
{
    if (u_intensity <= 0.0) {
        gl_FragColor = v_vColour * texture2D(gm_BaseTexture, v_vTexcoord);
    } else {
        // Multi-frequency sine wave distortion simulating rising heat waves
        float wave = sin(v_vTexcoord.y * 35.0 + u_time) * cos(v_vTexcoord.x * 20.0 + u_time * 0.8);
        vec2 distorted_coord = vec2(v_vTexcoord.x + wave * 0.008 * u_intensity, v_vTexcoord.y);
        
        gl_FragColor = v_vColour * texture2D(gm_BaseTexture, distorted_coord);
    }
}