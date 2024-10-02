extends Area2D

func _ready() -> void:
	$CollisionShape2D.disabled = true
	hide()


func _process(delta: float) -> void:
	pass


func start():
	$CollisionShape2D.disabled = false
	show()

func collected() -> void:
	queue_free()


func _on_area_entered(area: Area2D) -> void:
	print("_on_area_entered: Area entered:", area.name)
	# execute func in main
	if get_tree().root.has_node("Main"):  # Ensure Main node exists
		get_tree().root.get_node("Main").on_gin_collected()
	collected()


func _on_timer_timeout() -> void:
	print("gin _on_timer_timeout()")
	queue_free()
