extends Control

var left_sprite: TextureRect
var right_sprite: TextureRect

var left_scale: CenterContainer
var right_scale: CenterContainer

var left_name: String
var right_name: String

@export var unfocused_alpha: int
@export var focused_alpha: int
@export var unfocused_scale: Vector2
@export var focused_scale: Vector2
var focus: String = "left"

func _ready() -> void:
	self.left_sprite = $CenterContainerLeft/CharLeft
	self.right_sprite = $CenterContainerRight/CharRight
	
	self.left_scale = $CenterContainerLeft
	self.right_scale = $CenterContainerRight
	
	self.left_name = ""
	self.right_name = ""


func set_sprite(sprite_data: Dictionary) -> void:
	# sprite_data = { file_name, character, location }
	if sprite_data["location"] == "left":
		self.left_sprite.visible = true
		
		if sprite_data["file_name"] == "":
			self.left_sprite.visible = false
			return
		
		self.left_name = sprite_data["file_name"]
		
		self.left_sprite.texture = load(
			"res://assets/characters/" + 
			sprite_data["character"] + "/" + sprite_data["file_name"] + 
			".png"
		)
	
	elif sprite_data["location"] == "right":
		self.right_sprite.visible = true
		
		if sprite_data["file_name"] == "":
			self.right_sprite.visible = false
			return
		
		self.right_name = sprite_data["file_name"]
		
		self.right_sprite.texture = load(
			"res://assets/characters/" + 
			sprite_data["character"] + "/" + sprite_data["file_name"] + 
			".png"
		)
	
	else:
		print("INCORRECT LOCATION DATA")

func set_active_sprite(location: String) -> void:
	if location == "left":
		self.left_scale.scale = self.focused_scale
		self.right_scale.scale = self.unfocused_scale
		
		self.left_scale.modulate.a = self.focused_alpha
		self.right_scale.modulate.a = self.unfocused_alpha
		return
	
	elif location == "right":
		self.right_scale.scale = self.focused_scale
		self.left_scale.scale = self.unfocused_scale
		
		self.right_scale.modulate.a = self.focused_alpha
		self.left_scale.modulate.a = self.unfocused_alpha
		return
