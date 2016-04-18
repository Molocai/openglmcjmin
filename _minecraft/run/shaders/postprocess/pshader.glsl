uniform sampler2D Texture0;
uniform sampler2D Texture1;
uniform float screen_width;
uniform float screen_height;

float LinearizeDepth(float z)
{
	float n = 0.5; // camera z near
  	float f = 5000.0; // camera z far
  	return (2.0 * n) / (f + n - z * (f - n));
}

void main (void)
{
	float xstep = 1.0/screen_width;
	float ystep = 1.0/screen_height;
	float ratio = screen_width / screen_height;

	vec4 color = texture2D( Texture0 , vec2( gl_TexCoord[0] ) );
	float depth = texture2D( Texture1 , vec2( gl_TexCoord[0] ) ).r;	
	
	//Permet de scaler la profondeur
	depth = LinearizeDepth(depth);

	vec2 nearPixel = vec2( gl_TexCoord[0] );
	vec4 finalColor = texture2D( Texture0 , vec2( gl_TexCoord[0] ) );
	int count = 0;
	for (int i = -2; i <= 2; i++) {
		for (int j = -2; j <= 2; j++) {
			if (i >= 0 && i <= screen_width && j >= 0 && j <= screen_height) {
				nearPixel.x += i * xstep;
				nearPixel.y += j * ystep;

				finalColor += texture2D(Texture0, nearPixel);
				count++;
			}
		}
	}

	finalColor = finalColor / count;
	float aberationValue = 3;

	vec2 pixelAberationR = vec2( gl_TexCoord[0] );
	pixelAberationR.x += xstep * aberationValue;
	pixelAberationR.y += xstep * -aberationValue;

	vec4 cR = texture2D(Texture0, pixelAberationR);

	vec2 pixelAberationG = vec2( gl_TexCoord[0] );
	pixelAberationG.x += xstep * -aberationValue;
	pixelAberationG.y += xstep * aberationValue;

	vec4 cG = texture2D(Texture0, pixelAberationG);

	vec2 pixelAberationB = vec2( gl_TexCoord[0] );
	pixelAberationB.x += xstep * aberationValue;
	pixelAberationB.y += xstep * aberationValue;

	vec4 cB = texture2D(Texture0, pixelAberationB);

	// Abération chromatique
	// gl_FragColor = vec4(cR.r, cG.g, cB.b, cR.a);

	// Blur
	// gl_FragColor = finalColor;
	
	gl_FragColor = vec4(color.r, color.g, color.b, color.a);
	// gl_FragColor = vec4(depth, depth, depth, 1);
}