shader_type canvas_item;
render_mode blend_add;
//#include "TileUV.gdshaderinc"

uniform float resolution;
uniform float alpha;
uniform float background;
uniform float time_speed;
uniform vec2 offset;
uniform vec2 ratio;
uniform float division;
uniform sampler2D noise;
varying vec2 vert;
varying vec2 globalVert;
varying vec2 uv;
varying vec2 uv2;
varying float result;
varying vec4 modulate;


void vertex()
{
	
	float time = TIME * time_speed;
	vert = VERTEX;
	globalVert = ((MODEL_MATRIX * vec4(VERTEX, 0.0, 1.0)).xy) + offset;
	globalVert *= (ratio/division);
	uv = globalVert*resolution;
	uv2 = uv;
	uv.y += (time /10.0);
	uv.x -= (sin(time/10.0)/2.0);
	
	uv2.y += time/14.0;
	uv2.x += (sin(time/10.0)/9.0);
	modulate = COLOR;
}
void fragment() {
	//uv =vert/resolution;
	//uv =FRAGCOORD.xy / (1.0/SCREEN_PIXEL_SIZE);
//	vec2 uv2 = uv;
	float time = TIME * time_speed;
	

	result = 0.0;
	result += texture(noise,fract(uv * 0.6 + vec2(time * -0.003))).r;
	
	result *= texture(noise,fract(uv2 * 0.9 + vec2(time * 0.002))).b;
	result = pow(result,15.0);
	
	vec4 clr = vec4(background * vert.y) * result;
	clr.a *= alpha;
	//clr *= modulate;
	COLOR= abs(clr) * modulate;
//	COLOR = vec4(uv.x,uv.y,0.0,1.0);
	//vec2 uv3 = get_tile_uvs(UV,vec2(320.0,256.0),vec2(16.0),vec2(0.0),vec2(0.0));
	//COLOR = vec4(globalVert.x,globalVert.y, 0,1);
	//COLOR = texture(noise,fract(globalVert));
}
