extends Area2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# First, disconnect any previous connections (if any)
	if is_connected("area_entered", Callable(self, "_on_area_entered")):
		disconnect("area_entered", Callable(self, "_on_area_entered"))
	
	# Then, connect the signal again
	connect("area_entered", Callable(self, "_on_area_entered"))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func collected() -> void:
	queue_free()


func _on_area_entered(area: Area2D) -> void:
	# execute func in main
	get_tree().root.get_node("Main").on_ghost_area_entered()
	collected()


func _on_ghost_live_timer_timeout() -> void:
	print("ghost timeout")
	queue_free()
