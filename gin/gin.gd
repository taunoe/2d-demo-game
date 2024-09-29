extends Area2D


func _ready() -> void:
	pass


func _process(delta: float) -> void:
	pass


func collected() -> void:
	queue_free()


func _on_area_entered(area: Area2D) -> void:
	print("_on_area_entered")
	# execute func in main
	get_tree().root.get_node("Main").on_gin_collected()
	collected()


func _on_timer_timeout() -> void:
	print("gin timeout")
	queue_free()
