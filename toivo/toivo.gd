extends RigidBody2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	add_to_group("enemies")
	# get the list of animation names
	var toivo_types = $AnimatedSprite2D.sprite_frames.get_animation_names()
	# selects a random
	$AnimatedSprite2D.play(toivo_types[randi() % toivo_types.size()])
	set_contact_monitor(true)



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

# signal
# delete mobs themselves when they leave the screen
func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()
