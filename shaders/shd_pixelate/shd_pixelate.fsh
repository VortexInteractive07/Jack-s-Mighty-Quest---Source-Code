varying vec2 v_vTexcoord;
varying vec4 v_vColour;

uniform float u_pixel_size; // Controlled via shader_set_uniform_f()

void main()
{
    if (u_pixel_size <= 1.0) {
        gl_FragColor = v_vColour * texture2D(gm_BaseTexture, v_vTexcoord);
    } else {
        // Quantize texture coordinates for the Super Mario World blocky mosaic effect
        vec2 coord = floor(v_vTexcoord * u_pixel_size) / u_pixel_size;
        gl_FragColor = v_vColour * texture2D(gm_BaseTexture, coord);
    }
}