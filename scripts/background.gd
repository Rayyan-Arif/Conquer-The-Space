extends Node

var stars = []
var startScene = preload("res://scenes/star.tscn")
var screenSize = Vector2(0, 0)
var w = 0
var h = 0

@onready var shoot: AudioStreamPlayer = $"../Shoot"

var alienScene = preload("res://scenes/alien.tscn")

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
			shoot.play()

func spawnStars() -> void:
	for i in range(Global.starCount):
		var star = startScene.instantiate()
		star.position.x = randf() * w
		star.position.y = randf() * h
		star.scale = Vector2(0.2, 0.2)
		add_child(star)
		stars.append(star)
	
func spawnAliens() -> void:
	for i in range(Global.alienCount):
		var alien = alienScene.instantiate()
		alien.id = i
		alien.scale = Vector2(0.3, 0.3)
			
		Global.aliens.append(alien)
		Global.aliens[i].position = Global.generatePositionForAlien(i)
		
		Global.handleAlienProperties(alien)
		
		add_child(alien)
	
func moveStars(delta) -> void:
	for star in stars:
		var starW = star.get_node("Body").size.x
		star.position.x -= delta * 50
		if star.position.x < -starW:
			star.position.x += screenSize.x + starW
			
func checkPosition(i) -> bool:
	if abs(Global.aliens[i].position.x) > w * 3/2 or abs(Global.aliens[i].position.y) > h * 3/2:
		return true
	return false
		
func moveAliens() -> void:
	for i in range(Global.alienCount):
		#print(i,' alien and position ',Global.aliens[i].position,' and original: ', Global.alienPositions[i], ' and velocity: ', Global.aliens[i].velocity)
		if checkPosition(i):
			#print('matched for ',i, ' and current position: ', Global.aliens[i].position, ' and original position: ', Global.alienPositions[i])
			Global.aliens[i].position = Global.generatePositionForAlien(i)
				
			Global.handleAlienProperties(Global.aliens[i])
				
		Global.aliens[i].move_and_slide()
		
func createTimer() -> void:
	var timer = Timer.new()
	timer.name = "Timer"
	timer.wait_time = 1.0
	timer.timeout.connect(Global._on_timer_timeout)
	add_child(timer)
	timer.start()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	screenSize = get_viewport().get_visible_rect().size
	w = screenSize.x
	h = screenSize.y
	
	for i in range(Global.alienCount):
		Global.alienPositions.append(Vector2(0, 0))
	
	createTimer()
	spawnStars()
	spawnAliens()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	moveStars(delta)

func _physics_process(delta: float) -> void:
	moveAliens()
