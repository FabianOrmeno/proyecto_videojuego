@tool
extends Node3D

func _ready():
	if Engine.is_editor_hint():
		return
	for child in get_children():
		generar_colision_recursivo(child)

func generar_colision_recursivo(nodo):
	if nodo is MeshInstance3D:
		nodo.create_trimesh_collision()
	for child in nodo.get_children():
		generar_colision_recursivo(child)
