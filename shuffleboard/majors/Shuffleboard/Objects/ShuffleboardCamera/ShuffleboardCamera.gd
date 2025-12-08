extends Camera2D

func _process(delta: float) -> void:
	if Input.is_action_pressed("Space"):
		position.y -= 3
	
