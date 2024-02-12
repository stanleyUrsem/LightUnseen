#ifndef TILE_UVS
#define TILE_UVS

vec2 get_tile_uvs(vec2 p_uv,vec2 p_tex_size,vec2 p_region_size,vec2 p_margins,vec2 p_separation) {
	vec2 uv = p_uv - p_margins / p_tex_size;
	uv = fract(uv * p_tex_size / (p_region_size+p_separation));
	return uv * (p_region_size + p_separation) / p_region_size;
}

vec2 get_cell_uv(vec2 uv, float cell_size, vec2 pixel_size) 
{
	float tile_size = 1.0 / cell_size;
	vec2 ut = uv;
	ut.x = mod(1.0 - uv.x, pixel_size.x / tile_size) / pixel_size.x * tile_size;
	ut.y = mod(1.0 - uv.y, pixel_size.y / tile_size) / pixel_size.y * tile_size;
	
	return ut;
}

#endif
