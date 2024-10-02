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
	print("tere, area entered:", area.name)  # Print the name of the area entering
	get_tree().root.get_node("Main").on_alien_area_entered()
	collected()


func _on_alien_live_timer_timeout() -> void:
	print("alien timeout")
	queue_free()
