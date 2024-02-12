shader_type canvas_item;
//render_mode blend_add;
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
uniform sampler2D gradient;
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
uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear_mipmap;
varying vec2 vert;

float rnd(float x)
{
	return fract(sin(dot(vec2(x+47.49,38.2467/(x+2.3)), vec2(12.9898, 78.233)))* (43758.5453));
}

float drawCircle(vec2 center, float radius)
{
	return 1.0 - smoothstep(0.0,radius,length(uv-center));
}


void vertex()
{
//	VERTEX = (MODEL_MATRIX * vec4(VERTEX, 0.0, 1.0)).xy;
//	globalVert = ((MODEL_MATRIX * vec4(VERTEX, 0.0, 1.0)).xy) + offset;
	vert = VERTEX;
	vert *= (ratio/division);
	uv = vert*resolution;
}

void fragment() 
{
	//uv =vert/resolution;//FRAGCOORD.xy / (1.0/ SCREEN_PIXEL_SIZE);
//	float t = TIME * time_speed;
	float j;
	float amount;
	vec4 distorted = get_distorted_screen(uv,(SCREEN_UV*screen_resolution),SCREEN_TEXTURE , noiseX,noiseY,noiseScale,distortionView );
	COLOR.rgb += distorted.rgb;
	COLOR *= texture(gradient,vec2(uv))*color_grad;
	COLOR.a *= alpha;
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
