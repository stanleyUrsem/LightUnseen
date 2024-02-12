shader_type canvas_item;
render_mode blend_mix;
uniform sampler2D gradient;
uniform float alpha;
uniform float resolution;
uniform float resolution_vertex;
uniform float multiplier;

void fragment() 
{
	float t = step(1.0,COLOR.a);
	COLOR += (texture(gradient,fract(UV*resolution))*t) * multiplier;
	COLOR.a = alpha *t;
	// Place fragment code here.
}
