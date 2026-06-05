extends ProgressBar

# El método _set se activa automáticamente al cambiar el valor en Godot 4
func _set(property, new_value):
	if property == "value":
		var style = get_theme_stylebox("fill") as StyleBoxFlat
		style.bg_color = Color.RED*(1000.0-new_value)/1000 + Color.GREEN*(new_value/1000.0)
		
	
