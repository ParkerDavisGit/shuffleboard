extends RigidBody2D
class_name PuckSB

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("Click"):
		apply_impulse(Vector2(0, -500))
