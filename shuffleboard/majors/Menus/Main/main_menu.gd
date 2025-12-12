extends Control

class_name MainMenu

var start_game_method: Callable

func link_start_button(start_game: Callable) -> void:
	self.start_game_method = start_game

func _on_button_pressed() -> void:
	start_game_method.call()
