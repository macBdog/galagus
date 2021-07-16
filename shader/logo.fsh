in vec2 OutTexCoord;

void main(void)
{
	float xPlasma = sin(gl_FragCoord.x * 0.1) + sin(LifeTime * 6.5);
	float yPlasma = cos(gl_FragCoord.y * 0.16) + cos(LifeTime * 4.0);
	float plasma = xPlasma + yPlasma + sin(sqrt(100.0 * ((xPlasma * xPlasma) + (yPlasma * yPlasma)) + LifeTime));
	vec4 modColour = texture2D(DiffuseTexture, OutTexCoord);
	float plasmaFac = modColour.r;
	modColour.a = modColour.a*plasmaFac + plasma*(1.0 - plasmaFac);
	GBuffer1Colour = modColour;
}
