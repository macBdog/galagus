out vec4 Colour;
out vec2 OutTexCoord;

void main(void) 
{
	gl_Position = vec4(VertexPosition, 1.0) * ObjectMatrix * ViewMatrix * ProjectionMatrix;
	Colour = VertexColour;
	OutTexCoord = VertexUV;
}
