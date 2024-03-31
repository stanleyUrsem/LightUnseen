shader_type canvas_item;
//render_mode blend_mix;
render_mode blend_mul;
uniform int height;
uniform int new_height;
uniform float transition;
uniform sampler2D gradient;
varying vec4 modulate;
float easeInOutCubic(float x) 
{
	return x < 0.5 ? 4.0 * x * x * x : 1.0 - pow(-2.0 * x + 2.0, 3.0) / 2.0;

}

float get_uv(vec2 uv, float minUv,float maxUv, vec4 signUv, int index)
{
		float adjUv = (uv.y+signUv[0]);
	int i = 1;
	while(i<(index+1))
	{
		adjUv += signUv[i];
		i++;
	}
	return adjUv;
}

vec4 adjustUv(vec2 uv,float minUv, float maxUv, vec4 signUv, int index)
{
	
	float uvStep = 1.0 - ((1.0-step(minUv,uv.y)) + step(maxUv,uv.y));
	float current_uv = get_uv(uv,minUv,maxUv,signUv,index);
	float new_uv = get_uv(uv,minUv,maxUv,signUv,new_height);
	float fullUv = mix(current_uv,new_uv,(transition));
//	for(int i = 1; i < index; i++)
//	{
//		adjUv += signUv[i];
//	}
//	if(index > 0)
//	{
//		adjUv += signUv[1];	
//
//	}
//	for(int i = 1; i < index; i++)
//	{
//		adjUv += signUv[i];
//	}
	//adjUv *= uvStep;
		
//	uvStep += signUv[index];
	
	
	return  textureLod(gradient,(vec2(uv.x,fullUv)),0) * uvStep;	
}
void vertex()
{
	modulate = COLOR;
	
}
void fragment() {
	// Place fragment code here.
	
	float x = UV.x;
	//float y = step(1,UV.y);
	
	vec4 clr1 = adjustUv(UV,0.00,0.25,vec4(0,0.25,0.25,0.25),height);
	vec4 clr2 = adjustUv(UV,0.24,0.50,vec4(0,-0.25,0.25,0.25),height);
	vec4 clr3 = adjustUv(UV,0.51,0.75,vec4(0,-0.25,-0.25,0.25),height);
	vec4 clr4 = adjustUv(UV,0.76,1.00,vec4(0,-0.25,-0.25,-0.25),height);
	//float y = (1.0-step(0.75,UV.y)) + step(1,UV.y);
	//float y = uv1*uv2*uv3*uv4;// + uv2+uv3+uv4;	
	//COLOR = vec4(x,x,x,1);
//	float y = UV.y;
//	float y = smoothstep(0.0,0.74,UV.y);
	//float y = UV.y;
//	float y = uv1;
//	vec4 clr1 =  textureLod(gradient,(vec2(UV.x,uv1)),0);
//	COLOR = vec4(y,y,y,1);
	COLOR = (clr1+clr2+clr3+clr4);
	COLOR *= modulate;
//	COLOR = clr1+clr2;
//	COLOR= textureLod(gradient,(vec2(UV.x, y)),0);
	//COLOR= textureLod(gradient,(vec2(UV)),0);
}