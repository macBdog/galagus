in vec2 OutTexCoord;

void main(void)
{
	vec4 modColour = texture2D(DiffuseTexture, OutTexCoord);
	float baseShade = 0.7;
	float lifeScale = (LifeTime / 0.85);
	GBuffer1Colour = modColour - lifeScale;
}