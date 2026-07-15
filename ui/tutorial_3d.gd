extends Control

@onready var titulo: Label = $CenterContainer/VBoxContainer/"Label (titulo)"
@onready var contenido: RichTextLabel = $CenterContainer/VBoxContainer/"RichTextLabel (contenido)"
@onready var label_pagina: Label = $HBoxContainer/"Label (pagina)"
@onready var imagen: TextureRect = $CenterContainer/VBoxContainer/HBoxContainer/"TextureRect (Imagen)"
@onready var imagen2: TextureRect = $CenterContainer/VBoxContainer/HBoxContainer/"TextureRect (Imagen2)"

@export var imagen_bateria: Texture2D
@export var imagen_linterna: Texture2D
@export var imagen_placa: Texture2D

var pagina_actual = 0

var paginas = [
	{
		"titulo": "Objetivo",
		"contenido": "Debes escapar de la mansión abandonada sin ser atrapado por el enemigo.\n\nSi el enemigo te alcanza, la partida termina inmediatamente.\n\nEncuentra la salida en la puerta principal para ganar.",
		"imagen": null
	},
	{
		"titulo": "Controles",
		"contenido": "WASD — Moverse\nMouse — Mirar alrededor\nClick derecho — Encender/apagar linterna\nE — Recoger objetos\nR — Usar batería para recargar linterna\nQ — Colocar lámpara\nESC — Pausa",
		"imagen": null
	},
	{
		"titulo": "Objetos",
		"contenido": "Batería — Recarga la linterna al presionar R.\n\nLámpara — Al colocarla con Q ilumina un área circular. Desaparece tras un tiempo.\n\nLos objetos obtienen un contorno blanco al iluminarlos con la linterna y se recogen con E.\n\nLa barra de energía de la linterna es verde cuando está cargada y roja cuando se agota.",
		"imagen": null
	},
	{
		"titulo": "Puzzles",
		"contenido": "Placa de presión — Si el jugador o el enemigo la pisa, activa objetos como puertas.\n\nPrimer puzzle: El enemigo te persigue por un pasillo. Usa la mesa para inmovilizarlo cuando deje el camino libre.\n\nSegundo puzzle: Haz que el enemigo active la placa de presión, inmovilízalo con la linterna y escapa.",
		"imagen": null
	}
]

func _ready() -> void:
	paginas[2]["imagen"] = imagen_bateria
	paginas[2]["imagen2"] = imagen_linterna
	paginas[3]["imagen"] = imagen_placa
	
	mostrar_pagina(0)

func mostrar_pagina(indice: int) -> void:
	pagina_actual = indice
	var pagina = paginas[indice]
	titulo.text = pagina["titulo"]
	contenido.text = pagina["contenido"]
	
	if pagina["imagen"] != null:
		imagen.texture = pagina["imagen"]
		imagen.visible = true
	else:
		imagen.visible = false
	
	if pagina.get("imagen2") != null:
		imagen2.texture = pagina["imagen2"]
		imagen2.visible = true
	else:
		imagen2.visible = false
	
	label_pagina.text = str(pagina_actual + 1) + " / " + str(paginas.size())

func _on_button_siguiente_pressed() -> void:
	if pagina_actual < paginas.size() - 1:
		mostrar_pagina(pagina_actual + 1)

func _on_button_anterior_pressed() -> void:
	if pagina_actual > 0:
		mostrar_pagina(pagina_actual - 1)

func _on_button_volver_pressed() -> void:
	get_tree().change_scene_to_file("res://ui/main_menu_3d.tscn")
