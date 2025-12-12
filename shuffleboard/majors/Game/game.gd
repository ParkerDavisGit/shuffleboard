extends Node

class_name Game

var visual_novel: VisualNovelEngine
var boat_exploration_hub: BoatExplorationHub

func _ready() -> void:
	var main_menu: Control = load("res://majors/Menus/Main/MainMenu.tscn").instantiate()
	main_menu.link_start_button(start_game)
	add_child(main_menu)


func start_game() -> void:
	remove_child($MainMenu)
	
	self.boat_exploration_hub = load("res://majors/BoatExploration/BoatExploration.tscn").instantiate()
	add_child(self.boat_exploration_hub)
	self.boat_exploration_hub.start_intro_cutscene()
