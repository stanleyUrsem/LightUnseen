shader_type canvas_item;
//render_mode blend_mix;
uniform sampler2D gradient;
uniform float alpha;
uniform float resolution;
uniform float resolution_vertex;
uniform float multiplier;

void fragment() 
{
	float t = step(1.0,COLOR.a);
	COLOR += (texture(gradient,(UV))*t) * multiplier;
	COLOR.a = (texture(gradient,(UV))*t).a * alpha * t;
	//COLOR.a = alpha *t;
	//COLOR = vec4(UV.x,UV.y,0,1);
	// Place fragment code here.
}
