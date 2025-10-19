extends Node3D

@export var speed: float = 0.5

var moving: bool = false
var mouse_position: Vector2
var old_mouse_position: Vector2


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("Click"):
		moving = true
		mouse_position = get_viewport().get_mouse_position()
	elif event.is_action_released("Click"):
		moving = false
	
func _process(delta: float) -> void:
	if moving:
		old_mouse_position = mouse_position
		mouse_position = get_viewport().get_mouse_position()
		
		self.position.z += (mouse_position.y - old_mouse_position.y) * speed * delta
			
