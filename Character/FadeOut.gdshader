shader_type canvas_item;
uniform sampler2D noise;
uniform float time:hint_range(0.0, 1.57, 0.001) = 1.0;
uniform vec2 custom_resolution = vec2(100,100);


float rand(vec2 co){
    return fract(sin(dot(co.xy ,vec2(12.9898,96.233))) * 43758.5453);
}

void fragment()
{
	vec2 within_texture_pixel=vec2(floor(UV * custom_resolution));
	vec4 color= texture(TEXTURE,UV);
	//float noise_value = round(texture(noise,UV).x);
	float noise_value =rand(within_texture_pixel);
	//if(sin(time) > rand(within_texture_pixel))
	//COLOR *= noise_value;
	if(sin(time) > noise_value)
		COLOR = color;
	else
		COLOR = vec4(0.0,0.0,0.0,0.0);
}