extends Node

@export var toivo_scene: PackedScene
@export var gin_scene: PackedScene

var score
var lives


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	score = 0
	lives = 1


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


# Player hit signal
func player_hit() -> void:
	if lives > 0:
		lives -= 1

	$HUD.update_lives(lives)
	
	if lives < 1:
		$DeadTimer.start()
		$Player.set_animation('Dead', true)
		#$Player.player_dead()
		#game_over()
	else:
		$HurtTimer.start()
		$Player.set_animation('Hurt', true)
		$HurtSound.play()


func game_over() -> void:
	print("game_over")
	$ScoreTimer.stop()
	$ToivoTimer.stop()
	$GinTimer.stop()
	$HUD.show_game_over()
	$Music.stop()
	$DeathSound.play()

# start game signal
func new_game():
	score = 0
	lives = 2
	$Player.start($StartPosition.position)
	$StartTimer.start()
	$HUD.update_score(score)
	$HUD.update_lives(lives)
	$HUD.show_message("Ole valmis")
	get_tree().call_group("toivod", "queue_free") # eemlada eelmise mängu mobsid
	$Music.play()

# will start the other two timers
func _on_start_timer_timeout() -> void:
	$ToivoTimer.start()
	$ScoreTimer.start()
	$GinTimer.start()

#  increment the score by 1
func _on_score_timer_timeout() -> void:
	score += 1
	$HUD.update_score(score)

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
	var gin = gin_scene.instantiate()
	var screen_size = get_viewport().get_visible_rect().size
	var rand_x = randi_range(0, screen_size.x)
	var rand_y = randi_range(0, screen_size.y)
	gin.position = Vector2(rand_x, rand_y)
	add_child(gin)


func on_gin_collected() -> void:
	print("on_gin_collected")
	lives += 1
	$HUD.update_lives(lives)
	$GinSound.play()
