extends Area2D


func _ready() -> void:
	# First, disconnect any previous connections (if any)
	if is_connected("area_entered", Callable(self, "_on_area_entered")):
		disconnect("area_entered", Callable(self, "_on_area_entered"))
	
	# Then, connect the signal again
	connect("area_entered", Callable(self, "_on_area_entered"))



func _process(delta: float) -> void:
	pass


func collected() -> void:
	queue_free()


func _on_area_entered(area: Area2D) -> void:
	print("_on_area_entered: Area entered:", area.name)
	# execute func in main
	if get_tree().root.has_node("Main"):  # Ensure Main node exists
		get_tree().root.get_node("Main").on_gin_collected()
	collected()


func _on_timer_timeout() -> void:
	print("gin timeout")
	queue_free()
