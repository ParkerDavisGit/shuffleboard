## The Aggregate for all the visual novel pieces
## Text Box
## NISE-Parser

extends Control
class_name VisualNovelEngine

@export var sprite_sheet: Control
@export var textbox: Control

var vn_script: Array = [ ]
var vn_index: int = 0

var waiting_for_input: bool = false

var accepted_script_events: Dictionary = {
	
}

func _ready() -> void:
	SignalBus.on_script_event.connect(_on_script_event)
	
	open_file("dummy")
	read_next_line()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("Click"):
		if not waiting_for_input:
			return
		
		waiting_for_input = false
		read_next_line()


func read_next_line() -> void:
	if vn_index >= vn_script.size():
		return
	
	match vn_script[vn_index]["opcode"]:
		"text": # { speaker: { speaker, color }, text }
			display_test(vn_script[vn_index])
		"input": # { }
			self.waiting_for_input = true
		"ask": # { text, choices: [[text, jump], [text, jump]]}
			##TODO
			pass
		"wait": # { time }
			await get_tree().create_timer(vn_script[vn_index]["time"]).timeout
		"background": # { file_name }
			##TODO
			pass
		"sprite": # { file_name, character, location }
			# location: "LEFT", "RIGHT"  <- probably capital lock
			# Can leave file_name blank to deactivate
			self.set_sprite(vn_script[vn_index])
		"active_sprite": # { location }
			self.set_active_sprite(vn_script[vn_index]["location"])
		"move_sprite": # { name, location, time, method }
			# method: slide, instant
			##TODO ## TODO a lot later
			pass
		"animation": # { name }
			##TODO
			pass
		"music": # { name }
			##TODO
			pass
		"sound_effect": # { name }
			##TODO
			pass
		"jump": # { type, amount }
			# type: relative, absolute
			self.set_vn_index(vn_script[vn_index])
		"set_flag": # { name, value }
			##TODO
			pass
		"if": # { flag, value, jump_true, jump_false }
			##TODO
			pass
		"script": # { name }
			##TODO
			pass
		"event":
			##TODO
			pass
		_:
			print("Line " + str(vn_index) + " is invalid.")
			print("ERROR >> " + vn_script[vn_index])
	
	vn_index += 1
	
	if waiting_for_input:
		return
	
	read_next_line()


# Just having the textbox handle this
# Shouldn't be anything too crazy.
# Unless I ever want to add fancy effects.
func display_test(text_data: Dictionary) -> void:
	self.textbox.display_text(text_data)


func set_sprite(sprite_data: Dictionary) -> void:
	self.sprite_sheet.set_sprite(sprite_data)

func set_active_sprite(location: String) -> void:
	self.sprite_sheet.set_active_sprite(location)


func set_vn_index(index_data: Dictionary) -> void:
	# index_data = { type, amount }
	if index_data["type"] == "RELATIVE":
		self.vn_index += index_data["amount"]
		# Adjustment for the +1 the 'read_next_line' method gives
		self.vn_index -= 1
	
	elif index_data["type"] == "ABSOLUTE":
		self.vn_index = index_data["amount"]
		# Adjustment for the +1 the 'read_next_line' method gives
		self.vn_index -= 1
		

func open_file(file_name: String) -> void:
	var json_string: String = FileAccess.get_file_as_string("res://scripts/" + file_name + ".json")
	
	vn_script = JSON.parse_string(json_string)
	vn_index = 0


func _on_script_event(event_name: String, event_arguments: Dictionary) -> void:
	if event_name not in accepted_script_events.keys():
		return
	
	accepted_script_events[event_name].call(event_arguments)
