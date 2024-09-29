extends Area2D

signal hit

# export allows us to set its value in the Inspector.
@export var speed = 400 # How fast the player will move (pixels/sec).

var screen_size # Size of the game window.
var player_size
var is_player_hurt = false
var is_player_dead = false
var direction = Vector2.ZERO
var target_position = Vector2()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	hide()
	target_position = position  # Start with the current position
	screen_size = get_viewport_rect().size
	player_size = $CollisionShape2D.shape.get_rect().size


func _input(event):
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var direction = Vector2.ZERO # The player's movement vector. (0, 0)

	if Input.is_action_pressed("move_right"):
		direction.x += 1
	if Input.is_action_pressed("move_left"):
		direction.x -= 1
	if Input.is_action_pressed("move_down"):
		direction.y += 1
	if Input.is_action_pressed("move_up"):
		direction.y -= 1

	# Normalize direction to keep movement consistent in all directions
	if direction != Vector2.ZERO:
		direction = direction.normalized()
		global_position += direction * speed * delta
		target_position = global_position  # Update target position to stop touch-based movement

	# Check for touch or mouse input
	elif Input.is_action_just_pressed("ui_touch"):
		target_position = get_global_mouse_position()

	# Move the Area2D towards the touch target position
	if global_position.distance_to(target_position) > 5:
		direction = (target_position - global_position).normalized()
		global_position += direction * speed * delta
	
	# Animatsioonid
	if is_player_hurt == true:
		$AnimatedSprite2D.animation = "hurt"
		direction = Vector2.ZERO # et ei liiguks ise
		#await get_tree().create_timer(1.0).timeout
	elif is_player_dead == true:
		$AnimatedSprite2D.animation = "dead"
		direction = Vector2.ZERO # et ei liiguks ise
		#await get_tree().create_timer(1.0).timeout
	else:
		if direction.x != 0:
			$AnimatedSprite2D.animation = "walk"
			$AnimatedSprite2D.flip_v = false
			$AnimatedSprite2D.flip_h =direction.x < 0  # true or false
		elif direction.y != 0:
			$AnimatedSprite2D.animation = "run"
			#$AnimatedSprite2D.flip_v = velocity.y > 0  # tagurpidi
		else:
			$AnimatedSprite2D.animation = "idle"
		
	#direction = Vector2.ZERO


# emit hit signal
func _on_body_entered(body: Node2D) -> void:
	if body.get_name() == 'Toivo':
		print("Toivo")
	else:
		print(body.get_name())
	hit.emit()
	
	
func player_dead() -> void:
	hide()
	$CollisionShape2D.set_deferred("disabled", true)


func set_animation(animation, activate) -> void:
	if activate == true:
		if animation == 'Hurt':
			is_player_hurt = true
		if animation == 'Dead':
			is_player_dead = true
	else:
		is_player_hurt = false
		is_player_dead = false


# reset the player when starting a new game.
func start(pos):
	position = pos
	show()
	$CollisionShape2D.disabled = false
