extends Node

@export var toivo_scene: PackedScene
@export var gin_scene: PackedScene
@export var ghost_scene: PackedScene
@export var alien_scene: PackedScene

var score
var lives

var game_started = false  # Track if the game has started


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	score = 0
	lives = 2
	$HUD.update_score(score)
	$HUD.update_lives(lives)
	$GinSound.stop()
	$GhostSound.stop()
	$AlienSound.stop()  # Stop the music on startup
	#
	$ToivoTimer.stop()
	$GinTimer.stop()
	$GhostTimer.stop()
	$DeadTimer.stop()
	$HurtTimer.stop()
	$StartTimer.stop()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


# Player hit signal
func player_hit() -> void:
	if lives > 0:
		lives -= 1
	
	score -= 6
	if score < 0:
		score = 0

	$HUD.update_lives(lives)
	
	if lives < 1:
		$DeadTimer.start()
		$Player.set_animation('Dead', true)
	else:
		$HurtTimer.start()
		$Player.set_animation('Hurt', true)
		$HurtSound.play()


func game_over() -> void:
	$Music.stop()
	$DeathSound.play()
	$ScoreTimer.stop()
	$ToivoTimer.stop()
	$GinTimer.stop()
	$GhostTimer.stop()
	$DeadTimer.stop()
	$HurtTimer.stop()
	$HUD.show_game_over()
	#game_started = false
	

# start game signal
func new_game():
	game_started = true
	score = 0
	lives = 2
	$HUD.update_score(score)
	$HUD.update_lives(lives)
	$Player.start($StartPosition.position)
	$ToivoTimer.set_wait_time(0.65)
	$StartTimer.start()
	$HUD.show_message("Ole valmis")
	get_tree().call_group("toivod", "queue_free") # eemlada eelmise mängu mobsid
	$Music.play()

# will start the other two timers
func _on_start_timer_timeout() -> void:
	if game_started:
		print("_on_start_timer_timeout()")
		$ToivoTimer.start()
		$ScoreTimer.start()
		$GinTimer.start()
		$GhostTimer.start()
		$AlienTimer.start()

#  increment the score by 1
func _on_score_timer_timeout() -> void:
	score += 1
	$HUD.update_score(score)
	
	# Muudo uute toivode tulek kiiremaks
	if score > 50:
		$ToivoTimer.set_wait_time(0.5)
	if score > 100:
		$ToivoTimer.set_wait_time(0.4)

func _on_toivo_timer_timeout() -> void:
	# Create a new instance of the Mob scene.
	var toivo = toivo_scene.instantiate()

	# Choose a random location on Path2D.
	var toivo_spawn_location = $ToivoPath/ToivoSpawnLocation
	toivo_spawn_location.progress_ratio = randf()

	# Set the mob's direction perpendicular to the path direction.
	var direction = toivo_spawn_location.rotation + PI / 2

	# Set the mob's position to a random location.
	toivo.position = toivo_spawn_location.position

	# Add some randomness to the direction.
	direction += randf_range(-PI / 4, PI / 4)
	toivo.rotation = direction

	# Choose the velocity for the mob.
	var velocity = Vector2(randf_range(150.0, 250.0), 0.0)
	toivo.linear_velocity = velocity.rotated(direction)

	# Spawn the mob by adding it to the Main scene.
	add_child(toivo)


func _on_hurt_timer_timeout() -> void:
	$Player.set_animation('Hurt', false)

func _on_dead_timer_timeout() -> void:
	$Player.set_animation('Dead', false)
	$Player.player_dead()
	game_over()


func _on_gin_timer_timeout() -> void:
	if game_started:
		var gin = gin_scene.instantiate()
		var screen_size = get_viewport().get_visible_rect().size
		var rand_x = randi_range(0, screen_size.x)
		var rand_y = randi_range(0, screen_size.y)
		gin.position = Vector2(rand_x, rand_y)
		add_child(gin)
		$Gin.start()


func on_gin_collected() -> void:
	print("on_gin_collected")
	lives += 1
	score += 5
	$HUD.update_lives(lives)
	$HUD.update_score(score)
	$GinSound.play()


func on_ghost_area_entered() -> void:
	print("on_ghost_area_entered")
	lives -= 1
	score -= 5
	if lives < 0:
		lives = 0
	if score < 0:
		score = 0
	$HUD.update_lives(lives)
	$HUD.update_score(score)
	$HurtTimer.start()
	$Player.set_animation('Hurt', true)
	$GhostSound.play()


func _on_ghost_timer_timeout() -> void:
	if game_started:
		var ghost = ghost_scene.instantiate()
		var screen_size = get_viewport().get_visible_rect().size
		var rand_x = randi_range(0, screen_size.x)
		var rand_y = randi_range(0, screen_size.y)
		ghost.position = Vector2(rand_x, rand_y)
		add_child(ghost)
		$Ghost.start()


func on_alien_area_entered()  -> void:
	print("on_alien_area_entered")
	lives += 2
	score += 10
	if lives < 0:
		lives = 0
	if score < 0:
		score = 0
	$HUD.update_lives(lives)
	$HUD.update_score(score)
	$AlienSound.play()
	# Get all nodes in the "enemies" group
	for enemy in get_tree().get_nodes_in_group("enemies"):
		# Ensure the enemy node is valid
		if enemy:
			enemy.call_deferred("queue_free")  # Safely remove the enemy from the scene


func _on_alien_timer_timeout() -> void:
	if game_started:
		var alien = alien_scene.instantiate()
		var screen_size = get_viewport().get_visible_rect().size
		var rand_x = randi_range(0, screen_size.x)
		var rand_y = randi_range(0, screen_size.y)
		alien.position = Vector2(rand_x, rand_y)
		add_child(alien)
		$Alien.start()
