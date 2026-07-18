extends Area2D

func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and Global.gameStarted:
		if event.pressed && event.button_index == MOUSE_BUTTON_LEFT:
			var parent = get_parent()
			
			Global.handleAlienProperties(parent)
			
			Global.particles.position = parent.position
			
			parent.position = Global.generatePositionForAlien(parent.id)
			
			Global.particles.restart()
			Global.particles.emitting = true
			
			Global.alienDeathSound.play()
			
			Global.score += 1
			$"../../../Score".text = "Score: %d" % Global.score
