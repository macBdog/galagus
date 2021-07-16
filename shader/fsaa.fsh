float lumRGB(vec3 v)
{   
    return dot(v, vec3(0.212, 0.716, 0.072));   
}

void main(void)
{
    vec2 frameRecip = vec2(1.0/1280.0, 1.0/800.0);
    vec2 UV = gl_FragCoord.xy * frameRecip;
 
    float w = 1.75;
    float t = lumRGB(texture2D(Texture0, UV + vec2(0.0, -1.0) * w * frameRecip).xyz);
    float l = lumRGB(texture2D(Texture0, UV + vec2(-1.0, 0.0) * w * frameRecip).xyz);
    float r = lumRGB(texture2D(Texture0, UV + vec2(1.0, 0.0) * w * frameRecip).xyz);
    float b = lumRGB(texture2D(Texture0, UV + vec2(0.0, 1.0) * w * frameRecip).xyz);

    vec2 n = vec2(-(t - b), r - l);
    float nl = length(n);
 
    /* Regular pixel colour */
    if (nl < (1.0 / 16.0))
    {
        gl_FragColor = texture2D(Texture0, UV);
    }
    else /* Blurred edge */
    {
        n *= frameRecip / nl;
        vec4 o = texture2D(Texture0, UV);
        vec4 t0 = texture2D(Texture0, UV + n);
        vec4 t1 = texture2D(Texture0, UV - n);
        vec4 t2 = texture2D(Texture0, UV + n);
        vec4 t3 = texture2D(Texture0, UV - n);
        gl_FragColor = (o + t0 + t1 + t2 + t3) * 0.2;
    }
}