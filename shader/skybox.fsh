void main(void)
{
	gl_FragColor = texture2D(Texture0, OutTexCoord) * gl_Color;
}