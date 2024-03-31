// 2D liquid inside 'sphere' shader.

// Original Author: Mirza Beig
// Godot Implementation: RuverQ

// https://twitter.com/TheMirzaBeig
// https://www.youtube.com/@MirzaBeig

// https://twitter.com/RuverQuack

// Feel free troveto use this however you want.
// Modify, learn from it, copy-paste, etc...

// Original Shadertoy: https://www.shadertoy.com/view/Ds3BRN

shader_type canvas_item;
render_mode blend_premul_alpha;
// fV = fill value
uniform sampler2D under : filter_nearest,source_color;
uniform sampler2D over : filter_nearest,source_color;
uniform vec4 color : source_color;
uniform float resolution;
uniform float size;
uniform float resolution_under;
uniform float division_under;
uniform float step_under;
uniform float step_sdf;
uniform float pixel_size;
uniform float backFill_brightness;
uniform float fV;
uniform float fVx;
uniform float under_mult;
uniform vec2 big_wave_freq_range ;
uniform vec2 big_wave_amp_range ;
uniform vec2 main_wave_freq_range ;
uniform vec2 main_wave_amp_range;
uniform vec2 under_region_origin;
uniform vec2 under_region_size;
uniform vec2 under_atlas_size;
uniform vec2 over_region_origin;
uniform vec2 over_region_size;
uniform vec2 over_atlas_size;
vec2 get_atlas_uv(vec2 uv,vec2 region_size, vec2 region_origin, vec2 atlas_size)
{
	vec2 inv_atlas_size = vec2(1.0) / atlas_size;
	vec2 uv_offset = region_origin * inv_atlas_size;
	vec2 uv_scale = region_size * inv_atlas_size;
	uv = uv * uv_scale + uv_offset;
	
	return uv;
}
vec2 pixelate_uv(vec2 uv, float cellSize)
{
	return round(uv * cellSize) / cellSize ;
}

float mix_range(vec2 v, float t)
{
	return mix(v.x,v.y,t);
}

void fragment() {
    vec2 uv = ((UV / -size)) + vec2(resolution,resolution);
    vec2 uv_under = ((get_atlas_uv(UV,under_region_size,under_region_origin,under_atlas_size) / division_under)) + vec2(resolution_under,resolution_under);
    vec2 uv_over = ((get_atlas_uv(UV,over_region_size,over_region_origin,over_atlas_size) / division_under)) + vec2(resolution_under,resolution_under);
	uv = pixelate_uv(uv,pixel_size);
	
	float big_wave_freq =  mix_range(big_wave_freq_range,fV);
	float big_wave_amp =   mix_range(big_wave_amp_range,fV);
	float main_wave_freq = mix_range(main_wave_freq_range,fV);
	float main_wave_amp =  mix_range(main_wave_amp_range,fV);
	
    float
		sdf=length(uv),
		c=step(sdf,step_sdf),
        vB=smoothstep(.1,.9,sin(uv.x+(PI*.4))-.3),
		vBA=vB*sin(TIME*big_wave_freq)*big_wave_amp,
        
        fW=(sin(((TIME*main_wave_freq)+uv.x)*2.)*main_wave_amp)+vBA,
		bW=(sin(((TIME*-main_wave_freq)+uv.x)*2.+PI)*main_wave_amp)-vBA,
		
        fA=(sin(TIME*5.)*.1)*vB,
        
        fP=fV * 2.3 +(sin((TIME)*PI)*.1) - 1.1,
        fPx=fVx * 2.3 +(sin((TIME)*PI)*.1) - 1.1,
		
        fF=step(uv.y,(fA+fW)+fP)*c,
		bF=step(uv.y,(-fA+bW)+fP)*c ;
		
	//vec4 background = vec4((step(sdf,1.)-step(sdf,.9)));
	vec4 background = texture(under,-uv_under);
	vec4 foreground = texture(over,-uv_over);
	float cut_off = step(step_under,background.r);
	//COLOR = background;
	vec4 progress = vec4(
		(fF+(clamp(bF-fF,0.,1.)* backFill_brightness))* cut_off * foreground);	
	COLOR = background* under_mult;
    COLOR += step(-uv.x,mix(-1.045,1.77,fVx)) * progress;
}

