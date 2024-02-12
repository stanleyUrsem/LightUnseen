shader_type canvas_item;
//render_mode blend_premul_alpha;
uniform float speeds[3];
uniform vec2 direction;
uniform vec2 resolutions[3];
uniform sampler2D noise;
uniform sampler2D screen_texture : hint_screen_texture, repeat_disable, filter_nearest;

//varying vec3 world_vertex;
//
//void vertex()
//{
//	world_vertex = (MODEL_MATRIX * vec4(VERTEX,0,1.0)).xyz;
//
//}

void fragment() {
	// Place fragment code here.
	float grad = mix(0,1,fract(UV.y));
	vec2 uvi = FRAGCOORD.xy / (1.0 / SCREEN_PIXEL_SIZE);
	vec4 c = vec4(1,1,1,1);
	float mults[3] = {0.2,0.5,0.3};
	for(int i = 0; i<1 ; i++)
	{
		vec2 offset = direction * ((TIME * speeds[i]));
		c *= (texture(noise, fract(UV* resolutions[i] + offset)));
		
	}
	//c/=vec4(3.0);
		//c = texture(noise, fract(UV* resolutions[0] + offset));
	
//	COLOR = vec4(UV,0,1);
//		c = clamp(c,vec4(0,0,0,0), vec4(1,1,1,1));
	COLOR = c *COLOR;
//	COLOR = vec4(world_vertex.xy,0,1.0);
//	COLOR = texture(noise,fract(UV *resolution+ offset)) * COLOR ;
//	COLOR = vec4(offset,0.5,1.0);
		//COLOR = vec4(grad,grad,grad,1.0);
}
