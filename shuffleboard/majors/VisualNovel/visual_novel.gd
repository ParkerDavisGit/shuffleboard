## The Aggregate for all the visual novel pieces
## Text Box
## NISE-Parser

extends Control
class_name VisualNovelEngine

@export var sprite_sheet: Control
@export var textbox: Control
@export var background: Background

var vn_script: Array = [ ]
var vn_index: int = 0

var flag_bearer: Dictionary
var day_end: Callable

var waiting_for_input: bool = false
var waiting_for_choice: bool = false
var paused: bool = false

var choice_1: Button
var choice_2: Button
var choice_3: Button
var choice_jumps: Array = [0, 0, 0]

var accepted_script_events: Dictionary = {
	
}

func _ready() -> void:
	self.choice_1 = $SuggestionBox/Choice1
	self.choice_2 = $SuggestionBox/Choice2
	self.choice_3 = $SuggestionBox/Choice3
	
	SignalBus.on_script_event.connect(_on_script_event)

func _input(event: InputEvent) -> void:
	## Debug output for if that stupid softlock happens again
	if event.is_action_pressed("Click"):
		print(paused, " ", waiting_for_input, " ", waiting_for_choice)
	
	if paused: return
	if not waiting_for_input: return
	if waiting_for_choice: return
	
	if event.is_action_pressed("Click"):
		waiting_for_input = false
		read_next_line()

func link_flag_bearer(parents_bearer: Dictionary) -> void:
	self.flag_bearer = parents_bearer

func link_day_end(parents_day_end: Callable) -> void:
	self.day_end = parents_day_end


func read_next_line() -> void:
	if vn_index >= vn_script.size():
		return
	
	match vn_script[vn_index]["opcode"]:
		"text": # { speaker: { speaker, color }, text }
			display_test(vn_script[vn_index])
			# Could eventually be turned off in special flag in text
			self.waiting_for_input = true
		"display":
			activate_display(vn_script[vn_index]["text"])
			await get_tree().create_timer(2).timeout
			$Panel.visible = false
		"textbox": # { operation } # Usually on or off.
			text_box_operation(vn_script[vn_index]["operation"])
		"input": # { }
			self.waiting_for_input = true
		"ask": # { choices: [[text, {jump, type}], [text, {jump, type}], [text, {jump, type}]]}
			self.ask(vn_script[vn_index]["choices"])
			self.waiting_for_choice = true
		"wait": # { time }
			await get_tree().create_timer(vn_script[vn_index]["time"]).timeout
		"background": # { file_name }
			background.load_file(vn_script[vn_index]["file_name"])
		"sprite": # { file_name, character, location }
			# location: "LEFT", "RIGHT"  <- probably capital lock
			# Can leave file_name blank to deactivate
			self.set_sprite(vn_script[vn_index])
			self.set_active_sprite(vn_script[vn_index]["location"])
		"active_sprite": # { location }
			self.set_active_sprite(vn_script[vn_index]["location"])
		"move_sprite": # { name, location, time, method }
			# method: slide, instant
			##TODO ## TODO a lot later
			##
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
		"set_flag": # { name, value, operand }
			##TODO
			pass
		"if": # { flag, comparison, value, jump_true, jump_false }
			##TODO
			pass
		"script": # { name }
			open_file(vn_script[vn_index]["name"])
			return
		"event":
			##TODO
			pass
		"end":
			end_visual_novel()
			pass
		_:
			print("Line " + str(vn_index) + " is invalid.")
			print("ERROR >> " + vn_script[vn_index])
	
	vn_index += 1
	
	if waiting_for_input or waiting_for_choice:
		return
	
	read_next_line()


# Just having the textbox handle this
# Shouldn't be anything too crazy.
# Unless I ever want to add fancy effects.
func display_test(text_data: Dictionary) -> void:
	self.textbox.display_text(text_data)

func activate_display(text: String) -> void:
	$Panel.visible = true
	$Panel/Display.display_self(text)

func text_box_operation(operation: String) -> void:
	match operation:
		"on":
			textbox.visible = true
		"off":
			textbox.visible = false
		_:
			pass

func set_sprite(sprite_data: Dictionary) -> void:
	self.sprite_sheet.set_sprite(sprite_data)

func set_active_sprite(location: String) -> void:
	self.sprite_sheet.set_active_sprite(location)


func set_vn_index(index_data: Dictionary) -> void:
	# index_data = { type, amount }
	if index_data["type"] == "relative":
		self.vn_index += index_data["amount"]
		# Adjustment for the +1 the 'read_next_line' method gives
		self.vn_index -= 1
	
	elif index_data["type"] == "absolute":
		self.vn_index = index_data["amount"]
		# Adjustment for the +1 the 'read_next_line' method gives
		# As well as adjustment into a 0-starting array
		self.vn_index -= 2


func ask(choices: Array) -> void:
	self.choice_jumps[0] = choices[0][1]
	self.choice_jumps[1] = choices[1][1]
	self.choice_jumps[2] = choices[2][1]
	
	self.choice_1.text = choices[0][0]
	self.choice_2.text = choices[1][0]
	self.choice_3.text = choices[2][0]
	
	if self.choice_1.text != "":
		self.choice_1.visible = true
	if self.choice_2.text != "":
		self.choice_2.visible = true
	if self.choice_3.text != "":
		self.choice_3.visible = true


### Flag Methods ###
func set_flag_integer(arguments: Dictionary) -> void:
	## arguments = { name, value, operand }
	match arguments["operand"]:
		"add":
			# If the value has not been encountered before,
			#   Default to 0 and continue from there.
			if !self.flag_bearer.has(arguments["name"]):
				self.flag_bearer[arguments["name"]] = 0
			self.flag_bearer[arguments["name"]] += int(arguments["value"])
		"set":
			self.flag_bearer[arguments["name"]] = int(arguments["value"])

func check_flag(arguments: Dictionary) -> void:
	# arguments = { flag, comparison, value, jump_true { }, jump_false { } }
	var flag_true: bool = false
	match arguments["comparison"]:
		"=":
			flag_true = flag_bearer[arguments["flag"]] == int(arguments["value"])
		"<":
			flag_true = flag_bearer[arguments["flag"]] < int(arguments["value"])
		">":
			flag_true = flag_bearer[arguments["flag"]] > int(arguments["value"])
		"<=":
			flag_true = flag_bearer[arguments["flag"]] <= int(arguments["value"])
		">=":
			flag_true = flag_bearer[arguments["flag"]] >= int(arguments["value"])
		"!":
			flag_true = flag_bearer[arguments["flag"]] != int(arguments["value"])
	
	if flag_true:
		set_vn_index(arguments["jump_true"])
	else:
		set_vn_index(arguments["jump_false"])

### Other ###
func open_file(file_name: String) -> void:
	var json_string: String = FileAccess.get_file_as_string("res://scripts/" + file_name + ".json")
	
	vn_script = JSON.parse_string(json_string)
	vn_index = 0
	waiting_for_input = false
	
	read_next_line()

func end_visual_novel() -> void:
	self.day_end.call()


func _on_script_event(event_name: String, event_arguments: Dictionary) -> void:
	if event_name not in accepted_script_events.keys():
		return
	
	accepted_script_events[event_name].call(event_arguments)


func _on_choice_1_pressed() -> void:
	self.set_vn_index(self.choice_jumps[0])
	self.waiting_for_choice = false
	
	self.choice_1.visible = false
	self.choice_2.visible = false
	self.choice_3.visible = false
	
	read_next_line()


func _on_choice_2_pressed() -> void:
	self.set_vn_index(self.choice_jumps[1])
	self.waiting_for_choice = false
	
	self.choice_1.visible = false
	self.choice_2.visible = false
	self.choice_3.visible = false
	
	read_next_line()


func _on_choice_3_pressed() -> void:
	self.set_vn_index(self.choice_jumps[2])
	self.waiting_for_choice = false
	
	self.choice_1.visible = false
	self.choice_2.visible = false
	self.choice_3.visible = false
	
	read_next_line()
