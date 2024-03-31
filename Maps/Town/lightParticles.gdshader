shader_type canvas_item;
//render_mode blend_mul;
//render_mode  skip_vertex_transform;
#include "res://Maps/DistortedScreen.gdshaderinc"
//varying vec2 globalVert;
varying vec2 uv;
//uniform vec2 offset;
uniform vec2 ratio;
uniform float division;
//uniform vec4 clrBack :source_color;
//uniform vec4 clrMain :source_color;
//uniform vec2 scaleRange;
uniform sampler2D gradient : filter_nearest, source_color,repeat_enable;
uniform float resolution;
uniform float screen_resolution;
//uniform int snow_flake_amount;
//uniform float blizzard_factor;
//uniform float time_speed;
//uniform float initial_radius : hint_range(0.0, 0.001, 0.0001);
//uniform float radius_multiplier : hint_range(0.0, 0.012,0.0001);
//uniform float color_multiplier;
uniform float color_grad;
uniform float alpha;
uniform float distortionView;
uniform float noiseScale;
uniform sampler2D noiseX;
uniform sampler2D noiseY;
uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear;

varying vec2 vert;
varying vec4 modulate;
float rnd(float x)
{
	return fract(sin(dot(vec2(x+47.49,38.2467/(x+2.3)), vec2(12.9898, 78.233)))* (43758.5453));
}

float drawCircle(vec2 center, float radius)
{
	return 1.0 - smoothstep(0.0,radius,length(uv-center));
}
float oscillate_values(float val,float min_v, float max_v)
{
	float range = max_v - min_v;
	float cycle_length = 2.0 * range;
	float state = modf(val - min_v, cycle_length);
	if(state > range)
	{
		state = cycle_length - state;
		
	}
	return state + min_v;
}
// Color space conversion from https://godotshaders.com/shader/color-range-swap/
vec3 rgb2hsv(vec3 c)
{
    vec4 K = vec4(0.0, -1.0 / 3.0, 2.0 / 3.0, -1.0);
    vec4 p = mix(vec4(c.bg, K.wz), vec4(c.gb, K.xy), step(c.b, c.g));
    vec4 q = mix(vec4(p.xyw, c.r), vec4(c.r, p.yzx), step(p.x, c.r));

    float d = q.x - min(q.w, q.y);
    float e = 1.0e-10;
    return vec3(abs(q.z + (q.w - q.y) / (6.0 * d + e)), d / (q.x + e), q.x);
}

// All components are in the range [0…1], including hue.
vec3 hsv2rgb(vec3 c)
{
    vec4 K = vec4(1.0, 2.0 / 3.0, 1.0 / 3.0, 3.0);
    vec3 p = abs(fract(c.xxx + K.xyz) * 6.0 - K.www);
    return c.z * mix(K.xxx, clamp(p - K.xxx, 0.0, 1.0), c.y);
}

void vertex()
{
	vert = VERTEX;
	vert *= (ratio/division);
	uv = vert*resolution;
	modulate = COLOR;
}

void fragment() 
{
	//uv =vert/resolution;//FRAGCOORD.xy / (1.0/ SCREEN_PIXEL_SIZE);
//	float t = TIME * time_speed;
	float j;
	float amount;
	//vec4 distorted = texture(SCREEN_TEXTURE, SCREEN_UV * screen_tiling + screen_offset);
	vec4 distorted = get_distorted_screen(vec2(0.5),uv,(SCREEN_UV*screen_resolution),SCREEN_TEXTURE , noiseX,noiseY,noiseScale,distortionView );
	//vec4 distorted = get_distorted_screen_a(center_pos,FRAGCOORD.xy,SCREEN_UV,UV,SCREEN_TEXTURE, SCREEN_PIXEL_SIZE);
	vec4 tex = texture(TEXTURE,UV);
	vec3 source_hsv = rgb2hsv(tex.rgb);
	vec3 initial_hsv = rgb2hsv(modulate.rgb);
	vec3 hsv_shift = source_hsv - initial_hsv;
	//COLOR *= texture(gradient,vec2(uv))*color_grad;
	vec2 offset = (tex.rr + tex.gg + tex.bb + tex.aa) / 3.0;
	vec3 grad = (texture(gradient,vec2(uv+offset))*color_grad).rgb;
	vec3 grad_hsv = rgb2hsv(grad);
	grad_hsv.r += (source_hsv.r - 0.0);
	grad_hsv.r += hsv_shift.r;
	//grad_hsv.r = oscillate_values(grad_hsv.r, 0.0,1.0);
	//grad_hsv.r = clamp(grad_hsv.r,0.0,1.0);
	grad = hsv2rgb(grad_hsv);
	COLOR.rgb *= grad;
	COLOR.rgb += distorted.rgb;
	COLOR.a = tex.a;
	//if(COLOR.a <= 0.6){
		//discard;
		//}
//	COLOR = vec4(uv.x,uv.y,1.0,1.0);
//	vec4 clr = clrBack;
//	for(int i = 0; i < snow_flake_amount; i++)
//	{
//		j = float(i);
//		amount = float(snow_flake_amount);
//
//		float dt = j/amount;
//
//		float speed = 0.3+rnd(cos(j))*(0.7+0.5*cos(j/(float(snow_flake_amount)*0.25)));
//		vec2 center = vec2((0.25-uv.y)*blizzard_factor+rnd(j)+0.1*cos(t+sin(j)), mod(sin(j)-speed*(t*1.5*(0.1+blizzard_factor)), 0.65));
//		float rad = mix(scaleRange.x,scaleRange.y,dt);
//
//		clr += texture(gradient,vec2(dt,0)) *vec4(color_multiplier*drawCircle(center, initial_radius+speed*radius_multiplier));
////		clr *= texture(gradient,vec2(dt,0));
//	}
//
//	float delta = smoothstep(0.0,1.0,clr.r);
//	COLOR += ((clr) );//* delta);
	//COLOR = clr*clrMain;

//	COLOR = ((COLOR) + (clr*clrMain)) * BLOOM_INTENSITY;
	//COLOR = COLOR;
	//COLOR = vec4(uv.x,uv.y,0,1);
}
