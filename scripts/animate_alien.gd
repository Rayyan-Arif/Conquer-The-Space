extends TextureRect


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var tween = create_tween()
	tween.set_loops()
	
	tween.tween_property(self, "position:y", self.position.y - Global.w/20, 1)
	tween.tween_property(self, "position:y", self.position.y, 1)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
