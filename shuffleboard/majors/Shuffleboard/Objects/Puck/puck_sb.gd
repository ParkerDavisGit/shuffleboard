extends RigidBody2D
class_name PuckSB

@export var active: bool = false
var moving: bool = false

func _input(event: InputEvent) -> void:
	if not active:
		return
	
	if moving:
		return
	
	if event.is_action_pressed("Click"):
		moving = true
		apply_impulse(Vector2(0, -500))

func _physics_process(delta: float) -> void:
	if not active:
		return
	
	if not moving:
		return
	
	if self.linear_velocity.length() < 7:
		self.linear_velocity = Vector2.ZERO
		moving = false
