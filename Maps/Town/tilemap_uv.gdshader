shader_type canvas_item;

#include "res://Maps/TileUV.gdshaderinc"

// The size of each square cell normalized
// So if your cell is 8px by 8px the value should be 1.0 / 8.0
// if your cell is 16px by 16px the value should be 1.0 / 16.0
uniform vec2 offset;
uniform vec2 scale;
uniform float cell_size = 32.0;


void fragment() {
	vec2 cell_uv = get_cell_uv(UV,cell_size, TEXTURE_PIXEL_SIZE)*scale+ offset;
	//vec2 cell_uv = get_tile_uvs(UV, TEXTURE_PIXEL_SIZE,16.0 * vec2(1.0),vec2(0.0),vec2(0.0));
	COLOR = vec4(cell_uv.x, cell_uv.y, 0.0, 1.0);
}