void main(void) 
{
	gl_FrontColor = gl_Color; 
	OutTexCoord = gl_MultiTexCoord0.xy;
	gl_Position = gl_ModelViewProjectionMatrix * gl_Vertex;
}
