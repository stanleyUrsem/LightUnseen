shader_type canvas_item;
render_mode blend_mix;

#include "res://Maps/TileUV.gdshaderinc"
#include "res://Maps/Town/HelperFunctions.gdshaderinc"
// helpful to visually debug the noise scrolling texture.
uniform bool render_noise = false;
// Change if you want to move the bottom vertex of each tile.
uniform bool move_top = true;
// how strong is the vertex going to be pulled.
uniform vec2 distortion_force = vec2(10.0, 0.0);
// how fast is the noise texture is going to scroll.
uniform float time_scale :hint_range(0.0, 1.0, 0.01) = 0.1;
uniform float player_near;
uniform float player_distort;
// the distortion texture, can be hand made or generated with the Godot builtin
// noise texture.
uniform sampler2D noise_texture;
// the scale of the texture
uniform float noise_scale :hint_range(0.0, 2.0, 0.0001)= 0.002;
uniform float world_scale ;
uniform float offset;
// you need to pass the world position from a script as seen
// https://docs.godotengine.org/en/3.5/tutorials/shaders/shader_reference/canvas_item_shader.html#vertex-built-ins
varying vec2 world_position;

// the size of the tilemap tiles.
uniform float tile_size = 16.0;
uniform float cell_size = 16.0;
uniform float delta :hint_range(0.0, 1.0, 0.1)= 0.2;
uniform float deltaY :hint_range(0.0, 1.0, 0.1)= 0.2;

varying flat vec2 vertexPos[2];

vec2 get_uv(vec2 uv, float scale, float time) {
	vec2 new_uv = uv;
	new_uv *= scale;
	new_uv += time;
	return new_uv;
}

void vertex()
{
    world_position = (MODEL_MATRIX * vec4(0.0,0.0, 0.0, 1.0)).xy;
//    world_position = (inverse(view_transform) * MODEL_MATRIX * vec4(VERTEX,0.0,1.0)).xy;
//	world_position.x = remap(world_position.x,world_in,world_out);
//	world_position.y = remap(world_position.y,world_in,world_out);
	float t = mix(TIME * time_scale,time_scale,player_near);
	vec2 distort = mix(distortion_force,player_distort* distortion_force,player_near);
	vec2 world_uv = get_uv(world_position, noise_scale, t); 
//	vec2 noise = texture(noise_texture, fract(get_cell_uv(world_uv,tile_size,TEXTURE_PIXEL_SIZE))).rg;
	vec2 noise = texture(noise_texture, fract(world_uv*world_scale+vec2(offset))).rg;
	noise *= 2.0;
	noise -= 1.0;
	noise *= distort;
//	float a = fract(vec2(UV)*cell_size).y;
//	float d =  step(delta,a);
//	float d =  smoothstep(delta,deltaY,a);
//	noise *= d;
	
	float a = (VERTEX.y / tile_size);
//	float d = step(delta,a);
//	noise *=d;
	if (a <delta) 
	{
		VERTEX.x += noise.x;
		VERTEX.y += noise.y;
	}
//	if (a > delta && !move_top) {
//		VERTEX.x += noise.x;
//		VERTEX.y += noise.y;
//	}
//	if(d > 0.0)
//	{
//	VERTEX.x += noise.x;
//	VERTEX.y += noise.y;
//	}
}



