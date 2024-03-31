shader_type canvas_item;

uniform float alpha_override : hint_range(0.0,1.0) = 1.0;
uniform int num_colors;
uniform float precision : hint_range(0.0, 1.0) = 0.1;
uniform float index :hint_range(0.0, 17.0, 1.0);
uniform sampler2D palette_in : filter_nearest, source_color;
uniform sampler2D palette_out: filter_nearest, source_color;
varying flat vec4 modulate;
bool same_color(vec4 in_c, vec4 out_c)
{
	float r = in_c.r - out_c.r;
	float g = in_c.g - out_c.g;
	float b = in_c.b - out_c.b;
	bool r_same = r >= -precision && r <= precision;
	bool g_same = g >= -precision && g <= precision;
	bool b_same = b >= -precision && b <= precision;
	
	float dist =  distance(in_c, out_c);
	bool dist_same = dist >= -precision && dist <= precision;
	//return r_same && g_same && b_same;
	return dist_same;
}
vec4 swap_color(vec4 color) {
	float inc = 1.0 / float(num_colors); 
	for (int i = 0; i < num_colors; i++) {
		//vec2 uv = vec2(float(i) + (inc/2.0), 0.0);
		vec2 uv = vec2((float(i)/float(num_colors)) + (inc/2.0), 0.0);
		
		vec4 color_in = texture(palette_in, uv);
		if(same_color(color,color_in))
		{
			//return vec4(0.0,1.0,0.0,1.0);
			return texture(palette_out,uv);
		}
		//if (distance(color, color_in) <= precision && distance(color, color_in) >= -precision) {
			//return texture(palette_out, uv);
		//}
	}
	return color;
}
void vertex()
{
	modulate = COLOR;
	
}

void fragment() {
	vec4 color = texture(TEXTURE, UV);
	float inc = 1.0 / float(num_colors); 
	vec2 uv = vec2((float(index)/float(num_colors)) + (inc/2.0), 0.0);
	//vec4 color= texture(TEXTURE,UV);
	COLOR = modulate *swap_color(color);
	COLOR.a *= alpha_override;
	//COLOR = color;
}