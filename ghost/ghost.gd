extends Area2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$CollisionShape2D.disabled = true
	hide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func start():
	$CollisionShape2D.disabled = false
	show()

func collected() -> void:
	queue_free()


func _on_area_entered(area: Area2D) -> void:
	# execute func in main
	get_tree().root.get_node("Main").on_ghost_area_entered()
	collected()


func _on_ghost_live_timer_timeout() -> void:
	print("ghost timeout")
	queue_free()
