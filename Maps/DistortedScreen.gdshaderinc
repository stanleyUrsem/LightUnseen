#ifndef DISTORTED_SCREEN
#define DISTORTED_SCREEN

vec4 get_distorted_screen(vec2 uv,vec2 screen_uv,sampler2D screen_text, sampler2D noiseX, sampler2D noiseY, float noiseScale,float distortionView)
{
	float noiseValueX  = (texture(noiseX, fract(uv*noiseScale )).r); //* 2.0 - 1.0; // Range: -1.0 to 1.0
	float noiseValueY  = (texture(noiseY, fract(uv*noiseScale )).r);// * 2.0 - 1.0; // Range: -1.0 to 1.0
	vec2 noiseDistort = vec2(noiseValueX, noiseValueY);
	vec2 center = vec2(0.5);
	screen_uv = (screen_uv - center) * distortionView + center;
    vec4 c = texture(screen_text, screen_uv);
	return c;
}

#endif