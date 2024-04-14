extends TextureProgressBar

func set_material_progress(val : float):
	get_child(0).material.set_shader_parameter("fill_value", val / max_value)

