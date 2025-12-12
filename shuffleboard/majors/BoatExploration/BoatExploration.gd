extends Node2D

class_name BoatExplorationHub

var visual_novel: VisualNovelEngine
var shuffleboard: Node2D
var flag_bearer: Dictionary = { }

var progress: Dictionary = {
	"rei": 0,
	"rival": 0,
	"tourney": 0
}

var day: int = -1
var schedule: Array = [
	{ # Day 0 (Tutorial with Rei)
		"rei_tutorial": "deck"
	},
	{ # Day 1
		"rei": "gym",
		"rival": "deck"
	},
	{ # Day 2 (Round 1)
		"tourney": "deck"
	},
	{ # Day 3
		"rei": "gym",
		"rival": "deck"
	},
	{ # Day 4
		"rei": "gym",
		"rival": "deck"
	},
	{ # Day 5 (Round 2)
		"tourney": "deck"
	},
	{ # Day 6 
		"choice": ""
	},
	{ # Day 7
		"choice": ""
	},
	{ # Day 8 (Final)
		"tourney": "deck"
	},
]

func _ready() -> void:
	self.visual_novel = load("res://majors/VisualNovel/VisualNovel.tscn").instantiate()
	add_child(self.visual_novel)
	self.visual_novel.visible = false
	self.visual_novel.paused = true
	self.visual_novel.link_flag_bearer(self.flag_bearer)
	self.visual_novel.link_day_end(end_day)
	
	self.shuffleboard = load("res://majors/Shuffleboard/Shuffleboard.tscn").instantiate()
	add_child(self.shuffleboard)
	self.shuffleboard.visible = false
	self.shuffleboard.paused = true
	

func start_visual_novel(file_name: String) -> void:
	self.visual_novel.visible = true
	self.visual_novel.paused = false
	self.visual_novel.open_file(file_name)

func end_day() -> void:
	self.visual_novel.visible = false
	self.visual_novel.paused = true
	
	self.day += 1
	self.load_day()

func load_day() -> void:
	if day >= 9:
		end_game()
		return
	
	if self.schedule[self.day].has("choice"):
		$TournyMatchButton.visible = false
		
		if self.progress["rei"] >= self.progress["rival"]:
			$ReiButton.visible = true
			$RivalButton.visible = false
		else:
			$ReiButton.visible = false
			$RivalButton.visible = true
		
		return
	

	$ReiButton.visible = self.schedule[self.day].has("rei")
	$RivalButton.visible = self.schedule[self.day].has("rival")
	
	$ReiButtonTutorial.visible = self.schedule[self.day].has("rei_tutorial")
	$TournyMatchButton.visible = self.schedule[self.day].has("tourney")

func start_intro_cutscene() -> void:
	self.start_visual_novel("intro_cutscene")

func end_game() -> void:
	print("Game ends now!")


func _on_rei_button_pressed() -> void:
	self.progress["rei"] += 1
	self.start_visual_novel("rei_%s" % [self.progress["rei"]])


func _on_rival_button_pressed() -> void:
	self.progress["rival"] += 1
	self.start_visual_novel("rival_%s" % [self.progress["rival"]])


func _on_tourny_match_button_pressed() -> void:
	self.progress["tourney"] += 1
	self.start_visual_novel("tournament_%s" % [self.progress["tourney"]])


func _on_rei_button_tutorial_pressed() -> void:
	self.start_visual_novel("rei_tutorial")
