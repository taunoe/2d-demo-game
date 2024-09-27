extends Area2D

signal hit  # custom signal called "hit"

# export allows us to set its value in the Inspector.
@export var speed = 400 # How fast the player will move (pixels/sec).

var screen_size # Size of the game window.

var player_size

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	screen_size = get_viewport_rect().size
	player_size = $CollisionShape2D.shape.get_rect().size
	hide()  # player will be hidden when the game starts


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var velocity = Vector2.ZERO # The player's movement vector. (0, 0)
	
	if Input.is_action_pressed("move_right"):
		velocity.x += 1
	if Input.is_action_pressed("move_left"):
		velocity.x -= 1
	if Input.is_action_pressed("move_down"):
		velocity.y += 1
	if Input.is_action_pressed("move_up"):
		velocity.y -= 1

	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
		# $ returns the node at the relative path from the current node, or returns null
		$AnimatedSprite2D.play() # $ is shorthand for get_node()
	else:
		$AnimatedSprite2D.stop()  # get_node("AnimatedSprite2D").stop()
	
	position += velocity * delta
	# clamp() prevents it from leaving the screen
	# Clamping a value means restricting it to a given range
	# position = position.clamp(Vector2.ZERO, screen_size)
	position = position.clamp(Vector2.ZERO+player_size/2, screen_size-player_size/2)
	
	# Animatsioonid
	if velocity.x != 0:
		$AnimatedSprite2D.animation = "walk"
		$AnimatedSprite2D.flip_v = false
		$AnimatedSprite2D.flip_h = velocity.x < 0  # true or false
	elif velocity.y != 0:
		$AnimatedSprite2D.animation = "up"
		$AnimatedSprite2D.flip_v = velocity.y > 0  # true or false


# emit hit signal
func _on_body_entered(body: Node2D) -> void:
	hide() # Player disappears after being hit.
	hit.emit()
	# Must be deferred as we can't change physics properties on a physics callback.
	# We need to disable the player's collision so that we don't trigger the hit signal more than once.
	$CollisionShape2D.set_deferred("disabled", true) 

# reset the player when starting a new game.
func start(pos):
	position = pos
	show()
	$CollisionShape2D.disabled = false
