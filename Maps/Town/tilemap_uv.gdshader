shader_type canvas_item;

uniform vec4 B =  vec4(10., 20., 30., 20.);
uniform sampler2D text;

vec2 uv9slice(vec2 uv, vec2 s, vec4 b)
{
    vec2 t = clamp((s * uv - b.xy) / (s - b.xy - b.zw), 0., 1.);
	return mix(uv * s, 1. - s * (1. - uv), t);
}

/* HLSL for convenience

float2 uv9slice(float2 uv, float2 s, float4 b)
{
	float2 t = saturate((s * uv - b.xy) / (s - b.xy - b.zw));
	return lerp(uv * s, 1. - s * (1. - uv), t);
}

*/

void fragment()
{
    vec2 uv = UV;
    vec2 ts = vec2(textureSize(text, 0));
    // scaling factor
    // probably available as uniform irl
    vec2 s = SCREEN_PIXEL_SIZE.xy / ts;

    // border by texture size, shouldn't be > .5
    // probably available as uniform irl
    vec4 b = min(B / ts.xyxy, vec4(.499));
    uv = uv9slice(uv, s, b);
    
    vec3 col = vec3(texture(text, uv).x);

    COLOR = vec4(uv,0.0,1.0);
}