varying vec2 v_vTexcoord;
varying vec4 v_vColour;

uniform sampler2D texture;
uniform vec4 textUVs;
uniform vec2 texelSize;
uniform float index;

vec4 texelSPR;
vec4 texelPAL;

float yy;

void main() {
	
	// Store a texel(colour) from the texture of the sprite to manipulate
	texelSPR = texture2D(gm_BaseTexture,v_vTexcoord);
	
	// Iterate the palette texture (top(y) -> bottom(w))
	for (yy=textUVs.y; yy<textUVs.w; yy+=texelSize.y) {
		
		// Store the texel(colour) from the current texelposition(yy) of the palette texture
		texelPAL = texture2D(texture,vec2(textUVs.x,yy));
		
		// If the texture texel(colour) equals the palette texture texel(colour)
		if (distance(texelSPR,texelPAL) == 0.0) {
			
			// Overwrite the original texture texel(colour) with the
			// selected(left(x)+texelWidth*index) palette index texel(colour)
			texelSPR = texture2D(texture,vec2(textUVs.x+(texelSize.x*index),yy));
			
			break;
			
		}
		
	}
	
	gl_FragColor = texelSPR*v_vColour;
	
}
