shader_type canvas_item;
uniform float offset_multiplier;
uniform vec2 mouse_dir;
uniform float exposure;
void vertex()
{

	VERTEX += (mouse_dir * offset_multiplier) ;
	
}


void fragment()
{
	COLOR = COLOR * pow(2, exposure);
	
}


