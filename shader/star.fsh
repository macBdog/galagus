in vec2 OutTexCoord;

void main(void)
{
	vec4 modColour = texture2D(DiffuseTexture, OutTexCoord);
	float baseShade = 0.7;
	modColour = vec4(baseShade + sin(LifeTime), baseShade + cos(LifeTime*6.4), baseShade + sin(LifeTime*2.76), 0.25);
	GBuffer1Colour = modColour;
}