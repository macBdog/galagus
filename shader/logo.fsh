in vec2 OutTexCoord;

void main(void)
{
	vec4 modColour = texture2D(DiffuseTexture, OutTexCoord);
	float xPlasma = sin(gl_FragCoord.x * 0.1) + sin(LifeTime * 6.5);
	float yPlasma = cos(gl_FragCoord.y * 0.16) + cos(LifeTime * 4.0);
	float plasma = xPlasma + yPlasma + sin(sqrt(100.0 * ((xPlasma * xPlasma) + (yPlasma * yPlasma)) + LifeTime));
	float plasmaFrac = modColour.r;
	modColour.a = 1.0;
	modColour.g = modColour.g * plasmaFrac + plasma * (0.8 - plasmaFrac);
	GBuffer1Colour = modColour;
}
