extends Node

var aliens = []
var alienPositions = []
const alienCount = 12
const alienSpeed = 500
const starCount = 30
var w
var h
var gameStarted = false
var score = 0
var time = 60
var cursor = preload("res://assets/images/cursor.png")
var clickSound = preload("res://assets/audios/buttonClickSound.wav")
var buttonClick
var overSound = preload("res://assets/audios/gameOverSound.wav")
var gameOverSound
var deathSound = preload("res://assets/audios/death.wav")
var alienDeathSound
var particles

func createParticles() -> void:
	particles = GPUParticles2D.new()

	var material = ParticleProcessMaterial.new()

	material.spread = 360
	material.initial_velocity_min = 100
	material.initial_velocity_max = 100
	material.scale_min = 3
	material.scale_max = 3

	particles.process_material = material
	particles.amount = 100
	particles.lifetime = 0.5
	particles.modulate = Color.RED
	particles.one_shot = true
	particles.emitting = false

	add_child(particles)

func freeResources() -> void:
	aliens = []
	alienPositions = []
	gameStarted = false
	score = 0
	time = 60

func generatePositionForAlien(i) -> Vector2:
	var x = w * 3 / 2
	var y = h * 3 / 2
	var pos = randi_range(0, 3)
	
	if pos == 0:
		y = randf() * h
		x = -x + w
	elif pos == 1:
		x = randf() * w
		y = -y + h
	elif pos == 2:
		y = randf() * h
	elif pos == 3:
		x = randf() * w
		
	alienPositions[i] = Vector2(x, y)	
	return Vector2(x, y)
	
func handleAlienProperties(alien) -> void:
	alien.velocity.x = alienSpeed
	alien.velocity.y = alienSpeed * 0.7
	if alien.position.x > w/2:
		alien.velocity.x *= -1

	if alien.position.y > h/2:
		alien.velocity.y *= -1
	
	if alien.velocity.x > 0 and alien.scale.x > 0:
		alien.scale.x *= -1
	
		
func _on_timer_timeout() -> void:
	time -= 1
	get_tree().current_scene.get_node("Time").text = 'Time: %d' % time
	
	if time <= 0:
		gameOverSound.play()
		get_tree().current_scene.get_node("Background").get_node("Timer").stop()
		get_tree().change_scene_to_file("res://scenes/game_over.tscn")
	
func _ready():
	var screenSize = get_viewport().get_visible_rect().size
	w = screenSize.x
	h = screenSize.y
	
	var img: Image = cursor.get_image()
	img.resize(256, 180, Image.INTERPOLATE_LANCZOS)
	var resized_cursor = ImageTexture.create_from_image(img)
		
	Input.set_custom_mouse_cursor(
		resized_cursor, 
		Input.CURSOR_ARROW, 
		Vector2(128, 90)
	)

	buttonClick = AudioStreamPlayer.new()
	buttonClick.stream = clickSound
	add_child(buttonClick)
	
	gameOverSound = AudioStreamPlayer.new()
	gameOverSound.stream = overSound
	add_child(gameOverSound)
	
	alienDeathSound = AudioStreamPlayer.new()
	alienDeathSound.stream = deathSound
	add_child(alienDeathSound)
	
	createParticles()
