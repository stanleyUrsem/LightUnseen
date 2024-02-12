#ifndef HELPER_FUNCS
#define HELPER_FUNCS

float inverse_mix(float from, float to,float value)
{
	return (value- from) / (to-from);
}

float remap(float value,vec2 inMinMax,vec2 outMinMax)
{
	float rel = inverse_mix(inMinMax.x, inMinMax.y, value);
	return mix(outMinMax.x, outMinMax.y, rel);
}

#endif
