extends TextureRect

class_name  Background

func load_file(file_name: String) -> void:
	texture = load("res://assets/background/%s.jpg" % [file_name])
