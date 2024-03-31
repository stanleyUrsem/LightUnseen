shader_type canvas_item;

uniform float size;
uniform float resolution;
uniform float t;
uniform float t_a_y;
uniform float rad;
uniform vec2 _a;
uniform vec2 a_y_range;
uniform vec3 _b;
uniform float _w;
uniform vec2 cell;
uniform sampler2D gradient;
//-0.215
//-0.185
void vertex() {
	// Called for every vertex the material is visible on.
}
vec2 pixelate_uv(vec2 uv, vec2 cellSize)
{
	return round(uv * cellSize) / cellSize ;
}

float sdCircle( vec2 p, float r )
{
    return length(p) - r;
}

float sdOrientedVesica( vec2 uv, vec2 a, vec2 b, float w )
{
    float r = 0.5*length(b-a);
    float d = 0.5*(r*r-w*w)/w;
    vec2 v = (b-a)/r;
    vec2 c = (b+a)*0.5;
    vec2 q = 0.5*abs(mat2(vec2(v.y,v.x),vec2(-v.x,v.y))*(uv-c));
    vec3 h = (r*q.x<d*(q.y-r)) ? vec3(0.0,r,0.0) : vec3(-d,0.0,d+w);
	float ves = length( q-h.xy) - h.z;
    return step(ves-rad,mix(-0.455,1.0,t));
}

void fragment() 
{
	vec2 uv = ((UV / -size)) + vec2(resolution,resolution);
	//float full_uv = length(pixelate_uv(uv,cell));
	//float full_uv = sdCircle(pixelate_uv(uv,cell),rad);
	float _a_y = mix(a_y_range.x,a_y_range.y,t_a_y);
	float full_uv = sdOrientedVesica(pixelate_uv(uv,cell),vec2(_a.x,_a_y),_b.yx,_w);
	full_uv += sdOrientedVesica(pixelate_uv(uv,cell),vec2(-_a.x,_a_y),_b.zx,_w);
	//full_uv = step(full_uv,1.0-t);
	vec4 grad_clr = texture(gradient,vec2(full_uv,UV.y));
	//COLOR = vec4(length(pixelate_uv(uv,float(cell))));
	//COLOR = vec4(full_uv);
	COLOR = grad_clr;
	//COLOR.a = 1.0;
	// Called for every pixel the material is visible on.
}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}
